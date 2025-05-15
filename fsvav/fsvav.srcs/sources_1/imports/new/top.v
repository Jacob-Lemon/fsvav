module top(
    // system
    input clk_100MHz,   // clock
    input reset,        // btnC on Basys 3
    // vga ports
    output hsync,       // VGA port on Basys 3
    output vsync,       // VGA port on Basys 3
    output [11:0] rgb,  // to DAC, 3 bits to VGA port on Basys 3
    // sd card
    input MISO,
    output MOSI,
    output CS,
    output SPI_CLK
);

/******************************************************************************
* this is where I will make input/output delay things
******************************************************************************/
// reg [15:0] sw_reg;
// always @ (posedge clk_100MHz) begin
//     sw_reg <= sw;
// end


/******************************************************************************
* these are the vga things
******************************************************************************/

wire w_video_on, w_p_tick;
wire [9:0] w_x, w_y;
reg [11:0] rgb_reg;
wire[11:0] rgb_next;

vga_controller vc (
    .clk_100MHz(clk_100MHz),
    .reset(reset),
    .video_on(w_video_on),
    .hsync(hsync), 
    .vsync(vsync),
    .p_tick(w_p_tick),
    .x(w_x),
    .y(w_y)
);

wire [11:0] color_data;
sd sd_spi
    (
        .clk(clk_100MHz),
        .reset(reset),
        .MISO(MISO),
        .CS(CS),
        .MOSI(MOSI),
        .SPI_CLK(SPI_CLK),
        .color_data(color_data)
    );

pixel_generation pg (
    .clk(clk_100MHz),   // was clk_100MHz
    .reset(reset),
    .video_on(w_video_on),
    .x(w_x),
    .y(w_y),
    .rgb(rgb_next),
    .color_data_endian(color_data)
);


// rgb buffer
always @(posedge clk_100MHz) begin
    if (w_p_tick) begin
        rgb_reg <= rgb_next;
    end
end

assign rgb = rgb_reg;

endmodule