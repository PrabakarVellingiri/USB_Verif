interface ssram_intf(input logic clk);  
  logic[14:0] sram_adr_i;
  logic[31:0] sram_data_i;
  logic sram_re_i;
  logic sram_we_i;
  logic[31:0] sram_data_o;
endinterface
