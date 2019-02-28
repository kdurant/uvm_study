module dut
(
    input   wire                clk,
    input   wire                rst_n,
    input   wire [07:00]        rxd,
    input   wire                rx_dv,
    output  reg  [07:00]        txd,
    output  reg                 tx_en
);

always @(posedge clk) begin
   if(!rst_n) begin
      txd <= 8'b0;
      tx_en <= 1'b0;
   end
   else begin
      txd <= rxd;
      tx_en <= rx_dv;
   end
end
endmodule

