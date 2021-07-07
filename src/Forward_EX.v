`timescale 1ns / 1ps

module Forward_EX (
         ID_EX_rs, ID_EX_rt,
         EX_MEM_Write_register, MEM_WB_Write_register,
         EX_MEM_RegWrite, MEM_WB_RegWrite,
         FA_EX, FB_EX
       );

input [4:0] ID_EX_rs, ID_EX_rt;
input [4:0] EX_MEM_Write_register, MEM_WB_Write_register;
input EX_MEM_RegWrite, MEM_WB_RegWrite;

output [1:0] FA_EX, FB_EX;

assign FA_EX = (EX_MEM_RegWrite && EX_MEM_Write_register != 5'b0
             && (EX_MEM_Write_register == ID_EX_rs))?10 :
       (MEM_WB_RegWrite && MEM_WB_Write_register != 5'b0
        && (MEM_WB_Write_register == ID_EX_rs))?01 : 00;

assign FB_EX = (EX_MEM_RegWrite && EX_MEM_Write_register != 5'b0
             && (EX_MEM_Write_register == ID_EX_rt))?10 :
       (MEM_WB_RegWrite && MEM_WB_Write_register != 5'b0
        && (MEM_WB_Write_register == ID_EX_rt))?01 : 00;

endmodule
