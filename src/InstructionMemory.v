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
        instruction <= 32'h8c060000;
      8'd1:
        instruction <= 32'h8c040004;
      8'd2:
        instruction <= 32'h20050008;
      8'd3:
        instruction <= 32'h0c100006;
      8'd4:
        instruction <= 32'h00022021;
      8'd5:
        instruction <= 32'h08100026;
      8'd6:
        instruction <= 32'h20100100;
      8'd7:
        instruction <= 32'h20080000;
      8'd8:
        instruction <= 32'h00a04820;
      8'd9:
        instruction <= 32'h0104082a;
      8'd10:
        instruction <= 32'h10200017;
      8'd11:
        instruction <= 32'h8d2a0000;
      8'd12:
        instruction <= 32'h21290004;
      8'd13:
        instruction <= 32'h8d2b0000;
      8'd14:
        instruction <= 32'h21290004;
      8'd15:
        instruction <= 32'h00066021;
      8'd16:
        instruction <= 32'h0580000f;
      8'd17:
        instruction <= 32'h018a082a;
      8'd18:
        instruction <= 32'h1420000b;
      8'd19:
        instruction <= 32'h000c6880;
      8'd20:
        instruction <= 32'h01b06820;
      8'd21:
        instruction <= 32'h8dae0000;
      8'd22:
        instruction <= 32'h018ac022;
      8'd23:
        instruction <= 32'h0018c080;
      8'd24:
        instruction <= 32'h0310c020;
      8'd25:
        instruction <= 32'h8f0f0000;
      8'd26:
        instruction <= 32'h01eb7820;
      8'd27:
        instruction <= 32'h01ee082a;
      8'd28:
        instruction <= 32'h14200001;
      8'd29:
        instruction <= 32'hadaf0000;
      8'd30:
        instruction <= 32'h218cffff;
      8'd31:
        instruction <= 32'h08100010;
      8'd32:
        instruction <= 32'h21080001;
      8'd33:
        instruction <= 32'h08100009;
      8'd34:
        instruction <= 32'h00064080;
      8'd35:
        instruction <= 32'h02084020;
      8'd36:
        instruction <= 32'h8d020000;
      8'd37:
        instruction <= 32'h03e00008;
      8'd38:
        instruction <= 32'h3c044000;
      8'd39:
        instruction <= 32'h20840010;
      8'd40:
        instruction <= 32'h3045000f;
      8'd41:
        instruction <= 32'h0c10003c;
      8'd42:
        instruction <= 32'h20c60100;
      8'd43:
        instruction <= 32'hac860000;
      8'd44:
        instruction <= 32'h00022903;
      8'd45:
        instruction <= 32'h30a5000f;
      8'd46:
        instruction <= 32'h0c10003c;
      8'd47:
        instruction <= 32'h20c60200;
      8'd48:
        instruction <= 32'hac860000;
      8'd49:
        instruction <= 32'h00022a03;
      8'd50:
        instruction <= 32'h30a5000f;
      8'd51:
        instruction <= 32'h0c10003c;
      8'd52:
        instruction <= 32'h20c60400;
      8'd53:
        instruction <= 32'hac860000;
      8'd54:
        instruction <= 32'h00022b03;
      8'd55:
        instruction <= 32'h30a5000f;
      8'd56:
        instruction <= 32'h0c10003c;
      8'd57:
        instruction <= 32'h20c60800;
      8'd58:
        instruction <= 32'hac860000;
      8'd59:
        instruction <= 32'h08100028;
      8'd60:
        instruction <= 32'h14a00002;
      8'd61:
        instruction <= 32'h2006003f;
      8'd62:
        instruction <= 32'h03e00008;
      8'd63:
        instruction <= 32'h20010001;
      8'd64:
        instruction <= 32'h00a13022;
      8'd65:
        instruction <= 32'h14c00002;
      8'd66:
        instruction <= 32'h20060006;
      8'd67:
        instruction <= 32'h03e00008;
      8'd68:
        instruction <= 32'h20010002;
      8'd69:
        instruction <= 32'h00a13022;
      8'd70:
        instruction <= 32'h14c00002;
      8'd71:
        instruction <= 32'h2006005b;
      8'd72:
        instruction <= 32'h03e00008;
      8'd73:
        instruction <= 32'h20010003;
      8'd74:
        instruction <= 32'h00a13022;
      8'd75:
        instruction <= 32'h14c00002;
      8'd76:
        instruction <= 32'h2006004f;
      8'd77:
        instruction <= 32'h03e00008;
      8'd78:
        instruction <= 32'h20010004;
      8'd79:
        instruction <= 32'h00a13022;
      8'd80:
        instruction <= 32'h14c00002;
      8'd81:
        instruction <= 32'h20060066;
      8'd82:
        instruction <= 32'h03e00008;
      8'd83:
        instruction <= 32'h20010005;
      8'd84:
        instruction <= 32'h00a13022;
      8'd85:
        instruction <= 32'h14c00002;
      8'd86:
        instruction <= 32'h2006006d;
      8'd87:
        instruction <= 32'h03e00008;
      8'd88:
        instruction <= 32'h20010006;
      8'd89:
        instruction <= 32'h00a13022;
      8'd90:
        instruction <= 32'h14c00002;
      8'd91:
        instruction <= 32'h2006007d;
      8'd92:
        instruction <= 32'h03e00008;
      8'd93:
        instruction <= 32'h20010007;
      8'd94:
        instruction <= 32'h00a13022;
      8'd95:
        instruction <= 32'h14c00002;
      8'd96:
        instruction <= 32'h20060007;
      8'd97:
        instruction <= 32'h03e00008;
      8'd98:
        instruction <= 32'h20010008;
      8'd99:
        instruction <= 32'h00a13022;
      8'd100:
        instruction <= 32'h14c00002;
      8'd101:
        instruction <= 32'h2006007f;
      8'd102:
        instruction <= 32'h03e00008;
      8'd103:
        instruction <= 32'h20010009;
      8'd104:
        instruction <= 32'h00a13022;
      8'd105:
        instruction <= 32'h14c00002;
      8'd106:
        instruction <= 32'h2006006f;
      8'd107:
        instruction <= 32'h03e00008;
      8'd108:
        instruction <= 32'h2001000a;
      8'd109:
        instruction <= 32'h00a13022;
      8'd110:
        instruction <= 32'h14c00002;
      8'd111:
        instruction <= 32'h20060077;
      8'd112:
        instruction <= 32'h03e00008;
      8'd113:
        instruction <= 32'h2001000b;
      8'd114:
        instruction <= 32'h00a13022;
      8'd115:
        instruction <= 32'h14c00002;
      8'd116:
        instruction <= 32'h2006007c;
      8'd117:
        instruction <= 32'h03e00008;
      8'd118:
        instruction <= 32'h2001000c;
      8'd119:
        instruction <= 32'h00a13022;
      8'd120:
        instruction <= 32'h14c00002;
      8'd121:
        instruction <= 32'h20060039;
      8'd122:
        instruction <= 32'h03e00008;
      8'd123:
        instruction <= 32'h2001000d;
      8'd124:
        instruction <= 32'h00a13022;
      8'd125:
        instruction <= 32'h14c00002;
      8'd126:
        instruction <= 32'h2006005e;
      8'd127:
        instruction <= 32'h03e00008;
      8'd128:
        instruction <= 32'h2001000e;
      8'd129:
        instruction <= 32'h00a13022;
      8'd130:
        instruction <= 32'h14c00002;
      8'd131:
        instruction <= 32'h20060079;
      8'd132:
        instruction <= 32'h03e00008;
      8'd133:
        instruction <= 32'h20060071;
      8'd134:
        instruction <= 32'h03e00008;
      default :
        instruction <= 32'b0;
    endcase
  end

endmodule
