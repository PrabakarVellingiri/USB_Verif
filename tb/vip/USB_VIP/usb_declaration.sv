//--------Token_Bit---------//

`define IN_PID 4'b1001

`define OUT_PID 4'b0001

`define STP_PID 4'b1101

`define SOF_PID 4'b0101

//---------Data_Bit----------//

`define DATA0 4'b0011

`define DATA1 4'b1011

//---------Handshake_Bit----------//

`define ACK 4'b0010

`define NAK 4'b1010

`define STALL 4'b1110

//parameters

  parameter int depth=64;         //size of EP0_ROM
  parameter int W_size=64;        //size of data in bytes 
  parameter int D_size=W_size*8;  //size of data in bits
  parameter int f_size=D_size+15; //size of frame for CRC 
  parameter int P_size=W_size+2; //size of whole packet
  parameter int b_size=P_size*8; //size of whole packet in bits

