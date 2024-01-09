package usb_core_package;
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/wishbone/wb_master_sequence_item.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/wishbone/wb_slave_sequence_item.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/wishbone/wb_master_sequence.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/wishbone/wb_slave_sequence.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/wishbone/wb_master_sequencer.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/wishbone/wb_slave_sequencer.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/wishbone/wb_master_driver.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/wishbone/wb_slave_driver.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/wishbone/wb_master_monitor.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/wishbone/wb_master_agent.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/wishbone/wb_slave_agent.sv"
//`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/wishbone/wb_scoreboard.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/wishbone/wb_environment.sv"
//`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/wishbone/wb_test.sv"

`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/USB_VIP/usb_declaration.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/USB_VIP/usb_seq_item.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/USB_VIP/usb_sequences.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/USB_VIP/usb_sequencer.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/USB_VIP/usb_driver.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/USB_VIP/usb_monitor.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/USB_VIP/usb_agent.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/USB_VIP/usb_arbiter.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/USB_VIP/usb_dma.sv"
//`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/USB_VIP/usb_scoreboard.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/USB_VIP/usb_environment.sv"
//`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/vip/USB_VIP/usb_test.sv"

`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/usb_core_virtual_sequencer.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/usb_core_scoreboard.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/usb_core_environment.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/usb_core_base_virtual_sequence.sv"
`include "/Projects/DV_Trainees_Batch2023/keerthana.madhusoodan/my_directory/protocols/USB/USB_Verif/tb/testfiles/usb_core_base_test.sv"


endpackage

