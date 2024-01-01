//Fixed Priority Arbiter for Endpoints
 import uvm_pkg::*;
`include "uvm_macros.svh"

class fixed_priority_arbiter extends uvm_component;
  		bit clk;
  		bit rst_n;
       
        	bit EP_0_REQ; //Control Transfer-EP0 -First priority -gnt:0001
  
  		bit EP_1_REQ; //Bulk Transfer-EP1 - Last Priority -gnt:0010
  
  		bit EP_2_REQ; //Interrupt Transfer-EP2 -Third Priority -gnt:0100
  
  		bit EP_3_REQ; //Ishochronous Transfer-EP3 -second Priority -gnt:1000
  		
  		bit dma_busy; //To check availability of DMA

  		reg [3:0] GNT; //Output
  
  //Utility and Field macros,
  	`uvm_component_utils_begin(fixed_priority_arbiter)
    	`uvm_field_int(clk,UVM_ALL_ON)
    	`uvm_field_int(rst_n,UVM_ALL_ON)
  	`uvm_field_int(EP_0_REQ,UVM_ALL_ON)
  	`uvm_field_int(EP_1_REQ,UVM_ALL_ON)
 	`uvm_field_int(EP_2_REQ,UVM_ALL_ON)
  	`uvm_field_int(EP_3_REQ,UVM_ALL_ON)
  	`uvm_field_int(dma_busy,UVM_ALL_ON)
  	`uvm_component_utils_end
 
  // constructor
 function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

task arbiter();

  forever @ (posedge clk or negedge rst_n) 
              
    begin
		
        if(!rst_n || dma_busy)

	    GNT <= 4'b0000;

        else if(EP_0_REQ)

            GNT <= 4'b0001;//GNT[0]==1

        else if(EP_3_REQ)

            GNT <= 4'b1000;//GNT[3]==1

        else if(EP_2_REQ)

            GNT <= 4'b0100;//GNT[2]==1

        else if(EP_1_REQ)

            GNT <= 4'b0010;//GNT[1]==1

        else

	    GNT <= 4'b0000;

	end
 endtask
endclass 

