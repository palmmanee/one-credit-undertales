`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2020 12:03:40 AM
// Design Name: 
// Module Name: PivotSprite
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


module PivotSprite(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg PSpriteOn, // 1=on, 0=off
    input wire Pclk, // 25MHz pixel clock
    input wire Hit, // 25MHz pixel clock
    output reg [9:0]dmg, // 25MHz pixel clock
    input wire state_game,
    output reg win=0,
    input wire dead
    );
    
    reg [9:0] PX = 150;            
    reg [9:0] PY = 275;             
    localparam PWidth = 6;        
    localparam PHeight = 130;   
    reg [1:0] Adir = 1;   
    reg [9:0] del=0;
    
    initial dmg = 0;
    always @(posedge Hit)
        begin
        if (dmg < 200 && state_game ==1 && dead==0)
        begin
            if (PX>=131&&PX<178) dmg<=dmg+25;
            if (PX>=178&&PX<268) dmg<=dmg+50;
            if (PX>=268&&PX<332) dmg<=dmg+100;
            if (PX>=332&&PX<422) dmg<=dmg+50;
            if (PX>=422&&PX<515) dmg<=dmg+25;
        end
        if (dmg>=200)
            begin
                dmg <= 200;
            end
        end
              
    always @(posedge Pclk)
        begin
            if (dmg>=200)
            begin
                win=1;
            end
            if ((xx>PX && xx<PX+PWidth) && (yy>PY && yy<PY+PHeight))//v
                begin
                PSpriteOn <= 1;
                end
            else
                begin
                PSpriteOn <= 0;
                end
        end
    always @ (posedge Pclk)
    begin
        if (xx==639 && yy==479)
            begin
                del<=del+1;
                if (del>1)
                    begin
                        del<=0;
                        if (Adir==1)
                            begin
                                PX<=PX-10;
                                if (PX<161)
                                    Adir<=0;
                            end
                        if (Adir==0)
                            begin
                                PX<=PX+10;
                                if (PX+PWidth>479)    
                                    Adir<=1;
                            end
                    end
            end
    end
endmodule
