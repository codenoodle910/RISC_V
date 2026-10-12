`include "rv_defines.svh"
module ctu(
    input logic [31:0] instr,
    output logic [4:0] alu_opcode,
    output logic mem2reg,
    output logic wr_mem,
    output logic rd_mem,
    output logic i_wr, // active write data in register
    output logic c_jalr,
    output logic c_jal,
    output logic c_lui,
    output logic c_auipc,
    output logic alu_src, // active mux before alu for choose imm or no imm
    output logic branch
);
logic [6:0] op_ctr;
logic [9:0] op_alu;
logic [2:0] funct_3;

assign op_ctr = instr [6:0];
assign op_alu = {instr[31:25], instr[14:12]};
assign funct_3 = instr[14:12];


always_comb begin
     i_wr = 1'b0;
     branch = 1'b0;
     rd_mem = 1'b0;
     wr_mem = 1'b0;
     c_jalr = 1'b0;
     alu_src = 1'b0;
     alu_opcode = 5'b0;
     c_jal = 1'b0;
     mem2reg = 1'b0;
     c_auipc = 1'b0;
     c_lui = 1'b0;
    case (op_ctr) 
    `R_TYPE : begin
        i_wr = 1'b1;
        alu_opcode = 1'b0;
        case (op_alu)
        10'b0000000_000 : alu_opcode = `ALU_ADD;   
        10'b0100000_000 : alu_opcode = `ALU_SUB;   
        10'b0000000_001 : alu_opcode = `ALU_SLL;   
        10'b0000000_010 : alu_opcode = `ALU_SLT;  
        10'b0000000_011 : alu_opcode = `ALU_USLT;  
        10'b0000000_100 : alu_opcode = `ALU_XOR;   
        10'b0000000_101 : alu_opcode = `ALU_SRL;   
        10'b0100000_101 : alu_opcode = `ALU_SRA;   
        10'b0000000_110 : alu_opcode = `ALU_OR;   
        10'b0000000_111 : alu_opcode = `ALU_AND;  
        default         : alu_opcode = `ALU_ADD;   
        endcase
    end

    `B_TYPE : begin
        branch = 1'b1;
    end
    
    `I_TYPE : begin
    alu_src = 1'b1;
    case (op_ctr)
    
    //----------------------Logic/Arth---------------//
    7'b0010011 : begin
        i_wr = 1'b1;
        wr_mem = 1'b0;
        case (funct_3)
            3'b000 : alu_opcode = `ALU_ADDI;                         // addi
            3'b010 : alu_opcode = `ALU_SLTI;                         // slti
            3'b011 : alu_opcode = `ALU_USLTI;                        // sltiu
            3'b100 : alu_opcode = `ALU_XORI;                         // xori
            3'b110 : alu_opcode = `ALU_ORI;                          // ori
            3'b111 : alu_opcode = `ALU_ANDI;                         // andi
            3'b001 : alu_opcode = `ALU_SLLI;                         // slli
            3'b101 : alu_opcode = instr[30] ? `ALU_SRAI : `ALU_SRLI; // srai / srli
            default: alu_opcode = `ALU_ADDI;                         // safe mode 
        endcase
    end
    //-------------- LOAD -----------//
    7'b0000011 : begin 
        alu_opcode = `ALU_ADD;
        mem2reg = 1'b1;
        i_wr = 1'b1;
        alu_src = 1'b1;
        rd_mem = 1'b1;
        wr_mem = 1'b0;
    end

    //--------------Jump----------------//
    7'b1100111 : begin
        c_jalr = 1'b1;
        alu_src = 1'b1;
        i_wr = 1'b1;
        wr_mem = 1'b0;
        rd_mem = 1'b0;
        alu_src = 1'b1;
    end
    endcase    
    end

    `S_TYPE : begin
        rd_mem = 1'b0;
        alu_src = 1'b1;
        alu_opcode = `ALU_ADD;
        wr_mem = 1'b1; // active data memory for write 
    end

    `U_TYPE : begin
        alu_opcode = `ALU_ADD;
        wr_mem = 1'b0;
        alu_src = 1'b1;
        i_wr = 1'b1;
        rd_mem = 1'b0;
        case (op_ctr)
        7'b0110111 : c_lui = 1'b1;
        7'b0010111 : c_auipc = 1'b1;
        endcase
    end

    `J_TYPE : begin
        i_wr = 1'b1;
        alu_src = 1'b1;
        alu_opcode = `ALU_ADD;
        c_jal = 1'b1;
    end
    endcase 
end
endmodule 