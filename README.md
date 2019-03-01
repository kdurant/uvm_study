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

# step3 raise_objection机制
* UVM中通过objection机制来控制验证平台的关闭。`step2`中的例子并没有真正的输出信号.
* 在每个phase中，UVM会检查是否有objection被提起（raise_objection），如果有，那么等待这个objection被撤销（drop_objection）后停止仿真；如果没有，则马上结束当前phase。
* raise_objection和drop_objection总是成对出现
* raise_objection语句必须在main_phase中第一个消耗仿真时间的语句之前

# step4 使用virtual interface

1. 使用interface时需要先例化, 例化的格式和module一致
```verilog
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
```
2. bulid_phase
    * build_phase在new函数之后main_phase之前执行。
    * 在build_phase中主要通过config_db的set和get操作来传递一些数据，以及实例化成员变量等
    * build_phase是一个函数phase，而main_phase是一个任务phase
    * build_phase是不消耗仿真时间的。build_phase总是在仿真时间（$time函数打印出的时间）为0时执行。

3. uvm_config_db
    * set和get函数的第三个参数必须一致
    * set函数的第四个参数表示要将哪个interface通过config_db传递给my_driver
    ```verilog
    uvm_config_db#(virtual my_if)::set(null, "uvm_test_top", "vif", input_if);
    // 向my_driver的vif 接口(变量)传递一个input_if的实例
    ```
    * get函数的第四个参数表示把得到的interface传递给哪个my_driver的成员变量

4. 无论传递给run_test的参数是什么，创建的实例的名字都为uvm_test_top

# step5 加入transaction
