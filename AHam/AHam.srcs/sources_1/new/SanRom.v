`timescale 1ns / 1ps

// Setup BeeRom Module
module SanRom(
    input wire [14:0] i_addr, 
    input wire i_clk2,
    output reg [7:0] o_data // (7:0) 8 bit pixel value from San.mem
    );

    (*ROM_STYLE="block"*) reg [7:0] memory_array [0:22799]; // 8 bit values for 22800 pixels of San 

    initial begin
            $readmemh("San.mem", memory_array);
    end

    always @ (posedge i_clk2)
            o_data <= memory_array[i_addr];     
endmodule