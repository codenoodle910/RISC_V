module mux_bf_alu_b(
    input logic [31:0] i_data_rs2,
    input logic [31:0] i_imm_gen,
    input logic alu_src,
    output logic [31:0] o_data_rs2
);
always_comb begin
   if (alu_src) o_data_rs2 = i_imm_gen;
   else o_data_rs2 = i_data_rs2; 
end
endmodule

// hàm nằm trước ALU để chọn đầu vào 2 là rs2 hay là imm_gen