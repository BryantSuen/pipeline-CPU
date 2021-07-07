`timescale 1ns / 1ps

module PC(reset, clk, PCWrite, PC_flush, PC_i, PC_o);
    //Input Clock Signals
    input reset;             
    input clk;
    //Input Control Signals             
    input PCWrite, PC_flush;
    //Input PC             
    input [31:0] PC_i;
    //Output PC  
    output reg [31:0] PC_o; 


    always@(posedge reset or posedge clk)
    begin
        if(reset || PC_flush) begin
            PC_o <= 0;
        end else if (PCWrite) begin
            PC_o <= PC_i;
        end else begin
            PC_o <= PC_o;
        end
    end
endmodule