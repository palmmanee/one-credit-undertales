`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2020 04:55:32 PM
// Design Name: 
// Module Name: TimerState
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


module TimerState(
    input wire i_clk,      // 100MHz onboard clock
    input wire attack,
    output reg o_state_game,
    input wire TSpriteOn      // 25MHz pixel clock
    );
    
    reg [26:0] counter =0;    
    reg [1:0] o_state_game = 0; 
    
    always @ (posedge i_clk)
        begin
            if (TSpriteOn==0)
            begin
            counter = counter +1;
            if(counter > 125000000 && o_state_game == 0)
                begin
                o_state_game = 1;
                end
            else
            if(attack==1 && o_state_game == 1)
                begin
                counter = 0;
                o_state_game = 0;
                end
            end
            
        end
endmodule
