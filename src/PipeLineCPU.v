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
assign ID_rs = IF_ID.instruction_IF[25:21];
assign ID_rt = IF_ID.instruction_IF[20:16];
assign ID_rd = IF_ID.instruction_IF[15:11];
// assign ID_Write_register = (RegDst == 2'b01)?rd:(RegDst == 2'b10)?5'b11111:(RegDst == 2'b11)?errtarget:rt;
assign WB_Write_data = (MemtoReg == 2'b01)?MDR_data:(MemtoReg == 2'b10)?PC_cur:(MemtoReg == 2'b11)?32'hffff_ffff:ALU_out;

RegisterFile RF(.reset(reset), .clk(clk), .RegWrite(RegWrite),
                .Read_register1(ID_rs), .Read_register2(ID_rt),
                .Write_register(WB_Write_register), .Write_data(WB_Write_data),
                .Read_data1(ID_rs_data), .Read_data2(ID_rt_data));


wire ID_ExtOp, ID_LuiOp;
wire [31:0] ID_ImmExtOut, ID_ImmExtShift;

ImmProcess immprocess(.ExtOp(ID_ExtOp),.LuiOp(ID_LuiOp),.Immediate({IF_ID.instruction_IF[15:0]}),
                      .ImmExtOut(ID_ImmExtOut),.ImmExtShift(ID_ImmExtShift));


wire [1:0] PC_src, ID_RegDst;
wire ID_Reg_wr, ID_ALUSrc_A, ID_ALUSrc_B, ID_MemtoReg, ID_Branch;
wire [3:0] ID_ALUOp;
wire ID_Mem_wr, ID_Mem_rd;

Controller controller(.clk(clk), .reset(reset),
                      .ID_instruction(IF_ID.instruction),
                      .PC_src(PC_src), .RegDst(ID_RegDst),
                      .Reg_wr(ID_Reg_wr), .ExtOp(ID_ExtOp), .LuiOp(ID_LuiOp),
                      .ALUSrcA(ID_ALUSrc_A), .ALUSrcB(ID_ALUSrc_B), .ALUOp(ID_ALUOp), .MemtoReg(ID_MemtoReg), .Branch(ID_Branch),
                      .Mem_wr(ID_Mem_wr), .Mem_rd(ID_Mem_rd),
                      .Branch_harzard());


// ID/EX
ID_EX_reg ID_EX(.clk(clk), .reset(reset),
                .ID_PC_plus4(IF_ID.PC_plus4), .ID_rs_data(ID_rs_data), .ID_rt_data(ID_rt_data),.ID_Imm_ext(ID_ImmExtOut),
                .ID_rs(ID_rs), .ID_rt(ID_rt), .ID_rd(ID_rd),
                .ID_ExtOp(ID_ExtOp), .ID_RegDst(ID_RegDst),
                .ID_MemWr(ID_Mem_wr), .ID_Branch(ID_Branch), .ID_MemtoReg(ID_MemtoReg), .ID_RegWr(ID_Reg_wr),
                .ID_ALUSrc_A(), .ID_ALUSrc_B(),
                .ID_ALUOp(), .ID_EX_flush()
               );

// forward_ex
Forward_EX forward1(.ID_EX_rs(ID_EX.ID_rs), .ID_EX_rt(ID_EX.ID_rt)
                    .EX_MEM_Write_register(), .MEM_WB_Write_register(),
                    .EX_MEM_RegWrite(), .MEM_WB_RegWrite(),
                    .FA_EX(), .FB_EX());

// forward_ID
Forward_ID forward2(.IF_ID_rs(),
                    .ID_EX_Write_register(), .EX_MEM_Write_register(), .MEM_WB_Write_register(),
                    .ID_EX_RegWrite(), .EX_MEM_RegWrite(), .MEM_WB_RegWrite(),
                    .FA_ID());

//Harzard
Harzard harzard(.ID_EX_rt(), .IF_ID_rs(), .IF_ID_rt(),
         .ID_EX_MemRd(),
         .IF_ID_OpCode(), .IF_ID_Funct(),

         .PC_Wr_en(), .IF_ID_Wr_en(),
         .IF_ID_flush(), .ID_EX_flush());

// ALU
ALU alu(.ALUConf(ALUConf),.Sign(Sign),.In1(In1),.In2(In2),
        .Zero(Zero),.Result(Result));

// ALUCtrl
ALUControl alu_control(.ALUOp(ALUOp),.Funct(Funct),.ALUConf(ALUConf),.Sign(Sign));

// EX/MEM
EX_MEM_reg EX_MEM(.clk(clk), .reset(reset),
                  .EX_PC_pImm(),
                  .EX_MemWr(), .EX_MemtoReg(), .EX_RegWr(),
                  .EX_ALUout(), .EX_Zero(), .EX_rt_data(), .EX_Write_register());

// Bus
Bus bus(.clk(clk), .reset(reset),
        .addr(EX_MEM.ALUout),
        .Mem_rd(), .Mem_wr(),
        .Write_data(), .Read_data());

// MEM/WB
MEM_WB_reg MEM_WB(.clk(), .reset(),
                  .MEM_MemtoReg(), .MEM_RegWr(),
                  .MEM_DM_data(), .MEM_ALUout(),
                  .MEM_Write_register());

endmodule
