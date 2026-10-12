`include "rv_defines.svh"

module ALU #(
    parameter N = 32
)
(
    input logic [4:0] alu_opcode,
    input logic [N-1:0] o_r1_data,
    input logic [N-1:0] i_op_rs2,
    output logic [N-1:0] o_results // = i_rd_data
);


logic [4:0] shamt;
assign shamt = i_op_rs2[4:0];

always_comb begin
    case (alu_opcode)
        `ALU_ADD, `ALU_ADDI, `ALU_LD, `ALU_SD :  begin o_results = o_r1_data + i_op_rs2; end
        `ALU_SUB: begin o_results = o_r1_data - i_op_rs2; end
        `ALU_AND, `ALU_ANDI: begin o_results = o_r1_data & i_op_rs2; end
        `ALU_XOR, `ALU_XORI: begin o_results = o_r1_data ^ i_op_rs2; end 
        `ALU_SLL, `ALU_SLLI : begin
            o_results = o_r1_data << shamt;
        end
        `ALU_SRL, `ALU_SRLI : begin 
            o_results = o_r1_data >> shamt;
        end
        `ALU_SRA, `ALU_SRAI : begin
            o_results = $signed(o_r1_data) >>> shamt;
        end
        `ALU_USLT, `ALU_USLTI : begin
            o_results = ($unsigned(o_r1_data) < $unsigned(i_op_rs2)) ? 32'b1 : 32'b0;
        end
        `ALU_SLT, `ALU_SLTI : begin
            o_results = ($signed(o_r1_data) < $signed(i_op_rs2)) ? 32'b1 : 32'b0;
        end
        `ALU_OR, `ALU_ORI: begin
            o_results = o_r1_data | i_op_rs2;
        end
        default: o_results = 32'b0;
    endcase
end
endmodule 