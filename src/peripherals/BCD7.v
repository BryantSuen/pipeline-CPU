`timescale 1ns / 1ps
module BCD7 (
         clk, reset,
         bcd7_wr_en, bcd7_wr_data,
         bcd7_rd_data
       );

input clk, reset, bcd7_wr_en;
input [11:0] bcd7_wr_data;

output reg [11:0] bcd7_rd_data;

always @(posedge clk or posedge reset)
  begin
    if(reset)
      bcd7_rd_data <= 12'b0;
    else
      begin
        if(bcd7_wr_en)
          bcd7_rd_data <= bcd7_wr_data;
      end
  end

endmodule