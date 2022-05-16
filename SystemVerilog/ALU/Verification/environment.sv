`ifndef ENV_SV
`define ENV_SV

//compiler directive to include contents of the following file 
`include "interface.sv"

//environment is another abstract testbench layer that encapsulates components within an controlled environment that can be reconfigured for better flexibility & validation
//parameterized environment to be instantiated for different classes ex: testcases
class environment #(type T=int);

    //virtual declaration allows datatype to be a ptr; used to connect actual DUT
    virtual intf vif;

    //constructor; each time class is init, requires following parameters
    function new (virtual intf vif);
        //get interface from testbench
        this.vif = vif;
    endfunction


    /*---------------tasks---------------*/
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
        pre_test();
        test();
        post_test();
        //SV task to end cur sim
        $finish;
    endtask






endclass

`endif
