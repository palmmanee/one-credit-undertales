module FrameSprite(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg FrameSpriteOn, // 1=on, 0=off
    input wire Pclk // 25MHz pixel clock
    );
    
    always @(posedge Pclk)
        begin
            if (((xx>245 && xx<395) && (yy>265 && yy<271))||((xx>245 && xx<395) && (yy>409 && yy<415))||((xx>245 && xx<251) && (yy>265 && yy<415))||((xx>389 && xx<395) && (yy>265 && yy<415)))
                begin
                FrameSpriteOn <= 1;
                end
            else
                begin
                FrameSpriteOn <= 0;
                end
        end
endmodule