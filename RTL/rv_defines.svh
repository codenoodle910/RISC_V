//==============================================================================
// rv_defines.svh - FILE DEFINE DUY NHAT cho toan bo core RV32I
// Dung:  `include "rv_defines.svh"   (o dau moi file .sv can macro)
// Co include guard nen include nhieu lan khong sao.
//==============================================================================
`ifndef RV_DEFINES_SVH
`define RV_DEFINES_SVH

//------------------------------------------------------------------------------
// 1. OPCODE (instr[6:0])
//------------------------------------------------------------------------------
`define OP_R_TYPE   7'b0110011   // add sub sll slt sltu xor srl sra or and
`define OP_I_ARITH  7'b0010011   // addi slti sltiu xori ori andi slli srli srai
`define OP_LOAD     7'b0000011   // lb lh lw lbu lhu
`define OP_STORE    7'b0100011   // sb sh sw
`define OP_BRANCH   7'b1100011   // beq bne blt bge bltu bgeu
`define OP_JAL      7'b1101111   // jal
`define OP_JALR     7'b1100111   // jalr
`define OP_LUI      7'b0110111   // lui
`define OP_AUIPC    7'b0010111   // auipc

// Ten ngan de khop voi code control_unit cua ban (R/S/B/J chi co 1 opcode).
// I-type co 3 opcode, U-type co 2 opcode -> dung ten OP_* o tren.
`define R_TYPE      `OP_R_TYPE
`define S_TYPE      `OP_STORE
`define B_TYPE      `OP_BRANCH
`define J_TYPE      `OP_JAL

//------------------------------------------------------------------------------
// 2. ALU OPCODE (alu_opcode, rong 5 bit)
//------------------------------------------------------------------------------
// Cong: add, addi, tinh dia chi load/store, jalr, auipc, lui
`define ALU_ADD     5'd0
`define ALU_ADDI    5'd0
`define ALU_LD      5'd0
`define ALU_SD      5'd0
// Tru
`define ALU_SUB     5'd1
// Logic
`define ALU_AND     5'd2
`define ALU_ANDI    5'd2
`define ALU_OR      5'd3
`define ALU_ORI     5'd3
`define ALU_XOR     5'd4
`define ALU_XORI    5'd4
// Dich bit (shamt = rs2[4:0] / imm[4:0])
`define ALU_SLL     5'd5
`define ALU_SLLI    5'd5
`define ALU_SRL     5'd6
`define ALU_SRLI    5'd6
`define ALU_SRA     5'd7
`define ALU_SRAI    5'd7
// So sanh nho hon
`define ALU_SLT     5'd8         // co dau   (slt, slti)
`define ALU_SLTI    5'd8
`define ALU_USLT    5'd9         // khong dau (sltu, sltiu)
`define ALU_USLTI   5'd9

//------------------------------------------------------------------------------
// 3. Chon toan hang A cua ALU (cho mux A: lui / auipc / cac lenh con lai)
//------------------------------------------------------------------------------
`define A_RS1       2'd0         // mac dinh: rs1
`define A_PC        2'd1         // auipc : PC + imm
`define A_ZERO      2'd2         // lui   : 0 + imm
`define I_TYPE   `OP_I_ARITH, `OP_LOAD, `OP_JALR
`define U_TYPE   `OP_LUI, `OP_AUIPC
`endif
