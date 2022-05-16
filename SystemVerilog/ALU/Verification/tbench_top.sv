`ifndef TBTOP_SV
`define TBTOP_SV

//compiler directive that specifies units for simulation & precision
`timescale 1ns/1ns

//compiler directive to include contents of the following file 
`include "interface.sv"
`include "testbench.sv"
`include "dut_top.sv"

//top module instanties tb components such as the program, the DUT, & interface
module tbench_top #( parameter PERIOD=10 );
    //signal declaration
    bit clk, reset;

    //clk gen
    initial  
        clk=0;
        
    always #(PERIOD/2) clk=~clk;

    //rst gen
    initial begin
        reset=1;
        #(PERIOD) reset=0;
    end

    //Instantiate testbench's components
    intf dut_intf (.*);     //.name port connection
    testbench tb(dut_intf); //interface handle is passed as a parameter
    dut_top dut(dut_intf);

    //enable wave dump
    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
    end

endmodule



`endif
