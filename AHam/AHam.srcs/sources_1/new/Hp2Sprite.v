module Hp2Sprite(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg Hp2SpriteOn, // 1=on, 0=off
    input wire Pclk, // 25MHz pixel clock
    input wire [9:0] dmg
//    output reg win=0 
    );
    
    // setup character positions and sizes
    localparam Hp = 200; // Bee width in pixels
    
    always @(posedge Pclk)
        begin
        if (((xx>360 && xx<=360+Hp-dmg) && (yy>448 && yy<460)))
                begin
                Hp2SpriteOn <= 1;
                if (dmg>=200)
                    begin
//                        win=1;
                        Hp2SpriteOn <= 0;
                    end
                end
        else
            begin
                Hp2SpriteOn <= 0;
            end     
        end
endmodule