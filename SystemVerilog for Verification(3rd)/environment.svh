class Environment;
    UNI_generator gen[];
    mailbox gen2drv[];
    event drv2gen[];
    Drive drv[];
    Monitor mon[];
    Config cfg;
    Scoreboard scb;
    Coverage cov;

    virtual Utopia.TB_Rx Rx[];
    virtual Utopia.TB_Tx Tx[];

    int numRx, numTx;
    vCPU_T mif;
    CPU_drive cpu;
    /*
     * 静态属性
     */
    extern function new(input vUtopiaRx Rx[],
                input vUtopiaTx Tx[],
                input int numRx, numTx,
                input vCPU_T mif);  // 需要赋初值的属性
    endfunction
    extern virtual function void gen_cfg();
    extern virtual function void build();
    extern virtual task run();
    extern virtual function void wrap_up();
endclass
