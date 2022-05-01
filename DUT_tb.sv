`timescale 1ns/1ps
module DUT_tb;

reg clk, reset, btn;

reg signed [17:0] x_in;
wire signed [17:0] y;
wire out;

localparam PERIOD = 10;
localparam RESET_DELAY = 2;
localparam RESET_LENGTH = 21;

// Clock generation initial
initial
begin
    clk = 0;
    forever begin
    #(PERIOD/2);
    clk=~clk;
    end
end

initial begin
    repeat (PERIOD) @(posedge clk)
    btn=0;
    //repeat (PERIOD) @(posedge clk)
    repeat (7) @(posedge clk)
    btn=1;
    repeat (PERIOD) @(posedge clk)
    btn=0;
end

button_conditioner #( .COUNT(3) ) DUT 
    (
	.clk(clk),
    .btn(btn),
    .out(out)
    );

endmodule
