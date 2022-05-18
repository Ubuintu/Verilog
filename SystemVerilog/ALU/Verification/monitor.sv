`ifndef MON_SV
`define MON_SV

`include "globals.sv"
import globals::*;

class monitor
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
        forever begin
            transactionOut trans2scb;
            trans2scb=new();
            trans2scb.y_out=vif.
        end
    endtask
    
endclass

`endif
