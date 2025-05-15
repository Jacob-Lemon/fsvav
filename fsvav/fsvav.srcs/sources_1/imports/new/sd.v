//required to keep line high when not driven (UART like protocol)
(* PULLTYPE = "{PULLUP}" *)

module sd (
			input clk,
			input reset,
			input MISO,
			output CS,
			output MOSI,
			output SPI_CLK,
            output reg [11:0] color_data
		);


// initialization state machine
localparam WAIT_1_MS                = 0;
localparam SEND_74_HIGH             = 1;
localparam SEND_CMD0                = 2;
localparam RECEIVE_CMD0_RESPONSE    = 3;
localparam SEND_CMD8                = 4;
localparam RECEIVE_CMD8_RESPONSE    = 5;
localparam SEND_CMD55               = 6;
localparam RECEIVE_CMD55_RESPONSE   = 7;
localparam SEND_ACMD41              = 8;
localparam RECEIVE_ACMD41_RESPONSE  = 9;
localparam SEND_CMD58               = 10;
localparam RECEIVE_CMD58_RESPONSE   = 11;
localparam INIT_DONE                = 12;
localparam SEND_CMD17               = 13;
localparam RECEIVE_CMD17_RESPONSE   = 14;



//useful sd card commands
// localparam CMD0  = 8'h00; // GO_IDLE_STATE - Init card in SPI mode if CS low
localparam CMD0 = 6'b000000;
localparam CMD8 = 6'b001000; // SEND_IF_COND - Verify SD Memory Card interface
localparam CMD17 = 6'b010001; // READ_BLOCK - Read a single data block from the card
localparam CMD58 = 6'b111010; // READ_OCR - Read the OCR register of a card

localparam CMD55 = 6'b110111; //required before sending an acmd
localparam ACMD41 = 6'b101001; // SD_SEND_OP_COMD - Card initialization


reg clk_500kHz_reg;
wire clk_500kHz; // SPI_CLK count
assign clk_500kHz = clk_500kHz_reg;

reg [15:0] clk_500_counter;


reg CS_reg;
assign CS = CS_reg;

reg MOSI_reg;
assign MOSI = MOSI_reg;


reg SPI_CLK_reg;
//wire SPI_CLK;
assign SPI_CLK = SPI_CLK_reg;


initial begin
    clk_500kHz_reg = 0;
    clk_500_counter = 0;
    CS_reg = 1; //active low communication
    MOSI_reg = 0;
    SPI_CLK_reg = 0;
end



