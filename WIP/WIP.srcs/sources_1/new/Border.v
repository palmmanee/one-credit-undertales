`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2020 08:29:27 PM
// Design Name: 
// Module Name: Border
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


module border(
        px, py,
        rgb
    );

    parameter BUS_WIDTH = 12;
    parameter TOP = 240;
    parameter LEFT = 240;
    parameter BOTTOM = 420;
    parameter RIGHT = 400;
    parameter THICKNESS = 3;

    input wire [9:0] px, py;
    output wire [BUS_WIDTH-1:0] rgb;

    wire isTop = TOP-THICKNESS <= py && py <= TOP+THICKNESS;
    wire isBottom = BOTTOM-THICKNESS <= py && py <= BOTTOM+THICKNESS;
    wire inBoundY = TOP-THICKNESS <= py && py <= BOTTOM+THICKNESS;

    wire isLeft = LEFT-THICKNESS <= px && px <= LEFT+THICKNESS;
    wire isRight = RIGHT-THICKNESS <= px && px <= RIGHT+THICKNESS;
    wire inBoundX = LEFT-THICKNESS <= px && px <= RIGHT+THICKNESS;

    assign rgb = ((inBoundX && (isTop || isBottom)) || (inBoundY && (isLeft || isRight))) ? 15'd3 : 5'd0;

endmodule
