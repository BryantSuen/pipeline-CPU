`timescale 1ns / 1ps
module Bus (
         clk, reset,
         addr,
         Mem_rd, Mem_wr,
         Write_data, Read_data
       );

input clk, reset;
input Mem_rd, Mem_wr;
input [31:0] addr, Write_data;

output [31:0] Read_data;

wire Data_Memory_en, leds_en, bcd7_en, sysclk_en, uart_en;

//assign Data_Memory_en = addr <= 32'h7ff;
assign Data_Memory_en = 1'b1;
assign leds_en = addr == 32'h4000000C;
assign bcd7_en = addr == 32'h40000010;
assign sysclk_en = addr == 32'h40000014;
assign uart_en = (addr >= 32'h40000018) && (addr <= 32'h40000020);

DataMemory data_memory(.clk(clk), .reset(reset),
                      .addr(addr),
                      .Mem_rd(Mem_rd && Data_Memory_en), .Mem_wr(Mem_wr && Data_Memory_en),
                      .Write_data(Write_data), .Read_data(Read_data));


endmodule
