`timescale 1ns / 1ps

module PipeLineCPU (reset, clk);
input reset;
input clk;

// PC
wire [31:0]PC_cur, PC_next;
wire PC_write_en, PC_flush;
wire [31:0] PC_plus4, PC_branch, PC_jump, PC_jump_reg;

assign PC_plus4 = PC_cur + 4;
assign PC_next = (PCSource == 2'b01)? PC_branch:
       (PCSource == 2'b10)? PC_jump:
       (PCSource == 2'b11)? PC_jump_reg:PC_plus4;

PC pc(.reset(reset), .clk(clk), .PCWrite(PC_write_en),
      .PC_flush(PC_flush), .PC_i(PC_next), .PC_o(PC_cur));


// InstrunctionMemory
wire [31:0] Instruction;
InstructionMemory(.address(PC_cur),
                  .Instruction(Instruction));

// IF/ID
wire IF_ID_wr_en, IF_ID_flush;

IF_ID_reg IF_ID(.clk(clk), .reset(reset),
                .IF_PC(PC_cur), IF_instruction(Instruction),
                .IF_ID_wr_en(IF_ID_wr_en), .IF_ID_flush(IF_ID_flush));


// RF
wire [4:0] WB_Write_register, ID_rs, ID_rt, ID_rd;
wire [31:0] ID_rs_data, ID_rt_data;
wire [31:0] WB_Write_data;
wire WB_RegWrite;

assign ID_rs = IF_ID.instruction_IF[25:21];
assign ID_rt = IF_ID.instruction_IF[20:16];
assign ID_rd = IF_ID.instruction_IF[15:11];

assign WB_Write_data = MEM_WB.MemtoReg ? MEM_WB.DM_data : MEM_WB.ALUout;
assign WB_RegWrite = MEM_WB.RegWr;
assign WB_Write_register = MEM_WB.Write_register;

RegisterFile RF(.reset(reset), .clk(clk), .RegWrite(WB_RegWrite),
                .Read_register1(ID_rs), .Read_register2(ID_rt),
                .Write_register(WB_Write_register), .Write_data(WB_Write_data),
                .Read_data1(ID_rs_data), .Read_data2(ID_rt_data));


wire ID_ExtOp, ID_LuiOp;
wire [31:0] ID_ImmExtOut, ID_ImmExtShift;

ImmProcess immprocess(.ExtOp(ID_ExtOp),.LuiOp(ID_LuiOp),.Immediate({IF_ID.instruction_IF[15:0]}),
                      .ImmExtOut(ID_ImmExtOut),.ImmExtShift(ID_ImmExtShift));


wire [1:0] PC_src, ID_RegDst;
wire ID_Reg_wr, ID_ALUSrcA, ID_ALUSrcB, ID_MemtoReg, ID_Branch;
wire [3:0] ID_ALUOp;
wire ID_Mem_wr, ID_Mem_rd;

wire Branch_harzard;
assign Branch_harzard = ID_EX.branch && (EX_rs_data_forward == EX_rt_data_forward);

Controller controller(.clk(clk), .reset(reset),
                      .ID_instruction(IF_ID.instruction),
                      .PC_src(PC_src), .RegDst(ID_RegDst),
                      .Reg_wr(ID_Reg_wr), .ExtOp(ID_ExtOp), .LuiOp(ID_LuiOp),
                      .ALUSrcA(ID_ALUSrcA), .ALUSrcB(ID_ALUSrcB), .ALUOp(ID_ALUOp), .MemtoReg(ID_MemtoReg), .Branch(ID_Branch),
                      .Mem_wr(ID_Mem_wr), .Mem_rd(ID_Mem_rd),
                      .Branch_harzard());


// ID/EX
wire ID_EX_flush;

ID_EX_reg ID_EX(.clk(clk), .reset(reset),
                .ID_PC_plus4(IF_ID.PC_plus4), .ID_rs_data(ID_rs_data), .ID_rt_data(ID_rt_data),.ID_Imm_ext(ID_ImmExtOut),
                .ID_rs(ID_rs), .ID_rt(ID_rt), .ID_rd(ID_rd),
                .ID_ExtOp(ID_ExtOp), .ID_RegDst(ID_RegDst),
                .ID_Mem_wr(ID_Mem_wr), .ID_Branch(ID_Branch), .ID_MemtoReg(ID_MemtoReg), .ID_RegWr(ID_Reg_wr),
                .ID_ALUSrcA(ID_ALUSrcA), .ID_ALUSrcB(ID_ALUSrcB),
                .ID_ALUOp(ID_ALUOp), .ID_EX_flush(ID_EX_flush)
               );

// forward_ex
wire [1:0] FA_EX, FB_EX;
Forward_EX forward1(.ID_EX_rs(ID_EX.rs), .ID_EX_rt(ID_EX.rt)
                    .EX_MEM_Write_register(EX_MEM.Write_register), .MEM_WB_Write_register(MEM_WB.Write_register),
                    .EX_MEM_RegWrite(EX_MEM.RegWr), .MEM_WB_RegWrite(MEM_WB.RegWr),
                    .FA_EX(FA_EX), .FB_EX(FB_EX));

// forward_ID
output [1:0] FA_ID;
Forward_ID forward2(.IF_ID_rs(IF_ID.instruction[25:21]),
                    .EX_MEM_Write_register(EX_MEM.Write_register), .MEM_WB_Write_register(MEM_WB.Write_register),
                    .ID_EX_RegWrite(ID_EX.RegWr), .EX_MEM_RegWrite(EX_MEM.RegWr), .MEM_WB_RegWrite(MEM_WB.RegWr),
                    .FA_ID(FA_ID));

//Harzard
Harzard harzard(.ID_EX_rt(ID_EX.rt), .IF_ID_rs(IF_ID.instruction[25:21]), .IF_ID_rt(IF_ID.instruction[20:16]),
                .ID_EX_Mem_rd(ID_EX.MemtoReg),
                .IF_ID_OpCode(IF_ID.instruction[31:26]), .IF_ID_Funct(IF_ID.instruction[5:0]),

                .PC_Wr_en(PC_write_en), .IF_ID_Wr_en(IF_ID_wr_en),
                .IF_ID_flush(IF_ID_flush), .ID_EX_flush(ID_EX_flush));

// ALUCtrl
wire EX_sign;
wire [4:0] EX_ALUConf;
ALUControl alu_control(.ALUOp(ID_EX.ALUOp),.Funct(ID_EX.Funct),.ALUConf(EX_ALUConf),.Sign(EX_sign));

// ALU
wire [31:0] EX_ALUout, EX_In1, EX_In2, EX_rs_data_forward, EX_rt_data_forward;

assign EX_rs_data_forward = (FA_EX == 2'b01) ? EX_MEM.Write_register :
       (FA_EX == 2'b10) ? MEM_WB.Write_register :
       ID_EX.rs;
assign EX_rt_data_forward = (FB_EX == 2'b01) ? EX_MEM.Write_register :
       (FB_EX == 2'b10) ? MEM_WB.Write_register :
       ID_EX.rt;
assign EX_In1 = ID_EX.ALUSrcA ? EX_rs_data_forward : ID_EX.Imm_ext;
assign EX_In2 = ID_EX.ALUSrcB ? EX_rt_data_forward : ID_EX.Imm_ext;


ALU alu(.ALUConf(EX_ALUConf),.Sign(EX_sign),.In1(EX_In1),.In2(EX_In2),
        .Result(EX_ALUout));

// EX/MEM
EX_MEM_reg EX_MEM(.clk(clk), .reset(reset),
                  .EX_Mem_wr(ID_EX.Mem_wr), .EX_MemtoReg(ID_EX.MemtoReg), .EX_RegWr(ID_EX.RegWr),
                  .EX_ALUout(EX_ALUout), .EX_Zero(ID_EX.Zero), .EX_rt_data(EX_rt_data_forward), .EX_Write_register(ID_EX.Write_register));

// Bus
wire [31:0] MEM_bus_read_data;
Bus bus(.clk(clk), .reset(reset),
        .addr(EX_MEM.ALUout),
        .Mem_rd(EX_MEM.MemtoReg), .Mem_wr(EX_MEM.Mem_wr),
        .Write_data(EX_MEM.rt_data), .Read_data(MEM_bus_read_data));

// MEM/WB
MEM_WB_reg MEM_WB(.clk(clk), .reset(reset),
                  .MEM_MemtoReg(EX_MEM.MemtoReg), .MEM_RegWr(EX_MEM.RegWr),
                  .MEM_DM_data(MEM_bus_read_data), .MEM_ALUout(EX_MEM.ALUout),
                  .MEM_Write_register(EX_MEM.Write_register));

endmodule
