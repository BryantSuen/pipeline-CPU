`timescale 1ns / 1ps
module Branch (
         ID_EX_OpCode,
         rs_data, rt_data,
         Branch_hazard
       );
input [5:0] ID_EX_OpCode;
input [31:0] rs_data, rt_data;

output Branch_hazard;

// 6'h04: beq
// 6'h05: bne
// 6'h06: blez
// 6'h07: bgtz
// 6'h01: bltz
assign Branch_hazard = ((ID_EX_OpCode == 6'h04) && (rs_data == rt_data)) ||
       ((ID_EX_OpCode == 6'h05) && (rs_data != rt_data)) ||
       ((ID_EX_OpCode == 6'h06) && (rs_data[31] || (rs_data == 32'b0))) ||
       ((ID_EX_OpCode == 6'h07) && (~rs_data[31] && (rs_data != 32'b0))) ||
       ((ID_EX_OpCode == 6'h01) && (rs_data[31]));

endmodule
