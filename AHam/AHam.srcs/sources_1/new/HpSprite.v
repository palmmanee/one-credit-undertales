module HpSprite(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg HpSpriteOn, // 1=on, 0=off
    input wire Pclk, // 25MHz pixel clock
    input wire [9:0] dmg1,
    input wire [9:0] dmg2,
    input wire [9:0] dmg3,
    output reg dead=0
    );
    
    // setup character positions and sizes
    localparam Hp = 200; // width in pixels
    
    always @(posedge Pclk)
        begin
        if (((xx>=80 && xx<=80+Hp-dmg1-dmg2+dmg3) && (yy>448 && yy<460)))
                begin
                HpSpriteOn <= 1;
                if (dmg1+dmg2-dmg3>=200 && dmg1+dmg2>0)
                    begin
                        dead=1;
                        HpSpriteOn <= 0;
                    end
                end
        else
            begin
                HpSpriteOn <= 0;
            end     
        end
endmodule