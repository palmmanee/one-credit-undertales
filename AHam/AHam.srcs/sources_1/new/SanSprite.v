`timescale 1ns / 1ps

// Setup BeeSprite Module
module SanSprite(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg SanSpriteOn, // 1=on, 0=off
    output wire [7:0] dataout, // 8 bit pixel value from Bee.mem
    input wire Pclk // 25MHz pixel clock
    );

    // instantiate BeeRom code
    reg [14:0] address; // 2^10 or 1024, need 34 x 27 = 918
    SanRom SanVRom (.i_addr(address),.i_clk2(Pclk),.o_data(dataout));
            
    // setup character positions and sizes
    reg [9:0] SanX = 250; // Bee X start position
    reg [8:0] SanY = 70; // Bee Y start position
    localparam SanWidth = 120; // Bee width in pixels
    localparam SanHeight = 190; // Bee height in pixels
  
    always @ (posedge Pclk)
    begin
        if (aactive)
            begin // check if xx,yy are within the confines of the Bee character
                if (xx==SanX-1 && yy==SanY)
                    begin
                        address <= 0;
                        SanSpriteOn <=1;
                    end
                if ((xx>SanX-1) && (xx<SanX+SanWidth) && (yy>SanY-1) && (yy<SanY+SanHeight))
                    begin
                        address <= address + 1;
                        SanSpriteOn <=1;
                    end
                else
                    SanSpriteOn <=0;
            end
    end
endmodule