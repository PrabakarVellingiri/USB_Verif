//Sequences for Handshake stage
//`include "usb_seq_item.sv" 

// Reset seq
/*class reset_seq extends uvm_sequence#(usb_packet);
  `uvm_object_utils(reset_seq)
  
  function new(string name="reset_seq");
    super.new(name);
  endfunction
  
  task body();
  #1ms
  endtask 

endclass*/
   
// ACK HANDSHAKE
class ack_sts_seq extends uvm_sequence#(usb_packet);
  `uvm_object_utils(ack_sts_seq)
  
  function new(string name="ack_sts_seq");
    super.new(name);
  endfunction
  
  task body();
        
    req = usb_packet::type_id::create("req"); //creating handle for sequence item
     
         start_item(req);
	     req.A_PID  = `ACK;  //4'b0010
         req.Packet[0] =req.PID; //8'b0010 1101
     	 finish_item(req);
  endtask
  
endclass

//NAK HANDSHAKE

class nak_sts_seq extends uvm_sequence#(usb_packet);
  `uvm_object_utils(nak_sts_seq)
  
  function new(string name="nak_sts_seq");
    super.new(name);
  endfunction
  
  task body();
         req = usb_packet::type_id::create("req");
     
         start_item(req);
	     req.A_PID  = `NAK; //1010
         req.Packet[0]  =req.PID; //1010 0101
     	 finish_item(req);       
  endtask
  
endclass
  
//STALL HANDSHAKE


class stall_sts_seq extends uvm_sequence#(usb_packet);
  `uvm_object_utils(nak_sts_seq)
  
  function new(string name="stall_sts_seq");
    super.new(name);
  endfunction
  
  task body();
    
    req = usb_packet::type_id::create("req"); 
     
         start_item(req);
	     req.A_PID  = `STALL; //1110
         req.Packet[0]  =req.PID; //1110 0001
     	 finish_item(req);         
  endtask
  
endclass

//Sequences for Data stage

//Zero length data packet with DATA1 PID

class zero_length_data1_seq extends uvm_sequence#(usb_packet);
  `uvm_object_utils(zero_length_data1_seq)
  
  function new(string name="zero_length_data1_seq");
    super.new(name);
  endfunction
  
  task body();
         req = usb_packet::type_id::create("req");
     
         start_item(req);
	 req.A_PID   = `DATA1; //1011
         req.Packet_1  = {req.PID,16'b0000000000000000}; //1011 0100
         for (int i=0;i<P_size;i++)
         begin
            req.Packet[i]=req.Packet_1[8*i+:8];
         end 
     	 finish_item(req);       
  endtask
  
endclass

//Bulk Transfer

class bulk_data_seq extends uvm_sequence#(usb_packet);
  `uvm_object_utils(bulk_data_seq)
  
  function new(string name="bulk_data_seq");
    super.new(name);
  endfunction
  
  task body();
      
         req = usb_packet::type_id::create("req");
     
         start_item(req);
         req.sel_crc=3'b000;
	 req.A_PID=`DATA0; //0011
         req.randomize();
         req.Packet_1={req.PID,req.data,req.CRC16};
         for (int i=0;i<P_size;i++)
          begin
             req.Packet[i]=req.Packet_1[8*i+:8];
          end
     	 finish_item(req);
  endtask
  
endclass

//Control Transfer for device descriptor_8b

class control_dev_data_8b_seq extends uvm_sequence#(usb_packet);
  `uvm_object_utils(control_dev_data_8b_seq)
  
  function new(string name="control_dev_data_8b_seq");
    super.new(name);
  endfunction
  
  task body();
         //parameter int W_size=dev_size;
         
         req = usb_packet::type_id::create("req");
     
         start_item(req);
         req.sel_crc=3'b001;
	 req.A_PID=`DATA1;
         req.Packet_1={req.PID,req.device_descriptor_8b,req.CRC16};
         for (int i=0;i<P_size;i++)
          begin
             req.Packet[i]=req.Packet_1[8*i+:8];
          end
     	 finish_item(req);
  endtask
endclass
  
  class control_dev_data_18b_seq extends uvm_sequence#(usb_packet);
    `uvm_object_utils(control_dev_data_18b_seq)
  
    function new(string name="control_dev_data_18b_seq");
    super.new(name);
  endfunction
  
  task body();
         //parameter int W_size=dev_size;
         
         req = usb_packet::type_id::create("req");
     
         start_item(req);
         req.sel_crc=3'b010;
	 req.A_PID=`DATA1;
         req.Packet_1={req.PID,req.device_descriptor_18b,req.CRC16};
         for (int i=0;i<P_size;i++)
          begin
              req.Packet[i]=req.Packet_1[8*i+:8];
          end
     	 finish_item(req);
  endtask
  
endclass

//control transfer for configuration descriptor

class control_config_data_9b_seq extends uvm_sequence#(usb_packet);
  `uvm_object_utils(control_config_data_9b_seq)
  
  function new(string name="control_config_data_9b_seq");
    super.new(name);
  endfunction
  
  task body();
         //parameter int W_size=config_size;
         
         req = usb_packet::type_id::create("req");
     
         start_item(req);
         req.sel_crc=3'b011;
	 req.A_PID=`DATA1;
         req.Packet_1={req.PID,req.config_descriptor_9b,req.CRC16};
         for (int i=0;i<P_size;i++)
         begin
            req.Packet[i]=req.Packet_1[8*i+:8];
         end
     	 finish_item(req);
  endtask
endclass
  
  class control_config_data_39b_seq extends uvm_sequence#(usb_packet);
    `uvm_object_utils(control_config_data_39b_seq)
  
    function new(string name="control_config_data_39b_seq");
    super.new(name);
  endfunction
  
  task body();
         //parameter int W_size=config_size;
         
         req = usb_packet::type_id::create("req");
     
         start_item(req);
         req.sel_crc=3'b100;
	 req.A_PID=`DATA1;
         req.Packet_1={req.PID,req.config_descriptor_39b,req.CRC16};
         for (int i=0;i<P_size;i++)
          begin
             req.Packet[i]=req.Packet_1[8*i+:8];
          end
         finish_item(req);
  endtask
endclass


//Interrupt Transfer

class interrupt_data_seq extends uvm_sequence#(usb_packet);
  `uvm_object_utils(interrupt_data_seq)
  
  function new(string name="interrupt_data_seq");
    super.new(name);
  endfunction
  
  task body();
      
         req = usb_packet::type_id::create("req");
     
         start_item(req);
         req.sel_crc=3'b000;
	 req.A_PID=`DATA0; //0011
         req.randomize();
         req.Packet_1={req.PID,req.data,req.CRC16};
         for (int i=0;i<P_size;i++)
          begin
             req.Packet[i]=req.Packet_1[8*i+:8];
          end
     	 finish_item(req);
  
  endtask
  
endclass

//Isochronous Transfer

class isoch_data_seq extends uvm_sequence#(usb_packet);
  `uvm_object_utils(isoch_data_seq)
  
  function new(string name="isoch_data_seq");
    super.new(name);
  endfunction
  
 task body();
      
         req = usb_packet::type_id::create("req");
     
         start_item(req);
         req.sel_crc=3'b000;
	 req.A_PID=`DATA0; //0011
         req.randomize();
         req.Packet_1={req.PID,req.data,req.CRC16};
         for (int i=0;i<P_size;i++)
          begin
              req.Packet[i]=req.Packet_1[8*i+:8];
          end
     	 finish_item(req);
  
  endtask
  
  
  
endclass



