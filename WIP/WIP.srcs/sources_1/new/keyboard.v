`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc 
// Engineer: Arthur Brown
// 
// Create Date: 07/27/2016 02:04:01 PM
// Design Name: Basys3 Keyboard Demo
// Module Name: top
// Project Name: Keyboard
// Target Devices: Basys3
// Tool Versions: 2016.X
// Description: 
//     Receives input from USB-HID in the form of a PS/2, displays keyboard key presses and releases over USB-UART.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//     Known issue, when multiple buttons are pressed and one is released, the scan code of the one still held down is ometimes re-sent.
//////////////////////////////////////////////////////////////////////////////////

module keyboard(
    input         clk,
    input         PS2Data,
    input         PS2Clk,
    output reg       w,
    output reg       s,
    output reg       a,
    output reg       d,
    output reg       space,
    output reg [15:0]keycodev
);
    wire        tready;
    wire        ready;
    wire        tstart;
    reg         start=0;
    reg         CLK50MHZ=0;
    wire [31:0] tbuf;
    //reg  [15:0] keycodev=0;
    wire [15:0] keycode;
    wire [ 7:0] tbus;
    reg  [ 2:0] bcount=0;
    wire        flag;
    reg         cn=0;
    
    always @(posedge(clk))begin
        CLK50MHZ<=~CLK50MHZ;
    end
    
    PS2Receiver uut (
        .clk(CLK50MHZ),
        .kclk(PS2Clk),
        .kdata(PS2Data),
        .keycode(keycode),
        .oflag(flag)
    );
    
    
    always@(keycode)
        if (keycode[7:0] == 8'hf0) begin
            cn <= 1'b0;
            bcount <= 3'd0;
        end else if (keycode[15:8] == 8'hf0) begin
            cn <= keycode != keycodev;
            bcount <= 3'd5;
        end else begin
            cn <= keycode[7:0] != keycodev[7:0] || keycodev[15:8] == 8'hf0;
            bcount <= 3'd2;
        end
    
    always@(posedge clk)
        if (flag == 1'b1 && cn == 1'b1) begin
            start <= 1'b1;
            keycodev <= keycode;
        end else
            start <= 1'b0;
    
    always @(keycodev)
        if (keycodev[15:8]!=8'b11110000 && keycodev[7:0]==8'b00011100)//a
            begin
             a = 1'b1;
            end
        else if (keycodev[15:8]!=8'b11110000 && keycodev[7:0]==8'b00100011)//d
            begin
             d = 1'b1;
            end
        else if (keycodev[15:8]!=8'b11110000 && keycodev[7:0]==8'b00011101)//w
            begin
             w = 1'b1;
            end
        else if (keycodev[15:8]!=8'b11110000 && keycodev[7:0]==8'b00011011)//s
            begin
             s = 1'b1;
            end
        else if (keycodev[15:8]!=8'b11110000 && keycodev[7:0]==8'b00011001)//space
            begin
             s = 1'b1;
            end                                                          
        else
            begin
             w = 1'b0;
             s = 1'b0;
             a = 1'b0;
             d = 1'b0;
            end
    initial
    begin
        keycodev<=16'b1111111111111111;
    end           
            
endmodule
