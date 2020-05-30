`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2020 02:38:58 PM
// Design Name: 
// Module Name: CursorRom
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

module CursorRom(
    input wire [9:0] i_Caddr, // (9:0) or 2^10 or 1024, need 34 x 27 = 918
    input wire i_clk2,
    output reg [7:0] o_Cdata // (7:0) 8 bit pixel value from Bee.mem
    );
/*    
    (*ROM_STYLE="block"*) reg [7:0] memory_array [0:917]; // 8 bit values for 918 pixels of Bee (34 x 27)

    initial begin
            $readmemh("Bee.mem", memory_array);
    end

    always @ (posedge i_clk2)
            o_Cdata <= memory_array[i_Caddr];  */

    (*ROM_STYLE="block"*) reg [7:0] Cmemory_array [0:1023]; // 8 bit values for 918 pixels of Bee (34 x 27)

    initial begin
            $readmemh("Cursor.mem", Cmemory_array);
    end

    always @ (posedge i_clk2)
            o_Cdata <= Cmemory_array[i_Caddr];     
endmodule
