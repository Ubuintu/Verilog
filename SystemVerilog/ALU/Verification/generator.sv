`ifndef GEN_SV
`define GEN_SV

`include "globals.sv"
import globals::*;

//parameterized for different constrained-randomized transactions
class generator #(type T = transactionIn);
    //generator properties
    int debug, rpt_cnt;
    int transNo=0;
    string msg ="[ Generator transaction: ";
    string cat;
    mailbox gen2driv;
    //events are static objects handles used to synchronize threads
    event end_gen;

    //constructor
    function new(mailbox gen2driv);
        this.gen2driv=gen2driv;
    endfunction

    //declare transaction class
    rand T transIn;

    //main task to create randomize stimulus
    task main();
        repeat(rpt_cnt) begin
            transIn = new();
            msg ="[ Generator transaction: ";
            cat.itoa(transNo);
            if(!transIn.randomize()) $fatal("Gen:: trans randomization failed");
            transIn.reset <= $root.testbench.reset;
            if(debug) begin
                msg={msg, cat, " ]"};
                transIn.display(msg);
            end
            gen2driv.put(transIn);
            transNo++;
        end
        
        //syntax for triggering event
        -> end_gen;

    endtask
        

endclass
    

`endif
