`ifndef ENV_SV
`define ENV_SV

//compiler directive to include contents of the following file 
`include "interface.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "globals.sv"
import globals::*;

//environment is another abstract testbench layer that encapsulates components within an controlled environment that can be reconfigured for better flexibility & validation
//parameterized environment to be instantiated for different classes ex: testcases
//class environment #(type T=transactionIn);
class environment #(type T=transactionAdd); //for debugging monitor

    //testbench component instances
    generator #(T) gen;
    driver drv;
    monitor mon;

    //mailbox handle's
    mailbox gen2driv;
    mailbox mon2scb;

    //virtual declaration allows datatype to be a ptr; used to connect actual DUT
    virtual intf vif;

    //constructor; each time class is init, requires following parameters
    function new (virtual intf vif);
        //get interface from testbench
        this.vif = vif;

        //mailbox to be shared across testbench
        gen2driv=new();
        mon2scb=new();
        
        //init components
        gen=new(gen2driv);
        drv=new(vif,gen2driv);
        mon=new(vif,mon2scb);

    endfunction


/*===================================
===============tasks===============
===================================*/

    //unlike funcs, task can return multiple outputs based on its given inputs
    
    task pre_test();
        $display("\n\n===============================================================");
        $display("%0d : Environment : beginning of pre-verification stage", $time);
        $display("===============================================================\n\n");
        $display("\n\n===============================================================");
        $display("%0d : Environment : end of pre-verification stage", $time);
        $display("===============================================================\n\n");
    endtask
    
    task test();
        $display("\n\n===============================================================");
        $display("%0d : Environment : starting verification stage", $time);
        $display("===============================================================\n\n");
        //fork join creates parallel threads; join waits for all parallel threads to finish
        fork
            gen.main();
            drv.main();
            mon.main();
        //join
        join_any      //!!! sim will get stuck using "join" from driver's "forever begin"
        //@(gen.end_gen); //syntax to wait for event trigger; edge-sensitive trigger
        wait(gen.end_gen.triggered);    //level sensitive trigger; is event triggered RIGHT NOW?
        //@(vif.cb_driv);
        //$root.testbench.rstDUT;
        //@(vif.cb_driv);
        //$root.testbench.endRst;
        wait(drv.end_driv.triggered);
        wait(mon.end_mon.triggered);
        $display("\n\n===============================================================");
        $display("%0d : Environment : end of verification stage", $time);
        $display("===============================================================\n\n");
    endtask
    
    task post_test();
        $display("\n\n===============================================================");
        $display("%0d : Environment : beginning post-verification stage", $time);
        $display("===============================================================\n\n");
        $display("\n\n===============================================================");
        $display("%0d : Environment : end of post-verification stage", $time);
        $display("===============================================================\n\n");
    endtask

    task run();
        reset();
        pre_test();
        test();
        post_test();
        //SV task to end cur sim
        $finish;
    endtask

    task reset();
        $root.testbench.rstDUT();
        @(vif.cb_driv);
        //wait for vif.reset to be asserted
        wait(vif.reset);
        $display("[%0d | ENV] ----- Reset asserted ----- ",$time);
        //non-blocking assignment
        vif.a_in <= 0;
        vif.b_in <= 0;
        //vif.op_in <= 0; //uncomment for now, see what opcode resets to
        @(vif.cb_driv);
        $root.testbench.endRst();
        wait(!vif.reset); //wait for deassertion
        $display("[%0d | ENV] ----- Reset deasserted ----- ",$time);
    endtask


endclass

`endif
