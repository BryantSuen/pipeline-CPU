`timescale 1ns / 1ps

module IF_ID_reg (
    clk, reset,
    IF_PC, IF_instruction,
    IF_ID_wr_en, IF_ID_flush 
);

input clk,reset;
input [31:0] IF_PC, IF_instruction;
input IF_ID_wr_en, IF_ID_flush;

reg [31:0] PC_plus4, instruction;

always @(posedge clk or posedge reset) begin
    if( reset || IF_ID_flush )begin
        PC_plus4 <= 32'h0;
        instruction <= 32'h0;
    end
    else if ( IF_ID_wr_en ) begin
        PC_plus4 <= IF_PC;
        instruction <= IF_instruction;
    end
end
     
endmodule