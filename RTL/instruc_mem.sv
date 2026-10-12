module memory 
#(
    parameter N = 32,
    parameter int MEM_DEPTH = 512
)
(
    input logic [N-1:0] pc_curr,
    output logic [N-1:0] instr

);
logic [31:0] mem [0:MEM_DEPTH-1]; 

initial begin
    $readmemh("program.hex", mem);
end
always_comb begin
    instr = mem [pc_curr >> 2];
end
endmodule