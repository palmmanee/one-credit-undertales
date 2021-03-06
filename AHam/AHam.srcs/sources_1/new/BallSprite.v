module BallSprite(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg BallSpriteOn, // 1=on, 0=off
    input wire Pclk, // 25MHz pixel clock
    input wire [9:0] SoulX,
    input wire [9:0] SoulY,
    output reg [9:0] dmg1 = 0,
    input wire state_game
    );
    
    reg [9:0] hit=0;          // counter to slow Ball movement
    reg [9:0] B1X = 251;            // X start position
    reg [9:0] B1Y = 370;             // Y start position
    reg [1:0] Bdir = 1;             // direction of Ball: 0=right, 1=left
    reg [1:0] del = 0;

    
    always @(posedge Pclk)
        begin
            if (((xx-B1X)**2 + (yy-B1Y)**2) <= 25 && del == 0)
                begin
                BallSpriteOn <= 1;
                end
            else
                begin
                BallSpriteOn <= 0;
                end
        end
    
        
    always @ (posedge Pclk)
        begin
        if (xx==639 && yy==479 && state_game==1)
            begin // check for left or right button pressed
                B1X<=251;
                B1Y<=370;
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
                                B1X<=B1X+6;
                                if (B1X>376)
                                    Bdir<=0;
                            end
                        if (Bdir==0)
                            begin
                                B1X<=B1X-6;
                                if (B1X<263)
                                    Bdir<=1;
                            end
                        if ((SoulX+15 > B1X && SoulX < B1X) && (SoulY+15 > B1Y && SoulY < B1Y))
                            begin
                                if (dmg1 < 200)
                                begin
                                    if (dmg1 ==0 && del==0)
                                    begin
                                        dmg1<=50;
                                        del <= 1;
                                    end
                                    if (dmg1 ==50 && del==0)
                                    begin
                                        dmg1<=100;
                                        del <= 1;
                                    end
                                    if (dmg1 ==100 && del==0)
                                    begin
                                        dmg1<=150;
                                        del <= 1;
                                    end
                                    if (dmg1 ==150 && del==0)
                                    begin
                                        dmg1<=200;
                                        del <= 1;
                                    end
                                end
                            end
                    end
            end
      end

endmodule