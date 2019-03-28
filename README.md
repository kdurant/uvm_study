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

> run_test是在uvm_globals.svh中定义的一个task，用于启动UVM。
> 可以在run_test 里指定参数或者通过命令行参数`+UVM_TESTNAME`来指定

* `uvm_component_utils()`

# step3 raise_objection机制
* UVM中通过objection机制来控制验证平台的关闭。`step2`中的例子并没有真正的输出信号.
* 在每个phase中，UVM会检查是否有objection被提起（raise_objection），如果有，那么等待这个objection被撤销（drop_objection）后停止仿真；如果没有，则马上结束当前phase。
* raise_objection和drop_objection总是成对出现
* raise_objection语句必须在main_phase中第一个消耗仿真时间的语句之前

# step4 使用virtual interface

* 使用interface时需要先例化, 例化的格式和module一致

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

* build_phase
    * build_phase 在new函数之后main_phase之前执行。
    * 在build_phase 中主要通过config_db的set和get操作来传递一些数据，以及实例化成员变量等
    * build_phase 是一个函数phase，而main_phase是一个任务phase
    * build_phase 是不消耗仿真时间的。build_phase 总是在仿真时间（$time函数打印出的时间）为0时执行。

* `uvm_test_top`, 顶级实例名, 无论传递给run_test的参数是什么，创建的实例的名字都为uvm_test_top

* [uvm_config_db](https://www.cnblogs.com/YINBin/p/6833533.html)
    * 作用是把验证环境的一些资源配置为类似全局变量一样，使得它对于整个验证环境来说是可见的。最常见的是在验证环境顶层通过它对一些组件进行配置，组件可以在建立的阶段读取这些配置实现组件不同工作模式的切换
    * 第一个和第二个参数联合起来组成目标路径，与此路径符合的目标才能收信
    * 第三个参数表示一个记号，用以说明这个值是传给目标中的哪个成员的
        - set和get函数的第三个参数必须一致
    * 第四个参数是要设置的值

    * set函数的第四个参数表示要将哪个interface通过config_db传递给my_driver
    ```verilog
    uvm_config_db#(virtual my_if)::set(null, "uvm_test_top", "vif", input_if);
    // 向my_driver的vif 接口(变量)传递一个input_if的实例
    ```
    * get函数的第四个参数表示把得到的interface传递给哪个my_driver的成员变量


# step5 加入transaction
transaction 某种意义上和一个完整的数据帧类似或者说某段时间内总线上需要信号的集合

* transaction 只是作为一个类对象, 在driver中某个任务完成对transaction数据的驱动
* main_phase调用具体的任务

# step6 容器类uvm_env
* 包含所有组件, 通过对容器的例化, 就可以实现对所有组件的例化
* 在env的build_phase中加入组件
```verilog
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = my_driver::type_id::creat("drv", this);
    endfunction
```
* build_phase 的执行遵照树根到树叶的顺序
```verilog
initial 
begin
    run_test("my_env");
end

initial
begin
    uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.drv", "vif", input_if);
end

// uvm_test_top (my_env)
// my_env里例化了"drv"
```


# step7 加入monitor

验证平台必须监测DUT的行为，只有知道DUT的输入输出信号变化之后，才能根据这些信号变化来判定DUT的行为是否正确。

验证平台中实现监测DUT行为的组件是monitor。driver负责把transaction级别的数据转变成DUT的端口级别，并驱动给DUT，monitor的行为与其相对，用于收集DUT的端口数据，并将其转换成transaction交给后续的组件如reference model、scoreboard等处理。

* 有两个monitor, 一个检测输入端口, 一个检测输出端口
* monitor 和 driver 代码高度相似, 其本至是因为二者处理的是同一种协议

* top_tb -> my_env -> my_driver/my_monitor

# step8 加入agent

* top_tb -> my_env -> my_agent -> my_driver/my_monitor
* `is_active`是uvm_agent的一个成员变量, 默认值是`UVM_ACTIVE`
    - UVM_PASSIVE 表示agent是passive模式, 只能例化monitor
    - UVM_ACTIVE 表示agent既有激励也有监测功能

# step9 加入reference model
* reference model用于完成和DUT相同的功能
* reference model的输出被scoreboard接收，用于和DUT的输出相比较
* DUT如果很复杂，那么reference model也会相当复杂

* uvm_analysis_port
* uvm_tlm_analysis_fifo, 参数化类

# step10 加入scoreboard
1. 比较的数据一是来源于reference model，二是来源于o_agt的monitor。前者通过exp_port获取，而后者通过act_port获取

# step11 加入field_automation机制
作用?

# step12 加入sequencer
1. sequence 用于产生激励

# step13 sequence机制
1. sequence 不属于验证平台的任何一部分, 但和 sequencer 关系密切
2. 只有在sequencer的帮助下，sequence产生出的transaction才能最终送给driver
3. sequencer只有在sequence出现的情况下才能体现其价值，如果没有sequence，sequencer就几乎没有任何作用
4. sequence就像是一个弹夹，里面的子弹是transaction，而sequencer是一把枪。弹夹只有放入枪中才有意义，枪只有在放入弹夹后才能发挥威力。

## `uvm_do

# step14(2.4.3) 使用默认sequence
