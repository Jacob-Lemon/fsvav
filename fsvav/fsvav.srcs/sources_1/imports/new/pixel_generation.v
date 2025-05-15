module pixel_generation(
    input clk,                      // 100MHz from Basys 3
    input reset,                    // btnC
    input video_on,                 // from VGA controller
    input [9:0] x, y,               // from VGA controller
    output reg [11:0] rgb,          // to DAC, to VGA controller
    // switches for test purposes
    // input [15:0] sw,                 // switches from the basys3 board
        //color from the sd card
    input [11:0] color_data_endian
);

//

// create a 60Hz refresh tick at the start of vsync
// this is the framerate
wire refresh_tick;
assign refresh_tick = ((y == 481) && (x == 0)) ? 1 : 0;



wire [11:0] color_data_rgb;

assign color_data_rgb[11:8] = color_data_endian[3:0];
assign color_data_rgb[7:4]  = color_data_endian[7:4];
assign color_data_rgb[3:0]  = color_data_endian[11:8];



/**************************************************************************************************
* RGB control
* order of if-else cascade determines layering of visuals
**************************************************************************************************/


// Stage 1: Check if video is on
reg video_active;
always @(posedge clk or posedge reset) begin
    if (reset)
        video_active <= 1'b0;
    else
        video_active <= video_on;
end

// Stage 2: Determine intermediate RGB value
reg [11:0] intermediate_rgb;
always @(posedge clk or posedge reset) begin
    if (reset) 
        intermediate_rgb <= 12'h000;
    else begin
        if (~video_active)
            intermediate_rgb <= 12'h000;
        else
            intermediate_rgb <= color_data_rgb;
    end
end

// Stage 3: Final assignment to RGB output
always @(posedge clk or posedge reset) begin
    if (reset)
        rgb <= 12'h000;
    else
        rgb <= intermediate_rgb;
end

endmodule
