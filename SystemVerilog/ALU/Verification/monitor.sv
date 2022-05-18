`ifndef MON_SV
`define MON_SV

`include "globals.sv"
import globals::*;

class monitor
    //virtual intf handle
    virtual intf vif;
    //mailbox
    mailbox mon2scb;
    
endclass

`endif
