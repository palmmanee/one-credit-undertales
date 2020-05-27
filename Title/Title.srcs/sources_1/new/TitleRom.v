
`timescale 1ns / 1ps

// Setup TitleRom Module
module TitleRom(
    input wire [9:0] i_addr, // (9:0) or 2^10 or 1024, need 640*480 = 918
    input wire i_clk2,
    output reg [7:0] o_data // (7:0) 8 bit pixel value from Title.mem
    );

    (*ROM_STYLE="block"*) reg [7:0] memory_array [0:307199]; // 8 bit values for 307200 pixels of Title (640*480)

    initial begin
            $readmemh("Title.mem", memory_array);
    end

    always @ (posedge i_clk2)
            o_data <= memory_array[i_addr];     
endmodule