module branch_unit #(
    parameter N = 32
)
(
    input logic [14:12] instr,
    input logic [N-1:0] o_r1_data,
    input logic [N-1:0] i_op_rs2,
    output logic take
);

logic [2:0] funct_3;
assign funct_3 = instr;

always_comb begin
    case(funct_3)
        3'b000 : take = (i_op_rs2 == o_r1_data);
        3'b001 : take = (i_op_rs2 != o_r1_data);
        3'b100 : take = ($signed(o_r1_data) < $signed(i_op_rs2));
        3'b101 : take = ($signed(o_r1_data) >= $signed(i_op_rs2));
        3'b110 : take = ($unsigned(o_r1_data) < $unsigned(i_op_rs2));
        3'b111 : take = ($unsigned(o_r1_data) >= $unsigned(i_op_rs2));
        default : take = 1'b0;
    endcase
end

endmodule 