module data_mem#(
    parameter N = 32,
    parameter DEPTH = 512
)
(
input logic [N-1:0] rs2,
input logic clk,     
input logic wr_mem,
input logic [N-1:0] instr,           // get value for funtc_3
input logic [N-1:0] o_results,           // từ alu đưa tới 
output logic [N-1:0] r_data
);

logic [2:0] funct_3;
logic [31:0] mem_data [DEPTH-1:0];

assign funct_3 = instr [14:12];

always_ff @(posedge clk) begin
    if (wr_mem) begin
            case (funct_3)

            //-------------------------------SB----------------------------
            3'b000 : begin
                case (o_results [1:0])
                2'b00: mem_data [o_results >> 2] <= {mem_data [o_results >> 2] [31:8], rs2 [7:0]};
                2'b01: mem_data [o_results >> 2] <= {mem_data [o_results >> 2] [31:16], rs2 [7:0], mem_data [o_results >> 2] [7:0] };
                2'b10: mem_data [o_results >> 2] <= {mem_data [o_results >> 2] [31:24], rs2 [7:0], mem_data [o_results >> 2] [15:0] };
                2'b11: mem_data [o_results >> 2] <= {rs2 [7:0], mem_data [o_results >> 2] [23:0] };
                endcase
            end

            //-------------------------------SH----------------------------
            3'b001 : begin
                case (o_results [1])
                1'b0 : mem_data [o_results >> 2] <= {mem_data [o_results >> 2] [31:16], rs2 [15:0]};
                1'b1 : mem_data [o_results >> 2] <= {rs2 [15:0], mem_data [o_results >> 2] [15:0]};
                endcase
            end

            //--------------------------------SW----------------------------------
            3'b010 : begin
                mem_data [o_results >> 2] <= rs2;
            end
            endcase
    end
end
 
always_comb begin
    r_data = mem_data [o_results >> 2];
end
endmodule