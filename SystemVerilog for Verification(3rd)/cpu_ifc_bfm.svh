interface cpu_ifc ();
    logic BusMode, Sel, Rd_DS, Wr_RW, Rdy_Dtack;
    logic [11:0] Addr;

    CellCfgType DataIn, DataOut;

    // 使用modport的模块端口方向和modport里声明的一致
    modport Peripheral
    (
        input BusMode, Addr, Sel, DataIn, Rd_DS, Wr_RW,
        output DataOut, Rdy_Dtack
    );

    // 使用modport的模块端口方向和modport里声明的一致
    modport Test
    (
        output BusMode, Addr, Sel, DataIn, Rd_DS, Wr_RW,
        input DataOut, Rdy_Dtack
    );

endinterface

typedef virtual cpu_ifc.Test vCPU_T;


interface Utopia ();
    parameter               int IfWidth = 8;
    logic   [IfWidth - 1 : 0]   data;
    bit clk_in, clk_out;
    bit soc, en, clav, valid, ready, reset, selected;

    ATMCellType ATMCell;

    // 使用modport的模块端口方向和modport里声明的一致
    modport TopReceive
    (
        input  data, soc, clav,
        output clk_in, reset, ready, clk_out, en, ATMCell, valid
    );

    // 使用modport的模块端口方向和modport里声明的一致
    modport TopTransmit
    (
        input clav,
        inout selected,
        output clk_in, clk_out, ATMCell, data, soc, en, valid, reset, ready
    );

    // 使用modport的模块端口方向和modport里声明的一致
    modport CoreReceive
    (
        input clk_in, data, sc, clav, ready, reset,
        output clk_out, en, ATMCell, valid
    );

    // 使用modport的模块端口方向和modport里声明的一致
    modport CoreTransmit
    (
        input clk_in, clav, ATMCell, valid, reset
        output clk_out, data, soc, en, ready
    );

    clocking cbr @ (negedge clk_out);
        input   clk_in, clk_out, ATMCell, valid, reset, en, ready;
        output  data, soc, clav;
    endclocking

    // 使用modport的模块端口方向和modport里声明的一致
    modport TB_Rx
    (
        clocking cbr
    );

    clocking cbt @ (negedge clk_out);
        input clk_out, clk_in, ATMCell, soc, en, valid, reset, data, ready;
        output clav;
    endclocking

    modport TB_Tx ( clocking cbr);
endinterface

typdef virtual Utopia vUtopia;
typdef virtual Utopia.TB_Rx vUtopiaRx;
typdef virtual Utopia.TB_Tx vUtopiaTx;
