module pc #(
    parameter N = 32
)
(
input logic [N-1:0] pc_next,
input logic clk,
input logic rst,
output logic [N-1:0] pc_curr
);
always_ff @(posedge clk or posedge rst) begin
    if (rst) 
        pc_curr <= 32'b0;
    else 
        pc_curr <= pc_next;
end
endmodule