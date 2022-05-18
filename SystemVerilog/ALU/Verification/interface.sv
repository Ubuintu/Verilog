`ifndef INTERFACE_SV
`define INTERFACE_SV
//compiler directive

//interface is a SV datatype that encapsulates signals; intfs can implement many SV functionality such as tasks, coverage, etc
interface intf(input logic clk, reset); //intf takes clk & rst from TB

//-------------------------------------------------
// Signals from TB to DUT; logic is a SV datatype that can support 4 states
//-------------------------------------------------
    logic [7:0] a_in, b_in, y_out;
    logic [3:0] op_in;
    logic co_out;   //CarryOver output

//-------------------------------------------------
//Clocking blocks describe the timing of signals to keep them synchronous with the DUT & testbench
//-------------------------------------------------
    clocking cb_driv @ (posedge clk);
        //timing for signals from DRV to DUT
        /*
        Default clock skew for inputs & outputs is "#1 <units>" & "#0 <units>" respectively
        Delay input as much as possible to avoid race conditions ex: setup-time, clk-to-q prop, etc
        Drive output ASAP after time event ex: @ (posedge clk)
        */
        output a_in, b_in, op_in, reset;
    endclocking

    clocking cb_mon @ (posedge clk);
        //default clock skew
        input y_out, co_out;
    endclocking

//-------------------------------------------------
//modports describe the mapping of signals from the testbench to the design
//modports can take clocking blocks as input thus the timing can be described with the mapping of each signal
//-------------------------------------------------
    modport M_DRV (clocking cb_driv);

    //no need to make a cb for DUT since driv & mon already have timing specified
    modport M_DUT (input clk, reset, a_in, b_in, op_in, output y_out, co_out);

    modport M_MON (clocking cb_mon);

endinterface

`endif
