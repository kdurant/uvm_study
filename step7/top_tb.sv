`timescale 1ns/1ps
`include "uvm_macros.svh"

import uvm_pkg::*;
`include "my_if.sv"
`include "my_transaction.sv"
`include "my_driver.sv"
`include "my_env.sv"

module top_tb;

reg                         clk;
reg                         rst_n;
reg [07:00]                 rxd;
reg                         rx_dv;

wire[07:00]                 txd;
wire                        tx_en;

my_if input_if
(
    .clk      (    clk      ),
    .rst_n    (    rst_n    )
);

my_if output_if
(
    .clk      (    clk      ),
    .rst_n    (    rst_n    )
);

dut my_dut
(
    .clk      (    clk      ),
    .rst_n    (    rst_n    ),
    .rxd      (    input_if.data      ),
    .rx_dv    (    input_if.valid    ),
    .txd      (    output_if.data      ),
    .tx_en    (    output_if.valid    )
);


initial begin
   clk = 0;
   forever begin
      #100 clk = ~clk;
   end
end

initial begin
   rst_n = 1'b0;
   #1000;
   rst_n = 1'b1;
end

initial 
begin
    run_test("my_env");
end

initial
begin
    uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.dr1v", "vif", input_if);
end

endmodule
