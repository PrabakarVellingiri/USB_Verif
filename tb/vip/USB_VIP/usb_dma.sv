`include "uvm_macros.svh"

import uvm_pkg::*;


class dma extends uvm_component;
  
      parameter int data_width =8;

    bit clk;
    bit reset;
    bit wr_en;                              //write enable
    bit [7:0]dma_length;
    bit dma_grant;
    bit [1:0] ep_no;                       //End Point No. 
    bit [data_width-1:0] data_control;
    bit [data_width-1:0] data_bulk;
    bit [data_width-1:0] data_intr;
    bit [data_width-1:0] data_isoch;
  
    bit dma_done;
    bit dma_busy;

   reg [7:0]mem[255:0];                        //Memory
  
   int control=0;
   int bulk=64;
   int isoch=128;
   int intr=192;
   int i;

`uvm_component_utils(dma)
 
   // constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction

task dma ();

  //assign this.dma_busy = (this.dma_grant==1)?1:(this.dma_done==1)?0:1;
  if(dma_grant == 1)
    begin
      dma_busy=1;
    end
  else if(dma_grant == 0)
    begin
      if(dma_done == 1)
        dma_busy = 0;
      else if(dma_done == 0)
        dma_busy = 1;
    end

     
forever @(negedge reset)
  begin
    dma_busy =0;
    dma_done =0;
    for(i=0;i<256;i++)
      mem[i]=0;
  end
   
  forever @(posedge clk)
    begin
      if(wr_en)
        begin
          $display("%d",ep_no);
      case(ep_no)
        2'b00:
          begin
            dma_done=0;
            for(int i=0; i<dma_length;i++)    //Control Data
              begin
                mem[control]=data_control;
                //$display(data_control);
                $display("mem[%d]=%h",control,mem[control]);
                control=control+1;
              end
            //$display("%b",dma_busy);
           dma_done=1;
             //$display("%b",dma_busy);
            end
        
        2'b01:
          begin
            dma_done=0;
            for(int i=0; i<dma_length;i++)   //Bulk Data
              begin
                mem[bulk]=data_bulk;
                $display("mem[%d]=%h",bulk,mem[bulk]);
                bulk=(bulk+1);
        end
            dma_done=1;
          end
        
        2'b10:
          begin
            dma_done=0;
            for(int i=0; i<dma_length;i++)   //Isochronous Data
              begin
                mem[isoch]=data_isoch;
                $display("mem[%d]=%h",isoch,mem[isoch]);
                isoch=(isoch+1);
          end
            dma_done=1;
          end
        
        2'b11:
          begin
            dma_done=0;
            for(int i=0; i<dma_length;i++)   //Interrupt Data
              begin
                mem[intr]=data_intr;
                $display("mem[%d]=%h",intr,mem[intr]);
                intr=(intr+1);
          end
            dma_done=1;
          end
       
      endcase
       
        end
      else
        $display("READ");
end
endtask
endclass

