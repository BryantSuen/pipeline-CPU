`timescale 1ns / 1ps
module EX_MEM_reg (
         clk, reset,
         EX_Mem_wr, EX_MemtoReg, EX_RegWr,
         EX_ALUout, EX_rt_data, EX_Write_register,
         EX_PC_jal
       );
input clk, reset;
input EX_Mem_wr, EX_RegWr;
input [1:0] EX_MemtoReg;
input [31:0] EX_ALUout, EX_rt_data;
input [4:0] EX_Write_register;
input [31:0] EX_PC_jal;

reg [31:0] ALUout, rt_data;
reg Mem_wr, RegWr;
reg [4:0] Write_register;
reg [31:0] PC_jal;
reg [1:0] MemtoReg;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        ALUout <= 32'b0; rt_data <= 32'b0;
        Mem_wr <= 0; MemtoReg <= 2'b00; RegWr <= 0;
        Write_register <= 5'b0;
        PC_jal <= 32'b0;
    end
    else begin
        ALUout <= EX_ALUout; rt_data <= EX_rt_data;
        Mem_wr <= EX_Mem_wr; MemtoReg <= EX_MemtoReg; RegWr <= EX_RegWr;
        Write_register <= EX_Write_register;
        PC_jal <= EX_PC_jal;
    end
end

endmodule
