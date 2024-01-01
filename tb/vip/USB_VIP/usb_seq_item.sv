import uvm_pkg::*;
`include "uvm_macros.svh"
//`include "usb_declarations.sv"
class usb_packet extends uvm_sequence_item;
  
   //control information
  //PID
  bit [3:0]A_PID;        //ACK/NAK/STALL/DATA0/DATA1
  bit [7:0]PID;          //PID+INVERSE PID
  
  //----Data fields-----
  //data content
  //rand bit [7:0]data;    //for randomizing data
  rand bit[(D_size-1):0]data;
  
  //CRC
  //bit [(W_size-1):0]Data_crc; //To pass the data portion to CRC generation
  bit [15:0]CRC16;       //CRC
 
  //Configuration information
  
  bit [63:0]device_descriptor_8b;   //8 bytes of get descriptor
  bit [143:0]device_descriptor_18b; //18 bytes of get descriptor
  bit [71:0]config_descriptor_9b;   //9 bytes of configuration descriptor
  bit [311:0]config_descriptor_39b; //39 bytes of configuration along with it's interface and endpoint descriptors
    
  bit [(b_size-1):0]Packet_1; //Whole packet(PID,DATA,CRC)
  byte Packet[P_size];
  bit [2:0]sel_crc;
  
//Factory registeration
  `uvm_object_utils_begin(usb_packet) //utility macro
  `uvm_field_int(PID,UVM_ALL_ON)      //field macros
  `uvm_field_int(A_PID,UVM_ALL_ON)
  `uvm_field_int(data,UVM_ALL_ON)
  `uvm_field_int(Packet_1,UVM_ALL_ON)
  `uvm_field_sarray_int(Packet,UVM_ALL_ON)
  `uvm_field_int(sel_crc,UVM_ALL_ON) 
  `uvm_field_int(CRC16,UVM_ALL_ON)
  `uvm_field_int(device_descriptor_8b,UVM_ALL_ON)
  `uvm_field_int(config_descriptor_9b,UVM_ALL_ON)
  `uvm_field_int(device_descriptor_18b,UVM_ALL_ON)
  `uvm_field_int(config_descriptor_39b,UVM_ALL_ON)
  `uvm_object_utils_end 

    
  //New constructor
  function new(string name="usb_packet");
    super.new(name);
  endfunction
  
//Constraint for PID
   constraint pid{
     PID =={A_PID,(~A_PID)};
                  }

  //Constraint for CRC
  constraint data_crc {if (sel_crc==3'b001)
                         CRC16 == crc(device_descriptor_8b);
                       else if (sel_crc==3'b010)
                         CRC16 == crc(device_descriptor_18b);
                       else if (sel_crc==3'b011)
                         CRC16 == crc(config_descriptor_9b);
                       else if (sel_crc==3'b100)
                         CRC16 == crc(config_descriptor_39b);
                       else
                              CRC16 == crc(data);
                      };
  
 
  //function for CRC
  function bit [15:0]crc(input bit [(D_size-1):0]data_f);
    
    bit [15:0]zero=16'b0000000000000000;
    bit [f_size:0]frame={data_f,zero};             
    bit [16:0]divisor=17'b11000000000000101;                
  
    reg[16:0]temp;                      
    int num = (f_size-16); 
  

    temp = frame[f_size:(f_size-16)]; 
    num = (f_size-16); 
      
      while(num>=0)
        begin
      temp=temp^divisor;
        
          while(temp[16]==0)           
        begin

          if(num==0)
            begin
              num=num-1;
              break;
            end

            temp=temp<<1;              //shift operation
          temp[0]=frame[(num=num-1)];  //bringing down the bits
          end
        end
       crc = temp;

  endfunction
  
  //Constraint for device descriptor and configuration descriptor
  
  //***********EP0-ROM IF****************
  
  task mem(output bit [63:0]device_descriptor_8b,output bit [143:0]device_descriptor_18b,output bit [71:0]config_descriptor_9b,output bit [311:0]config_descriptor_39b);
  reg [7:0] ROM [depth-1:0];
    
  //***********Device descriptor************
  
  ROM[0]=8'h12; //length of the device descriptor-18 bytes
  ROM[1]=8'h01; //Identificaion of device descriptor(0x01)
  ROM[2]=8'h02; //2 bytes of USB specification number(USB 2.0-0x0200)
  ROM[3]=8'h00; //2 bytes of USB specification number(USB 2.0-0x0200)
  ROM[4]=8'h00; //Device class code
  ROM[5]=8'h00; //device sub class
  ROM[6]=8'h00; //device protocol
  ROM[7]=8'h40; //Maximum packet size for EP0-64 bytes
  ROM[8]=8'h00; //vendor ID
  ROM[9]=8'h00; //vendor ID
  ROM[10]=8'h00; //product ID
  ROM[11]=8'h00; //Product ID
  ROM[12]=8'h02; //Device release number(BCD-0x0200)
  ROM[13]=8'h00; //Device release number
  ROM[14]=8'h00; //index of manufacturer string descriptor
  ROM[15]=8'h00; //index of product string descriptor
  ROM[16]=8'h00; //index of serial number string descriptor
  ROM[17]=8'h01; //number of possible configurations the device supports at its current speed
  
  //***********configuration decsriptor***********
  
  ROM[18]=8'h09; //size of configuration descriptor (9 bytes)
  ROM[19]=8'h02; //Configuration descriptor
  ROM[20]=8'h00; //Total length(no of bytes)in the hierarchy including interface and Ep descriptor 
  ROM[21]=8'h29; //second byte of total length
  ROM[22]=8'h01; //number of interfaces
  ROM[23]=8'h01; //configuration value-value to use as an argument to select this configuration 
  ROM[24]=8'h00; //index of string descriptor describing this configuration
  ROM[25]=8'h80; //Attributes-bus powered(10000000)
  ROM[26]=8'h02; //maximum power the device will drain from the bus-2mA
  
  //**************interface descriptor**************
  
  ROM[27]=8'h09; //size of interface descriptor(9 bytes)
  ROM[28]=8'h04; //interface descriptor
  ROM[29]=8'h00; //interface number-indicates the index of the interface descriptor starts with zero
  ROM[30]=8'h00; //alternative interface setting
  ROM[31]=8'h03; //Number of endpoints in this interface except EP0
  ROM[32]=8'h00; //interface class code
  ROM[33]=8'h00; //interface subclass code
  ROM[34]=8'h00; //interface protocol code
  ROM[35]=8'h00; //index of string descriptor for this interface
  
  //*************endpoint descriptor for EP1************
  
  ROM[36]=8'h07; //size of endpoint descriptor(7 bytes)
  ROM[37]=8'h05; //endpoint descriptor(0x05)
  ROM[38]=8'h01; //endpoint address(EP1)
  ROM[39]=8'h02; //transfer type-bulk
  ROM[40]=8'h00; //maximum payload size(64 bytes)
  ROM[41]=8'h40; //maximum payload size
  ROM[42]=8'h00; //polling interval(ignored for bulk)
  
  //*************endpoint descriptor for EP2************
  
  ROM[43]=8'h07; //size of endpoint descriptor(7 bytes)
  ROM[44]=8'h05; //endpoint descriptor(0x05)
  ROM[45]=8'h02; //endpoint address(EP2)
  ROM[46]=8'h01; //transfer type-isochronous
  ROM[47]=8'h00; //maximum payload size(64 bytes)
  ROM[48]=8'h40; //maximum payload size
  ROM[49]=8'h01; //polling interval(1 frame-1 ms)
  
  //*************endpoint descriptor for EP3************
  
  ROM[50]=8'h07; //size of endpoint descriptor(7 bytes)
  ROM[51]=8'h05; //endpoint descriptor(0x05)
  ROM[52]=8'h03; //endpoint address(EP3)
  ROM[53]=8'h03; //transfer type-interrupt
  ROM[54]=8'h00; //maximum payload size(64 bytes)-0x0040
  ROM[55]=8'h40; //maximum payload size
  ROM[56]=8'h04; //polling interval(4 frame-4 ms)

  
 
  //device descriptor_8b
    for(int i=0;i<8;i++)
    begin
     
      device_descriptor_8b={ROM[0],ROM[1],ROM[2],ROM[3],ROM[4],ROM[5],ROM[6],ROM[7]};
    
    end
    
    //device descriptor_18b
  for(int i=0;i<18;i++)
    begin
     
      device_descriptor_18b={ROM[0],ROM[1],ROM[2],ROM[3],ROM[4],ROM[5],ROM[6],ROM[7],ROM[8],ROM[9],ROM[10],ROM[11],ROM[12],ROM[13],ROM[14],ROM[15],ROM[16],ROM[17]};
    
    end
    
  //configuration descriptor_9b
  for(int i=0,j=18;i<9;i++,j++)
    
    begin
      config_descriptor_9b={ROM[18],ROM[19],ROM[20],ROM[21],ROM[22],ROM[23],ROM[24],ROM[25],ROM[26]};
    end
    
    //configuration descriptor_39b
  for(int i=0,j=18;i<39;i++,j++)
    
    begin
      config_descriptor_39b={ROM[18],ROM[19],ROM[20],ROM[21],ROM[22],ROM[23],ROM[24],ROM[25],ROM[26],ROM[27],ROM[28],ROM[29],ROM[30],ROM[31],ROM[32],ROM[33],ROM[34],ROM[35],ROM[36],ROM[37],ROM[38],ROM[39],ROM[40],ROM[41],ROM[42],ROM[43],ROM[44],ROM[45],ROM[46],ROM[47],ROM[48],ROM[49],ROM[50],ROM[51],ROM[52],ROM[53],ROM[54],ROM[55],ROM[56]};
    end
   
  
   endtask
  
endclass


