//////////////////////////////////////////////////////////////////////////////////
//  Contents:
//    File for tvs_usb2_host_monitor class
//
//  Brief description: 
//    Here we monitor the ulpi transactions coming at the pin level 
//
//  Known exceptions to rules:
//    
//============================================================================
//  Author        : 
//  Created on    : 
//  File Id       : 
//============================================================================
///////////////////////////////////////////////////////////////////////////////////

`ifndef TVS_USB2_HOST_MONITOR_SVH
`define TVS_USB2_HOST_MONITOR_SVH

class tvs_usb2_host_monitor#(int DATA_WIDTH_SLV =8) extends uvm_monitor;
   
  // Virtual interface for monitor connection
  virtual tvs_ulpi_intf#(DATA_WIDTH_SLV) tvs_ulpi_hos_if;
  // config class
  tvs_usb2_host_agent_config host_cfg;
  // Sequence Item handle declaration
  tvs_usb2_host_sequence_item#(DATA_WIDTH_SLV) mon_item;
  //Handle declaration for ulpi_tx_cmd_cmd seq item
  tvs_ulpi_host_tx_cmd ulpi_tx_cmd;
  //Handle declaration for rx_cmd seq item
  tvs_ulpi_host_rx_cmd ulpi_rx_cmd;
  //enum variable to indicate link transmission or link reception
  dir_e dir;
  //Array variable to store tx_cmd
  bit [7:0] tx_cmd_queue[int];
  //Array variable to store rx_cmd
  bit [7:0] rx_cmd_queue[int];
  //Handle declaration for ulpi register seq item
  tvs_ulpi_host_reg ulpi_reg;
  //Handle declaration for usb token packet seq item
  tvs_usb_host_token_pkt usb_token_pkt;
  //Handle declaration for usb data packet seq item
  tvs_usb_host_data_pkt usb_data_pkt;
  //Array variable to store rx_data
  bit [7:0] rx_data_queue[int];
  //pid is used to detect type of token
  bit[7:0] pid;
  //enum variable for token type
  token_type_e token_type;
  //enum variable for data packet type
  data_pkt_type_e data_type;
  //enum variable for handshake packet type
  handshake_pkt_type_e hs_type_e;
  //enum variable for special packet type
  special_pkt_type_e special_type;
  //enum variable to indicate type of speed
  host_speed_e speed;
  
  ////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////PORT DECLARATION/////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  
  //uvm_analysis_port #(tvs_usb2_host_sequence_item#(int DATA_WIDTH_SLV =8)) usb2_slave_monitor_port;

  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  //////////////////////Registration of the Component  ///////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  // method name         :  Factory Registration  
  // description         :  Provide implementations of virtual methods such as 
  //                        get_type_name and create 
  //////////////////////////////////////////////////////////////////////////////// 
  `uvm_component_utils_begin(tvs_usb2_host_monitor#(DATA_WIDTH_SLV))
     `uvm_field_object(host_cfg, UVM_ALL_ON)
  `uvm_component_utils_end
  ////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  /////////////////////////Declaration of the Methods  ///////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  // method name         : new
  // description         : Default new constructor 
  ////////////////////////////////////////////////////////////////////////////////
  function new(string name = "tvs_usb2_host_monitor",uvm_component parent);
    super.new(name,parent);
    `tvs_info("TVS_USB2_DEVICE_SLAVE_MONITOR-NEW", $psprintf("Building the ULPI host Slave Monitor\n"))
     //usb2_slave_monitor_port = new("usb2_slave_monitor_port", this);
  endfunction: new
  ////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////////
  // FUNCTION: build_phase()
  // Factory build phase
  // Get configuration settings for virtual interfaces
  ////////////////////////////////////////////////////////////////////////////////
  virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
  endfunction
  ////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////////
  // FUNCTION: connect_phase()
  // Factory connect phase
  // Get configuration settings for virtual interfaces
  ////////////////////////////////////////////////////////////////////////////////
  virtual function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
  endfunction
  ////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////////
  // Task name           : run_phase
  // Description         : Use to start the transactor. 
  ////////////////////////////////////////////////////////////////////////////////
  task run_phase(uvm_phase phase);
    mon_item = tvs_usb2_host_sequence_item#(DATA_WIDTH_SLV)::type_id::create("mon_item");
    //forever
    //  begin
    // //   collect_data();
    //   // timing_delay();
    //  end  
  endtask: run_phase
 
  ////////////////////////////////////////////////////////////////////////////////
  // Task name           : collect_data
  // Description         : Receiving the data continuously.
  ////////////////////////////////////////////////////////////////////////////////
  task collect_data();
    forever begin
      wait(tvs_ulpi_hos_if.reset==1'b1)
       @(negedge tvs_ulpi_hos_if.clock)
        if(tvs_ulpi_hos_if.dir==lnk_tx && !(tvs_ulpi_hos_if.stp) && tvs_ulpi_hos_if.nxt==1'b1) begin
          if(tx_cmd_queue.size()==1'b0) begin
            ulpi_tx_cmd =tvs_ulpi_host_tx_cmd::type_id::create("ulpi_tx_cmd");
            ulpi_tx_cmd.stp=tvs_ulpi_hos_if.stp;        
            ulpi_tx_cmd.data=tvs_ulpi_hos_if.data_out;
            ulpi_tx_cmd.dir=tvs_ulpi_hos_if.dir;
            ulpi_tx_cmd.nxt=tvs_ulpi_hos_if.nxt;
            tx_cmd_queue[tx_cmd_queue.size()]=ulpi_tx_cmd.data;
            ulpi_tx_cmd.frm2item(ulpi_tx_cmd); 
          end //if 
          else if(tx_cmd_queue.size != 0 && tx_cmd_queue[0][7:6] ==2'b10 && !(tvs_ulpi_hos_if.stp)) begin
            ulpi_reg=tvs_ulpi_host_reg::type_id::create("ulpi_reg");
            ulpi_reg.addr=tx_cmd_queue[0][5:0];
            ulpi_reg.data=tvs_ulpi_hos_if.data_out;
            ulpi_reg.ulpi_reg_update(ulpi_reg);
            speed=host_speed_e'(ulpi_reg.speed);
            tx_cmd_queue.delete();
          end// else if
        end//if 
        else if(tvs_ulpi_hos_if.dir==lnk_rx && !(tvs_ulpi_hos_if.stp) && !(tvs_ulpi_hos_if.nxt)) begin
          ulpi_rx_cmd = tvs_ulpi_host_rx_cmd::type_id::create("ulpi_rx_cmd");
          ulpi_rx_cmd.stp=tvs_ulpi_hos_if.stp;
          ulpi_rx_cmd.data=tvs_ulpi_hos_if.data_in;
          ulpi_rx_cmd.dir=tvs_ulpi_hos_if.dir;
          ulpi_rx_cmd.nxt=tvs_ulpi_hos_if.nxt;
          rx_cmd_queue[rx_cmd_queue.size()]=ulpi_rx_cmd.data;
          ulpi_rx_cmd.frm2item(ulpi_rx_cmd);
        end//if
        else if(tvs_ulpi_hos_if.nxt==1'b1 && tvs_ulpi_hos_if.dir==lnk_rx && !(tvs_ulpi_hos_if.stp)) begin
          if(rx_data_queue.size()==1'b0) begin
            rx_data_queue[rx_data_queue.size()]=tvs_ulpi_hos_if.data_in;
            pid=rx_data_queue[0];
          end//if 
          if(pid[3:0]==TVS_OUT_TOKEN || pid[3:0]==TVS_IN_TOKEN || pid[3:0]==TVS_SETUP_TOKEN || pid[3:0]==TVS_SOF_TOKEN) begin
            `tvs_info("TVS_USB_TOKEN_PKT", $psprintf("TVS USB Token packet"))
            if(usb_token_pkt ==null) 
              usb_token_pkt=tvs_usb_host_token_pkt::type_id::create("USB_Token_Pkt");
            usb_token_pkt.data=tvs_ulpi_hos_if.data_in;
            rx_data_queue[rx_data_queue.size()]=usb_token_pkt.data;
            usb_token_pkt.frm2item(usb_token_pkt);
            if(rx_data_queue.size==4)
              rx_data_queue.delete();
          end//if
          else if(pid[3:0]==TVS_DATA0_PKT || pid[3:0]==TVS_DATA1_PKT || pid[3:0]==TVS_DATA2_PKT || pid[3:0]==TVS_MDATA_PKT) begin
            `tvs_info("TVS_USB_DATA_PKT", $psprintf(" TVS USB Data packet"))
            if(usb_data_pkt == null)
              usb_data_pkt=tvs_usb_host_data_pkt::type_id::create("usb_data_pkt");
            usb_data_pkt.data=tvs_ulpi_hos_if.data_in;
            usb_data_pkt.frm2item(usb_data_pkt);
          end//else if
          else if(pid[3:0]==TVS_ACK_PKT || pid[3:0]==TVS_NAK_PKT || pid[3:0]==TVS_STALL_PKT || pid[3:0]==TVS_NYET_PKT)
            `tvs_info("TVS_USB_HANDSHAKE_PKT", $psprintf(" TVS USB Handshake packet"))
          else if( pid[3:0]==TVS_ERR || pid[3:0]==TVS_SPLIT || pid[3:0]==TVS_PING || pid[3:0]==TVS_RSVD)
            `tvs_info("TVS_USB_SPECIAL_PKT", $psprintf(" TVS USB Special packet"))
        end//else if
        if(tvs_ulpi_hos_if.nxt==1'b0 && tvs_ulpi_hos_if.dir==lnk_rx ) 
          if(pid[3:0]==TVS_DATA0_PKT || pid[3:0]==TVS_DATA1_PKT || pid[3:0]==TVS_DATA2_PKT || pid[3:0]==TVS_MDATA_PKT) begin
            usb_data_pkt.crc_16(usb_data_pkt);
            rx_data_queue.delete();
          end//if  
    end//forever
  endtask : collect_data

endclass : tvs_usb2_host_monitor

`endif 

