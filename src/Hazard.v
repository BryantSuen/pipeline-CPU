`timescale 1ns / 1ps
module Hazard (
         ID_EX_rt, IF_ID_rs, IF_ID_rt,
         ID_EX_Mem_rd,

         IF_ID_OpCode, IF_ID_Funct,
         rs_forward, rt_forward,
         Branch_hazard,

         EX_MEM_Mem_rd, EX_MEM_Write_register,

         PC_Wr_en, IF_ID_Wr_en,
         IF_ID_flush, ID_EX_flush
       );

input [4:0] ID_EX_rt, IF_ID_rs, IF_ID_rt;
input ID_EX_Mem_rd;
input [5:0] IF_ID_OpCode, IF_ID_Funct;
input [31:0] rs_forward, rt_forward;
input Branch_hazard;

input EX_MEM_Mem_rd;
input [4:0] EX_MEM_Write_register;

output PC_Wr_en, IF_ID_Wr_en;
output IF_ID_flush, ID_EX_flush;

wire load_use_hazard;
wire Jump_hazard;

//hazard
assign load_use_hazard = (ID_EX_Mem_rd && ((ID_EX_rt == IF_ID_rs) || (ID_EX_rt == IF_ID_rt))) ||
       (EX_MEM_Mem_rd && (EX_MEM_Write_register == IF_ID_rs) && (IF_ID_OpCode == 6'h00) && (IF_ID_Funct == 6'h08));
assign Jump_hazard = (IF_ID_OpCode == 6'h02) || (IF_ID_OpCode == 6'h03) ||
       (IF_ID_OpCode == 6'h0 && ((IF_ID_Funct == 6'h08) || (IF_ID_Funct == 6'h09)));

//load-use
assign IF_ID_Wr_en = ~load_use_hazard;
assign PC_Wr_en = ~load_use_hazard;

//branch
assign IF_ID_flush = Branch_hazard || (IF_ID_Wr_en && Jump_hazard);
assign ID_EX_flush = Branch_hazard;

endmodule
