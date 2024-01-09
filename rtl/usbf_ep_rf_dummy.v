`include "usbf_defines.v"

// Endpoint register File
module usbf_ep_rf_dummy(
		clk, wclk, rst,

		// Wishbone Interface
		adr, re, we, din, dout, inta, intb,
		dma_req, dma_ack,

		// Internal Interface

		idin,
		ep_sel, ep_match,
		buf0_rl, buf0_set, buf1_set,
		uc_bsel_set, uc_dpd_set,

		int_buf1_set, int_buf0_set, int_upid_set,
		int_crc16_set, int_to_set, int_seqerr_set,
		out_to_small,

		csr, buf0, buf1, dma_in_buf_sz1, dma_out_buf_avail
		);

input		clk, wclk, rst;
input	[1:0]	adr;
input		re;
input		we;
input	[31:0]	din;
output	[31:0]	dout;
output		inta, intb;
output		dma_req;
input		dma_ack;

input	[31:0]	idin;		// Data Input
input	[3:0]	ep_sel;		// Endpoint Number Input
output		ep_match;	// Asserted to indicate a ep no is matched
input		buf0_rl;	// Reload Buf 0 with original values

input		buf0_set;	// Write to buf 0
input		buf1_set;	// Write to buf 1
input		uc_bsel_set;	// Write to the uc_bsel field
input		uc_dpd_set;	// Write to the uc_dpd field
input		int_buf1_set;	// Set buf1 full/empty interrupt
input		int_buf0_set;	// Set buf0 full/empty interrupt
input		int_upid_set;	// Set unsupported PID interrupt
input		int_crc16_set;	// Set CRC16 error interrupt
input		int_to_set;	// Set time out interrupt
input		int_seqerr_set;	// Set PID sequence error interrupt
input		out_to_small;	// OUT packet was to small for DMA operation

output	[31:0]	csr;		// Internal CSR Output
output	[31:0]	buf0;		// Internal Buf 0 Output
output	[31:0]	buf1;		// Internal Buf 1 Output
output		dma_in_buf_sz1;	// Indicates that the DMA IN buffer has 1 max_pl_sz
				// packet available
output		dma_out_buf_avail;// Indicates that there is space for at least
				// one MAX_PL_SZ packet in the buffer

///////////////////////////////////////////////////////////////////
//
// Internal Access
//

assign	dout = 32'h0;
assign	inta = 1'b0;
assign	intb = 1'b0;
assign	dma_req = 1'b0;
assign	ep_match = 1'b0;
assign	csr = 32'h0;
assign	buf0 = 32'hffff_ffff;
assign	buf1 = 32'hffff_ffff;
assign	dma_in_buf_sz1 = 1'b0;
assign	dma_out_buf_avail = 1'b0;

endmodule
