`ifndef DUT_TOP_SV
`define DUT_TOP_SV

`include "alu_simple_bugs_enc2.svp"

//wrapper module to connect DUT & interface
module dut_top(interface dut_intf);
    
//Instantiate of DUT; connection by name
    alu alu_wrapper (
                        .clk( dut_intf.clk ),
                        .reset( dut_intf.reset ),
                        .alu_a_in( dut_intf.a_in ),
                        .alu_b_in( dut_intf.b_in ),
                        .alu_opcode_in( dut_intf.op_in ),
                        .alu_y_out( dut_intf.y_out ),
                        .alu_co_out( dut_intf.co_out )
                    );

endmodule

`endif
