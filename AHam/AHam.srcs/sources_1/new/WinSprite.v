//--------------------------------------------------
// TitleSprite Module : Digilent Basys 3               
// TitleInvaders Tutorial 3 : Onboard clock 100MHz
// VGA Resolution 640x480 @ 60Hz : Pixel Clock 25MHz
//--------------------------------------------------
`timescale 1ns / 1ps

// Setup WinSprite Module
module WinSprite(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg WSpriteOn=1, // 1=on, 0=off
    output wire [7:0] dataout, // 8 bit pixel value from Win.mem
    input wire Pclk // 25MHz pixel clock
    );

    // instantiate WinRom code
    reg [13:0] address; // 234*64
    WinRom WinVRom (.i_addr(address),.i_clk2(Pclk),.o_data(dataout));
            
    // setup character positions and sizes
    reg [9:0] TX = 203; // X start position
    reg [8:0] TY = 160; // Y start position
    localparam TWidth = 234; // width in pixels
    localparam THeight = 64; // height in pixels
    reg check = 0;
  
    always @ (posedge Pclk)
    begin
        if (aactive)
            begin // check if xx,yy are within the confines of the win page
                if (xx==TX-1 && yy==TY && check==0)
                    begin
                        address <= 0;
                        WSpriteOn <=1;
                    end
                if ((xx>TX-1) && (xx<TX+TWidth) && (yy>TY-1) && (yy<TY+THeight)&& check==0)
                    begin
                        address <= address + 1;
                        WSpriteOn <=1;
                    end
               else
                WSpriteOn<=0;
            end
    end
endmodule