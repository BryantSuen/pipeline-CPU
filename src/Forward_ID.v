`timescale 1ns / 1ps

module Forward_ID (
         IF_ID_rs,
         ID_EX_Write_register, EX_MEM_Write_register, MEM_WB_Write_register,
         ID_EX_RegWrite, EX_MEM_RegWrite, MEM_WB_RegWrite,
         FA_ID
       );

input [4:0] IF_ID_rs;
input [4:0] ID_EX_Write_register, EX_MEM_Write_register, MEM_WB_Write_register;
input ID_EX_RegWrite, EX_MEM_RegWrite, MEM_WB_RegWrite;

output FA_ID;

assign FA_ID = (ID_EX_RegWrite && (ID_EX_Write_register != 5'b0)
                && (ID_EX_Write_register == IF_ID_rs))? 2'b01 :
       (EX_MEM_RegWrite && (EX_MEM_Write_register != 5'b0)
        && (EX_MEM_Write_register == IF_ID_rs))? 2'b10 :
       (MEM_WB_RegWrite && (MEM_WB_Write_register != 5'b0)
        && (MEM_WB_Write_register == IF_ID_rs))? 2'b11 : 2'b00;

endmodule
