`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2020 10:03:06 PM
// Design Name: 
// Module Name: FightFrameSprite
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

module FightFrameSprite(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg FrameSpriteOn, // 1=on, 0=off
    input wire Pclk // 25MHz pixel clock
    );
    
    always @(posedge Pclk)
        begin
            if (((xx>125 && xx<515) && (yy>265 && yy<271))//h
            ||((xx>125 && xx<515) && (yy>409 && yy<415))//h
            ||((xx>125 && xx<131) && (yy>265 && yy<415))//v
            ||((xx>509 && xx<515) && (yy>265 && yy<415)))//v
                begin
                FrameSpriteOn <= 1;
                end
            else
                begin
                FrameSpriteOn <= 0;
                end
        end

endmodule
