`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2020 08:31:22 AM
// Design Name: 
// Module Name: clkDivide
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


module clkDivide(
    output reg fClk,
    input wire clk,
    input wire [4:0] bit
    );
parameter bitDiv=22;

wire [bitDiv-1:0] f, d;

assign f[0] = clk;

genvar i;
for(i=1;i<bitDiv;i = i+1)
    begin
    flipflop ff(f[i], d[i], d[i], f[i-1]);
    end
always @(f[bit[4:0]]) fClk = f[bit[4:0]];
    
endmodule


module flipflop(
    output reg q,
    output reg qd,
    input wire d,
    input wire clk
    );

reg st;

initial st = 0;

always @(posedge clk) st = d;
always @(st)
begin
    q = st;
    qd = !st;
end
endmodule
