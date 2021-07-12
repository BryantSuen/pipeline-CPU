`timescale 1ns / 1ps

module PipeLineCPU (reset, sysclk, bcd7_data);
input reset;
input sysclk;

output [11:0] bcd7_data;

// divider
wire clk;
Divider divider(.clk(sysclk), .reset(reset),
                .clk_div(clk));

// PC
wire [31:0]PC_cur, PC_next;
wire [1:0] PC_src;
wire PC_write_en, PC_flush;
wire [31:0] PC_plus4, PC_branch, PC_jump, PC_jump_reg;

assign PC_plus4 = PC_cur + 4;
assign PC_branch = ID_EX.PC_plus4 + (ID_EX.Imm_ext << 2);
assign PC_jump = {IF_ID.PC_plus4[31:28], IF_ID.instruction[25:0], 2'b00};
assign PC_jump_reg = ID_rs_data_forward;

assign PC_next = (PC_src == 2'b01)? PC_branch:
       (PC_src == 2'b10)? PC_jump:
       (PC_src == 2'b11)? PC_jump_reg:PC_plus4;

PC pc(.reset(reset), .clk(clk), .PCWrite(PC_write_en),
      .PC_flush(PC_flush), .PC_i(PC_next), .PC_o(PC_cur));


// IF stage
wire [31:0] instruction;
InstructionMemory IM(.address(PC_cur),
                     .instruction(instruction));

// IF/ID
wire IF_ID_wr_en, IF_ID_flush;

IF_ID_reg IF_ID(.clk(clk), .reset(reset),
                .IF_PC(PC_plus4), .IF_instruction(instruction),
                .IF_ID_wr_en(IF_ID_wr_en), .IF_ID_flush(IF_ID_flush));


// ID and WB stage
wire [4:0] WB_Write_register, ID_rs, ID_rt, ID_rd;
wire [31:0] ID_rs_data, ID_rt_data;
wire [31:0] WB_Write_data;
wire WB_RegWrite;

assign ID_rs = IF_ID.instruction[25:21];
assign ID_rt = IF_ID.instruction[20:16];
assign ID_rd = IF_ID.instruction[15:11];

assign WB_Write_data = (MEM_WB.MemtoReg == 2'b01) ? MEM_WB.DM_data :
       (MEM_WB.MemtoReg == 2'b10) ? MEM_WB.PC_jal : MEM_WB.ALUout;
assign WB_RegWrite = MEM_WB.RegWr;
assign WB_Write_register = MEM_WB.Write_register;

RegisterFile RF(.reset(reset), .clk(clk), .RegWrite(WB_RegWrite),
                .Read_register1(ID_rs), .Read_register2(ID_rt),
                .Write_register(WB_Write_register), .Write_data(WB_Write_data),
                .Read_data1(ID_rs_data), .Read_data2(ID_rt_data));

wire [31:0] ID_rs_data_forward, ID_rt_data_forward;
assign ID_rs_data_forward = (FA_ID == 2'b01) ? EX_MEM.ALUout :
       (FA_ID == 2'b10) ? WB_Write_data :
       ID_rs_data;
assign ID_rt_data_forward = (FB_ID == 2'b01) ? EX_MEM.ALUout :
       (FB_ID == 2'b10) ? WB_Write_data :
       ID_rt_data;

wire ID_ExtOp, ID_LuiOp;
wire [31:0] ID_ImmExtOut, ID_ImmExtShift;

ImmProcess immprocess(.ExtOp(ID_ExtOp),.LuiOp(ID_LuiOp),.Immediate({IF_ID.instruction[15:0]}),
                      .ImmExtOut(ID_ImmExtOut),.ImmExtShift(ID_ImmExtShift));


wire [1:0] ID_RegDst;
wire ID_Reg_wr, ID_ALUSrcA, ID_ALUSrcB;
wire [1:0] ID_MemtoReg;
wire [3:0] ID_ALUOp;
wire ID_Mem_wr, ID_Mem_rd;

wire Branch_hazard;
wire [5:0] ID_OpCode, ID_Funct;

Branch branch(.ID_EX_OpCode(ID_EX.OpCode),
              .rs_data(EX_rs_data_forward), .rt_data(EX_rt_data_forward),
              .Branch_hazard(Branch_hazard));

Controller controller(.clk(clk), .reset(reset),
                      .ID_instruction(IF_ID.instruction),
                      .OpCode(ID_OpCode),
                      .PC_src(PC_src), .RegDst(ID_RegDst),
                      .Reg_wr(ID_Reg_wr), .ExtOp(ID_ExtOp), .LuiOp(ID_LuiOp),
                      .ALUSrcA(ID_ALUSrcA), .ALUSrcB(ID_ALUSrcB), .ALUOp(ID_ALUOp), .Funct(ID_Funct),
                      .MemtoReg(ID_MemtoReg),
                      .Mem_wr(ID_Mem_wr), .Mem_rd(ID_Mem_rd),
                      .Branch_hazard(Branch_hazard));


// ID/EX
wire ID_EX_flush;

ID_EX_reg ID_EX(.clk(clk), .reset(reset),
                .ID_PC_plus4(IF_ID.PC_plus4), .ID_rs_data(ID_rs_data_forward), .ID_rt_data(ID_rt_data_forward),.ID_Imm_ext(ID_ImmExtOut),
                .ID_rs(ID_rs), .ID_rt(ID_rt), .ID_rd(ID_rd),
                .ID_ExtOp(ID_ExtOp), .ID_RegDst(ID_RegDst),
                .ID_Mem_wr(ID_Mem_wr), .ID_Mem_rd(ID_Mem_rd), .ID_MemtoReg(ID_MemtoReg), .ID_RegWr(ID_Reg_wr),
                .ID_ALUSrcA(ID_ALUSrcA), .ID_ALUSrcB(ID_ALUSrcB),
                .ID_ALUOp(ID_ALUOp), .ID_Funct(ID_Funct), .ID_EX_flush(ID_EX_flush),
                .ID_PC_jal(IF_ID.PC_plus4),
                .ID_OpCode(ID_OpCode)
               );

// EX stage
wire [1:0] FA_EX, FB_EX;
Forward_EX forward1(.ID_EX_rs(ID_EX.rs), .ID_EX_rt(ID_EX.rt),
                    .EX_MEM_Write_register(EX_MEM.Write_register), .MEM_WB_Write_register(MEM_WB.Write_register),
                    .EX_MEM_RegWrite(EX_MEM.RegWr), .MEM_WB_RegWrite(MEM_WB.RegWr),
                    .FA_EX(FA_EX), .FB_EX(FB_EX));

wire [1:0] FA_ID, FB_ID;
Forward_ID forward2(.IF_ID_rs(IF_ID.instruction[25:21]), .IF_ID_rt(IF_ID.instruction[20:16]),
                    .EX_MEM_Write_register(EX_MEM.Write_register), .MEM_WB_Write_register(MEM_WB.Write_register),
                    .ID_EX_RegWrite(ID_EX.RegWr), .EX_MEM_RegWrite(EX_MEM.RegWr), .MEM_WB_RegWrite(MEM_WB.RegWr),
                    .FA_ID(FA_ID), .FB_ID(FB_ID));

Hazard hazard(.ID_EX_rt(ID_EX.rt), .IF_ID_rs(IF_ID.instruction[25:21]), .IF_ID_rt(IF_ID.instruction[20:16]),
              .ID_EX_Mem_rd(ID_EX.Mem_rd),
              .IF_ID_OpCode(IF_ID.instruction[31:26]), .IF_ID_Funct(IF_ID.instruction[5:0]),
              .rs_forward(EX_rs_data_forward), .rt_forward(EX_rt_data_forward),
              .Branch_hazard(Branch_hazard),

              .PC_Wr_en(PC_write_en), .IF_ID_Wr_en(IF_ID_wr_en),
              .IF_ID_flush(IF_ID_flush), .ID_EX_flush(ID_EX_flush),

              .EX_MEM_Mem_rd(EX_MEM.Mem_rd), .EX_MEM_Write_register(EX_MEM.Write_register));

wire EX_sign;
wire [4:0] EX_ALUConf;
ALUControl alu_control(.ALUOp(ID_EX.ALUOp),.Funct(ID_EX.Funct),.ALUConf(EX_ALUConf),.Sign(EX_sign));

wire [31:0] EX_ALUout, EX_In1, EX_In2, EX_rs_data_forward, EX_rt_data_forward;

assign EX_rs_data_forward = (FA_EX == 2'b01) ? EX_MEM.ALUout :
       (FA_EX == 2'b10) ? WB_Write_data : ID_EX.rs_data;
assign EX_rt_data_forward = (FB_EX == 2'b01) ? EX_MEM.ALUout :
       (FB_EX == 2'b10) ? WB_Write_data : ID_EX.rt_data;

assign EX_In1 = ID_EX.ALUSrcA ? ID_EX.Imm_ext : EX_rs_data_forward;
assign EX_In2 = ID_EX.ALUSrcB ? ID_EX.Imm_ext : EX_rt_data_forward;


ALU alu(.ALUConf(EX_ALUConf),.Sign(EX_sign),.In1(EX_In1),.In2(EX_In2),
        .Result(EX_ALUout));

// EX/MEM
wire [4:0] EX_Write_register;
assign EX_Write_register = (ID_EX.RegDst == 2'b01) ? ID_EX.rd :
       (ID_EX.RegDst == 2'b10) ? 5'b11111 : ID_EX.rt;

EX_MEM_reg EX_MEM(.clk(clk), .reset(reset),
                  .EX_Mem_wr(ID_EX.Mem_wr), .EX_Mem_rd(ID_EX.Mem_rd), .EX_MemtoReg(ID_EX.MemtoReg), .EX_RegWr(ID_EX.RegWr),
                  .EX_ALUout(EX_ALUout), .EX_rt_data(EX_rt_data_forward), .EX_Write_register(EX_Write_register),
                  .EX_PC_jal(ID_EX.PC_plus4)
                 );

// MEM stage
wire [31:0] MEM_bus_read_data;
Bus bus(.clk(clk), .reset(reset),
        .addr(EX_MEM.ALUout),
        .Mem_rd(EX_MEM.Mem_rd), .Mem_wr(EX_MEM.Mem_wr),
        .Write_data(EX_MEM.rt_data), .Read_data(MEM_bus_read_data),
        .bcd7_rd_data(bcd7_data));

// MEM/WB
MEM_WB_reg MEM_WB(.clk(clk), .reset(reset),
                  .MEM_MemtoReg(EX_MEM.MemtoReg), .MEM_RegWr(EX_MEM.RegWr),
                  .MEM_DM_data(MEM_bus_read_data), .MEM_ALUout(EX_MEM.ALUout),
                  .MEM_Write_register(EX_MEM.Write_register),
                  .MEM_PC_jal(EX_MEM.PC_jal));

endmodule
