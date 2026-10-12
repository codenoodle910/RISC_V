//==============================================================================
// top.sv - RV32I single-cycle core: noi 12 khoi lai voi nhau
// Dau vao duy nhat: clk, rst (bo nho lenh/du lieu nam ben trong)
//==============================================================================
module riscv_top (
    input logic clk,
    input logic rst
);

//---------------------------- Day 32 bit -------------------------------------
logic [31:0] pc_curr;       // PC hien tai
logic [31:0] pc_nxt;        // PC ke tiep
logic [31:0] instr;         // lenh dang thuc hien
logic [31:0] imm;           // immediate
logic [31:0] r1_data;       // gia tri rs1
logic [31:0] r2_data;       // gia tri rs2
logic [31:0] alu_b;         // toan hang B cua ALU (rs2 hoac imm)
logic [31:0] alu_result;    // ket qua ALU
logic [31:0] mem_rdata;     // du lieu doc tu data_mem (tho)
logic [31:0] load_data;     // du lieu sau load_unit (da cat byte/half, mo rong dau)
logic [31:0] wb_data;       // du lieu ghi vao rd

//---------------------------- Tin hieu dieu khien ----------------------------
logic [4:0]  alu_opcode;
logic        alu_src;
logic        i_wr;
logic        wr_mem;
logic        rd_mem;        // chua khoi nao dung
logic        mem2reg;
logic        c_jalr;
logic        c_jal;
logic        c_lui;
logic        c_auipc;
logic        branch;
logic        take;          // tu branch_unit

//---------------------------- Fetch ------------------------------------------
pc u_pc (
    .pc_next (pc_nxt),
    .clk     (clk),
    .rst     (rst),
    .pc_curr (pc_curr)
);

memory u_imem (
    .pc_curr (pc_curr),
    .instr   (instr)
);

//---------------------------- Decode -----------------------------------------
imm_gen u_imm_gen (
    .instr (instr),
    .imm   (imm)
);

ctu u_ctu (
    .instr      (instr),
    .alu_opcode (alu_opcode),
    .mem2reg    (mem2reg),
    .wr_mem     (wr_mem),
    .rd_mem     (rd_mem),
    .i_wr       (i_wr),
    .c_jalr     (c_jalr),
    .c_jal      (c_jal),
    .c_lui      (c_lui),
    .c_auipc    (c_auipc),
    .alu_src    (alu_src),
    .branch     (branch)
);

reg u_reg_file (
    .clk       (clk),
    .rst       (rst),
    .instr     (instr),
    .i_rd_data (wb_data),
    .i_wr      (i_wr),
    .o_r1_data (r1_data),
    .o_r2_data (r2_data)
);

//---------------------------- Execute ----------------------------------------
mux_bf_alu_b u_mux_alu_b (
    .i_data_rs2 (r2_data),
    .i_imm_gen  (imm),
    .alu_src    (alu_src),
    .o_data_rs2 (alu_b)
);

alu u_alu (
    .alu_opcode (alu_opcode),
    .o_r1_data  (r1_data),
    .i_op_rs2   (alu_b),
    .o_results  (alu_result)
);

branch_unit u_branch_unit (
    .instr     (instr[14:12]),
    .o_r1_data (r1_data),
    .i_op_rs2  (r2_data),
    .take      (take)
);

//---------------------------- Memory -----------------------------------------
data_mem u_data_mem (
    .rs2       (r2_data),
    .clk       (clk),
    .wr_mem    (wr_mem),
    .instr     (instr),
    .o_results (alu_result),
    .r_data    (mem_rdata)
);

load_unit u_load_unit (
    .i_mux_reg    (mem_rdata),
    .i_alu_result (alu_result[1:0]),
    .instr        (instr[14:12]),
    .o_data_reg   (load_data)
);

//---------------------------- Write back -------------------------------------
mux_reg u_mux_reg (
    .i_alu_data (alu_result),
    .i_data_mem (load_data),
    .mem2reg    (mem2reg),
    .c_jalr     (c_jalr),
    .c_jal      (c_jal),
    .c_lui      (c_lui),
    .c_auipc    (c_auipc),
    .imm_gen    (imm),
    .pc_curr    (pc_curr),
    .o_to_reg   (wb_data)
);

//---------------------------- Next PC ----------------------------------------
pc_next u_pc_next (
    .imm_gen  (imm),
    .pc_jalr  (c_jalr),
    .pc_jal   (c_jal),
    .pc_curr  (pc_curr),
    .rs1_data (r1_data),
    .take     (take),
    .branch   (branch),
    .pc_nxt   (pc_nxt)
);

endmodule