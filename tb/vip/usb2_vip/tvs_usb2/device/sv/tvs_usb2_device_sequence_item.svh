//////////////////////////////////////////////////////////////////////////////
//  Contents:
//    File for tvs_usb2_device_sequence_item class
//
//  Brief description: 
//    Sequence item contains the list of variables used for the transactions
//    to be done.  
//
//  Known exceptions to rules:
//    
//============================================================================
//  Author        : 
//  Created on    : 
//  File Id       : 
//============================================================================
///////////////////////////////////////////////////////////////////////////////

`ifndef TVS_USB2_DEVICE_SEQUENCE_ITEM_SVH 
`define TVS_USB2_DEVICE_SEQUENCE_ITEM_SVH

class tvs_usb2_device_sequence_item#(int DATA_WIDTH_SLV =8) extends uvm_sequence_item; 
  
  //stp signal used to indicate last data
  bit stp;
  //data signal used to collect data
  bit[DATA_WIDTH_SLV-1:0] data;
  //Direction signal used to indicate transaction from PHY/LINK
  bit dir;
  //next signal used to indicate data throttle
  bit nxt;
  //enum variable to specify type of speed  
  device_speed_e speed;
  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////Registration of the Component  /////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  // method name         :  Factory Registration 
  // description         :  Provide implementations of virtual methods such as 
  //                        get_type_name and create 
  ////////////////////////////////////////////////////////////////////////////////

  `uvm_object_utils_begin(tvs_usb2_device_sequence_item#(DATA_WIDTH_SLV))
   `uvm_field_int(stp, UVM_DEFAULT)
   `uvm_field_int(data, UVM_DEFAULT)
   `uvm_field_int(dir, UVM_DEFAULT)
   `uvm_field_int(nxt, UVM_DEFAULT)
   `uvm_field_enum(device_speed_e,speed, UVM_DEFAULT)
  `uvm_object_utils_end

  ////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////////
  // method's name       : new
  // Description         : This is a constructor for tvs_usb2_device_sequence_item class. 
  ////////////////////////////////////////////////////////////////////////////////
  function new (string name = "tvs_usb2_device_sequence_item" );
    super.new(name);
    `tvs_debug("TVS_USB2_DEVICE_SEQUENCE_ITEM-NEW", $psprintf("Building the ULPI Slave Sequence Item\n")) 
  endfunction : new 
  ////////////////////////////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////////////////////////////
  // method's name       : frm2item
  // Description         :  
  ////////////////////////////////////////////////////////////////////////////////
  function void frm2item(tvs_usb2_device_sequence_item item);
  begin
   this.stp =item.stp;
   this.data=item.data;
   this.dir =item.dir;
   this.nxt =item.nxt;
  end
  endfunction : frm2item
  ////////////////////////////////////////////////////////////////////////////////
  // method's name       : item2frm
  // Description         :  
  ////////////////////////////////////////////////////////////////////////////////
  //function void item2frm();
  //begin
  // item.stp =this.stp;
  // item.data=this.data;
  // item.dir =this.dir;
  // item.nxt =this.nxt;
  //end
  //endfunction : item2frm
endclass : tvs_usb2_device_sequence_item

