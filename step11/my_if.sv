`ifndef MY_IF_SV
`define MY_IF_SV

interface my_if 
(
    input logic clk,
    input logic rst_n
);
logic   [07:00]             data;
logic                       valid;

endinterface

`endif
