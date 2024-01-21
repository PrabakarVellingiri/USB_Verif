///////////////////////////////////////////////////////////////////////////////////////////////////
//
//  File name: tvs_usb2_device_agent.svh
//  Brief description: 
//     This is passive slave agent used to receive ULPI/UTMI transcation from ULPI/UTMI Master.   
//     Here we build the slave monitor. 
//
//==================================================================================================
//  Author name: 
//  Created on :
//  File ID    :
//==================================================================================================
//  
////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef TVS_USB2_DEVICE_AGENT_SVH
`define TVS_USB2_DEVICE_AGENT_SVH

class tvs_usb2_device_agent#(int DATA_WIDTH_SLV =8) extends uvm_agent;

  ////////////////////////////////////////////////////////////////////////////////
  /////////Declaration of the Variables or Handles of other classes //////////////
  ////////////////////////////////////////////////////////////////////////////////
 
  // Generic Slave Driver Instantiation/Handle 
   tvs_usb2_device_driver#(DATA_WIDTH_SLV) driver;
  // Generic Slave Sequencer Instantiation/Handle 
   tvs_usb2_device_sequencer#(DATA_WIDTH_SLV) sequencer;
  // Generic Slave Monitor Instantiation/Handle 
   tvs_usb2_device_monitor#(DATA_WIDTH_SLV) monitor;
  // Generic Slave Config Instantiation/Handle 
   tvs_usb2_device_agent_config device_cfg; 

  ////////////////////////////////////////////////////////////////////////////////
  //////////////////////Registration of the component  ///////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  // method name         :  Factory Registration 
  // description         :  Provide implementations of virtual methods such as 
  //                        get_type_name and create 
  ////////////////////////////////////////////////////////////////////////////////
  `uvm_component_utils_begin(tvs_usb2_device_agent#(DATA_WIDTH_SLV))
    `uvm_field_object (device_cfg,UVM_ALL_ON)
  `uvm_component_utils_end
  ////////////////////////////////////////////////////////////////////////////////
 
  ////////////////////////////////////////////////////////////////////////////////
  //////////////////////////Declaration of the Methods  //////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  // Method name         : new 
  // Description         : This is a constructor for tvs_usb2_device_agent class.  
  ////////////////////////////////////////////////////////////////////////////////
  function new(string name, uvm_component parent);
    super.new(name,parent);
    `uvm_info("TVS_USB2_DEVICE_SLAVE_AGENT-NEW", $psprintf("Building the Slave Sequencer, Driver, Monitor\n"),UVM_MEDIUM)
  endfunction : new
  ////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////Build Phase////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  // Method name         : build 
  // Description         : This method is used to build master env.  
  ////////////////////////////////////////////////////////////////////////////////
  virtual function void build_phase(uvm_phase phase);
    //if(!uvm_config_db #(tvs_usb2_device_agent_config)::get(this,"*","device_cfg",device_cfg))
    //begin
    //`uvm_fatal("SLAVE CONFIG","cannot get()interface slave_cfg from uvm_config_db in Slave Agent. Have you set() it?") 
    //end
    super.build_phase(phase);
    if(device_cfg != null) begin
      if (device_cfg.is_active == UVM_ACTIVE)
         begin
           if(device_cfg.has_driver == 1)
             begin       
               // Build the slave driver
               driver =  tvs_usb2_device_driver#(DATA_WIDTH_SLV)::type_id::create("driver",this); 
             end
             // Build the slave sequencer
             sequencer =  tvs_usb2_device_sequencer#(DATA_WIDTH_SLV)::type_id::create("sequencer",this); 
           if(device_cfg.has_monitor == 1)
             begin 
               // Build the slave monitor
               monitor =  tvs_usb2_device_monitor#(DATA_WIDTH_SLV)::type_id::create("monitor",this); 
             end
         end
       if (device_cfg.is_active == UVM_PASSIVE) 
         begin
           // Build the slave monitor
           monitor =  tvs_usb2_device_monitor#(DATA_WIDTH_SLV)::type_id::create("monitor",this); 
         end
     end
  endfunction: build_phase
  ////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////////
  // Method name         : connect_phase
  // Description         : This method use to connect the driver port with sequencer.
  ////////////////////////////////////////////////////////////////////////////////
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(device_cfg != null) begin 
      if(device_cfg.is_active == UVM_ACTIVE) 
        begin
         // Connect the sequencer with the driver
          if(device_cfg.has_driver == 1) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
          end 
        end 
    end
  endfunction: connect_phase
  ////////////////////////////////////////////////////////////////////////////////

endclass : tvs_usb2_device_agent

`endif // TVS_USB2_DEVICE_AGENT_SVH
