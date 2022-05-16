`ifndef TB
`define TB
//compiler directive; tells compiler to include code IF macro, "TB", is not defined

//Dynamic datatype; the reactive region is one of the last phases before sim advances, by then all design element (module)  statements have been executed and testbench will have the newest values;
//To avoid race conditions with the design, the program executes DURING the reactive region of the simulation cycle
program testbench(intf dut_intf);   //for simple DUTS, one inteface is good enough for encapsulation

initial begin
    $display("===========================================================================================");
    $display("===================================== Start of test =======================================");
    $display("===========================================================================================");
end

initial begin
    $display("===========================================================================================");
    $display("====================================== End of test ========================================");
    $display("===========================================================================================");
end

endprogram
`endif
