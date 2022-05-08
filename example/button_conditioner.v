module button_conditioner #(parameter COUNT=5)
  (
    input clk,
    input btn,
    output out
  );
 
  reg [COUNT-1:0] ctr_d, ctr_q;
  reg [1:0] sync_d, sync_q;
 
  //only when ctr/btn stablizes does it count as a btn press
  assign out = ctr_q == {COUNT{1'b1}};
 
  always @(*) begin
    sync_d[0] = btn;
    sync_d[1] = sync_q[0];
    ctr_d = ctr_q + 1'b1;
 
    if (ctr_q == {COUNT{1'b1}}) begin
      ctr_d = ctr_q;
    end
 
    if (!sync_q[1])
      ctr_d = {COUNT{1'b0}};
  end
 
  always @(posedge clk) begin
    //q is delay of d
    ctr_q <= ctr_d;
    sync_q <= sync_d;
  end
 
endmodule
