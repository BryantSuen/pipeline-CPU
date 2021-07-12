`timescale 1ns / 1ps
module Bus (
         clk, reset,
         addr,
         Mem_rd, Mem_wr,
         Write_data, Read_data,
         bcd7_rd_data
       );

input clk, reset;
input Mem_rd, Mem_wr;
input [31:0] addr, Write_data;

output [31:0] Read_data;
output [11:0] bcd7_rd_data;

wire Data_Memory_en, leds_en, bcd7_en, sysclk_en, uart_en;

wire [31:0] Mem_rd_data;

assign Data_Memory_en = addr <= 32'h7ff;
assign leds_en = addr == 32'h4000000C;
assign bcd7_en = addr == 32'h40000010;
assign sysclk_en = addr == 32'h40000014;
assign uart_en = (addr >= 32'h40000018) && (addr <= 32'h40000020);

DataMemory data_memory(.clk(clk), .reset(reset),
                       .addr(addr),
                       .Mem_rd(Mem_rd && Data_Memory_en), .Mem_wr(Mem_wr && Data_Memory_en),
                       .Write_data(Write_data), .Read_data(Mem_rd_data));

BCD7 bcd7(.clk(clk), .reset(reset),
          .bcd7_wr_en(bcd7_en && Mem_wr),
          .bcd7_wr_data(Write_data[11:0]),
          .bcd7_rd_data(bcd7_rd_data));

assign Read_data = Data_Memory_en ? Mem_rd_data :
       bcd7_en ? {20'b0 , bcd7_rd_data}: 32'b0;

endmodule
