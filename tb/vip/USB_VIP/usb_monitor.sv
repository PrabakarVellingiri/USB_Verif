`include "uvm_macros.svh"
import uvm_pkg::*;
//`define im vif.mon_mp.mon_cb
class usb_monitor extends uvm_monitor;
    `uvm_component_utils(usb_monitor)
    event start_seq;                // Event declaration
    bit [7:0] sie_data_m[$];		// Queue to send data to sie block
    //usb_packet pkt;
    virtual utmi_interf vif;
    //uvm_blocking_put_port(sie_data_m) mon2scr;                         // parameterize with queue

    function new( string name="usb_monitor", uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //pkt=usb_packet::type_id::create("pkt") ;
       // mon2scr=new(mon2scr,"this");

        if(!(uvm_config_db#(virtual utmi_interf)::get(this,"","vif",vif)))
            `uvm_error("monitor","virtual interface error in build phase")
    endfunction

virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction: connect_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
          #5;
          if(vif.mon_mp.mon_cb.RXActive)begin
          //if(vif.RXActive)begin
            if(vif.mon_mp.mon_cb.RXValid && (!vif.mon_mp.mon_cb.RXError))begin		// No error & is valid,  sample data 
              @(posedge vif.clk_480mhz)
              sie_data_m.push_back(vif.mon_mp.mon_cb.DataOut);
           end
          end
          trig_event();
        end
    endtask

    function void trig_event(); begin
        if(sie_data_m[0]==4'b1001)
            -> start_seq;
          //mon2scr.write(pkt);
    end
    endfunction
endclass

