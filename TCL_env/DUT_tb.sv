`timescale 1ns/1ps
module DUT_tb;

//Same scope as parameter but cannot be changed from outside
localparam WIDTH=4;   //width of regs required
localparam PERIOD=10; //10ns = 10000MHz

//for all DUTs
reg clk, rst;
wire [WIDTH-1:0] out;

//DUT exclusive sigs
reg load;
reg [WIDTH-1:0] data_in;

//clk gen
initial begin
    clk=1'b0;
    
    forever begin
        #(PERIOD/2);
        clk=~clk;
    end
end

//for init regs for MS
initial begin
    data_in={WIDTH{1'd0}};
    rst=0;
    load=0;
    //out={WIDTH{1'd0}};
    repeat (PERIOD) @(posedge clk)
    rst=1;
    @(posedge clk)
    rst=0;
end


//instantiate DUT
counter #( .WIDTH(WIDTH), .INCR(2) ) DUT
    (
    .*
    );

endmodule
