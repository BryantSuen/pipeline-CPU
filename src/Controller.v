`timescale 1ns / 1ps
module Controller (
         clk, reset,
         ID_instruction,
         Branch_hazard,

         OpCode,
         PC_src, RegDst,
         Reg_wr, ExtOp, LuiOp,
         ALUSrcA, ALUSrcB, ALUOp, Funct, MemtoReg,
         Mem_wr, Mem_rd
       );

input clk, reset;
input [31:0] ID_instruction;
input Branch_hazard;

output Mem_wr, Mem_rd;
output [3:0] ALUOp;
output [5:0] Funct;
output [1:0] RegDst, PC_src;
output [1:0] MemtoReg;
output ALUSrcA, ALUSrcB;
output Reg_wr;
output ExtOp, LuiOp;

output [5:0] OpCode;

assign OpCode = ID_instruction[31:26];
assign Funct = ID_instruction[5:0];

assign Mem_wr = OpCode == 6'h2b;
assign Mem_rd = OpCode == 6'h23;

// 2'b00: PC+4
// 2'b01: branch
// 2'b10: j
// 2'b11: jr
assign PC_src = Branch_hazard ? 2'b01 :
       (OpCode == 6'h02 || OpCode == 6'h03) ? 2'b10 :
       (OpCode == 6'h00 && (Funct == 6'h08 || Funct == 6'h09))? 2'b11 : 2'b00;

assign Reg_wr = (OpCode == 6'h0 && Funct != 5'h08) || OpCode == 6'h23 || OpCode == 6'h0f || OpCode == 6'h08
       || OpCode == 6'h09 || OpCode == 6'h0c || OpCode == 6'h0a || OpCode == 6'h0b || OpCode == 6'h03;

assign ExtOp = OpCode != 6'h0c;
assign LuiOp = OpCode == 6'h0f;

// 1'b1: Imm
// 1'b0: rs
assign ALUSrcA = OpCode == 6'h00 && (Funct == 6'h00 || Funct == 6'h02 || Funct == 6'h03);

// 1'b1: Imm
// 1'b0: rt
assign ALUSrcB = OpCode == 6'h23 || OpCode == 6'h2b || OpCode == 6'h0f || OpCode == 6'h08
       || OpCode == 6'h09 || OpCode == 6'h0c || OpCode == 6'h0a || OpCode == 6'h0b;

assign ALUOp[3] = OpCode[0];

assign ALUOp[2:0] =
       (OpCode == 6'h00)? 3'b010:
       (OpCode == 6'h04)? 3'b001:
       (OpCode == 6'h0c)? 3'b100:
       (OpCode == 6'h0a || OpCode == 6'h0b)? 3'b101:
       3'b000;

// 2'b00 : Reg
// 2'b01 : Mem
// 2'b10 : jal
assign MemtoReg = (OpCode == 6'h23) ? 2'b01 :
       (OpCode == 6'h03) ? 2'b10 : 2'b00;

// 2'b01: rd
// 2'b00: rt
// 2'b10: ra
assign RegDst = OpCode == 6'h00 ? 2'b01 : OpCode == 6'h03 ? 2'b10 : 2'b00;

endmodule
