# RV32I Single-Cycle Core

Core RISC-V RV32I kiến trúc single-cycle, viết bằng SystemVerilog để học thiết kế RTL.
Mô phỏng bằng [Icarus Verilog](https://steveicarus.github.io/iverilog/) (`iverilog`).

## Tính năng

- Tập lệnh RV32I: R, I (số học, load, jalr), S, B, U (`lui`, `auipc`), J (`jal`)
- Load/store byte, halfword, word (có sign/zero extend)
- Kiến trúc single-cycle: mỗi lệnh hoàn thành trong một chu kỳ clock
- Bộ nhớ lệnh và bộ nhớ dữ liệu tách riêng
- Một file `rv_defines.svh` chứa toàn bộ opcode và mã ALU

## Sơ đồ khối

```
        +------+   +-------+   +----------+   +-----+   +----------+   +----------+
 clk -> |  PC  |-->| imem  |-->| control  |   |     |   |          |   |          |
        +------+   +-------+   +----------+   |     |   |          |   |          |
           ^           |                      | ALU |-->| data_mem |-->| load_unit|--> mux_reg --> reg_file (ghi rd)
           |           +--> reg_file (rs1,rs2)|     |   |          |   |          |
        pc_next <------ imm_gen, branch_unit  +-----+   +----------+   +----------+
```

(Nên thay bằng hình vẽ chi tiết hơn, ví dụ xuất từ draw.io, đặt trong thư mục `docs/`.)

## Cấu trúc thư mục

| File | Chức năng |
|---|---|
| `top.sv` | Module `riscv_top`, nối tất cả các khối |
| `rv_defines.svh` | Opcode, mã ALU, nhóm type |
| `PC.sv` | Thanh ghi PC |
| `pc_next.sv` | Tính PC kế tiếp (PC+4, branch, jal, jalr) |
| `instruc_mem.sv` | Bộ nhớ lệnh, nạp từ `program.hex` |
| `control_unit.sv` | Giải mã opcode thành tín hiệu điều khiển |
| `imm_gen.sv` | Sinh immediate cho các định dạng I/S/B/U/J |
| `reg.sv` | Tệp thanh ghi (32 x 32 bit) |
| `alu.sv` | Cộng, trừ, logic, dịch, so sánh, tính địa chỉ load/store |
| `mux_bf_alu_b.sv` | Chọn toán hạng B của ALU (rs2 hoặc immediate) |
| `branch_unit.sv` | So sánh rs1/rs2 theo funct3 để quyết định rẽ nhánh |
| `data_mem.sv` | Bộ nhớ dữ liệu (ghi byte/half/word) |
| `load_unit.sv` | Chọn byte/half từ word đọc ra, mở rộng dấu |
| `mux_reg.sv` | Chọn dữ liệu ghi về thanh ghi rd |
| `control_tb.sv` | Testbench tự kiểm cho control unit |
| `program.hex` | Chương trình mẫu (mỗi dòng một lệnh 32 bit, hex) |

## Chạy mô phỏng

Cần cài `iverilog` (phiên bản 12 trở lên).

Testbench control unit:

```bash
iverilog -g2012 -I. -s control_tb -o sim control_tb.sv control_unit.sv
vvp sim
```

Kết quả mong đợi: `PASS: 39  FAIL: 0`.

Chương trình đầu tiên phải nằm ở địa chỉ `0x00` vì khi reset PC = 0.

## Trạng thái kiểm thử

- [x] Đủ các khối RTL
- [x] Testbench control unit (39 ca)
- [ ] Testbench ALU
- [ ] Testbench imm_gen
- [ ] Testbench branch_unit
- [ ] Testbench load_unit, data_mem, reg_file
- [ ] Testbench top chạy chương trình thật

## Hạn chế

- Chưa hỗ trợ CSR, `ecall`, `ebreak`, `fence`
- Không có pipeline, không có xử lý ngoại lệ hay ngắt
- Chưa kiểm tra truy cập không căn chỉnh (misaligned)

## Hướng phát triển

- Hoàn thiện testbench cho từng khối và cho top
- Thêm chương trình mẫu (cộng 1..10, Fibonacci, sắp xếp)
- Nâng cấp lên pipeline 5 tầng

## Tài liệu tham khảo

- RISC-V Unprivileged ISA Specification (riscv.org)
