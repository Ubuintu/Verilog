`ifndef INTERFACE_SV
`define INTERFACE_SV
//compiler directive

//interface is a SV datatype that encapsulates signals; intfs can implement many SV functionality such as tasks, coverage, etc
interface intf(input logic clk, reset); //intf takes clk & rst from TB

//Signals from TB to DUT; logic is a SV datatype that can support 4 states
logic [7:0] a_in, b_in, y_out;
logic [3:0] op_in;
logic co_out;   //CarryOver output


endinterface

`endif
