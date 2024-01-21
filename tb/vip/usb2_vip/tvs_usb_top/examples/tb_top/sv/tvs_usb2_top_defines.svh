//============================================================================
//  CONFIDENTIAL and Copyright (C) 2015 Test and Verification Solutions Ltd
//============================================================================
//  Contents:
//  Defines file
//
//  Brief description: 
//  Contains the list of defines used across the Verification Environment 
//    
//
//  Known exceptions to rules:
//    
//============================================================================
//  Author        : 
//  Created on    : 
//  File Id       : 
//============================================================================


`ifndef TVS_USB2_TOP_DEFINES_SVH
`define TVS_USB2_TOP_DEFINES_SVH

//------------------------------------------------------------------------
// Setting the macros for uvm message access
//------------------------------------------------------------------------
`define tvs_fatal(ID, MSG)    uvm_report_fatal(.id(ID), .message(MSG));
`define tvs_error(ID, MSG)    uvm_report_error(.id(ID), .message(MSG));
`define tvs_warning(ID, MSG)  uvm_report_warning(.id(ID), .message(MSG), .verbosity(UVM_NONE));
`define tvs_note(ID, MSG)     uvm_report_info(.id(ID), .message(MSG), .verbosity(UVM_LOW));
`define tvs_debug(ID, MSG)    uvm_report_info(.id(ID), .message(MSG), .verbosity(UVM_HIGH));
//------------------------------------------------------------------------

`endif // TVS_USB2_TOP_DEFINES_SVH