function [47:0] create_spi_cmd;
    input [5:0] cmd;       // 6-bit command number
    input [31:0] arg;      // 32-bit argument
    reg [7:0] crc;         // 7-bit CRC + stop bit

    begin
        // Set CRC only for CMD0 and CMD8
        case (cmd)
            CMD0:  crc = 8'h95; // GO_IDLE_STATE
            CMD8:  crc = 8'h87; // SEND_IF_COND
            default: crc = 8'h01; // All other commands, CRC is ignored in SPI mode
        endcase
        
        create_spi_cmd = {2'b01, cmd, arg, crc};  // Format: CMD + ARG + CRC
    end
endfunction




//clock divider for 250kHz initialization sequence
always @(posedge clk or posedge reset) begin
    if (reset) begin
        clk_500kHz_reg <= 0;
        clk_500_counter <= 0;    
    end else begin
    if (clk_500_counter == 164) begin
        clk_500kHz_reg <= ~clk_500kHz_reg;
        clk_500_counter <= 0;
    end else 
        clk_500_counter <= clk_500_counter + 1; 
    end
end



reg [3:0] init_state;
initial init_state = WAIT_1_MS;

reg initialization_finished;
initial initialization_finished = 0;

reg [10:0] wait_1_ms_counter;
initial wait_1_ms_counter = 0;

reg [7:0] dummy_clocks_counter;
initial dummy_clocks_counter = 0;

reg [47:0] command_to_send;
initial command_to_send = 0;

reg [5:0] command_index;
initial command_index = 0;

reg [31:0] delay_counter;
initial delay_counter = 0;

reg reset_once;
initial reset_once = 0;

reg [31:0] acmd41_sends;
initial acmd41_sends = 0;


reg [5:0] color_index;
initial color_index = 0;

reg start_reading;
initial start_reading = 0;

reg first_time_reset;
initial first_time_reset <= 0;

//250kHz
always @(posedge clk_500kHz or posedge reset) begin
    if (reset || first_time_reset) begin
        init_state <= WAIT_1_MS;
        wait_1_ms_counter <= 0;
        dummy_clocks_counter <= 0;
        command_to_send <= 0;
        command_index <= 0;
        MOSI_reg <= 0;
        CS_reg <= 1;
        SPI_CLK_reg <= 0;
        delay_counter <= 0;
        acmd41_sends <= 0;
        reset_once <= 1;
        color_data <= 0;
        color_index <= 0;
        start_reading <= 0;
        first_time_reset <= 0;
    end else begin
        case (init_state)
            WAIT_1_MS: begin
                if (wait_1_ms_counter == 500) begin // 1 ms in clock cycles
                    wait_1_ms_counter <= 0;
                    init_state <= SEND_74_HIGH;
                end else begin
                    wait_1_ms_counter <= wait_1_ms_counter + 1; 
                end
            end
            SEND_74_HIGH: begin

                if (dummy_clocks_counter == 160) begin // send at least 74 clock pulses
                    dummy_clocks_counter <= 0;
                    init_state <= SEND_CMD0;
                    SPI_CLK_reg <= ~SPI_CLK_reg;
                end else begin
                    dummy_clocks_counter <= dummy_clocks_counter + 1; 
                    MOSI_reg <= 1;
                    SPI_CLK_reg <= ~SPI_CLK_reg;
                end

                if (dummy_clocks_counter == 146) begin //give 8 spi clocks before transmitting
                    CS_reg <= 0;
                end

            end
            SEND_CMD0: begin
                command_to_send <= create_spi_cmd(CMD0, 32'b0);

                if (command_index == 48) begin 
                    command_index <= 0;
                    init_state <= RECEIVE_CMD0_RESPONSE;  // change later!!!
                    SPI_CLK_reg <= 0;
                    MOSI_reg <= 1;
                    SPI_CLK_reg <= ~SPI_CLK_reg;
                end else begin
                    if (SPI_CLK_reg) begin
                        MOSI_reg <= command_to_send[47 - command_index];
                        command_index <= command_index + 1; 
                    end
                    SPI_CLK_reg <= ~SPI_CLK_reg;
                end
                
            end
            RECEIVE_CMD0_RESPONSE: begin
                if (delay_counter < 16 || delay_counter >= 22) begin //send dummy bytes
                    SPI_CLK_reg <= ~SPI_CLK_reg;
                    if (delay_counter >= 22 && delay_counter < 102) begin
                        CS_reg <= 1;
                    end
                    if (delay_counter >= 150) begin
                        CS_reg <= 0;
                    end
                end
                else begin
                    SPI_CLK_reg <= 0;
                end

                if (delay_counter > 0) begin
                    delay_counter <= delay_counter + 1;
                end

                //start delaying
                if (!MISO && delay_counter == 0) begin
                    delay_counter <= delay_counter + 1;
                end

                if (delay_counter == 164) begin //wait 100 ms ish for sd to respond (adjust later)
                    init_state <= SEND_CMD8;
                    delay_counter <= 0;
                end
            end
            SEND_CMD8: begin
                command_to_send <= create_spi_cmd(CMD8, 32'h00001AA);

                if (command_index == 48) begin 
                    command_index <= 0;
                    init_state <= RECEIVE_CMD8_RESPONSE;
                    SPI_CLK_reg <= 0;
                    MOSI_reg <= 1;
                    SPI_CLK_reg <= ~SPI_CLK_reg;
                end else begin
                    if (SPI_CLK_reg) begin
                        MOSI_reg <= command_to_send[47 - command_index];
                        command_index <= command_index + 1; 
                    end
                    SPI_CLK_reg <= ~SPI_CLK_reg;
                end
            end
            RECEIVE_CMD8_RESPONSE: begin
                if (delay_counter < 80 || delay_counter >= 150) begin
                    SPI_CLK_reg <= ~SPI_CLK_reg;
                end
                else begin
                    SPI_CLK_reg <= 0;
                end

                if (delay_counter > 0) begin
                    delay_counter <= delay_counter + 1;
                end

                //start delaying
                if (!MISO && delay_counter == 0) begin
                    delay_counter <= delay_counter + 1;
                end

                if (delay_counter == 164) begin //wait 100 ms ish for sd to respond (adjust later)
                    init_state <= SEND_CMD55;
                    delay_counter <= 0;
                end
            end
            SEND_CMD55: begin
                command_to_send <= create_spi_cmd(CMD55, 32'b0);

                if (command_index == 48) begin 
                    command_index <= 0;
                    init_state <= RECEIVE_CMD55_RESPONSE;
                    SPI_CLK_reg <= 0;
                    MOSI_reg <= 1;
                    SPI_CLK_reg <= ~SPI_CLK_reg;
                end else begin
                    if (SPI_CLK_reg) begin
                        MOSI_reg <= command_to_send[47 - command_index];
                        command_index <= command_index + 1; 
                    end
                    SPI_CLK_reg <= ~SPI_CLK_reg;
                end
            end
            RECEIVE_CMD55_RESPONSE: begin
                if (delay_counter < 16 || delay_counter >= 150) begin //r1 response
                    SPI_CLK_reg <= ~SPI_CLK_reg;
                end
                else begin
                    SPI_CLK_reg <= 0;
                end

                if (delay_counter > 0) begin
                    delay_counter <= delay_counter + 1;
                end

                //start delaying
                if (!MISO && delay_counter == 0) begin
                    delay_counter <= delay_counter + 1;
                end

                if (delay_counter == 164) begin //wait 1/5 ms ish for sd to respond (adjust later)
                    init_state <= SEND_ACMD41;
                    delay_counter <= 0;
                end
            end
            SEND_ACMD41: begin
                command_to_send <= create_spi_cmd(ACMD41, 32'h40000000);

                if (command_index == 48) begin 
                    command_index <= 0;
                    init_state <= RECEIVE_ACMD41_RESPONSE;
                    SPI_CLK_reg <= 0;
                    MOSI_reg <= 1;
                    SPI_CLK_reg <= ~SPI_CLK_reg;
                end else begin
                    if (SPI_CLK_reg) begin
                        MOSI_reg <= command_to_send[47 - command_index];
                        command_index <= command_index + 1; 
                    end
                    SPI_CLK_reg <= ~SPI_CLK_reg;
                end
            end
            RECEIVE_ACMD41_RESPONSE: begin
                if (delay_counter < 16 || delay_counter >= 150) begin
                    SPI_CLK_reg <= ~SPI_CLK_reg;
                end
                else begin
                    SPI_CLK_reg <= 0;
                end

                if (delay_counter > 0) begin
                    delay_counter <= delay_counter + 1;
                end

                //start delaying
                if (!MISO && delay_counter == 0) begin
                    delay_counter <= delay_counter + 1;
                end

                if (delay_counter == 164) begin //wait 100 ms ish for sd to respond (adjust later)
                    if (acmd41_sends < 100) begin
                        init_state <= SEND_CMD55;
                    end else begin
                        init_state <= SEND_CMD58;
                    end
                    delay_counter <= 0;
                    acmd41_sends <= acmd41_sends + 1;
                end
            end
            SEND_CMD58: begin
                command_to_send <= create_spi_cmd(CMD58, 32'b0);

                if (command_index == 48) begin 
                    command_index <= 0;
                    init_state <= RECEIVE_CMD58_RESPONSE;
                    SPI_CLK_reg <= 0;
                    MOSI_reg <= 1;
                    SPI_CLK_reg <= ~SPI_CLK_reg;
                end else begin
                    if (SPI_CLK_reg) begin
                        MOSI_reg <= command_to_send[47 - command_index];
                        command_index <= command_index + 1; 
                    end
                    SPI_CLK_reg <= ~SPI_CLK_reg;
                end
            end
            RECEIVE_CMD58_RESPONSE: begin
                if (delay_counter < 80 || delay_counter >= 150) begin
                    SPI_CLK_reg <= ~SPI_CLK_reg;
                end
                else begin
                    SPI_CLK_reg <= 0;
                end

                if (delay_counter > 0) begin
                    delay_counter <= delay_counter + 1;
                end

                //start delaying
                if (!MISO && delay_counter == 0) begin
                    delay_counter <= delay_counter + 1;
                end

                if (delay_counter == 164) begin //wait 1 ms ish for sd to respond (adjust later)
                    if (reset_once) begin
                        init_state <= SEND_CMD17;
                    end else begin
                        init_state <= INIT_DONE;
                    end
                    delay_counter <= 0;
                end
            end
            SEND_CMD17: begin
                command_to_send <= create_spi_cmd(CMD17, 32'h2003); //block 3 with 8192 offset

                if (command_index == 48) begin 
                    command_index <= 0;
                    init_state <= RECEIVE_CMD17_RESPONSE;
                    SPI_CLK_reg <= 0;
                    MOSI_reg <= 1;
                    SPI_CLK_reg <= ~SPI_CLK_reg;
                end else begin
                    if (SPI_CLK_reg) begin
                        MOSI_reg <= command_to_send[47 - command_index];
                        command_index <= command_index + 1; 
                    end
                    SPI_CLK_reg <= ~SPI_CLK_reg;
                end
            end
            RECEIVE_CMD17_RESPONSE: begin
                if (!MISO && color_index == 0) begin //wait for r1 response to pass
                    delay_counter <= delay_counter + 1;
                    if (delay_counter > 16) begin
                        start_reading <= 1;
                    end
                end
                if (!SPI_CLK_reg && start_reading) begin
                    color_data[11 - color_index] <= MISO; //get 12 bits

                    if (color_index == 11) begin
                        start_reading <= 0;
                        delay_counter <= 0;
                    end
                    
                    color_index <= color_index + 1;
                end
                SPI_CLK_reg <= ~SPI_CLK_reg; //give it clocks and see if it responds
                if (color_index != 0 && !start_reading) begin //finished reading 12 bit data
                    delay_counter = delay_counter + 1;
                    if (delay_counter == 3000) begin
                        init_state <= INIT_DONE; //wait for rest of 512 bytes then done
                    end
                end
            end
            INIT_DONE: begin
                if (!reset_once) begin
                    first_time_reset <= 1;
                end
                init_state <= INIT_DONE;
            end
            default: begin
                init_state <= WAIT_1_MS;
            end
        endcase
    end
end




endmodule