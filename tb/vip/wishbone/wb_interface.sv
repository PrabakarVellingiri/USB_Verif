interface wb_interface(input logic CLK_I,RST_I);
  logic [31:0]ADR_O;
  logic [31:0] ADR_I; //from slv interface
  logic [31:0]DAT_I;
  //logic [31:0]DAT_i; //from slv interface
  logic [31:0]DAT_O;
  //logic [31:0]DAT_o; //from slv interface
  logic WE_O;
  logic WE_I;//from slv interface
  logic [3:0]SEL_O;
  logic [3:0] SEL_I;//from slv interface
  logic STB_O;
  logic STB_I;//from slv interface
  logic ACK_I;
  logic ACK_O;//from slv interface
  logic CYC_O;
  logic CYC_I;//from slv interface
endinterface
