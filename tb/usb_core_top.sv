`include "/Projects/DV_Trainees_Batch2023/priyadharshini.ramakrishnan/USB/TB/WSB_MASTER/Wsb_INTERFACE.sv"
`include "/Projects/DV_Trainees_Batch2023/priyadharshini.ramakrishnan/USB/TB/UTMI_SLAVE/Utmi_INTERFACE.sv"

import uvm_pkg::*;
`include "/Projects/DV_Trainees_Batch2023/priyadharshini.ramakrishnan/USB/TB/WSB_UTMI_PACKAGE.sv"
`include "/Projects/DV_Trainees_Batch2023/priyadharshini.ramakrishnan/USB/RTL/SSRAM.v"

import Wsb_Utmi_PACKAGE::*;
`include "uvm_macros.svh"


module top;
  
  bit clk_o;
  bit rst_i;
  bit Phy_clk_pad_i;
  
  ovi_wisbone wsb_vif(clk_o,rst_i);
  utmi_interface utmi_vif(Phy_clk_pad_i);
  
  initial 
    begin 
      clk_o =1'b0;
      PHY_CLK=1'b0;
      wsb_vif.wb_data_o = 0;
      wsb_vif.wb_ack_i = 0;
      wsb_vif.wb_we_o = 0;
      wsb_vif.wb_stb_o = 0;
      wsb_vif.wb_cyc_o = 0;
      utmi_vif.DataOut_pad_o = 0;
      utmi_vif.TxValid_pad_o = 0;
 
    end

  always  #5 phy_clk_pad_i = ~ phy_clk;
    
  initial begin
   rst_i = 0;
    #15;
   rst_i = 1;
  end
  
  
      usbf_top u1(// WISHBONE Interface
		clk_i, rst_i, wb_addr_i, wb_data_i, wb_data_o,
		wb_ack_o, wb_we_i, wb_stb_i, wb_cyc_i, inta_o, intb_o,
		dma_req_o, dma_ack_i, susp_o, resume_req_i,
 
		// UTMI Interface
		phy_clk_pad_i, phy_rst_pad_o,
		DataOut_pad_o, TxValid_pad_o, TxReady_pad_i,
 
		RxValid_pad_i, RxActive_pad_i, RxError_pad_i,
		DataIn_pad_i, XcvSelect_pad_o, TermSel_pad_o,
		SuspendM_pad_o, LineState_pad_i,
 
		OpMode_pad_o, usb_vbus_pad_i,
		VControl_Load_pad_o, VControl_pad_o, VStatus_pad_i,
 
		// Buffer Memory Interface
		sram_adr_o, sram_data_i, sram_data_o, sram_re_o, sram_we_o
 
		);
         ssram s1(sram_adr_i, sram_data_o, sram_data_i, sram_re_i, sram_we_i);
  
  initial  begin        
    uvm_config_db#(virtual wsb_interface)::set(null,"*", "w_vif",wsb_vif);
    uvm_config_db#(virtual utmi_interface)::set(null,"*", "u_vif",utmi_vif);
  end
  
  initial begin
      run_test();
  end 
  
   initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars();
      
    end

endmodule
