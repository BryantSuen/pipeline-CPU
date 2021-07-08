`timescale 1ns / 1ps
module ID_EX_reg (
    clk, reset, 
    ID_PC_plus4, ID_rs_data, ID_rt_data, ID_Imm_ext,
    ID_rs, ID_rt, ID_rd;
    ID_ExtOp, ID_RegDst, ID_Mem_wr, ID_Branch, ID_MemtoReg, ID_RegWr,
    ID_ALUSrcA, ID_ALUSrcB, 
    ID_ALUOp, 
    ID_EX_flush
);

input clk, reset;
input [31:0] ID_PC_plus4, ID_rs_data, ID_rt_data, ID_Imm_ext;
input [4:0] ID_rs, ID_rt, ID_rd;
input ID_ExtOp, ID_Mem_wr, ID_Branch, ID_MemtoReg, ID_RegWr;
input ID_ALUSrcA, ID_ALUSrcB;
input [3:0] ID_ALUOp;
input ID_EX_flush;
input [1:0] ID_RegDst;

reg [31:0] PC_plus4, rs_data, rt_data, Imm_ext;
reg [4:0] rs, rt, rd;
reg ExtOp, Mem_wr, Branch, MemtoReg, RegWr;
reg ALUSrcA, ALUSrcB;
reg [3:0] ALUOp;
reg [1:0] RegDst;

always @( posedge clk or posedge reset ) begin

    if( reset || ID_EX_flush ) begin
        PC_plus4 <= 32'b0; rs_data <= 32'b0; rt_data <= 32'b0; Imm_ext <= 32'b0;
        rs <= 5'b0; rt <= 5'b0; rd <= 5'b0; 
        ExtOp <= 0; RegDst <= 2'b0; Mem_wr <= 0; Branch <= 0; MemtoReg <= 0; RegWr <= 0;
        ALUSrcA <= 0; ALUSrcB <= 0;
        ALUOp <= 4'b0;
    end

    else begin
        PC_plus4 <= ID_PC_plus4; rs_data <= ID_rs_data; rt_data <= ID_rt_data; Imm_ext <= ID_Imm_ext;
        rs <= ID_rs; rt <= ID_rt; rd <= ID_rd;
        ExtOp <= ID_ExtOp; RegDst <= ID_RegDst; Mem_wr <= ID_Mem_wr; 
        Branch <= ID_Branch; MemtoReg <= ID_MemtoReg; RegWr <= ID_RegWr;
        ALUSrcA <= ID_ALUSrcA; ALUSrcB <= ID_ALUSrcB;
        ALUOp <= ID_ALUOp;
    end

end

    
endmodule