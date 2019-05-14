// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Fri May 10 20:50:43 2019
// Host        : Arthur-Desk running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               w:/PCR/RoboMovel/RoboMovel.srcs/sources_1/ip/Memory_Xul/Memory_Xul_stub.v
// Design      : Memory_Xul
// Purpose     : Stub declaration of top-level module interface
// Device      : xa7a35tcpg236-1I
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_2,Vivado 2018.3" *)
module Memory_Xul(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[6:0],douta[26:0]" */;
  input clka;
  input [6:0]addra;
  output [26:0]douta;
endmodule
