//--------------------------------------------------
// Top Module : Digilent Basys 3               
// BeeInvaders Tutorial 4 : Onboard clock 100MHz
// VGA Resolution 640x480 @ 60Hz : Pixel Clock 25MHz
//--------------------------------------------------
`timescale 1ns / 1ps

module Top(
    input wire CLK,         // Onboard clock 100MHz : INPUT Pin W5
    input wire RESET,       // Reset button / Centre Button : INPUT Pin U18
    output wire HSYNC,      // VGA horizontal sync : OUTPUT Pin P19
    output wire VSYNC,      // VGA vertical sync : OUTPUT Pin R19
    output reg [3:0] RED,   // 4-bit VGA Red : OUTPUT Pin G19, Pin H19, Pin J19, Pin N19
    output reg [3:0] GREEN, // 4-bit VGA Green : OUTPUT Pin J17, Pin H17, Pin G17, Pin D17
    output reg [3:0] BLUE,  // 4-bit VGA Blue : OUTPUT Pin N18, Pin L18, Pin K18, Pin J18/ 4-bit VGA Blue : OUTPUT Pin N18, Pin L18, Pin K18, Pin J18
    input PS2Data,
    input PS2Clk           // Left button : INPUT Pin W19
    );
    
    wire w,s,a,d,space;
    wire [15:0] code;
    keyboard kb (.clk(CLK),.PS2Data(PS2Data),.PS2Clk(PS2Clk),.w(w),.s(s),.a(a),.d(d),.space(space),.keycodev(code));
    wire rst = RESET;       // Setup Reset button

    // instantiate vga640x480 code
    wire [9:0] x;           // pixel x position: 10-bit value: 0-1023 : only need 800
    wire [9:0] y;           // pixel y position: 10-bit value: 0-1023 : only need 525
    wire active;            // high during active pixel drawing
    wire PixCLK;            // 25MHz pixel clock
    vga640x480 display (.i_clk(CLK),.i_rst(rst),.o_hsync(HSYNC), 
                        .o_vsync(VSYNC),.o_x(x),.o_y(y),.o_active(active),
                        .pix_clk(PixCLK));
      
    // instantiate BeeSprite code
    wire BeeSpriteOn;       // 1=on, 0=off
    wire FrameSpriteOn;
    wire SanSpriteOn;
    wire BallSpriteOn;
    wire [7:0] dout;
    wire [7:0] SanDout;        // pixel value from Bee.mem
    BeeSprite BeeDisplay (.xx(x),.yy(y),.aactive(active),
                          .BSpriteOn(BeeSpriteOn),.dataout(dout),.BR(d),
                          .BL(a),.BU(w),.BD(s),.Pclk(PixCLK));
                          
    // Frame
    FrameSprite FrameDisplay (.xx(x),.yy(y),.aactive(active),
                          .FrameSpriteOn(FrameSpriteOn),.Pclk(PixCLK));
    
    //San
    SanSprite SanDisplay (.xx(x),.yy(y),.aactive(active),
                          .SanSpriteOn(SanSpriteOn),.dataout(SanDout),.Pclk(PixCLK));
                          
    // load colour palette
    reg [7:0] palette [0:191];  // 8 bit values from the 192 hex entries in the colour palette
    reg [7:0] COL = 0;          // background colour palette value
    initial begin
        $readmemh("pal24bit.mem", palette); // load 192 hex values into "palette"
    end
    
    // load San colour palette
    reg [7:0] SanPalette [0:191];  // 8 bit values from the 192 hex entries in the colour palette
    reg [7:0] SanCOL = 0;          // background colour palette value
    initial begin
        $readmemh("SanPal.mem", SanPalette); // load 192 hex values into "palette"
    end

    // draw on the active area of the screen
    always @ (posedge PixCLK)
    begin
        if (active)
            begin
                if (BeeSpriteOn==1)
                    begin
                        RED <= (palette[(dout*3)])>>4;          // RED bits(7:4) from colour palette
                        GREEN <= (palette[(dout*3)+1])>>4;      // GREEN bits(7:4) from colour palette
                        BLUE <= (palette[(dout*3)+2])>>4;       // BLUE bits(7:4) from colour palette
                    end
                else
                if (FrameSpriteOn==1) 
                    begin              
                      RED<=4'b1111;  
                      GREEN <=4'b1111;
                      BLUE <= 4'b1111;
                    end 
                else
                if (SanSpriteOn==1) 
                    begin              
                      RED <= (SanPalette[(SanDout*3)])>>4;          // RED bits(7:4) from colour palette
                      GREEN <= (SanPalette[(SanDout*3)+1])>>4;      // GREEN bits(7:4) from colour palette
                      BLUE <= (SanPalette[(SanDout*3)+2])>>4; 
                    end
                else
                if (BallSpriteOn==1) 
                    begin              
                      if (((x-100)**2 + (y-100)**2) <= 25)
                         begin
                            RED <= 0;           // RED bits(7:4) from colour palette
                            GREEN <= 0;       // GREEN bits(7:4) from colour palette
                            BLUE <= 4'b1111;        // BLUE bits(7:4) from colour palette
                         end
                    else
                        begin
                            RED <= 0;           // RED bits(7:4) from colour palette
                            GREEN <= 0;       // GREEN bits(7:4) from colour palette
                            BLUE <= 0;        // BLUE bits(7:4) from colour palette
                        end
                    end
                else
                    begin
                        RED <= 0;           // RED bits(7:4) from colour palette
                        GREEN <= 0;       // GREEN bits(7:4) from colour palette
                        BLUE <= 0;        // BLUE bits(7:4) from colour palette
                    end
              end
        else
                begin
                    RED <= 0;   // set RED, GREEN & BLUE
                    GREEN <= 0; // to "0" when x,y outside of
                    BLUE <= 0;  // the active display area
                end
        end
endmodule