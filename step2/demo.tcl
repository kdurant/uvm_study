quit -sim
.main clear
vlib    work
vmap    work work

set UVM_HOME               C:/questasim64_10.6c/verilog_src/uvm-1.1d
set UVM_DPI_DIR            C:/questasim64_10.6c/uvm-1.1d/win64/uvm_dpi
set WORK_HOME              D:/puvm

vlog -work work +incdir+$UVM_HOME/src  -L mtiAvm -L mtiOvm -L mtiUvm -L mtiUPF $UVM_HOME/src/uvm_pkg.sv
vlog -work work +incdir+$UVM_HOME/src  -L mtiAvm -L mtiOvm -L mtiUvm -L mtiUPF top_tb.sv
vlog -work work -sv ../dut.sv

vsim -voptargs="+acc" -sv_lib $UVM_DPI_DIR work.top_tb

log -r /*
radix 16

run 1us

