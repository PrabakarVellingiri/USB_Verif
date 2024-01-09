//`define ifn1 vif.driv_cb1	//Define interface path
//`define ifn2 vif.driv_cb2
`include "uvm_macros.svh"
import uvm_pkg::*;
class usb_driver extends uvm_driver#(usb_packet);
  `uvm_component_utils(usb_driver)
  virtual utmi_interf vif;
  bit flag;
  bit [7:0] sie_data[$];		// Queue to send data to sie block
  bit [7:0] data0_q[$];			// Queue to send data for data0 pid
  bit [7:0] data1_q[$];			// Queue to send data for data1 pid
  bit [7:0] out_q[$];			// Queue to send data for out pid
  bit [7:0] setup_q[$];			// Queue to send data for setup pid
//  bit [7:0] 
  bit [7:0] pid;
  bit [3:0] token_pid;
  bit [7:0] ep_fifo[4][$];		//Array of queue to mimic endpoint fifos
 // bit 
  bit [7:0] crc_q[$];					// Setup data reg
  reg [7:0]  bmRequestType;
  reg [7:0]  bRequest;
  reg [15:0] wValue;
  reg [15:0] wIndex;
  reg [15:0] wLength;
					//address 
  reg [6:0] device_add;
  reg [3:0] ep_no;			//Ep_number

  function new (string name ="driver", uvm_component parent);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!(uvm_config_db #(virtual utmi_interf )::get(this,"","u_vif",vif)))
      `uvm_error("driver",$sformatf("virtual interface error"))
  endfunction

 // extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task drive();
  extern task sie();
  extern task setup_data(bit [7:0] setup_q[$]);
  extern task addr_info(bit[7:0] out_q[$]);
  extern task data_to_mem(bit[7:0] data_q[$]);
  extern function bit[15:0] crc16_check(bit[7:0] crc_q[$]);
  extern function bit[5:0] crc5_check(bit[7:0] crc_q[$]);
endclass
    
      task usb_driver::run_phase(uvm_phase phase);
        forever begin
          #5;
          if (vif.RXActive) begin
            if(vif.RXValid & (!vif.RXError)) begin		// No error & is valid,  sample data 
              @(posedge vif.clk_480mhz)
              sie_data.push_back(vif.DataOut);
           end
          end

          if(vif.RXActive==0 && vif.RXValid==0)begin
	   sie(); 

          seq_item_port.get_next_item(req);
          drive();					// drive if sequence available
          seq_item_port.item_done();
	 
        end
end
      endtask:run_phase
    
    
//Drive task    
    task usb_driver:: drive(); 
           vif.TXValid<=1;
      if(vif.TXReady) begin				//drive
             for(int i=0;i< $size(req.Packet);i++) begin
               @(posedge vif.clk_60mhz)
                vif.DataIn<=req.Packet[i];
             end
           end
     endtask:drive
    
task usb_driver:: sie();
	bit [7:0]dis;
							//(striping pid)
	pid=sie_data.pop_front();
	if(pid[1:0] == 2'b01) 
          token_pid=pid[3:0];

 	if(!(pid[3:0] & pid[7:4])) begin		//if no pid error

	case(pid[3:0])								//processing based on pid
	4'b0011: begin	
		while(sie_data.size!=0)
		   data0_q.push_back(sie_data.pop_front());
		crc_q=data0_q;
		if(crc16_check(crc_q)) begin			//check crc 
		  dis=data0_q.pop_back();
		  dis=data0_q.pop_back();
		  if(token_pid== 4'b1101)			//if it is token packet is setup treat data as setup data else send data to mem 
		  setup_data(data0_q);
		  else if(token_pid==4'b0001)
		  data_to_mem(data0_q);
		end
 		end
	4'b1011: begin
	        while(sie_data.size!=0)
		 data1_q.push_back(sie_data.pop_front());
		crc_q=data1_q;
		if(crc16_check(crc_q)) begin			//check crc 			
		  dis=data0_q.pop_back();
		  dis=data0_q.pop_back();
		  if(token_pid== 4'b1101)			//if it is token packet is setup treat data as setup data else send data to mem 
		  setup_data(data0_q);
		  else if(token_pid==4'b0001)
		  data_to_mem(data0_q);
		end
		end
	4'b0001: begin
	while(sie_data.size!=0)
		   out_q.push_back(sie_data.pop_front());
		crc_q=out_q;
		if(crc5_check(crc_q)) begin			//check crc 
		 addr_info(out_q);				//get endpoint and device address
		end
		 end
	4'b1101: begin
	         while(sie_data.size!=0)
		   setup_q.push_back(sie_data.pop_front());
		crc_q=setup_q;
		if(crc5_check(crc_q)) begin			//check crc 
		  addr_info(setup_q);				//get endpoint and device address
		end
		 end
	endcase
	end

      endtask:sie

      task usb_driver::setup_data(bit [7:0]   setup_q[$]) ;
	 begin	//parsing the setup packet data to the setup fields
	if(setup_q.size!=0) begin
	
        bmRequestType=setup_q.pop_front();
        bRequest=setup_q.pop_front();
	wValue[15:8]=setup_q.pop_front();
	wValue[7:0]=setup_q.pop_front();
	wIndex[15:8]=setup_q.pop_front();
	wIndex[7:0]=setup_q.pop_front();
	wLength[15:8]=setup_q.pop_front();
	wLength[7:0]=setup_q.pop_front();
	end
	end
      endtask:setup_data

      task usb_driver:: addr_info(bit[7:0] out_q[$]); 		//parsing the out packet data to the address fields
        if(out_q.size!=0) begin
	 bit [7:0] temp_setup=out_q.pop_front();
	   device_add=temp_setup[6:0];
	   ep_no[3]=temp_setup[7];
	    temp_setup=out_q.pop_front();
	   ep_no[2:0]=temp_setup[7:5];
	 end
	
       endtask:addr_info

	task usb_driver:: data_to_mem(bit[7:0] data_q[$]); 
	while(data_q.size!=0) begin
	ep_fifo[ep_no].push_back(data_q.pop_front()); 	//push data to queue based on endpoint number 
	end
	endtask:data_to_mem

function bit[5:0] usb_driver:: crc5_check(bit[7:0] crc_q[$]); 	begin	// check crc 
  reg [5:0] generator=6'b100101;
  reg [7:0] hold;
  reg [7:0] frame;
  int res;
  
  res=0;
  hold=crc_q.pop_front();
  frame=crc_q.pop_front();
  while(res<11)begin
    $display("hold %b",hold[7:2]);
    hold[7:2]=hold[7:2]^generator;
    $display("gene %b",generator);
    while(hold[7]==0 && (res<11)) begin
      hold=hold<<1;
      hold[0]=frame[7];
      frame=frame<<1;
      res=res+1;
    end
  end
  if(hold==0)						//return 1 if remainder is 0 else 1
    crc5_check=1;
  else
    crc5_check=0;
end
endfunction:crc5_check
    

function bit[15:0] usb_driver:: crc16_check(bit[7:0] crc_q[$]); begin
  bit[23:0] div;
  int s_count;
  bit [16:0] gen;
  bit [16:0] hold;
  bit[7:0] shift_hold;
  
    s_count=0;
    gen=17'b11000000000000101;
   
    div={crc_q.pop_front(),crc_q.pop_front(),crc_q.pop_front()};
    shift_hold=crc_q.pop_front();

    while(crc_q.size()!=0) begin
      hold=div[23:7]^gen;
      div[23:7]=hold;
        while (div[23]==0) begin
        div=div<<1;
        div[0]=shift_hold[7];
        shift_hold=shift_hold<<1;
        s_count=s_count+1;
        if(s_count==7) begin
          shift_hold=crc_q.pop_front();
          s_count=0;
        end
        end
         crc16_check=div[23:8];
    end
  end
endfunction:crc16_check

