module mux_reg (
input logic [31:0] i_alu_data,
input logic [31:0] i_data_mem,
input logic mem2reg,
input logic c_jalr,
input logic c_jal,
input logic c_lui,
input logic c_auipc,
input logic [31:0] imm_gen,
input logic [31:0] pc_curr,
output logic [31:0] o_to_reg // truyền giá trị cho reg để ghi vào thanh ghi 
);
always_comb begin
    if (mem2reg) o_to_reg = i_data_mem;
    else if (c_jalr || c_jal) o_to_reg = pc_curr + 4 ;
    else if (c_lui) o_to_reg = imm_gen;
    else if (c_auipc) o_to_reg = imm_gen + pc_curr;
    else o_to_reg = i_alu_data;
end
endmodule 