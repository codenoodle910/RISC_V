module reg_file #(
    parameter N = 32,
    parameter int DEPTH = 32
)
(
    input logic clk,
    input logic rst,
    input logic [N-1:0] instr,
    input logic [N-1:0] i_rd_data, // get value from mux_reg (o_to_reg)
    input logic i_wr, // write = 1 ; read = 0
    output logic [N-1:0] o_r1_data,
    output logic [N-1:0] o_r2_data
);
logic [4:0] i_r2_addr, i_r1_addr, i_rd_addr;


assign i_r1_addr = instr [19:15];
assign i_r2_addr = instr [24:20];
assign i_rd_addr = instr [11:7];

 logic [31:0] reg_data [DEPTH];
 integer i;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i = 0 ; i < DEPTH ; i++) begin
            reg_data[i] <= 32'b0;
        end
    end 
    else if (i_wr && (i_rd_addr != 0))begin
        reg_data [i_rd_addr] <= i_rd_data ;
    end
end

always_comb begin 
        o_r1_data = (i_r1_addr == 0) ? '0 : reg_data [i_r1_addr]; // Quy ước RISC-V: đọc x0 luôn ra 0, ghi vào x0 bị bỏ qua.
        o_r2_data = (i_r2_addr == 0) ? '0 : reg_data [i_r2_addr];
end
endmodule 