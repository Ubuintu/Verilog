`ifndef TB_SV
`define TB_SV
//compiler directive; tells compiler to include code IF macro, "TB", is not defined

//compiler directive to include contents of the following file 
`include "interface.sv"
`include "testbench.sv"
`include "dut_top.sv"
`include "environment.sv"
`include "globals.sv"

//import <scope_resolution_oper> <scope>; "*" specifies to use all items inside
import globals::*;

//top module instanties tb components such as the program, the DUT, & interface
//!!THIS MODULE IS CME435 TBENCH_TOP!!
module testbench #( parameter PERIOD=10 );
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

    //verify base class
    //test_transactionIn_class tbb();

    //Instantiate testbench's components
    intf dut_intf (.*);     //.name port connection
    test_prog tb(dut_intf); //interface handle is passed as a parameter
    dut_top dut(dut_intf);
    

    //enable wave dump
    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
    end

endmodule

//Dynamic datatype; the reactive region is one of the last phases before sim advances, by then all design element (module)  statements have been executed and testbench will have the newest values;
//To avoid race conditions with the design, the program executes DURING the reactive region of the simulation cycle
program test_prog(intf dut_intf);   //for simple DUTS, one inteface is good enough for encapsulation
//!!THIS MODULE IS CME435 TESTBENCH!!

initial begin

    //declaring environment instance
    environment env;

    //initialize environment instance
    env = new(dut_intf);

    //initialize counter for repeating rand inputs
    env.gen.rpt_cnt = 5;

    //enable/disable debug mode
    env.gen.debug=debug;

    $display("===========================================================================================");
    $display("===================================== Start of verification =======================================");
    $display("===========================================================================================\n\n");

    //calling environment run() method
    env.run();
end

final begin
    $display("\n\n===========================================================================================");
    $display("====================================== End of verification ========================================");
    $display("===========================================================================================");
end

endprogram

program test_transactionIn_class;

//transactionIn trans;
transactionMult trans;  //verify enum works

initial begin
    trans=new();
    repeat(10) begin
        trans.randomize();
        trans.display("[Testing Transaction class]");
    end
    $finish;
end

endprogram

`endif
