
`include "wb_interface.sv"
import uvm_pkg::*;
`include "wb_package.sv"
import WISHBONE_PACKAGE::*;

module top;
  
  bit CLK_O;
  bit RST_O;
  
  wb_interface vif(CLK_O,RST_O);
  //wb_slave_intf s_vif(CLK_O,RST_O);
 
  initial 
    CLK_O = 1'b0;
  always 
    #5 CLK_O = ~CLK_O;
  
  initial begin
    RST_O=0;
    #15 RST_O=1;
   
    #2000 $finish;
  end

  
  initial begin
    uvm_config_db#(virtual wb_interface)::set(null,"*","vif",vif);
  end
  
  initial begin
    run_test("test");
  end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars();
  end
endmodule
