`ifndef MY_MONITOR__SV
`define MY_MONITOR__SV
class my_monitor extends uvm_monitor;
    virtual my_if vif;

    `uvm_component_utils(my_monitor);
    function new(/*parameter*/);
        //this.x = x;
    endfunction
endclass

`endif
