//--------------------------------------------------
// TitleSprite Module : Digilent Basys 3               
// TitleInvaders Tutorial 3 : Onboard clock 100MHz
// VGA Resolution 640x480 @ 60Hz : Pixel Clock 25MHz
//--------------------------------------------------
`timescale 1ns / 1ps

// Setup TitleSprite Module
module TitleSprite(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg SpriteOn, // 1=on, 0=off
    output wire [7:0] dataout, // 8 bit pixel value from Title.mem
    input wire space, // space button
    input wire Pclk // 25MHz pixel clock
    );

    // instantiate TitleRom code
    reg [9:0] address;
    TitleRom TitleVRom (.i_addr(address),.i_clk2(Pclk),.o_data(dataout));
            
    // setup positions and sizes
    reg [9:0] TitleX = 0; // Title X start position
    reg [8:0] TitleY = 0; // Title Y start position
    localparam TitleWidth = 640; // Title width in pixels
    localparam TitleHeight = 480; // Title height in pixels
  
    always @ (posedge Pclk)
    begin
        if (xx==639 && yy==479)
            begin // check for left or right button pressed
                if (space == 1)
                    // Change to game page here
                    TitleX<=TitleX-1;
            end  
        if (aactive)
            begin // check if xx,yy are within the confines of the Title
                if (xx==TitleX-1 && yy==TitleY)
                    begin
                        address <= 0;
                        TitleSpriteOn <=1;
                    end
                if ((xx>TitleX-1) && (xx<TitleX+TitleWidth) && (yy>TitleY-1) && (yy<TitleY+TitleHeight))
                    begin
                        address <= address + 1;
                        TitleSpriteOn <=1;
                    end
                else
                    TitleSpriteOn <=0;
            end  
    end
endmodule