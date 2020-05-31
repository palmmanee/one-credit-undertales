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
    input PS2Clk,
    output [6:0]seg,
    output [3:0]an           // Left button : INPUT Pin W19
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
                        
    // instantiate CursorSprite code
    wire Cursor1SpriteOn, Cursor2SpriteOn,Cursor3SpriteOn, Cursor4SpriteOn;       // 1=on, 0=off
    wire [7:0] C1dout;        
    wire [7:0] C2dout;        
    wire [7:0] C3dout;        
    wire [7:0] C4dout;        
    wire [1:0] select;        
    CursorSprite CursorDisplay (.xx(x),.yy(y),.aactive(active),.L(a),.R(d),
                          .C1SpriteOn(Cursor1SpriteOn),.C1dataout(C1dout),
                          .C2SpriteOn(Cursor2SpriteOn),.C2dataout(C2dout),
                          .C3SpriteOn(Cursor3SpriteOn),.C3dataout(C3dout),
                          .C4SpriteOn(Cursor4SpriteOn),.C4dataout(C4dout),
                          .sel(select),.Pclk(PixCLK));    

    // instantiate FightFrameSprite code
    wire FightFrameSpriteOn;
    FightFrameSprite FightFrameDisplay (.xx(x),.yy(y),.aactive(active),
                          .FrameSpriteOn(FightFrameSpriteOn),.Pclk(PixCLK));
    // instantiate ColorbarSprite code
    wire CSpriteOn;
    wire [7:0] CDout;  
    ColorbarSprite ColorbarDisplay (.xx(x),.yy(y),.aactive(active),
                          .ColorSpriteOn(CSpriteOn),.dataout(CDout),.Pclk(PixCLK)); 
                          
    // instantiate PivotSprite code
    wire PivotSpriteOn;
    wire [9:0] dmg;
    wire [9:0] SoulX;
    wire [9:0] SoulY;
     
    wire SoulSpriteOn;       // 1=on, 0=off
    wire FrameSpriteOn;
    wire SanSpriteOn;
    wire BallSpriteOn;
    wire BallSprite2On;
    wire BallSprite3On;
    wire HpSpriteOn;
    wire HpSprite2On;
    wire [9:0] dmg1;
    wire [9:0] dmg2;
    wire [9:0] dmg3;
    wire [7:0] dout;    // pixel value from RedSoul.mem
    wire [7:0] SanDout;        // pixel value from San.mem
    wire state_game;
    wire dead;
    wire win;
    
    PivotSprite PivotDisplay (.xx(x),.yy(y),.aactive(active),
                          .PSpriteOn(PivotSpriteOn),.Pclk(PixCLK),.Hit(space),.dmg(dmg),.state_game(state_game),.win(win),.dead(dead));
        
    // instantiate TiTleSprite code
    wire TSpriteOn;       // 1=on, 0=off
    wire [7:0] Tdout;        // pixel value from Title.mem
    TitleSprite TitleDisplay (.xx(x),.yy(y),.aactive(active),
                          .TitleSpriteOn(TSpriteOn),.dataout(Tdout),.Pclk(PixCLK),.space(space));
                          
    wire GSpriteOn;       // 1=on, 0=off
    wire [7:0] Gdout;        // pixel value from Gameover.mem
    GameoverSprite GameoverDisplay (.xx(x),.yy(y),.aactive(active),
                          .GSpriteOn(GSpriteOn),.dataout(Gdout),.Pclk(PixCLK));
    
    wire WSpriteOn;       // 1=on, 0=off
    wire [7:0] Wdout;        // pixel value from Win.mem
    WinSprite WinDisplay (.xx(x),.yy(y),.aactive(active),
                          .WSpriteOn(WSpriteOn),.dataout(Wdout),.Pclk(PixCLK));
                          
    TimerState timer (.i_clk(PixCLK),.attack(space),.o_state_game(state_game),.TSpriteOn(TSpriteOn));
    
    SoulSprite SoulDisplay (.xx(x),.yy(y),.aactive(active),
                          .SoulSpriteOn(SoulSpriteOn),.dataout(dout),.BR(d),
                          .BL(a),.BU(w),.BD(s),.Pclk(PixCLK),.SoulX(SoulX),.SoulY(SoulY),.state_game(state_game));
                          
    // Frame
    FrameSprite FrameDisplay (.xx(x),.yy(y),.aactive(active),
                          .FrameSpriteOn(FrameSpriteOn),.Pclk(PixCLK));
    
    // Hp
    HpSprite HpDisplay (.xx(x),.yy(y),.aactive(active),
                          .HpSpriteOn(HpSpriteOn),.Pclk(PixCLK),.dmg1(dmg1),.dmg2(dmg2),.dmg3(dmg3),.dead(dead));
                          
    // Hp2
    Hp2Sprite Hp2Display (.xx(x),.yy(y),.aactive(active),
                          .Hp2SpriteOn(Hp2SpriteOn),.Pclk(PixCLK),.dmg(dmg));
    
    // Ball
    BallSprite BallDisplay (.xx(x),.yy(y),.aactive(active),
                          .BallSpriteOn(BallSpriteOn),.Pclk(PixCLK),.SoulX(SoulX),.SoulY(SoulY),.dmg1(dmg1),.state_game(state_game));
    
    BallSprite2 Ball2Display (.xx(x),.yy(y),.aactive(active),
                          .BallSprite2On(BallSprite2On),.Pclk(PixCLK),.SoulX(SoulX),.SoulY(SoulY),.dmg2(dmg2),.state_game(state_game));
   
    BallSprite3 Ball3Display (.xx(x),.yy(y),.aactive(active),
                          .BallSprite3On(BallSprite3On),.Pclk(PixCLK),.SoulX(SoulX),.SoulY(SoulY),.dmg3(dmg3),.state_game(state_game));
    
    //San
    SanSprite SanDisplay (.xx(x),.yy(y),.aactive(active),
                          .SanSpriteOn(SanSpriteOn),.dataout(SanDout),.Pclk(PixCLK));
                          
    // load colour palettes
    reg [7:0] palette [0:191];  // 8 bit values from the 192 hex entries in the colour palette
    reg [7:0] COL = 0;          // background colour palette value
    initial begin
        $readmemh("pal24bit.mem", palette); // load 192 hex values into "palette"
    end
    
    reg [7:0] SanPalette [0:191];  // 8 bit values from the 192 hex entries in the colour palette
    reg [7:0] SanCOL = 0;          // background colour palette value
    initial begin
        $readmemh("SanPal.mem", SanPalette); // load 192 hex values into "SanPalette"
    end
    
    reg [7:0] Tpalette [0:191];  // 8 bit values from the 192 hex entries in the colour palette
    initial begin
        $readmemh("Titlepal.mem", Tpalette); // load 192 hex values into "Tpalette"
    end
    
    reg [7:0] Mpalette [0:191];  // 8 bit values from the 192 hex entries in the colour palette
    initial begin
        $readmemh("MemberPal.mem", Mpalette); // load 192 hex values into "Mpalette"
    end
    
    reg [7:0] Cpalette [0:191];  // 8 bit values from the 192 hex entries in the colour palette
    initial begin
        $readmemh("ColorbarPal.mem", Cpalette); // load 192 hex values into "Cpalette"
    end
    
    reg [7:0] Gpalette [0:191];  // 8 bit values from the 192 hex entries in the colour palette
    initial begin
        $readmemh("GameoverPal.mem", Gpalette); // load 192 hex values into "Gpalette"
    end
    
    reg [7:0] Wpalette [0:191];  // 8 bit values from the 192 hex entries in the colour palette
    initial begin
        $readmemh("WinPal.mem", Wpalette); // load 192 hex values into "Wpalette"
    end
    
    segmentDriver sd(seg, an, dmg1+dmg2+dmg3, CLK);

    // draw on the active area of the screen
    always @ (posedge PixCLK)
    begin
        if (active)
            begin
                if (GSpriteOn==1 && dead==1 && TSpriteOn==0)
                    begin
                        RED <= (Gpalette[(Gdout*3)])>>4;          // RED bits(7:4) from colour palette
                        GREEN <= (Gpalette[(Gdout*3)+1])>>4;      // GREEN bits(7:4) from colour palette
                        BLUE <= (Gpalette[(Gdout*3)+2])>>4;       // BLUE bits(7:4) from colour palette
                    end
                else
                if (WSpriteOn==1 && win==1 && TSpriteOn==0)
                    begin
                        RED <= (Wpalette[(Wdout*3)])>>4;          // RED bits(7:4) from colour palette
                        GREEN <= (Wpalette[(Wdout*3)+1])>>4;      // GREEN bits(7:4) from colour palette
                        BLUE <= (Wpalette[(Wdout*3)+2])>>4;       // BLUE bits(7:4) from colour palette
                    end
                else
                if (TSpriteOn==1)
                    begin
                        RED <= (Tpalette[(Tdout*3)])>>4;          // RED bits(7:4) from colour palette
                        GREEN <= (Tpalette[(Tdout*3)+1])>>4;      // GREEN bits(7:4) from colour palette
                        BLUE <= (Tpalette[(Tdout*3)+2])>>4;       // BLUE bits(7:4) from colour palette
                    end
                else
                if (SoulSpriteOn==1 && state_game ==0 && TSpriteOn==0 && win==0 && dead==0)
                    begin
                        RED <= (palette[(dout*3)])>>4;          // RED bits(7:4) from colour palette
                        GREEN <= (palette[(dout*3)+1])>>4;      // GREEN bits(7:4) from colour palette
                        BLUE <= (palette[(dout*3)+2])>>4;       // BLUE bits(7:4) from colour palette
                    end
                else
                if (FrameSpriteOn==1 && state_game ==0 && TSpriteOn==0 && win==0 && dead==0) 
                    begin              
                      RED<=4'b1111;  
                      GREEN <=4'b1111;
                      BLUE <= 4'b1111;
                    end 
                else
                if (SanSpriteOn==1 && TSpriteOn==0 && win==0 && dead==0) 
                    begin              
                      RED <= (SanPalette[(SanDout*3)])>>4;          // RED bits(7:4) from colour palette
                      GREEN <= (SanPalette[(SanDout*3)+1])>>4;      // GREEN bits(7:4) from colour palette
                      BLUE <= (SanPalette[(SanDout*3)+2])>>4; 
                    end
                else
                if (BallSpriteOn==1 && state_game ==0 && TSpriteOn==0 && win==0 && dead==0) 
                    begin              
                        RED <= 4'b1111;           // RED bits(7:4) from colour palette
                        GREEN <= 4'b1111;       // GREEN bits(7:4) from colour palette
                        BLUE <= 4'b1111;        // BLUE bits(7:4) from colour palette
                    end
                else
                if (BallSprite2On==1 && state_game ==0 && TSpriteOn==0 && win==0 && dead==0) 
                    begin              
                        RED <= 4'b1111;           // RED bits(7:4) from colour palette
                        GREEN <= 4'b1111 ;       // GREEN bits(7:4) from colour palette
                        BLUE <= 4'b1111;        // BLUE bits(7:4) from colour palette
                    end
                else
                if (BallSprite3On==1 && state_game ==0 && TSpriteOn==0 && win==0 && dead==0) 
                    begin              
                        RED <= 0;           // RED bits(7:4) from colour palette
                        GREEN <= 4'b1111 ;       // GREEN bits(7:4) from colour palette
                        BLUE <= 0;        // BLUE bits(7:4) from colour palette
                    end
                else
                if (Cursor1SpriteOn==1 && state_game ==1 && TSpriteOn==0 && win==0 && dead==0)
                    begin
                        RED <= (palette[(C1dout*3)])>>4;        // RED bits(7:4) from colour palette
                        GREEN <= (palette[(C1dout*3)+1])>>4;    // GREEN bits(7:4) from colour palette
                        BLUE <= (palette[(C1dout*3)+2])>>4;     // BLUE bits(7:4) from colour palette
                    end
                else
                if (Cursor2SpriteOn==1 && state_game ==1 && TSpriteOn==0 && win==0 && dead==0)
                    begin
                        RED <= (palette[(C2dout*3)])>>4;        // RED bits(7:4) from colour palette
                        GREEN <= (palette[(C2dout*3)+1])>>4;    // GREEN bits(7:4) from colour palette
                        BLUE <= (palette[(C2dout*3)+2])>>4;     // BLUE bits(7:4) from colour palette
                    end
                else
                if (Cursor3SpriteOn==1 && state_game ==1 && TSpriteOn==0 && win==0 && dead==0)
                    begin
                        RED <= (palette[(C3dout*3)])>>4;        // RED bits(7:4) from colour palette
                        GREEN <= (palette[(C3dout*3)+1])>>4;    // GREEN bits(7:4) from colour palette
                        BLUE <= (palette[(C3dout*3)+2])>>4;     // BLUE bits(7:4) from colour palette
                    end
                else
                if (Cursor4SpriteOn==1 && state_game ==1 && TSpriteOn==0 && win==0 && dead==0)
                    begin
                        RED <= (palette[(C4dout*3)])>>4;        // RED bits(7:4) from colour palette
                        GREEN <= (palette[(C4dout*3)+1])>>4;    // GREEN bits(7:4) from colour palette
                        BLUE <= (palette[(C4dout*3)+2])>>4;     // BLUE bits(7:4) from colour palette
                    end
                else
                if (HpSpriteOn==1 && TSpriteOn==0 && win==0 && dead==0)
                    begin
                        RED <= 0;        // RED bits(7:4) from colour palette
                        GREEN <= 4'b1111;    // GREEN bits(7:4) from colour palette
                        BLUE <= 0;     // BLUE bits(7:4) from colour palette
                    end
                else
                if (Hp2SpriteOn==1 && TSpriteOn==0 && win==0 && dead==0)
                    begin
                        RED <= 4'b1111;        // RED bits(7:4) from colour palette
                        GREEN <= 0;    // GREEN bits(7:4) from colour palette
                        BLUE <= 0;     // BLUE bits(7:4) from colour palette
                    end
                else
                if (FightFrameSpriteOn==1 && state_game ==1 && TSpriteOn==0 && win==0 && dead==0) 
                    begin              
                      RED<=4'b1111;  
                      GREEN <=4'b1111;
                      BLUE <= 4'b1111;
                    end 
                else
                if (PivotSpriteOn==1 && state_game ==1 && TSpriteOn==0 && win==0 && dead==0) 
                    begin              
                      RED<=4'b0000;  
                      GREEN <=4'b1111;
                      BLUE <= 4'b0000;
                    end 
                else
                if (CSpriteOn==1 && state_game ==1 && TSpriteOn==0 && win==0 && dead==0) 
                    begin              
                      RED <= (Cpalette[(CDout*3)])>>4;          // RED bits(7:4) from colour palette
                      GREEN <= (Cpalette[(CDout*3)+1])>>4;      // GREEN bits(7:4) from colour palette
                      BLUE <= (Cpalette[(CDout*3)+2])>>4;
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