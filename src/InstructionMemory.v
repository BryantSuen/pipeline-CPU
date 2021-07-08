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
      8'd0:
        instruction <= 32'h2012000a;
      8'd1:
        instruction <= 32'h2013000a;
      8'd2:
        instruction <= 32'h20140000;
      8'd3:
        instruction <= 32'h20040040;
      8'd4:
        instruction <= 32'h20080000;
      8'd5:
        instruction <= 32'h21080064;
      8'd6:
        instruction <= 32'h00081020;
      8'd7:
        instruction <= 32'h200b0000;
      8'd8:
        instruction <= 32'h8e8d0000;
      8'd9:
        instruction <= 32'h8e8e0004;
      8'd10:
        instruction <= 32'h000dc820;
      8'd11:
        instruction <= 32'h0019c880;
      8'd12:
        instruction <= 32'h00024020;
      8'd13:
        instruction <= 32'h00126020;
      8'd14:
        instruction <= 32'h0012c020;
      8'd15:
        instruction <= 32'h0018c080;
      8'd16:
        instruction <= 32'h01184020;
      8'd17:
        instruction <= 32'h018d7822;
      8'd18:
        instruction <= 32'h05e00007;
      8'd19:
        instruction <= 32'h0119c022;
      8'd20:
        instruction <= 32'h8d150000;
      8'd21:
        instruction <= 32'h8f160000;
      8'd22:
        instruction <= 32'h02ceb020;
      8'd23:
        instruction <= 32'h02b6b822;
      8'd24:
        instruction <= 32'h1ee00001;
      8'd25:
        instruction <= 32'had160000;
      8'd26:
        instruction <= 32'h218cffff;
      8'd27:
        instruction <= 32'h2108fffc;
      8'd28:
        instruction <= 32'h000c2822;
      8'd29:
        instruction <= 32'h04a0fff3;
      8'd30:
        instruction <= 32'h216b0001;
      8'd31:
        instruction <= 32'h22940008;
      8'd32:
        instruction <= 32'h1573ffe7;
      8'd33:
        instruction <= 32'h0012b820;
      8'd34:
        instruction <= 32'h0017b880;
      8'd35:
        instruction <= 32'h00024020;
      8'd36:
        instruction <= 32'h01174020;
      8'd37:
        instruction <= 32'h8d020000;
      8'd38:
        instruction <= 32'h08100026;
      default :
        instruction <= 32'b0;
    endcase
  end

endmodule
