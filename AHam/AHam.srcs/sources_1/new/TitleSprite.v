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
    output reg TitleSpriteOn=1, // 1=on, 0=off
    output wire [7:0] dataout, // 8 bit pixel value from Bee.mem
    input wire Pclk, // 25MHz pixel clock
    input wire space
    );

    reg [16:0] address; // 2^10 or 1024, need 34 x 27 = 918
    TitleRom TitleVRom (.i_addr(address),.i_clk2(Pclk),.o_data(dataout));
            
    // setup character positions and sizes
    reg [9:0] TX = 143; // X start position
    reg [8:0] TY = 117; // Y start position
    localparam TWidth = 350; // width in pixels
    localparam THeight = 246; // height in pixels
    reg check = 0;
  
    always @ (posedge Pclk)
    begin
        if (aactive)
            begin 
                if (xx==TX-1 && yy==TY && check==0)
                    begin
                        address <= 0;
                        TitleSpriteOn <=1;
                    end
                if ((xx>TX-1) && (xx<TX+TWidth) && (yy>TY-1) && (yy<TY+THeight)&& check==0)
                    begin
                        address <= address + 1;
                        TitleSpriteOn <=1;
                    end
                if (space==1 && check==0)
                    begin
                    check<=1;
                    TitleSpriteOn <=0;
                    end
            end
    end
endmodule