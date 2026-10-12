module load_unit(
    input logic [31:0]i_mux_reg,
    input logic [1:0] i_alu_result, // lấy kết quả từ ALU để chọn vị trị cho các lệnh lb lh 
    input logic [14:12] instr,
    output logic [31:0] o_data_reg
);
always_comb begin
    case (instr[14:12])
    3'b000 : begin
        case(i_alu_result) // chọn vị trí load data
        2'b00 : o_data_reg = {{24{i_mux_reg[7]}},i_mux_reg[7:0]}; // lb
        2'b01 : o_data_reg = {{24{i_mux_reg[15]}},i_mux_reg[15:8]}; 
        2'b10 : o_data_reg = {{24{i_mux_reg[23]}},i_mux_reg[23:16]};
        2'b11 : o_data_reg = {{24{i_mux_reg[31]}},i_mux_reg[31:24]};
        endcase
    end
    3'b001 : begin
        case (i_alu_result[1])
            1'b0 : o_data_reg = {{16{i_mux_reg[15]}},i_mux_reg[15:0]}; // lh
            1'b1 : o_data_reg = {{16{i_mux_reg[31]}},i_mux_reg[31:16]}; 
        endcase
    end
    
    3'b010 : o_data_reg = i_mux_reg; // lw (load word)

    3'b100 : begin
        case(i_alu_result) // chọn vị trí load data
        2'b00 : o_data_reg = {24'b0,i_mux_reg[7:0]}; //lbu (load byte unsigned)
        2'b01 : o_data_reg = {24'b0,i_mux_reg[15:8]}; 
        2'b10 : o_data_reg = {24'b0,i_mux_reg[23:16]};
        2'b11 : o_data_reg = {24'b0,i_mux_reg[31:24]};
        endcase
    end
    3'b101 : begin
        case (i_alu_result[1])
            1'b0 : o_data_reg = {16'b0,i_mux_reg[15:0]}; // lhu (load half unsigned)
            1'b1 : o_data_reg = {16'b0,i_mux_reg[31:16]}; // lh
        endcase
    end
    default :  o_data_reg = i_mux_reg;
    endcase
end
endmodule