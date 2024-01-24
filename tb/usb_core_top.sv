`timescale 1ns/1ns
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB2_0/USB_Verif/tb/vip/wishbone/wb_interface.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB2_0/USB_Verif/tb/vip/USB_VIP/usb_interface.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB2_0/USB_Verif/tb/ssram_interface.sv"
 //`include "utmi_design.v"
import uvm_pkg::*;
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB2_0/USB_Verif/tb/usb_core_package.sv"
import usb_core_package::*;

//`include "uvm_macros.svh" 
 
module top;
  bit clk_i;
  bit rst_i;
  bit phy_clk_i;
  bit clk_480mhz;
  parameter period = 1.04;
  
  wb_interface w_vif(clk_480mhz,rst_i);
  utmi_interf u_vif( clk_480mhz,clk_i,rst_i);
  ssram_intf s_vif(clk_480mhz);
  
  initial 
    begin 
      clk_i =1'b0;
     /* w_vif.DAT_O = 0;
      w_vif.ACK_I = 0;
      w_vif.WE_O = 0;
      w_vif.STB_O = 0;
      w_vif.CYC_O = 0;
      u_vif.TXValid = 0;
      u_vif.DataOut = 0;
      u_vif.Xcvr_select = 0;
      u_vif.OpMode = 0;
      s_vif.sram_data_o = 0;
      s_vif.sram_re_i = 0;
      s_vif.sram_we_i = 0;*/
    end

 initial 
    clk_480mhz = 1'b0;

   always #5 clk_480mhz=~clk_480mhz;
   always #(period) clk_i=~clk_i;
 
   
    
  initial begin
   rst_i = 0;
    #15;
   rst_i = 1;
  end

      usbf_top DUT(// WISHBONE Interface
        .clk_i(w_vif.CLK_I), .rst_i(w_vif.RST_I), .wb_addr_i(w_vif.ADR_O), .wb_data_i(w_vif.DAT_O), .wb_data_o(w_vif.DAT_I),.wb_ack_o(w_vif.ACK_O), .wb_we_i(w_vif.WE_I), .wb_stb_i(w_vif.STB_O), .wb_cyc_i(w_vif.CYC_O),.inta_o(u_vif.inta_o), .intb_o(u_vif.intb_o),.dma_req_o(u_vif.dma_req_o), .dma_ack_i(u_vif.dma_ack_i), .susp_o(u_vif.susp_o), .resume_req_i(u_vif.resume_req_i),
		// UTMI Interface
        .phy_clk_pad_i(u_vif.clk_480mhz), .phy_rst_pad_o(u_vif.phy_rst_pad_o),.DataOut_pad_o(u_vif.DataOut), .TxValid_pad_o(u_vif.TXValid), .TxReady_pad_i(u_vif.TXReady),.RxValid_pad_i(u_vif.RXValid), .RxActive_pad_i(u_vif.RXActive), .RxError_pad_i(u_vif.RXError),.DataIn_pad_i(u_vif.DataIn), .XcvSelect_pad_o(u_vif.Xcvr_select), .TermSel_pad_o(u_vif.TermSel),.SuspendM_pad_o(u_vif.SuspendM), .LineState_pad_i(u_vif.LineState),.OpMode_pad_o(u_vif.OpMode), .usb_vbus_pad_i(u_vif.usb_vbus),.VControl_Load_pad_o(u_vif.utmi_vend_wr), .VControl_pad_o(u_vif.utmi_vend_ctrl), .VStatus_pad_i(u_vif.utmi_vend_stat),
		// Buffer Memory Interface
        .sram_adr_o(s_vif.sram_adr_i), .sram_data_i(s_vif.sram_data_i), .sram_data_o(s_vif.sram_data_o), .sram_re_o(s_vif.sram_re_i), .sram_we_o(s_vif.sram_we_i));
  
  //utmi u2(.clk_480mhz(u_vif.clk_480mhz), .clk_60mhz(u_vif.clk_60mhz), .rst(u_vif.rst), .data(u_vif.DataIn), .data(u_vif.DataOut), .tx_Valid(u_vif.TXValid), .data_p(u_vif.data_p), .data_m(u_vif.data_m));
         ssram s1(sram_adr_i, sram_data_o, sram_data_i, sram_re_i, sram_we_i);
  initial  begin      
    
    uvm_config_db#(virtual wb_interface)::set(null,"*", "w_vif",w_vif);
    uvm_config_db #(virtual utmi_interf)::set(null,"*","u_vif",u_vif);
    uvm_config_db #(virtual ssram_intf)::set(null,"*","s_vif",s_vif);
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
    //run_test("usb_core_reg_reset_read_test");
    run_test("usb_core_reg_wr_rd_test");
  end 
  
endmodule
