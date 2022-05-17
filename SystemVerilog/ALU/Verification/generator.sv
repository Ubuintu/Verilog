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

    //declare transaction class
    rand T transIn;

    //main task to create randomize stimulus
    task main();
        repeat(rpt_cnt) begin
            transIn = new();
            cat.itoa(transNo);
            if(!transIn.randomize()) $fatal("Gen:: trans randomization failed");
            if(debug) begin
                msg={msg, cat, " ]"};
                transIn.display(msg);
            end
            transNo++;
        end
    endtask
        

endclass
    

`endif
