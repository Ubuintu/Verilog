`timescale 1ns/1ns
module DUT_tb #(
                parameter WIDTH=8,
                parameter OPCODE=4
               );

/*---------Local Param---------*/
//similar to parameter BUT cannot be modified outside of module
//localparam PERIOD=1000; // 1 MHz = 1000 ns
localparam PERIOD=10;
localparam RSTDLY=2;
localparam RSTLEN=10;

/*---------Reg & wire declaration---------*/
reg clk,reset;
reg [WIDTH-1:0] alu_a_in, alu_b_in;
reg [OPCODE-1:0] alu_opcode_in;
wire [WIDTH-1:0] alu_y_out;
wire alu_co_out;

/*---------Clock generation---------*/
initial begin
    clk=0;
    forever begin
        #(PERIOD/2);
        clk=~clk;
    end
end

alu DUT (
        .*
        );

endmodule
