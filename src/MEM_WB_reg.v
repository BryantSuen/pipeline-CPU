`timescale 1ns / 1ps
module MEM_WB_reg (
    clk, reset, 
    MEM_MemtoReg, MEM_RegWr,
    MEM_DM_data, MEM_ALUout,
    MEM_Write_register
);
input clk, reset;
input MEM_MemtoReg, MEM_RegWr;
input [31:0] MEM_DM_data, MEM_ALUout;
input [4:0] MEM_Write_register;

reg MemtoReg, RegWr;
reg [31:0] DM_data, ALUout;
reg [4:0] Write_register;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        MemtoReg <= 0; RegWr <= 0;
        DM_data <= 32'b0; ALUout <= 32'b0;
        Write_register <= 5'b0;
    end
    else begin
        MemtoReg <= MEM_MemtoReg; RegWr <= MEM_RegWr;
        DM_data <= MEM_DM_data; ALUout <= MEM_ALUout;
        Write_register <= MEM_Write_register;
    end
end
    
endmodule