`timescale 1ns / 10ps

// Uncomment the lines below to get various levels of debugging
// verbosity ...
`define USBF_DEBUG
//`define USBF_VERBOSE_DEBUG

// Uncomment the line below to run the test bench
// Comment it out to use your own address parameters ...
`define USBF_TEST_IMPL

// For each endpoint that should actually be instantiated,
// set the below define value to a one. Uncomment the define
// statement for unused endpoints. The endpoints should be
// sequential, e.q. 1,2,3. I have not tested what happens if
// you select endpoints in a non sequential manner e.g. 1,4,6
// Actual (logical) endpoint IDs are set by the software. There
// is no correlation between the physical endpoint number (below)
// and the actual (logical) endpoint number.
`ifdef USBF_TEST_IMPL
		// Do not modify this section
		// this is to run the test bench
		`define	USBF_HAVE_EP1	1
		`define	USBF_HAVE_EP2	1
		`define	USBF_HAVE_EP3	1
`else
		// Modify this section to suit your implementation
		`define	USBF_HAVE_EP1	1
		`define	USBF_HAVE_EP2	1
		`define	USBF_HAVE_EP3	1
		//`define	USBF_HAVE_EP4	1
		//`define	USBF_HAVE_EP5	1
		//`define	USBF_HAVE_EP6	1
		//`define	USBF_HAVE_EP7	1
		//`define	USBF_HAVE_EP8	1
		//`define	USBF_HAVE_EP9	1
		//`define	USBF_HAVE_EP10	1
		//`define	USBF_HAVE_EP11	1
		//`define	USBF_HAVE_EP12	1
		//`define	USBF_HAVE_EP13	1
		//`define	USBF_HAVE_EP14	1
		//`define	USBF_HAVE_EP15	1
`endif


// Highest address line number that goes to the USB core
// Typically only A0 through A17 are needed, where A17
// selects between the internal buffer memory and the
// register file.
// Implementations may choose to have a more complex address
// decoding ....

`ifdef USBF_TEST_IMPL
		// Do not modify this section
		// this is to run the test bench
		`define USBF_UFC_HADR	17
		`define USBF_RF_SEL	(!wb_addr_i[17])
		`define USBF_MEM_SEL	(wb_addr_i[17])
		`define USBF_SSRAM_HADR	14
		//`define USBF_ASYNC_RESET

`else
		// Modify this section to suit your implementation
		`define USBF_UFC_HADR	12
		// Address Decoding for Register File select
		`define USBF_RF_SEL	(!wb_addr_i[12])
		// Address Decoding for Buffer Memory select
		`define USBF_MEM_SEL	(wb_addr_i[12])
		`define USBF_SSRAM_HADR	9
		// The next statement determines if reset is async or sync.
		// If the define is uncommented the reset will be ASYNC.
		//`define USBF_ASYNC_RESET
`endif


/////////////////////////////////////////////////////////////////////
//
// Items below this point should NOT be modified by the end user
// UNLESS you know exactly what you are doing !
// Modify at you own risk !!!
//
/////////////////////////////////////////////////////////////////////

// PID Encodings
`define USBF_T_PID_OUT		4'b0001
`define USBF_T_PID_IN		4'b1001
`define USBF_T_PID_SOF		4'b0101
`define USBF_T_PID_SETUP	4'b1101
`define USBF_T_PID_DATA0	4'b0011
`define USBF_T_PID_DATA1	4'b1011
`define USBF_T_PID_DATA2	4'b0111
`define USBF_T_PID_MDATA	4'b1111
`define USBF_T_PID_ACK		4'b0010
`define USBF_T_PID_NACK		4'b1010
`define USBF_T_PID_STALL	4'b1110
`define USBF_T_PID_NYET		4'b0110
`define USBF_T_PID_PRE		4'b1100
`define USBF_T_PID_ERR		4'b1100
`define USBF_T_PID_SPLIT	4'b1000
`define USBF_T_PID_PING		4'b0100
`define USBF_T_PID_RES		4'b0000

