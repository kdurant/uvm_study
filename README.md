# uvm_study
uvm study step-by-step


# step1 对uvm有基本的认识.

1. UVM第一原则是:验证平台中的所有组件都派生自UVM中的类

2. UVM使用phase来管理验证平台中运行

3. 最顶层文件要首先包含uvm头文件
```verilog
`include "uvm_macros.svh"
import uvm_pkg::*;

//`include "my_driver.sv"
```

# step2 加入factory机制
* 改变了调用`main_phase`的方式
```verilog
initial begin
    run_test("my_driver");  // 名称不能错
end
```
