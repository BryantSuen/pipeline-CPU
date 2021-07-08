`timescale 1ns / 1ps
module DataMemory (
    clk, reset,
    addr, 
    Mem_rd, Mem_wr,
    Write_data, Read_data
);

input reset, clk;
input [31:0] addr, Write_data;
input Mem_rd, Mem_wr;

output [31:0] Read_data;

    
endmodule