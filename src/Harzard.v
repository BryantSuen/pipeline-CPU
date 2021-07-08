`timescale 1ns / 1ps
module Hazard (
         ID_EX_rt, IF_ID_rs, IF_ID_rt,
         ID_EX_Mem_rd,
         IF_ID_OpCode, IF_ID_Funct,

         PC_Wr_en, IF_ID_Wr_en,
         IF_ID_flush, ID_EX_flush
       );

input [4:0] ID_EX_rt, IF_ID_rs, IF_ID_rt;
input ID_EX_Mem_rd; // Mem_rd equals to MemtoReg
input [5:0] IF_ID_OpCode, IF_ID_Funct;

output PC_Wr_en, IF_ID_Wr_en;
output IF_ID_flush, ID_EX_flush;

wire load_use_harzard;
wire Branch_harzard;
wire Jump_harzard;

//harzard
assign load_use_harzard = ID_EX_Mem_rd && ((ID_EX_rt == IF_ID_rs) || (ID_EX_rt == IF_ID_rt));
assign Branch_harzard = ID_EX_Branch && (rs_forward == rt_forward);
assign Jump_harzard = (IF_ID_OpCode == 6'h02) || (IF_ID_OpCode == 6'h03) ||
       (IF_ID_OpCode == 6'h0 && ((IF_ID_Funct == 6'h08) || (IF_ID_Funct == 6'h09)));

//load-use
assign IF_ID_Wr_en = ~load_use_harzard;
assign PC_Wr_en = ~load_use_harzard;

//branch
assign IF_ID_flush = Branch_harzard || (IF_ID_Wr_en && Jump_harzard);
assign ID_EX_flush = Branch_harzard;

endmodule
