`include "usbf_defines.v"
module usbf_utmi_if( // UTMI Interface (EXTERNAL)
		phy_clk, wclk, rst,
		DataOut, TxValid, TxReady,
		RxValid, RxActive, RxError, DataIn,
		XcvSelect, TermSel, SuspendM, LineState,
		OpMode, usb_vbus,
 
		// Internal Interface
		rx_data, rx_valid, rx_active, rx_err,
		tx_data, tx_valid, tx_valid_last, tx_ready,
		tx_first,
 
		// Misc Interfaces
		mode_hs, usb_reset, usb_suspend, usb_attached,
		resume_req, suspend_clr
		);
 
input		phy_clk; //480mhz
input		wclk; // 60mhz
input		rst;
 
output	[7:0]	DataOut;
output		TxValid;
input		TxReady;
 
input	[7:0]	DataIn;
input		RxValid;
input		RxActive;
input		RxError;
 
output		XcvSelect;
output		TermSel;
output		SuspendM;
input	[1:0]	LineState;
output	[1:0]	OpMode;
input		usb_vbus;
 
output	[7:0]	rx_data;
output		rx_valid, rx_active, rx_err;
input	[7:0]	tx_data;
input		tx_valid;
input		tx_valid_last;
output		tx_ready;
input		tx_first;
 
output		mode_hs;	// High Speed Mode
output		usb_reset;	// USB Reset
output		usb_suspend;	// USB Suspend
output		usb_attached;	// Attached to USB
input		resume_req;
 
output		suspend_clr;
 
 
///////////////////////////////////////////////////////////////////
//utmi interface 
//utmi_interf
//wires for serial connection of utmi (utmi to utmi (serial o/p to serial i/p)
wire dp;
wire dm;
///////////////////////////////////////////////////////////////////
 
///////////////////////////////////////////////////////////////////
//
// Local Wires and Registers
//
reg	[7:0]	rx_data;
reg		rx_valid, rx_active, rx_err;
reg	[7:0]	DataOut;
reg		tx_ready;
reg		TxValid;
wire		drive_k;
reg		drive_k_r;
 
///////////////////////////////////////////////////////////////////
//
// Misc Logic
//
 
 
///////////////////////////////////////////////////////////////////
//
// RX Interface Input registers
//
 
`ifdef USBF_ASYNC_RESET
always @(posedge phy_clk or negedge rst)
`else
always @(posedge phy_clk)
`endif
	if(!rst)	rx_valid <= 1'b0;
	else		rx_valid <= RxValid;
 
`ifdef USBF_ASYNC_RESET
always @(posedge phy_clk or negedge rst)
`else
always @(posedge phy_clk)
`endif
	if(!rst)	rx_active <= 1'b0;
	else		rx_active <= RxActive;
 
`ifdef USBF_ASYNC_RESET
always @(posedge phy_clk or negedge rst)
`else
always @(posedge phy_clk)
`endif
	if(!rst)	rx_err <= 1'b0;
	else		rx_err <= RxError;
 
always @(posedge phy_clk)
		rx_data <= DataIn;
 
///////////////////////////////////////////////////////////////////
//
// TX Interface Output/Input registers
//
 
always @(posedge phy_clk)
	if(TxReady || tx_first)	DataOut <= tx_data;
	else
	if(drive_k)		DataOut <= 8'h00;
 
always @(posedge phy_clk)
	tx_ready <= TxReady;
 
always @(posedge phy_clk)
	drive_k_r <= drive_k;
 
 
`ifdef USBF_ASYNC_RESET
always @(posedge phy_clk or negedge rst)
`else
always @(posedge phy_clk)
`endif
	if(!rst)	TxValid <= 1'b0;
	else
	TxValid <= tx_valid | drive_k | tx_valid_last | (TxValid & !(TxReady | drive_k_r));
 
 
///////////////////////////////////////////////////////////////////
//
// Line Status Signaling & Speed Negotiation Block
//
 
usbf_utmi_ls	u0(
		.clk(		phy_clk		),
		.rst(		rst		),
		.resume_req(	resume_req	),
		.rx_active(	rx_active	),
		.tx_ready(	tx_ready	),
		.drive_k(	drive_k		),
		.XcvSelect(	XcvSelect	),
		.TermSel(	TermSel		),
		.SuspendM(	SuspendM	),
		.LineState(	LineState	),
		.OpMode(	OpMode		),
		.usb_vbus(	usb_vbus	),
		.mode_hs(	mode_hs		),
		.usb_reset(	usb_reset	),
		.usb_suspend(	usb_suspend	),
		.usb_attached(	usb_attached	),
		.suspend_clr(	suspend_clr	)
		);
 
//module instantiation of utmi with two instances
  //utmi u1(.clk_480mhz(phy_clk), .clk_60mhz(wclk), .rst(rst), .data(DataIn), .data(Data_Out), .tx_Valid(TxValid), .data_p(dp), .data_m(dm));

 
 
endmodule
