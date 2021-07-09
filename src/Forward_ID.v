`timescale 1ns / 1ps

module Forward_ID (
         IF_ID_rs, IF_ID_rt,
         EX_MEM_Write_register, MEM_WB_Write_register,
         ID_EX_RegWrite, EX_MEM_RegWrite, MEM_WB_RegWrite,
         FA_ID, FB_ID
       );

input [4:0] IF_ID_rs, IF_ID_rt;
input [4:0] EX_MEM_Write_register, MEM_WB_Write_register;
input ID_EX_RegWrite, EX_MEM_RegWrite, MEM_WB_RegWrite;

output [1:0] FA_ID, FB_ID;

assign FA_ID = (EX_MEM_RegWrite && (EX_MEM_Write_register != 5'b0)
                && (EX_MEM_Write_register == IF_ID_rs))? 2'b01 :
       (MEM_WB_RegWrite && (MEM_WB_Write_register != 5'b0)
        && (MEM_WB_Write_register == IF_ID_rs))? 2'b10 : 2'b00;

assign FB_ID = (EX_MEM_RegWrite && (EX_MEM_Write_register != 5'b0)
                && (EX_MEM_Write_register == IF_ID_rt))? 2'b01 :
       (MEM_WB_RegWrite && (MEM_WB_Write_register != 5'b0)
        && (MEM_WB_Write_register == IF_ID_rt))? 2'b10 : 2'b00;

endmodule
