`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2020 12:34:07 AM
// Design Name: 
// Module Name: ColorbarRom
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


module ColorbarRom(
    input wire [14:0] i_addr, // (9:0) or 2^10 or 1024, need 34 x 27 = 918
    input wire i_clk2,
    output reg [7:0] o_data // (7:0) 8 bit pixel value from Bee.mem
    );

    (*ROM_STYLE="block"*) reg [7:0] memory_array [0:5069]; // 8 bit values for 918 pixels of Bee (34 x 27)

    initial begin
            $readmemh("colorbar.mem", memory_array);
    end

    always @ (posedge i_clk2)
            o_data <= memory_array[i_addr];   
endmodule
