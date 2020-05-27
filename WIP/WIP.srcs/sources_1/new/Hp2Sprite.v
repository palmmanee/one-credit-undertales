module Hp2Sprite(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg Hp2SpriteOn, // 1=on, 0=off
    input wire Pclk // 25MHz pixel clock
    );
    
    // setup character positions and sizes
    localparam Hp = 200; // Bee width in pixels
    
    always @(posedge Pclk)
        begin
        if (((xx>360 && xx<360+Hp) && (yy>448 && yy<460)))
                begin
                Hp2SpriteOn <= 1;
                end
            else
                begin
                Hp2SpriteOn <= 0;
                end     
        end
endmodule