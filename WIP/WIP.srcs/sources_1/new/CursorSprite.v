`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2020 02:38:15 PM
// Design Name: 
// Module Name: CursorSprite
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


module CursorSprite(
    input wire [9:0] xx,            // current x position
    input wire [9:0] yy,            // current y position
    input wire aactive,             // high during active pixel drawing
    input wire L,
    input wire R,
    output reg C1SpriteOn,          // 1=on, 0=off
    output reg C2SpriteOn,          // 1=on, 0=off
    output reg C3SpriteOn,          // 1=on, 0=off
    output reg C4SpriteOn,          // 1=on, 0=off
    output wire [7:0] C1dataout,    // 8 bit pixel value from Alien1.mem
    output wire [7:0] C2dataout,    // 8 bit pixel value from Alien2.mem
    output wire [7:0] C3dataout,    // 8 bit pixel value from Alien1.mem
    output wire [7:0] C4dataout,    // 8 bit pixel value from Alien2.mem
    output reg [1:0] sel,    // 8 bit pixel value from Alien2.mem
    input wire Pclk                 // 25MHz pixel clock
    );

    // instantiate Alien1Rom code
    reg [9:0] C1address;            // 2^10 or 1024, need 31 x 26 = 806
    CursorRom Cursor1VRom (.i_Caddr(C1address),.i_clk2(Pclk),.o_Cdata(C1dataout));
    reg [9:0] C2address;            // 2^10 or 1024, need 31 x 26 = 806
    CursorRom Cursor2VRom (.i_Caddr(C2address),.i_clk2(Pclk),.o_Cdata(C2dataout));
    reg [9:0] C3address;            // 2^10 or 1024, need 31 x 26 = 806
    CursorRom Cursor3VRom (.i_Caddr(C3address),.i_clk2(Pclk),.o_Cdata(C3dataout));
    reg [9:0] C4address;            // 2^10 or 1024, need 31 x 26 = 806
    CursorRom Cursor4VRom (.i_Caddr(C4address),.i_clk2(Pclk),.o_Cdata(C4dataout));


    // setup character positions and sizes
    reg [9:0] C1X = 120;            // Alien1 X start position
    reg [9:0] C1Y = 433;             // Alien1 Y start position
    localparam C1Width = 15;        // Alien1 width in pixels
    localparam C1Height = 15;       // Alien1 height in pixels
    reg [9:0] C2X = 240;            // Alien2 X start position
    reg [9:0] C2Y = 433;            // Alien2 Y start position
    localparam C2Width = 15;        // Alien2 width in pixels
    localparam C2Height = 15;       // Alien2 height in pixels
    reg [9:0] C3X = 360;            // Alien1 X start position
    reg [9:0] C3Y = 433;             // Alien1 Y start position
    localparam C3Width = 15;        // Alien1 width in pixels
    localparam C3Height = 15;       // Alien1 height in pixels
    reg [9:0] C4X = 480;            // Alien2 X start position
    reg [9:0] C4Y = 433;            // Alien2 Y start position
    localparam C4Width = 15;        // Alien2 width in pixels
    localparam C4Height = 15;       // Alien2 height in pixels]
    reg [1:0]sh;
    initial sel = 3;
        
    always @ (posedge L or posedge R)
    begin
        if (L==1)begin
            end
        else if (R==1)
            begin
                case(sel)
                    2'b11: sel<=2'b00;
                    2'b10: sel<=2'b11;
                    2'b01: sel<=2'b10;
                    2'b00: sel<=2'b01;                    
                endcase
            end
    end
    
    always @ (posedge Pclk)
    begin
        if (aactive)
            begin // check if xx,yy are within the confines of the Bee character
                if (xx==C1X-1 && yy==C1Y && sel==2'b00)
                    begin
                        C1address <= 0;
                        C1SpriteOn <=1;
                    end
                if ((xx>C1X-1) && (xx<C1X+C1Width) && (yy>C1Y-1) && (yy<C1Y+C1Height)&& sel==2'b00)
                    begin
                        C1address <= C1address + 1;
                        C1SpriteOn <=1;
                    end
                else 
                    C1SpriteOn <=0;//end1
                if (xx==C2X-1 && yy==C2Y && sel==2'b01)
                    begin
                        C2address <= 0;
                        C2SpriteOn <=1;
                    end
                if ((xx>C2X-1) && (xx<C2X+C2Width) && (yy>C2Y-1) && (yy<C2Y+C2Height) && sel==2'b01)
                    begin
                        C2address <= C2address + 1;
                        C2SpriteOn <=1;
                    end
                else
                    C2SpriteOn <=0;//end2
                if (xx==C3X-1 && yy==C3Y && sel==2'b10)
                    begin
                        C3address <= 0;
                        C3SpriteOn <=1;
                    end
                if ((xx>C3X-1) && (xx<C3X+C3Width) && (yy>C3Y-1) && (yy<C3Y+C3Height)&& sel==2'b10)
                    begin
                        C3address <= C3address + 1;
                        C3SpriteOn <=1;
                    end
                else //end3
                    C3SpriteOn <=0;
                if (xx==C4X-1 && yy==C4Y && sel==2'b11)
                    begin
                        C4address <= 0;
                        C4SpriteOn <=1;
                    end
                if ((xx>C4X-1) && (xx<C4X+C4Width) && (yy>C4Y-1) && (yy<C4Y+C4Height) && sel==2'b11)
                    begin
                        C4address <= C4address + 1;
                        C4SpriteOn <=1;
                    end
                else 
                    C4SpriteOn <=0; //end4                     
            end
    end
endmodule