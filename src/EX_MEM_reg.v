`timescale 1ns / 1ps
module EX_MEM_reg (
         clk, reset,
         EX_PC_pImm,
         EX_MemWr, EX_MemtoReg, EX_RegWr,
         EX_ALUout, EX_Zero, EX_rt_data, EX_Write_register
       );
input clk, reset;
input [31:0] EX_PC_pImm;
input EX_MemWr, EX_MemtoReg, EX_RegWr;
input [31:0] EX_ALUout, EX_rt_data;
input EX_Zero;
input [4:0] EX_Write_register;

reg [31:0] PC_pImm, ALUout, rt_data;
reg MemWr, MemtoReg, RegWr;
reg Zero;
reg [4:0] Write_register;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        PC_pImm <= 32'b0; ALUout <= 32'b0; rt_data <= 32'b0;
        MemWr <= 0; MemtoReg <= 0; RegWr <= 0;
        Zero <= 0;
        Write_register <= 5'b0;
    end
    else begin
        PC_pImm <= EX_PC_pImm; ALUout <= EX_ALUout; rt_data <= EX_rt_data;
        MemWr <= EX_MemWr; MemtoReg <= EX_MemtoReg; RegWr <= EX_RegWr;
        Zero <= EX_Zero; 
        Write_register <= EX_Write_register;
    end
end

endmodule
