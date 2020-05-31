
`timescale 1ns / 1ps

// Setup WinRom Module
module WinRom(
    input wire [13:0] i_addr, 
    input wire i_clk2,
    output reg [7:0] o_data // (7:0) 8 bit pixel value from Win.mem
    );

    (*ROM_STYLE="block"*) reg [7:0] memory_array [0:14975]; // 8 bit values for 14976 pixels of Win page

    initial begin
            $readmemh("Win.mem", memory_array);
    end

    always @ (posedge i_clk2)
            o_data <= memory_array[i_addr];  

endmodule