
`timescale 1ns / 1ps

// Setup TitleRom Module
module TitleRom(
    input wire [16:0] i_addr,
    input wire i_clk2,
    output reg [7:0] o_data 
    );

    (*ROM_STYLE="block"*) reg [7:0] memory_array [0:86099]; 

    initial begin
            $readmemh("TiTle.mem", memory_array);
    end

    always @ (posedge i_clk2)
            o_data <= memory_array[i_addr];  

endmodule