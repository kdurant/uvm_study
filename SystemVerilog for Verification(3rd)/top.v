`timescale 1ns/1ps
`define TxPorts 4
`define RxPorts 4

module top;
parameter               int NumRx = `RxPorts;
parameter               int NumTx = `TxPorts;

logic       rst, clk;

initial
begin
    rst = 0;
    clk = 0;
    #5ns rst = 1;
    #5ns clk = 1;
    #5ns rst =0; clk = 0;
    forever
    #5ns clk = ~clk;
end

Utopia  Rx[0:NumRx-1] ();
Utopia  Tx[0:NumTx-1] ();
cpu_ifc mif();
squat #(NumRx, NumTx) squat(Rx, Tx, mif, rst, clk);         //DUT
test #(NumRx, NumTx) t1(Rx, Tx, mif, rst);         //DUT

endmodule
