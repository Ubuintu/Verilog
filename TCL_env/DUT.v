module counter #(parameter WIDTH=5,
                 parameter INCR=1,
                 parameter LOAD=0)
    (
        input clk, rst, load,
        input [WIDTH-1:0] data_in,
        output reg [WIDTH-1:0] out
    );

    //initialize output to 0 OR assert RST in tb
//    initial
//        out={WIDTH{1'b0}};

    always @ (posedge clk)
        if (rst)
            out<={WIDTH{1'd0}};
        else if (load)
            out<=data_in;
        else
            out<=out+INCR;

endmodule
