`ifndef MON_SV
`define MON_SV

`include "globals.sv"
import globals::*;

class monitor;

    //driver properties
    int debug;
    int transNo=0;
    string msg ="[ Monitor transaction: ";
    string cat;
    event end_mon;

    //virtual intf handle
    virtual intf vif;
    //mailbox
    mailbox mon2scb;

    //constructor
    function new (virtual intf vif, mailbox mon2scb);
        this.vif = vif;
        this.mon2scb=mon2scb;
    endfunction

    task main();
        //Delay for 2 clock cycles for inital reset
      repeat(1) @(vif.cb_mon);

        forever begin
            transactionOut trans2scb;
            trans2scb=new();
            trans2scb.y_out<=vif.M_MON.y_out;
            trans2scb.co_out<=vif.M_MON.co_out;

            //send transaction to scb via mailbox
            mon2scb.put(trans2scb);

            cat.itoa(transNo);
            msg ="[ Monitor transaction: ";
            if(debug) begin
                msg={msg, cat, " ]"};
                @(vif.cb_mon);
                trans2scb.display(msg);
            end
            transNo++;

            if (transNo==repeat_counter)    //uses a blocking trigger
                -> end_mon;    
        end
    endtask
    
endclass

`endif
