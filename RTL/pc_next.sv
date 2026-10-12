module pc_next (
    input logic [31:0] imm_gen,
    input logic pc_jalr,
    input logic pc_jal,
    input logic [31:0] pc_curr,
    input logic [31:0] rs1_data,
    input logic take, // lấy từ branch_unit -> để check xem có thoải mãn điều kiện rẽ nhánh không 
    input logic branch,
    output logic [31:0] pc_nxt
);

always_comb begin
    if (pc_jalr) begin
        pc_nxt = (rs1_data + imm_gen) & ~1; // ép để bit[0] luôn là 0 , để đảm bảo luôn là số chẵn (quy định ép buộc của lệnh jalr)
    end
    else if (pc_jal || (take && branch)) pc_nxt = pc_curr + imm_gen;
    else pc_nxt = pc_curr + 4;
    
end
endmodule 