`timescale 1ns / 1ps

// Setup SoulSprite Module
module SoulSprite(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg SoulSpriteOn, // 1=on, 0=off
    output wire [7:0] dataout, // 8 bit pixel value from Soul.mem
    input wire BR, // right button
    input wire BL, // left button
    input wire BU, // right button
    input wire BD, // left button
    input wire Pclk, // 25MHz pixel clock
    output reg [9:0] SoulX,
    output reg [9:0] SoulY,
    input wire state_game
    );

    // instantiate SoulRom code
    reg [9:0] address; // 2^10 or 1024, need 34 x 27 = 918
    SoulRom SoulVRom (.i_addr(address),.i_clk2(Pclk),.o_data(dataout));
            
    // setup character positions and sizes
    reg [9:0] SX = 310; // Soul X start position
    reg [8:0] SY = 325; // SOul Y start position
    localparam SoulWidth = 15; // Soul width in pixels
    localparam SoulHeight = 15; // Soul height in pixels
  
    always @ (posedge Pclk)
    begin
        if (xx==639 && yy==479 && state_game==1)
            begin // check for left or right button pressed
                SX<=310;
                SY<=325;
            end
        if (xx==639 && yy==479 && state_game==0)
            begin // check for left or right button pressed
                if (BR == 1 && SX<389-SoulWidth)
                    SX<=SX+1;
                if (BL == 1 && SX>251)
                    SX<=SX-1;
                if (BU == 1 && SY>271)
                    SY<=SY-1;
                if (BD == 1 && SY<409-SoulHeight)
                    SY<=SY+1;
            end    
        if (aactive)
            begin // check if xx,yy are within the confines of the Soul character
                if (xx==SX-1 && yy==SY)
                    begin
                        address <= 0;
                        SoulSpriteOn <=1;
                        SoulX <= SX;
                        SoulY <= SY;
                    end
                if ((xx>SX-1) && (xx<SX+SoulWidth) && (yy>SY-1) && (yy<SY+SoulHeight))
                    begin
                        address <= address + 1;
                        SoulSpriteOn <=1;
                        SoulX <= SX;
                        SoulY <= SY;
                    end
                else
                    begin
                    SoulSpriteOn<=0;
                    end
                  
            end
    end
endmodule