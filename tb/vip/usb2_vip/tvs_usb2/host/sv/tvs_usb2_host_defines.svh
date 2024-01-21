///////////////////////////////////////////////////////////////////////////////
//  Contents:
//    tvs_usb2_defines file
//
//  Brief description: 
//    This contains the list of signals which are used in USB2 host  
//
//  Known exceptions to rules:
//    
//============================================================================
//  Author        : 
//  Created on    : 
//  File Id       : 
//============================================================================
///////////////////////////////////////////////////////////////////////////////

`ifndef TVS_USB2_HOST_DEFINES_SVH
`define TVS_USB2_HOST_DEFINES_SVH

 typedef enum bit[1:0]{write,set,clear}ctrl_e;
 typedef enum bit {lnk_tx,lnk_rx}dir_e;
 typedef enum bit[1:0] {rise,fall,status,latch}int_type_e;
 typedef enum bit[1:0] {HIGH_SPEED_XVR=2'b00,FULL_SPEED_XVR=2'b01,LOW_SPEED_XVR=2'b10,FULL_SPEED_XVR_FOR_LS_PKT=2'b11}host_speed_e;
 typedef enum bit[3:0] {TVS_OUT_TOKEN=4'b0001,TVS_IN_TOKEN=4'b1001,TVS_SOF_TOKEN=4'b0101,TVS_SETUP_TOKEN=4'b1101}token_type_e;
 typedef enum bit[3:0] {TVS_DATA0_PKT=4'b0011,TVS_DATA1_PKT=4'b1011,TVS_DATA2_PKT=4'b0111,TVS_MDATA_PKT=4'b1111}data_pkt_type_e;
 typedef enum bit[3:0] {TVS_ACK_PKT=4'b0010,TVS_NAK_PKT=4'b1010,TVS_STALL_PKT=4'b1110,TVS_NYET_PKT=4'b0110}handshake_pkt_type_e;
 typedef enum bit[3:0] {TVS_ERR=4'b1100,TVS_SPLIT=4'b1000,TVS_PING=4'b0100,TVS_RSVD=4'b0000}special_pkt_type_e;
// typedef enum bit[1:0] {SE0_STATE=2'b00,J_STATE=2'b01,K_STATE=2'b10,SE1_STATE=2'b11}linestate_type_e; 
 typedef enum {IDLE,SE0_STATE,J_STATE,K_STATE,SE1_STATE}linestate_type_e; 
 typedef enum {RX_CMD,RX_DATA}received_data_type_e; 
 
 

//------------------------------------------------------------------------
  `define tvs_info(ID, MSG)    uvm_report_info(.id(ID), .message(MSG), .verbosity(UVM_LOW));
  `define tvs_error(ID, MSG)   uvm_report_error(.id(ID), .message(MSG));
  `define tvs_fatal(ID, MSG)   uvm_report_error(.id(ID), .message(MSG));
  `define tvs_debug(ID, MSG)   uvm_report_info(.id(ID), .message(MSG), .verbosity(UVM_HIGH));



 
`endif
