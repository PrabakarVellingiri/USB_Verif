module ssram(clk, sram_adr_i, sram_data_o, sram_data_i, sram_re_i, sram_we_i);

//  parameter SSRAM_HADR   = 14 ;
  input clk;
  input[14:0] sram_adr_i;
  input[31:0] sram_data_i;
  input sram_re_i;
  input sram_we_i;
  output reg[31:0] sram_data_o;
// parameters for the width 

 
  reg [31:0] SRAM[0:32767];
  
  always@(posedge clk)
  begin
    //$display("*******************sram*******************");
    if(sram_we_i == 1'b1 && sram_re_i == 1'b0) 
      begin
        SRAM[sram_adr_i] = sram_data_i;
       // $display("*******************sram_addr_i = %0d",sram_adr_i);
       // $display("*******************sram = %0d",SRAM[sram_adr_i]);
      end
    
    else if (sram_re_i == 1'b1 && sram_we_i == 1'b0)
      begin
        sram_data_o = SRAM[sram_adr_i];
        //$display("*******************sram_adr_i = %0d",sram_adr_i);
        //$display("*******************sramo = %0d",SRAM[sram_adr_i]);
      end
    else 
      sram_data_o = 1'b0;
  end
endmodule

