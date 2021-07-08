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
        instruction <={6'h2b, 5'h0, 5'h4, 16'h4};
      8'd2 :
        instruction <={6'h08, 5'h0, 5'h5, 16'h1};
      8'd3 :
        instruction <={6'h04, 5'h4, 5'h5, 16'h2};
      8'd4 :
        instruction <={6'h08, 5'h5, 5'h5, 16'h1};
      8'd5 :
        instruction <={6'h08, 5'h5, 5'h5, 16'h1};
      8'd6 :
        instruction <={6'h08, 5'h5, 5'h5, 16'h1};
      8'd7 :
        instruction <={6'h23, 5'h0, 5'h6, 16'h4};
      default :
        instruction <= 32'b0;
    endcase
  end

endmodule
