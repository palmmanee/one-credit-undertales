`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2020 12:33:54 AM
// Design Name: 
// Module Name: ColorbarSprite
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ColorbarSprite(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg ColorSpriteOn, // 1=on, 0=off
    output wire [7:0] dataout, // 8 bit pixel value from Bee.mem
    input wire Pclk // 25MHz pixel clock
    );

    // instantiate BeeRom code
    reg [13:0] address; // 2^10 or 1024, need 34 x 27 = 918
    ColorbarRom ColorVRom (.i_addr(address),.i_clk2(Pclk),.o_data(dataout));
            
    // setup character positions and sizes
    reg [9:0] CX = 150; // Bee X start position
    reg [8:0] CY = 340; // Bee Y start position
    localparam CWidth = 338; // Bee width in pixels
    localparam CHeight = 15; // Bee height in pixels
  
    always @ (posedge Pclk)
    begin
        if (aactive)
            begin // check if xx,yy are within the confines of the Bee character
                if (xx==CX-1 && yy==CY)
                    begin
                        address <= 0;
                        ColorSpriteOn <=1;
                    end
                if ((xx>CX-1) && (xx<CX+CWidth) && (yy>CY-1) && (yy<CY+CHeight))
                    begin
                        address <= address + 1;
                        ColorSpriteOn <=1;
                    end
                else
                    ColorSpriteOn <=0;
            end
    end
endmodule
