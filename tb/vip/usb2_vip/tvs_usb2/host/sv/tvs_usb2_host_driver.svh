 //////////////////////////////////////////////////////////////////////////////////
 //  Contents:
 //    File for tvs_usb2_host_driver class
 //
 //  Brief description:
 //    This is the USB2 slave driver, which receives the transactions from the
 //     slave sequencer and does the operations.
 //
 //
 //  Known exceptions to rules:
 //
 //============================================================================
 //  Author        :
 //  Created on    :
 //  File Id       :
 //============================================================================
 ///////////////////////////////////////////////////////////////////////////////////
 
 `ifndef TVS_USB2_HOST_DRIVER_SVH
 `define TVS_USB2_HOST_DRIVER_SVH
 
 class tvs_usb2_host_driver#(int DATA_WIDTH_SLV =8) extends uvm_driver #(tvs_usb2_host_sequence_item#(DATA_WIDTH_SLV));
 
   ////////////////////////////////////////////////////////////////////////////////
   //////////////////////Declaration of the variables///////////////////////////
   ////////////////////////////////////////////////////////////////////////////////
 
   // Instantiation of the  slave sequence item
   tvs_usb2_host_sequence_item#(DATA_WIDTH_SLV)  drvr_item;
   // config class
   tvs_usb2_host_agent_config host_cfg;
   // interface for the usb2 interface
   virtual tvs_ulpi_intf#(.ULPI_DATA_WIDTH(DATA_WIDTH_SLV)) tvs_ulpi_host_if;
 
   ////////////////////////////////////////////////////////////////////////////////
   ////////////////////////////////////////////////////////////////////////////////
   //////////////////////Registration of the Component  ///////////////////////////
   ////////////////////////////////////////////////////////////////////////////////
   ////////////////////////////////////////////////////////////////////////////////
   // method name         :  Factory Registration
   // description         :  Provide implementations of virtual methods such as
   //                    get_type_name and create
   ////////////////////////////////////////////////////////////////////////////////
   `uvm_component_utils_begin(tvs_usb2_host_driver#(DATA_WIDTH_SLV))
     `uvm_field_object(host_cfg, UVM_ALL_ON)
   `uvm_component_utils_end
   ////////////////////////////////////////////////////////////////////////////////
 
   ////////////////////////////////////////////////////////////////////////////////
   /////////////////////////Declaration of the Methods  ///////////////////////////
   ////////////////////////////////////////////////////////////////////////////////
   ////////////////////////////////////////////////////////////////////////////////
   // method name         : new
   // description         : Default new constructor function
   ////////////////////////////////////////////////////////////////////////////////
   function new(string name = "tvs_usb2_host_driver", uvm_component parent);
     super.new(name,parent);
     `uvm_info("TVS_USB2_DEVICE_SLAVE_DRIVER-NEW", $psprintf("Building the USB2 host Slave Driver\n"),UVM_MEDIUM)
   endfunction: new
   ////////////////////////////////////////////////////////////////////////////////
 
   ////////////////////////////////////////////////////////////////////////////////
   // Method name         : build_phase
   // Description         : Function used to create the component from the factory
   ////////////////////////////////////////////////////////////////////////////////
   virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
      if(!uvm_config_db#(virtual tvs_ulpi_intf#(.ULPI_DATA_WIDTH(DATA_WIDTH_SLV)))::get(this, "", "tvs_ulpi_host_if", tvs_ulpi_host_if))
     `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".tvs_ulpi_host_if"});

   endfunction: build_phase
   ////////////////////////////////////////////////////////////////////////////////

   ////////////////////////////////////////////////////////////////////////////////
   // Method name         : connect_phase
   // Description         : Function used to create the component from the factory
   ////////////////////////////////////////////////////////////////////////////////
   virtual function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
   endfunction: connect_phase
   ////////////////////////////////////////////////////////////////////////////////
 
   ////////////////////////////////////////////////////////////////////////////////
   // Task name           : run_phase
   // Description         : Use to start the transactor.
   ////////////////////////////////////////////////////////////////////////////////
   virtual task run_phase(uvm_phase phase);
     forever begin
       seq_item_port.get_next_item(req);
       $cast(drvr_item, req);
       wait_for_rst();
       driven_data(drvr_item);
       $cast(rsp, req.clone());
       rsp.set_id_info(req);
       seq_item_port.item_done(rsp);
      end
   endtask: run_phase
 
   ////////////////////////////////////////////////////////////////////////////////
   // Task name           : wait_for_reset 
   // Description         : 
   ////////////////////////////////////////////////////////////////////////////////
   task wait_for_rst();
     @(posedge tvs_ulpi_host_if.clock)
     wait(tvs_ulpi_host_if.host_cb.reset);
   endtask : wait_for_rst
   ////////////////////////////////////////////////////////////////////////////////
   // Task name           : driven_data
   // Description         : Use to send the transaction to DUT.
   ////////////////////////////////////////////////////////////////////////////////
   virtual task driven_data(tvs_usb2_host_sequence_item#(DATA_WIDTH_SLV) drvr_item);
     foreach (drvr_item.rx_data_queue[i]) begin
       tvs_ulpi_host_if.host_cb.dir<=1'b1;
       if(drvr_item.data_type_e == RX_DATA)
         tvs_ulpi_host_if.host_cb.nxt<=1'b1;
       else
         tvs_ulpi_host_if.host_cb.nxt<=1'b0;
       @(posedge tvs_ulpi_host_if.clock)
         tvs_ulpi_host_if.host_cb.data_out<=drvr_item.rx_data_queue[i];
     end //foreach
     @(posedge tvs_ulpi_host_if.clock)
       tvs_ulpi_host_if.host_cb.dir<=1'b0;
       tvs_ulpi_host_if.host_cb.nxt<=1'b0;
   endtask : driven_data 

endclass : tvs_usb2_host_driver
 
 `endif // TVS_USB2_HOST_DRIVER_SVH

