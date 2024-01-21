 //////////////////////////////////////////////////////////////////////////////////
 //  Contents:
 //    File for tvs_usb2_device_driver class
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
 
 `ifndef TVS_USB2_DEVICE_DRIVER_SVH
 `define TVS_USB2_DEVICE_DRIVER_SVH
 
 class tvs_usb2_device_driver#(int DATA_WIDTH_SLV =8) extends uvm_driver #(tvs_usb2_device_sequence_item#(DATA_WIDTH_SLV));
 
   ////////////////////////////////////////////////////////////////////////////////
   //////////////////////Declaration of the variables///////////////////////////
   ////////////////////////////////////////////////////////////////////////////////
 
   // Instantiation of the  slave sequence item
   tvs_usb2_device_sequence_item#(DATA_WIDTH_SLV)  drvr_item;
   // config class
   tvs_usb2_device_agent_config slave_cfg;
   // interface for the usb2 interface
    virtual tvs_ulpi_intf tvs_ulpi_dev_if;
  // Generic Slave Monitor Instantiation/Handle 
   tvs_usb2_device_monitor#(DATA_WIDTH_SLV) monitor;

 
   ////////////////////////////////////////////////////////////////////////////////
   ////////////////////////////////////////////////////////////////////////////////
   //////////////////////Registration of the Component  ///////////////////////////
   ////////////////////////////////////////////////////////////////////////////////
   ////////////////////////////////////////////////////////////////////////////////
   // method name         :  Factory Registration
   // description         :  Provide implementations of virtual methods such as
   //                    get_type_name and create
   ////////////////////////////////////////////////////////////////////////////////
   `uvm_component_utils_begin(tvs_usb2_device_driver#(DATA_WIDTH_SLV))
     `uvm_field_object(slave_cfg, UVM_ALL_ON)
   `uvm_component_utils_end
   ////////////////////////////////////////////////////////////////////////////////
 
   ////////////////////////////////////////////////////////////////////////////////
   /////////////////////////Declaration of the Methods  ///////////////////////////
   ////////////////////////////////////////////////////////////////////////////////
   ////////////////////////////////////////////////////////////////////////////////
   // method name         : new
   // description         : Default new constructor function
   ////////////////////////////////////////////////////////////////////////////////
   function new(string name = "tvs_usb2_device_driver", uvm_component parent);
     super.new(name,parent);
     `uvm_info("TVS_USB2_DEVICE_DRIVER-NEW", $psprintf("Building the USB2 device Driver\n"),UVM_MEDIUM)
   endfunction: new
   ////////////////////////////////////////////////////////////////////////////////
 
   ////////////////////////////////////////////////////////////////////////////////
   // Method name         : build_phase
   // Description         : Function used to create the component from the factory
   ////////////////////////////////////////////////////////////////////////////////
   virtual function void build_phase(uvm_phase phase);
     //if(!uvm_config_db#(tvs_usb2_device_agent_config)::get(this, "*", "slave_cfg", slave_cfg))
     //  begin
     //    `uvm_fatal("SLAVE CONFIG","cannot get()interface slave_cfg from uvm_config_db in driver. Have you set() it?")
     //  end
     super.build_phase(phase);
   endfunction: build_phase
   ////////////////////////////////////////////////////////////////////////////////

   ////////////////////////////////////////////////////////////////////////////////
   // Method name         : connect_phase
   // Description         : Function used to create the component from the factory
   ////////////////////////////////////////////////////////////////////////////////
   virtual function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     //tvs_ulpi_dev_if = slave_cfg.tvs_ulpi_dev_if;
   endfunction: connect_phase
   ////////////////////////////////////////////////////////////////////////////////
 
   ////////////////////////////////////////////////////////////////////////////////
   // Task name           : run_phase
   // Description         : Use to start the transactor.
   ////////////////////////////////////////////////////////////////////////////////
   virtual task run_phase(uvm_phase phase);
     forever
       begin
         seq_item_port.get_next_item(req);
         $cast(drvr_item, req);
         send_to_dut(drvr_item);
         $cast(rsp, req.clone());
         rsp.set_id_info(req);
         seq_item_port.item_done(rsp);
       end
   endtask: run_phase
 
   ////////////////////////////////////////////////////////////////////////////////
   // Task name           : send_to_dut
   // Description         : Use to send the transaction to DUT.
   ////////////////////////////////////////////////////////////////////////////////
   virtual task send_to_dut(tvs_usb2_device_sequence_item#(DATA_WIDTH_SLV) drvr_item);
     `uvm_info("DRIVER LOGIC","Write the driver logic here",UVM_MEDIUM)
   endtask

endclass : tvs_usb2_device_driver
 
 `endif // TVS_USB2_DEVICE_DRIVER_SVH