////////////////////////////////////////////////////////////////////////////////
////////////////////////////TX_CMD seqitem/////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
class tvs_ulpi_device_tx_cmd extends tvs_usb2_device_sequence_item;

  //field declaration
  rand bit[1:0] cmd_code;
  rand bit[5:0] cmd_payload;
  
  //factory registration
  `uvm_object_utils_begin(tvs_ulpi_device_tx_cmd)
   `uvm_field_int(cmd_code,UVM_ALL_ON)
   `uvm_field_int(cmd_payload,UVM_ALL_ON)
  `uvm_object_utils_end

   ////////////////////////////////////////////////////////////////////////////////
   // method's name       : new
   // Description         : This is a constructor for tvs_usb2_device_sequence_item class. 
   ////////////////////////////////////////////////////////////////////////////////
   function new (string name = "tvs_ulpi_device_tx_cmd" );
     super.new(name);
     `tvs_debug("TVS_TX_CMD", $psprintf("Building the TVS_ULPI_DEVICE_TX_CMD Sequence Item\n"))
   endfunction : new

  ////////////////////////////////////////////////////////////////////////////////
  // method's name       : frm2item
  // Description         :  
  ////////////////////////////////////////////////////////////////////////////////
  function void frm2item(tvs_ulpi_device_tx_cmd item);
  begin
    super.frm2item(item);
    cmd_decode();
  end
  endfunction : frm2item

  ////////////////////////////////////////////////////////////////////////////////
  // method's name       : cmd_decode
  // Description         :  
  ////////////////////////////////////////////////////////////////////////////////
  function void cmd_decode();
  begin
    cmd_code   =data[7:6];
    cmd_payload=data[5:0];

    `tvs_info("TVS_ULPI_TX_CMD",$psprintf("Link Transmit TX_CMD : 0x%0h ",data))
    if(cmd_code==2'b0 && cmd_payload==6'b0)
     `tvs_info("TVS_ULPI_TX_CMD_SPECIAL",$psprintf("Link drives NOOP by default "))
    else if(cmd_code==2'b0 && cmd_payload != 6'b0)
     `tvs_error("TVS_ULPI_TX_CMD_SPECIAL",$psprintf("Undefined behaviour of data bus"))
    else if(cmd_code==2'b01 && cmd_payload==6'b0)
     `tvs_info("TVS_ULPI_TX_CMD_TRANSMIT",$psprintf("USB data transmit NOPID "))
    else if(cmd_code==2'b01 && cmd_payload[6:5]==2'b0)
     `tvs_info("TVS_ULPI_TX_CMD_TRANSMIT",$psprintf("USB data transmit with PID"))
    else if(cmd_code==2'b01 && cmd_payload!=6'b0 && cmd_payload[6:5]!=2'b0)
     `tvs_error("TVS_ULPI_TX_CMD_TRANSMIT",$psprintf("Undefined behaviour of data bus"))
    else if(cmd_code==2'b10 && cmd_payload==6'b101111)
     `tvs_info("TVS_ULPI_TX_CMD_REG_WRITE",$psprintf("Extended REG_WRITE operation"))
    else if(cmd_code==2'b10)
     `tvs_info("TVS_ULPI_TX_CMD REG_WRITE",$psprintf("REG_WRITE operation with 6-bit immediate address"))
    else if(cmd_code==2'b11 && cmd_payload==6'b101111)
     `tvs_info("TVS_ULPI_TX_CMD REG_READ",$psprintf("Extended REG_READ operation"))
    else 
     `tvs_info("TVS_ULPI_TX_CMD REG_READ",$psprintf("REG_READ operation with 6-bit immediate address"))
  end
  endfunction : cmd_decode
endclass : tvs_ulpi_device_tx_cmd
////////////////////////////////////////////////////////////////////////////////
////////////////////////////RX_CMD seqitem/////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
class tvs_ulpi_device_rx_cmd extends tvs_usb2_device_sequence_item;

  //UTMI+ LineState signals
  rand bit[1:0] linestate;
  //Encoded Vbus Voltage state
  rand bit[1:0] vbus_state;
  //Indicates if the voltage on Vbus (0.2V < Vth < 0.8V)
  rand bit sess_end;
  rand bit sess_valid;
  //Indicates if the voltage on Vbus is at a valid level for operation
  rand bit vbus_valid;
  //Indicates if the rx_active or rx_error or host disconnect
  rand bit[1:0] rx_event;
  //Used to indicate receiver is active or not
  rand bit rx_active;
  //Indicate receiver error
  rand bit rx_error;
  //This signal is used for all types of peripherals connected to it
  rand bit host_disconnect;
  //Set to the value of IdGnd
  rand bit id;
  //Indicates non USB interrupts
  rand bit alt_int;

  //factory registration
  `uvm_object_utils_begin(tvs_ulpi_device_rx_cmd)
   `uvm_field_int(linestate,UVM_ALL_ON)
   `uvm_field_int(vbus_state,UVM_ALL_ON)
   `uvm_field_int(sess_end,UVM_ALL_ON)
   `uvm_field_int(sess_valid,UVM_ALL_ON)
   `uvm_field_int(vbus_valid,UVM_ALL_ON)
   `uvm_field_int(rx_event,UVM_ALL_ON)
   `uvm_field_int(rx_active,UVM_ALL_ON)
   `uvm_field_int(rx_error,UVM_ALL_ON)
   `uvm_field_int(host_disconnect,UVM_ALL_ON)
   `uvm_field_int(id,UVM_ALL_ON)
   `uvm_field_int(alt_int,UVM_ALL_ON)
  `uvm_object_utils_end
 
  //Constraints
  constraint rx_cmd_c {(vbus_state==2'b00) -> (sess_end==1'b1);(sess_valid==1'b0);(vbus_valid==1'b0); 
                       (vbus_state==2'b01)->(sess_end==1'b0);(sess_valid==0);(vbus_valid==1'b0);
                       (vbus_state==2'b10)->(sess_end==1'bx);(sess_valid==1'b1);(vbus_valid==1'b0);
                       (vbus_state==2'b11)->(sess_end==1'bx);(sess_valid==1'bx);(vbus_valid==1'b1);
                       (rx_event==2'b00)-> (rx_active==1'b0);(rx_error==1'b0);( host_disconnect==1'b0);
                       (rx_event==2'b01)->(rx_active==1'b1);(rx_error==1'b0);(host_disconnect==1'b0);
                       (rx_event==2'b11)->(rx_active==1'b1);(rx_error==1'b1);(host_disconnect==1'b0);
                       (rx_event==2'b10)->(rx_active==1'bx);(rx_error==1'bx);(host_disconnect==1'b1); }

  ////////////////////////////////////////////////////////////////////////////////
  // method's name       : new
  // Description         : This is a constructor for tvs_usb2_device_sequence_item class. 
  ////////////////////////////////////////////////////////////////////////////////
  function new (string name = "tvs_ulpi_device_rx_cmd" );
    super.new(name);
    `tvs_debug("TVS_ULPI_RX_CMD", $psprintf("Building the TVS_ULPI_RX_CMD Sequence Item\n"))
  endfunction : new

  ////////////////////////////////////////////////////////////////////////////////
  // method's name       : frm2item
  // Description         :  
  ////////////////////////////////////////////////////////////////////////////////
  function void frm2item(tvs_ulpi_device_rx_cmd item);
  begin
    super.frm2item(item);
    cmd_decode();
  end
  endfunction : frm2item
  ///////////////////////////////////////////////////////////////////////////////
  // method's name       : cmd_decode
  // Description         :  
  ////////////////////////////////////////////////////////////////////////////////
  function void cmd_decode();
  begin
    alt_int   =data[7];
    id        =data[6];
    rx_event  =data[5:4];
    vbus_state=data[3:2];
    linestate =data[1:0];
  
    if(vbus_state==2'b00) begin
      sess_end   =1'b1;
      sess_valid =1'b0;
      vbus_valid =1'b0;
    end//if
    else if(vbus_state==2'b01) begin
      sess_end  =1'b0;
      sess_valid=1'b0;
      vbus_valid=1'b0;
    end//else if
    else if(vbus_state==2'b10) begin 
      sess_end  =1'bx;
      sess_valid=1'b1;
      vbus_valid=1'b0;
    end//else if
    else if(vbus_state==2'b11) begin
      sess_end  =1'bx;
      sess_valid=1'bx;
      vbus_valid=1'b1;
    end//else if

    if(rx_event==2'b00) begin
      rx_active      =1'b0;
      rx_error       =1'b0;
      host_disconnect=1'b0;
    end//if
    else if(rx_event==2'b01) begin
      rx_active      =1'b1;
      rx_error       =1'b0;
      host_disconnect=1'b0;
    end//else if
    else if(rx_event==2'b11) begin
      rx_active      =1'b1;
      rx_error       =1'b1;
      host_disconnect=1'b0;
    end//else if
    else if(rx_event==2'b10) begin
      rx_active=1'bx;
      rx_error=1'bx;
      host_disconnect=1'b1; 
    end
    
    `tvs_info("TVS_ULPI_RX_CMD",$psprintf("TVS_ULPI_RX_CMD : 0x%0h",data))
    if(linestate==2'b00)
      `tvs_info("TVS_ULPI_RX_CMD",$psprintf("Linestate is SE0 state"))
    else if(linestate==2'b01)
      `tvs_info("TVS_ULPI_RX_CMD",$psprintf("Linestate is  J state"))
    else if(linestate==2'b10)
      `tvs_info("TVS_ULPI_RX_CMD",$psprintf("Linestate is K state"))
    else if(linestate==2'b11)
      `tvs_info("TVS_ULPI_RX_CMD",$psprintf("Linestate is SE1 state"))
    if(vbus_state==2'b00 || vbus_state==2'b01 || vbus_state==2'b11 || vbus_state==2'b01)
     `tvs_info("TVS_ULPI_RX_CMD",$psprintf("when vbus_state : 0x%0h sess_end=0x%0h sess_valid=0x%0h vbus_valid=0x%0h",vbus_state,sess_end,sess_valid,vbus_valid))
    if(rx_event==2'b00 || rx_event==2'b01 || rx_event==2'b11 || rx_event==2'b11 || rx_event==2'b10)
     `tvs_info("TVS_ULPI_RX_CMD",$psprintf(" when rx_event :0x %0h rx_active=0x%0h rx_error=0x%0h host_disconnect=0x%h",rx_event,rx_active,rx_error,host_disconnect))
    if(id==1'b1)
     `tvs_info("TVS_ULPI_RX_CMD",$psprintf("ID:set to the value of idgnd"))
    if(alt_int==1'b1)
     `tvs_info("TVS_ULPI_RX_CMD",$psprintf(" Alt_int: Unmasked interrupt event occured"))
  end  
  endfunction : cmd_decode

endclass : tvs_ulpi_device_rx_cmd
////////////////////////////////////////////////////
//typedef class
typedef class tvs_ulpi_device_func_cntrl_reg;
typedef class tvs_ulpi_device_otg_cntrl_reg;
typedef class tvs_ulpi_device_int_cntrl_reg;
///////////// Base seq_item ////////////////////////
class tvs_ulpi_device_reg extends tvs_usb2_device_sequence_item;
 
  //Register Addres   
  rand bit [5:0]addr;
  //Link transmit data
  rand bit [7:0]data;
  //enum variable to indicate write/set/clear
  ctrl_e ctrl;
  //Handle declaration for functional control register 
  tvs_ulpi_device_func_cntrl_reg func_cntrl;
  //Handle declaration for otg control register
  tvs_ulpi_device_otg_cntrl_reg otg_cntrl;
  //Handle declaration for usb interrupt rise register
  tvs_ulpi_device_int_cntrl_reg ulpi_int_rise;
  //Handle declaration for usb interrupt fall register
  tvs_ulpi_device_int_cntrl_reg ulpi_int_fall;
  //Handle declaration for usb interrupt status register
  tvs_ulpi_device_int_cntrl_reg ulpi_int_status;
  //Handle declaration for usb interrupt latch register
  tvs_ulpi_device_int_cntrl_reg ulpi_int_latch;
  
  `uvm_object_utils_begin(tvs_ulpi_device_reg)
    `uvm_field_int(addr,UVM_ALL_ON) 
    `uvm_field_int(data,UVM_ALL_ON) 
    `uvm_field_enum(ctrl_e,ctrl,UVM_ALL_ON)
  `uvm_object_utils_end
  ////////////////////////////////////////////////////////////////////////////////
  // method's name       : new
  // Description         : This is a constructor for tvs_usb2_device_sequence_item class. 
  ////////////////////////////////////////////////////////////////////////////////
  function new (string name = "tvs_ulpi_device_reg" );
    super.new(name);
    `tvs_debug("TVS_ULPI_DEVICE_REG", $psprintf("Building the ULPI Reg base Sequence Item\n"))
  endfunction : new
  ////////////////////////////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////////////////////////////
  // method's name       : reg_update
  // Description         :  
  ////////////////////////////////////////////////////////////////////////////////
  virtual function void reg_update();
  endfunction: reg_update

  function ulpi_reg_update(tvs_ulpi_device_reg item);
  begin
    addr=item.addr;
    data=item.data;
    
    if(addr == 'h4 || addr == 'h5 || addr == 'h6) begin
      func_cntrl=tvs_ulpi_device_func_cntrl_reg::type_id::create("func_cntrl");
      func_cntrl.addr = this.addr;
      func_cntrl.data = this.data; 
      func_cntrl.reg_update();
      speed=device_speed_e'(func_cntrl.xcvr_select);
      `tvs_info( get_name(), func_cntrl.convert2string()) 
    end//if
    if(addr == 'hA || addr == 'hB || addr == 'hC) begin
      otg_cntrl=tvs_ulpi_device_otg_cntrl_reg::type_id::create("otg_cntrl");
      otg_cntrl.addr = this.addr;
      otg_cntrl.data = this.data;
      otg_cntrl.reg_update();
      `tvs_info( get_name(), otg_cntrl.convert2string())
    end//if
    if(addr == 'hD || addr == 'hE || addr == 'hF) begin
      ulpi_int_rise=tvs_ulpi_device_int_cntrl_reg::type_id::create("ulpi_int_rise");
      ulpi_int_rise.addr = this.addr;
      ulpi_int_rise.data = this.data;
      ulpi_int_rise.reg_update();
      `tvs_info( get_name(), ulpi_int_rise.convert2string())
    end//if
    if(addr == 'h10 || addr == 'h11 || addr == 'h12) begin
      ulpi_int_fall=tvs_ulpi_device_int_cntrl_reg::type_id::create("ulpi_int_fall");
      ulpi_int_fall.addr = this.addr;
      ulpi_int_fall.data = this.data;
      ulpi_int_fall.reg_update();
      `tvs_info( get_name(), ulpi_int_fall.convert2string())
    end//if
    if(addr == 'h13) begin
      ulpi_int_status=tvs_ulpi_device_int_cntrl_reg::type_id::create("ulpi_int_status");
      ulpi_int_status.addr = this.addr;
      ulpi_int_status.data = this.data;
      ulpi_int_status.reg_update();
      `tvs_info( get_name(), ulpi_int_status.convert2string())
    end//if
    if(addr == 'h14) begin
      ulpi_int_latch=tvs_ulpi_device_int_cntrl_reg::type_id::create("ulpi_int_latch");
      ulpi_int_latch.addr = this.addr;
      ulpi_int_latch.data = this.data;
      ulpi_int_latch.reg_update();
      `tvs_info( get_name(), ulpi_int_latch.convert2string())
    end//if

  end   
  endfunction : ulpi_reg_update

endclass :tvs_ulpi_device_reg

/////////////////////////////////////////////////////////////////////////////////
///////////////////////////  Function control register //////////////////////////
/////////////////////////////////////////////////////////////////////////////////
class tvs_ulpi_device_func_cntrl_reg extends tvs_ulpi_device_reg;
  
  //Selects the required transceiver speed
  rand bit [1:0]xcvr_select;
  //Controls the internal pull-up resistor HS termination
  rand bit termselect;
  //Selects the required bit encoding style during transmit
  rand bit [1:0]opmode;
  //Active high transceiver reset
  rand bit reset;
  //Active low PHY suspend
  rand bit suspendm;
  //Reserved
  rand bit rsvd;
 
  //factory registaration
  `uvm_object_utils_begin(tvs_ulpi_device_func_cntrl_reg)
   `uvm_field_int(xcvr_select,UVM_ALL_ON)
   `uvm_field_int(termselect,UVM_ALL_ON)
   `uvm_field_int(reset,UVM_ALL_ON)
   `uvm_field_int(opmode,UVM_ALL_ON)
   `uvm_field_int(suspendm,UVM_ALL_ON)
   `uvm_field_int(rsvd,UVM_ALL_ON)
  `uvm_object_utils_end

  //Constraints
  constraint func_ctrl_reg_con { (addr=='h4) -> (ctrl==write); (addr=='h5)-> (ctrl==set); (addr=='h6)->(ctrl==clear);}
  ////////////////////////////////////////////////////////////////////////////////
  // method's name       : new
  // Description         : This is a constructor for tvs_usb2_device_sequence_item class. 
  ////////////////////////////////////////////////////////////////////////////////
  function new (string name = "tvs_ulpi_device_func_cntrl_reg" );
    super.new(name);
    `tvs_info("TVS_ULPI_DEVICE_FUNC_CTRL_REG", $psprintf("Building the func ctrl Reg  Sequence Item\n"))
  endfunction : new
  ////////////////////////////////////////////////////////////////////////////////

  /*==================================================================================\
  | Method Name : covert2string                                                         |
  | Description :                                                                     |
  \=================================================================================*/
   virtual function string convert2string();
     string s  = super.convert2string();
     s = { s, $psprintf( "\nname : %s addr : 0x%0h ctrl : %s xcvr_select : 0x%0h termselect : 0x%0h reset : 0x%0h opmode : 0x%0h suspendm : 0x%0h rsvd :0x%0h", get_name(),addr,ctrl.name(),xcvr_select,termselect,reset,opmode,suspendm,rsvd ) };
     return s;
  endfunction : convert2string
  ////////////////////////////////////////////////////////////////////////////////
  // method's name       : reg_update
  // Description         :  
  ////////////////////////////////////////////////////////////////////////////////
  virtual function void reg_update();
  begin
   if(addr=='h4)
     ctrl=write;
   else if(addr=='h5)
     ctrl=set;
   else 
     ctrl=clear;

   if(ctrl==write||set)
    begin
     rsvd       =data[7];
     suspendm   =data[6];
     reset      =data[5];
     opmode     =data[4:3];
     termselect =data[2];
     xcvr_select=data[1:0];
    end
  if(ctrl==clear)
   begin
    rsvd       =1'b0;
    suspendm   =1'b0;
    reset      =1'b0;
    opmode     =2'b0;
    termselect =1'b0;
    xcvr_select=2'b0;
   end
   
   speed=device_speed_e'(xcvr_select); //Assign value to speed
   
     
  end

  endfunction :reg_update

endclass :tvs_ulpi_device_func_cntrl_reg


/////////////////////////////////////////////////////////////////////////////////
///////////////////////////  OTG Control register  //////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
class tvs_ulpi_device_otg_cntrl_reg extends tvs_ulpi_device_reg;

  //Connects a pull-up to the ID line
  rand bit idpullup;
  //Enables the 15k Ohm pull-down resistor on D+
  rand bit dppulldown;
  //Enables the 15k Ohm pull-down resistor on D-
  rand bit dmpulldown;
  //Discharge V BUS through a resistor
  rand bit dischrgvbus;
  //Charge V BUS through a resistor
  rand bit chrgvbus; 
  //Signals the internal charge pump
  rand bit drvvbus;
  //Selects between the internal and the external 5V Vbus supply
  rand bit drvvbus_extr;
  //Tells the PHY to use an external V BUS over-current indicator
  rand bit use_extr_vbusindictr;
 

  //factory registaration
  `uvm_object_utils_begin(tvs_ulpi_device_otg_cntrl_reg)
   `uvm_field_int(idpullup,UVM_ALL_ON)
   `uvm_field_int(dppulldown,UVM_ALL_ON)
   `uvm_field_int(dmpulldown,UVM_ALL_ON)
   `uvm_field_int(dischrgvbus,UVM_ALL_ON)
   `uvm_field_int(chrgvbus,UVM_ALL_ON)
   `uvm_field_int(drvvbus,UVM_ALL_ON)
   `uvm_field_int(drvvbus_extr,UVM_ALL_ON)
   `uvm_field_int(use_extr_vbusindictr,UVM_ALL_ON)
  `uvm_object_utils_end

  ////////////////////////////////////////////////////////////////////////////////
  // method's name       : new
  // Description         : This is a constructor for tvs_usb2_device_sequence_item class. 
  ////////////////////////////////////////////////////////////////////////////////
  function new (string name = "tvs_ulpi_device_otg_cntrl_reg" );
     super.new(name);
    `tvs_info("TVS_ULPI_DEVICE_OTG_CTRL_REG", $psprintf("Building the tvs otg ctrl Reg  Sequence Item\n"))
  endfunction : new
  ////////////////////////////////////////////////////////////////////////////////

   ////////////////////////////////////////////////////////////////////////////////
   // method's name       :convert2string
   // Description         : 
   ////////////////////////////////////////////////////////////////////////////////
   virtual function string convert2string();
     string s  = super.convert2string();
     s = { s, $psprintf( "\nname : %s addr : 0x%0h ctrl : %s idpullup :0x%0h dppulldown : 0x%0h dmpulldown : 0x%0h dischrgvbus : 0x%0h chrgvbus :0x%0h drvvbus :0x%0h drvvbus_extr :0x%0h use_extr_vbusindicatr : 0x%0h ", get_name(),addr,ctrl.name(),idpullup,dppulldown,dmpulldown,dischrgvbus,chrgvbus,drvvbus,drvvbus_extr,use_extr_vbusindictr ) };
     return s;
  endfunction : convert2string

  ////////////////////////////////////////////////////////////////////////////////
  // method's name       : reg_update
  // Description         :  
  ////////////////////////////////////////////////////////////////////////////////
  virtual function void reg_update();
  begin
    if(addr=='hA)
     ctrl=write;
   else if(addr=='hB)
     ctrl=set;
   else
     ctrl=clear;
   if(ctrl==write||set) begin
     use_extr_vbusindictr=data[7];
     drvvbus_extr        =data[6];
     drvvbus             =data[5];
     chrgvbus            =data[4];
     dischrgvbus         =data[3];
     dmpulldown          =data[2];
     dppulldown          =data[1];
     idpullup            =data[0];
   end//if
   if(ctrl==clear) begin
     use_extr_vbusindictr=1'b0;
     drvvbus_extr        =1'b0;
     drvvbus             =1'b0;
     chrgvbus            =1'b0;
     dischrgvbus         =1'b0;
     dmpulldown          =1'b0;
     dppulldown          =1'b0;
     idpullup            =1'b0;
   end//if
  end
  endfunction :reg_update

endclass : tvs_ulpi_device_otg_cntrl_reg

/////////////////////////////////////////////////////////////////////////////////
///////////////////////////  USB Interrupt control register//////////////////////
/////////////////////////////////////////////////////////////////////////////////
class tvs_ulpi_device_int_cntrl_reg extends tvs_ulpi_device_reg;

  //field declaration
  //Generate an interrupt event notification when Hostdisconnect change
  rand bit hostdisconnect_int;
  //Generate an interrupt event notification when VbusValid change
  rand bit vbusvalid_int;
  //Generate an interrupt event notification when SessValid change
  rand bit sessvalid_int;
  //Generate an interrupt event notification when SessEnd change
  rand bit sessend_int;
  //Generate an interrupt event notification when IdGnd change
  rand bit idgnd_int;
  //Reserved 
  rand bit[2:0]rsvd;
  //enum variable to indicate ulpi interrupt rise/fall/status/latch register 
  int_type_e int_type;

  //factory registaration
  `uvm_object_utils_begin(tvs_ulpi_device_int_cntrl_reg)
   `uvm_field_int(hostdisconnect_int,UVM_ALL_ON)
   `uvm_field_int(vbusvalid_int,UVM_ALL_ON)
   `uvm_field_int(sessvalid_int,UVM_ALL_ON)
   `uvm_field_int(sessend_int,UVM_ALL_ON)
   `uvm_field_int(idgnd_int,UVM_ALL_ON)
   `uvm_field_int(rsvd,UVM_ALL_ON)
  `uvm_object_utils_end

  ////////////////////////////////////////////////////////////////////////////////
  // method's name       : new
  // Description         : This is a constructor for tvs_usb2_device_sequence_item class. 
  ////////////////////////////////////////////////////////////////////////////////
  function new (string name = "tvs_ulpi_device_int_cntrl_reg" );
     super.new(name);
    `tvs_debug("TVS_ULPI_DEVICE_INT_CTRL_REG", $psprintf("Building the tvs ulpi int ctrl Reg  Sequence Item\n"))
  endfunction : new
  ////////////////////////////////////////////////////////////////////////////////
 
   ////////////////////////////////////////////////////////////////////////////////
   // method's name       :convert2string
   // Description         : 
   ////////////////////////////////////////////////////////////////////////////////
   virtual function string convert2string();
     string s  = super.convert2string();
     s = { s, $psprintf( "\nname : %s addr : 0x%0h ctrl : %s hostdisconnect_int :0x%0h vbusvalid_int : 0x%0h sessvalid_int : 0x%0h sessend_int : 0x%0h idgnd_int :0x%0h rsvd :0x0h ", get_name(),addr,ctrl.name(),hostdisconnect_int,vbusvalid_int,sessvalid_int,sessend_int,idgnd_int,rsvd ) };
     return s;
  endfunction : convert2string

  ////////////////////////////////////////////////////////////////////////////////
  // method's name       : reg_update
  // Description         :  
  ////////////////////////////////////////////////////////////////////////////////
  virtual function void reg_update();
  begin
    if(addr == 'hD || addr == 'hE || addr == 'hF)
     int_type=rise;
    else if(addr =='h10 || addr == 'h11 || addr == 'h12)
     int_type=fall;
    else if(addr == 'h13)
     int_type=status;
    else
     int_type=latch;

    if(addr=='hD || addr=='h10)
     ctrl=write;
    else if(addr=='hE || addr=='h11)
     ctrl=set;
    else if(addr=='hF || addr=='h12)
     ctrl=clear;

    if((int_type==rise || int_type==fall) && (ctrl==write || ctrl==set) ) begin
      rsvd              =data[7:5];
      idgnd_int         =data[4];
      sessend_int       =data[3];
      sessvalid_int     =data[2];
      vbusvalid_int     =data[1];
      hostdisconnect_int=data[0];
    end//if
    else if((int_type==rise || int_type==fall) && (ctrl==clear)) begin
      rsvd              =3'b0;
      idgnd_int         =1'b0;
      sessend_int       =1'b0;
      sessvalid_int     =1'b0;
      vbusvalid_int     =1'b0;
      hostdisconnect_int=1'b0;
    end//else if 
  end
  endfunction : reg_update

endclass : tvs_ulpi_device_int_cntrl_reg   
                                           
/////////////////////////////////////////////////////////////////////////////////
///////////////////////////  TVS token packet ///////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
class tvs_usb_device_token_pkt extends tvs_usb2_device_sequence_item; 

  //Processor Identifier
  rand bit[7:0] pid;
  //Device Address
  rand bit[6:0] addr;
  //Used to indicate end point
  rand bit[3:0] endp;
  //Used to check CRC
  rand bit[4:0] crc;
  //Link received data
  rand bit[7:0] tkn_data_queue[];
  //Used to store CRC input
  bit [15:0]data_in;
  //Output CRC
  bit [4:0]crc_out;
  //Temperory register used for crc calculation
  bit [4:0] lfsr_q,lfsr_c;
  //Enum variable to indicate token type
  token_type_e token_type;

  bit set_default; 
  //factory registaration
  `uvm_object_utils_begin(tvs_usb_device_token_pkt)
   `uvm_field_int(pid,UVM_ALL_ON)
   `uvm_field_int(addr,UVM_ALL_ON)
   `uvm_field_int(endp,UVM_ALL_ON)
   `uvm_field_int(crc,UVM_ALL_ON)
  `uvm_object_utils_end

  ////////////////////////////////////////////////////////////////////////////////
  // method's name       : new
  // Description         : This is a constructor for tvs_usb2_device_sequence_item class. 
  ////////////////////////////////////////////////////////////////////////////////
  function new (string name = "tvs_usb_device_token_pkt" );
     super.new(name);
    `tvs_info("TVS_USB_DEVICE_TOKEN_PKT", $psprintf("Building the tvs usb token packet  Sequence Item\n"))
  endfunction

  ////////////////////////////////////////////////////////////////////////////////
  // method's name       : frm2item
  // Description         : This is a constructor for tvs_usb2_device_sequence_item class. 
  ////////////////////////////////////////////////////////////////////////////////
  function void frm2item(tvs_usb_device_token_pkt item);
  begin
    tkn_data_queue = new[tkn_data_queue.size()+1](tkn_data_queue);
    tkn_data_queue[tkn_data_queue.size()-1] = item.data;
    pid=tkn_data_queue[0];
    token_type = token_type_e'(pid[3:0]);
    if(tkn_data_queue.size()==1)
      `tvs_info("TVS_USB_OUT_TOKEN", $psprintf("Link receives PID=>%s",token_type.name()))
    if(tkn_data_queue.size()==3) 
      if(pid[3:0] == TVS_OUT_TOKEN || pid[3:0] == TVS_IN_TOKEN || pid[3:0] == TVS_SETUP_TOKEN)begin
        addr=tkn_data_queue[1][6:0];
        endp={tkn_data_queue[2][2:0],tkn_data_queue[1][7]};
        crc =tkn_data_queue[2][7:3];
        `tvs_info("TVS_USB_ADDR", $psprintf("Link receives Address: %h ",addr))
        `tvs_info("TVS_USB_ENDP", $psprintf("Link receives Endp: %h ",endp))
        `tvs_info("TVS_USB_CRC", $psprintf("Link receives CRC: %h ",crc))
        crc_5();
      end//if
   
  end//if
  endfunction : frm2item
   
  function void crc_5();
  begin
    data_in={addr[0],addr[1],addr[2],addr[3],addr[4],addr[5],addr[6],endp[0],endp[1],endp[2],endp[3],crc[0],crc[1],crc[2],crc[3],crc[4]};//
   
    if(set_default==1'b0)
     lfsr_q='1;
   else
     lfsr_q=lfsr_c;

   set_default=1;

    lfsr_c[0] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ data_in[0] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13];
    lfsr_c[1] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ data_in[1] ^ data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14];
    lfsr_c[2] = lfsr_q[3] ^ lfsr_q[4] ^ data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[14] ^ data_in[15];
    lfsr_c[3] = lfsr_q[0] ^ lfsr_q[4] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[15];
    lfsr_c[4] = lfsr_q[0] ^ lfsr_q[1] ^ data_in[2] ^ data_in[4] ^ data_in[5] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12];
      
    lfsr_q =lfsr_c;
    `tvs_info("TVS_USB_CRC5", $psprintf("Link CRC_OUT: %h ",lfsr_q))
    
    if(lfsr_q != 'h0c)
     `tvs_error("TVS_USB_CRC5_ERR", $psprintf("Expected CRC residual value 'h0C Received value %h",lfsr_q))
  end  
  endfunction : crc_5


endclass : tvs_usb_device_token_pkt

/////////////////////////////////////////////////////////////////////////////////
///////////////////////////  TVS Data packet ///////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
class tvs_usb_device_data_pkt extends tvs_usb2_device_sequence_item;

  //field declaration
  rand bit[7:0]  pid;
  rand bit[7:0]  data;
  rand bit[15:0] crc;
  rand bit[7:0]  data_queue[];
  //set default used to set initial value to lfsr_q
  bit set_default;
  reg [15:0] lfsr_q,lfsr_c;
  bit [15:0] data_in;
  //j used to indicate position of data_queue
  int j;

  //enum variable for data packet type
  data_pkt_type_e data_pkt_type;
  
  //factory registaration
  `uvm_object_utils_begin(tvs_usb_device_data_pkt)
   `uvm_field_int(pid,UVM_ALL_ON)
   `uvm_field_int(data,UVM_ALL_ON)
   `uvm_field_int(crc,UVM_ALL_ON)
  `uvm_object_utils_end

  ////////////////////////////////////////////////////////////////////////////////
  // method's name       : new
  // Description         : This is a constructor for tvs_usb2_device_sequence_item class. 
  ////////////////////////////////////////////////////////////////////////////////
  function new (string name = "tvs_usb_device_data_pkt" );
    super.new(name);
    `tvs_info("TVS_USB_DATA_PKT", $psprintf("Building the TVS USB Data packet  Sequence Item\n"))
  endfunction

  ////////////////////////////////////////////////////////////////////////////////
  // method's name       :frm2item 
  // Description         : 
  ////////////////////////////////////////////////////////////////////////////////
  function void frm2item(tvs_usb_device_data_pkt item);
  begin
    data_queue=new[data_queue.size()+1] (data_queue);
    data_queue[data_queue.size()-1]=item.data;     
    pid=data_queue[0];
    data_pkt_type = data_pkt_type_e'(pid[3:0]);
    if(data_queue.size() == 1)  
      `tvs_info("TVS_USB_DATA_PKT", $psprintf("Link receives PID=>%s",data_pkt_type.name()))
    else if(data_queue.size()>1)
      `tvs_info("TVS_USB_DATA_PKT", $psprintf("Link receives Data %h",item.data))
    if(data_queue.size() > 3) begin
      crc[15:8]=data_queue[data_queue.size()-1];
      crc[7:0] =data_queue[data_queue.size()-2];
      `tvs_info("TVS_USB_CRC16", $psprintf("Link receives CRC  %h",crc))
    end//if
  end
  endfunction : frm2item
   
   ////////////////////////////////////////////////////////////////////////////////
   // method's name       :crc_16 
   // Description         : 
   ////////////////////////////////////////////////////////////////////////////////
   function void crc_16(tvs_usb_device_data_pkt item);
   begin
     j=1;  //initialize j value as 1

     if(set_default==1'b0)
       lfsr_q='1;
     else
       lfsr_q=lfsr_c;

     set_default=1;
      
     for(int i=0;i<(data_queue.size()-1)/2;i++) begin
       data_in={data_queue[j][0],data_queue[j][1],data_queue[j][2],data_queue[j][3],data_queue[j][4],data_queue[j][5],data_queue[j][6],data_queue[j][7],data_queue[j+1][0],data_queue[j+1][1],data_queue[j+1][2],data_queue[j+1][3],data_queue[j+1][4],data_queue[j+1][5],data_queue[j+1][6],data_queue[j+1][7]};
             
       lfsr_c[0]   = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[15];
       lfsr_c[1]  = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14];
       lfsr_c[2]  = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[14] ^ data_in[0] ^ data_in[1] ^ data_in[14];
       lfsr_c[3]  = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[15] ^ data_in[1] ^ data_in[2] ^ data_in[15];
       lfsr_c[4]  = lfsr_q[2] ^ lfsr_q[3] ^ data_in[2] ^ data_in[3];
       lfsr_c[5]  = lfsr_q[3] ^ lfsr_q[4] ^ data_in[3] ^ data_in[4];
       lfsr_c[6]  = lfsr_q[4] ^ lfsr_q[5] ^ data_in[4] ^ data_in[5];
       lfsr_c[7]  = lfsr_q[5] ^ lfsr_q[6] ^ data_in[5] ^ data_in[6];
       lfsr_c[8]  = lfsr_q[6] ^ lfsr_q[7] ^ data_in[6] ^ data_in[7];
       lfsr_c[9]  = lfsr_q[7] ^ lfsr_q[8] ^ data_in[7] ^ data_in[8];
       lfsr_c[10] = lfsr_q[8] ^ lfsr_q[9] ^ data_in[8] ^ data_in[9];
       lfsr_c[11] = lfsr_q[9] ^ lfsr_q[10] ^ data_in[9] ^ data_in[10];
       lfsr_c[12] = lfsr_q[10] ^ lfsr_q[11] ^ data_in[10] ^ data_in[11];
       lfsr_c[13] = lfsr_q[11] ^ lfsr_q[12] ^ data_in[11] ^ data_in[12];
       lfsr_c[14] = lfsr_q[12] ^ lfsr_q[13] ^ data_in[12] ^ data_in[13];
       lfsr_c[15] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[14] ^ data_in[15];
            
       lfsr_q =lfsr_c;
       `tvs_info("TVS_USB_CRC16", $psprintf("Residual CRC: %h ",lfsr_q))
       j=j+2; //increment j count 2           

     end//for
     if(lfsr_q != 'h800d)
       `tvs_error("TVS_USB_CRC16_ERR", $psprintf("Expected CRC residual value 'h800d Received value %0h",lfsr_q))
  end
  endfunction : crc_16
endclass : tvs_usb_device_data_pkt
                                                                     
`endif // TVS_USB2_DEVICE_SEQUENCE_ITEM_SVH