// The HMS_DEL is a constant for the "Half Micro Second"
// Clock pulse generator. This constant specifies how many
// Phy clocks there are between two hms_clock pulses. This
// constant plus 2 represents the actual delay.
// Example: For a 60 Mhz (16.667 nS period) Phy Clock, the
// delay must be 30 phy clocks: 500ns / 16.667nS = 30 clocks
`define USBF_HMS_DEL		5'h1c

// After sending Data in response to an IN token from host, the
// host must reply with an ack. The host has 622nS in Full Speed
// mode and 400nS in High Speed mode to reply. RX_ACK_TO_VAL_FS
// and RX_ACK_TO_VAL_HS are the numbers of UTMI clock cycles
// minus 2 for Full and High Speed modes.
`define USBF_RX_ACK_TO_VAL_FS	8'd36
`define USBF_RX_ACK_TO_VAL_HS	8'd22


// After sending an OUT token the host must send a data packet.
// The host has 622nS in Full Speed mode and 400nS in High Speed
// mode to send the data packet.
// TX_DATA_TO_VAL_FS and TX_DATA_TO_VAL_HS are is the numbers of
// UTMI clock cycles minus 2.
`define USBF_TX_DATA_TO_VAL_FS	8'd36
`define USBF_TX_DATA_TO_VAL_HS	8'd22


// --------------------------------------------------
// USB Line state & Speed Negotiation Time Values


// Prescaler Clear value.
// The prescaler generates a 0.25uS pulse, from a nominal PHY clock of
// 60 Mhz. 250nS/16.667ns=15. The prescaler has to be cleared every 15
// cycles. Due to the pipeline, subtract 2 from 15, resulting in 13 cycles.
// !!! This is the only place that needs to be changed if a PHY with different
// !!! clock output is used.
`define	USBF_T1_PS_250_NS	4'd13

// uS counter representation of 2.5uS (2.5/0.25=10)
`define	USBF_T1_C_2_5_US	8'd10

// uS counter clear value
// The uS counter counts the time in 0.25uS intervals. It also generates
// a count enable to the mS counter, every 62.5 uS.
// The clear value is 62.5uS/0.25uS=250 cycles.
`define USBF_T1_C_62_5_US	8'd250

// mS counter representation of 3.0mS (3.0/0.0625=48)
`define USBF_T1_C_3_0_MS	8'd48

// mS counter representation of 3.125mS (3.125/0.0625=50)
`define USBF_T1_C_3_125_MS	8'd50

// mS counter representation of 5mS (5/0.0625=80)
`define USBF_T1_C_5_MS		8'd80

// Multi purpose Counter Prescaler, generate 2.5 uS period
// 2500/16.667ns=150 (minus 2 for pipeline)
`define	USBF_T2_C_2_5_US	8'd148

// Generate 0.5mS period from the 2.5 uS clock
// 500/2.5 = 200
`define	USBF_T2_C_0_5_MS	8'd200

// Indicate when internal wakeup has completed
// me_cnt counts 0.5 mS intervals. E.g.: 5.0mS are (5/0.5) 10 ticks
// Must be 0 =< 10 mS
`define USBF_T2_C_WAKEUP	8'd10

// Indicate when 100uS have passed
// me_ps2 counts 2.5uS intervals. 100uS are (100/2.5) 40 ticks
`define USBF_T2_C_100_US	8'd40

// Indicate when 1.0 mS have passed
// me_cnt counts 0.5 mS intervals. 1.0mS are (1/0.5) 2 ticks
`define USBF_T2_C_1_0_MS	8'd2

// Indicate when 1.2 mS have passed
// me_cnt counts 0.5 mS intervals. 1.2mS are (1.2/0.5) 2 ticks
`define USBF_T2_C_1_2_MS	8'd2

// Indicate when 100 mS have passed
// me_cnt counts 0.5 mS intervals. 100mS are (100/0.5) 200 ticks
`define USBF_T2_C_100_MS	8'd200
