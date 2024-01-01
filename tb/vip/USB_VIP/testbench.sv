`include "usb_interface.sv"
`include "usb_pkg.sv"
`include "uvm_macros.svh"
import uvm_pkg::*;
import usb_pkg::*;

module top;
  
  bit clk_60mhz,clk_480mhz;
  bit rst;
  parameter period=1.04;
  
  
 
  always #(period) clk_480mhz=~clk_480mhz;
   always #(period*8) clk_60mhz=~clk_60mhz;
  
    
  initial begin
   rst = 1;
   #10;
   rst = 0;
  end
  
  utmi_interf inf( clk_480mhz,clk_60mhz,rst);
  
  utmi u1(
    .data_p(inf.data_p),
    .data_m(inf.data_m),
    .tx_valid(inf.TXValid),
    .TX_ready(inf.TXReady),
    .RX_valid(inf.RXValid),
    .RX_active(inf.RXActive),
    .RXError(inf.RXError),
    .LineState(inf.LineState),
    .OpMode(inf.OpMode),
    .data_in(inf.DataIn),
    .data_out(inf.DataOut),
    .reg_cfg_done(inf.reg_cfg_done),
     .host_linkup_done(inf.host_linkup_done),
    .Xcvr_select(inf.Xcvr_select),
     .l_uclk_b(inf.clk_480mhz),
     .uclk_b(inf.clk_60mhz),
     .rst(inf.rst));
    
  initial begin
    uvm_config_db #(virtual utmi_interf)::set(null,"*","vif",inf);
  end

  
  initial begin
    run_test("bulk_data_seq_test");
    //run_test("interrupt_data_seq_test");
     //run_test("isoch_data_seq_test");
  end
  
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars();
      
    end
  endmodule 
