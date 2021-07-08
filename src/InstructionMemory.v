`timescale 1ns / 1ps
module InstructionMemory (
         address,
         instruction
       );
input [31:0] address;
output reg [31:0] instruction;

always @( address )
  begin
    case (address[9:2])
      8'd0 :
        instruction <= {6'h08, 5'h0, 5'h4, 16'h7};
      8'd1 :
        instruction <= {6'h08, 5'h0, 5'h5, 16'h8};
      8'd2 :
        instruction <= {6'h0, 5'h4, 5'h5, 5'h6, 5'h0, 6'h20};
      default :
        instruction <= 32'b0;
    endcase
  end

endmodule
