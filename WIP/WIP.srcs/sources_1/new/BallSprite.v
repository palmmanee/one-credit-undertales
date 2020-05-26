module BallSprite(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg BallSpriteOn, // 1=on, 0=off
    input wire Pclk // 25MHz pixel clock

    );
    
    reg [9:0] hit=0;          // counter to slow alien movement
    reg [9:0] B1X = 300;            // Alien1 X start position
    reg [9:0] B1Y = 250;             // Alien1 Y start position
    reg [1:0] Bdir = 1;             // direction of aliens: 0=right, 1=left


    
    always @(posedge Pclk)
        begin
            if (((xx-100)**2 + (yy-100)**2) <= 25)
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
        // slow down the alien movement / move aliens left or right
        if (xx==639 && yy==479)
            begin
                hit<=hit+1;
                if (hit>1)
                    begin
                        hit<=0;
                        if (Bdir==1)
                            begin
                                B1X<=B1X-10;
                                if (B1X<23)
                                    Bdir<=0;
                            end
                        if (Bdir==0)
                            begin
                                B1X<=B1X+10;
                                //if (A1X+A1Width+((AcolCount-1)*40)>636)    
                                   // Adir<=1;
                            end
                    end
            end
      end
      
      always @ (posedge Pclk)
        begin
        // slow down the alien movement / move aliens left or right
        if (xx==B1X && yy==B1Y)
            BallSpriteOn <=1;
        end
endmodule