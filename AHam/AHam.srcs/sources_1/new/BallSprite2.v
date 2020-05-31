module BallSprite2(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg BallSprite2On, // 1=on, 0=off
    input wire Pclk, // 25MHz pixel clock
    input wire [9:0] SoulX,
    input wire [9:0] SoulY,
    output reg [9:0] dmg2 = 0,
    input wire state_game
    );
    
    reg [9:0] hit=0;          // counter to slow ball movement
    reg [9:0] B1X = 360;            // X start position
    reg [9:0] B1Y = 340;             // Y start position
    reg [1:0] Bdir = 1;             // direction of ball: 0=right, 1=left
    reg [1:0] del = 0;

    
    always @(posedge Pclk)
        begin
            if (((xx-B1X)**2 + (yy-B1Y)**2) <= 25 && del == 0)
                begin
                BallSprite2On <= 1;
                end
            else
                begin
                BallSprite2On <= 0;
                end
        end
    
        
    always @ (posedge Pclk)
        begin
        if (xx==639 && yy==479 && state_game==1)
            begin // check for left or right button pressed
                B1X<=360;
                B1Y<=340;
                del<=0;
            end
        // slow down the ball movement / move ball left or right
        if (xx==639 && yy==479)
            begin
                hit<=hit+1;
                if (hit>1)
                    begin
                        hit<=0;
                        if (Bdir==1)
                            begin
                                B1Y<=B1Y+6;
                                if (B1Y>397)
                                    Bdir<=0;
                            end
                        if (Bdir==0)
                            begin
                                B1Y<=B1Y-6;
                                if (B1Y<283)
                                    Bdir<=1;
                            end
                        if ((SoulX+15 > B1X && SoulX < B1X) && (SoulY+15 > B1Y && SoulY < B1Y))
                            begin
                                if (dmg2 < 200)
                                begin
                                    if (dmg2 ==0 && del==0)
                                    begin
                                        del <= 1;
                                        dmg2<=50;
                                    end
                                    if (dmg2 ==50 && del==0)
                                    begin
                                        del <= 1;
                                        dmg2<=100;
                                    end
                                    if (dmg2 ==100 && del==0)
                                    begin
                                        del <= 1;
                                        dmg2<=150;
                                    end
                                    if (dmg2 ==150 && del==0)
                                    begin
                                        del <= 1;
                                        dmg2<=200;
                                    end
                                end
                            end
                    end
            end
      end
      
endmodule