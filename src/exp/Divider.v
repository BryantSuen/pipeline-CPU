`timescale 1ns / 1ps
module Divider(
         clk,reset,clk_div
       );
input clk,reset;
output clk_div;
reg [31:0]cnt;
reg clk_div;
always @(posedge clk or posedge reset)
  begin
    if(reset)
      begin
        cnt <= 32'd0;
        clk_div <= 1'b0;
      end
    else if(cnt < 32'd1000)
      begin
        cnt <= cnt + 1'b1;
        clk_div <= clk_div;
      end
    else
      begin
        cnt <= 0;
        clk_div <= ~clk_div;
      end
  end
endmodule
