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

parameter RAM_SIZE = 512;
parameter RAM_SIZE_BIT = 9;
integer i;

reg [31:0] RAM_data[RAM_SIZE - 1: 0];

assign Read_data = Mem_rd ? RAM_data[addr[RAM_SIZE_BIT + 1 : 2]] : 32'b0;

always @(posedge clk or posedge reset)
  begin
    if(reset)
      begin
        for(i = 20; i < RAM_SIZE; i = i + 1)
          begin
            RAM_data[i] <= 32'b0;
          end
        RAM_data[0] <= 32'd5;
        RAM_data[1] <= 32'd5;
        RAM_data[2] <= 32'd2;
        RAM_data[3] <= 32'hc;
        RAM_data[4] <= 32'h1;
        RAM_data[5] <= 32'ha;
        RAM_data[6] <= 32'h3;
        RAM_data[7] <= 32'h14;
        RAM_data[8] <= 32'h2;
        RAM_data[9] <= 32'hf;
        RAM_data[10] <= 32'h1;
        RAM_data[11] <= 32'h8;
      end
    else if (Mem_wr)
      begin
        RAM_data[addr[RAM_SIZE_BIT + 1 : 2]] <= Write_data;
      end
  end



endmodule
