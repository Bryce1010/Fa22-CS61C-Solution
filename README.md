# Fa22-CS61C-Solution

Lab0
环境配置 + SSH连接Hive Machine；

Lab1 
学习C语言，并使用gdb对程序进行debug；

Lab2
学习使用C语言的bit操作，使用gdb和valgrind发现内存泄漏，学习使用C语言的内存管理；

Lab3
学习使用RISC-V汇编语言；

Lab4
RISC-V的函数调用

Lab5  
Logisim入门，模拟数字逻辑电路

Lab6
CPU, 流水线入门

Lab7
Cache 优化及计算

Lab8
SIMD 指令入门，学习数据层的并行与循环的展开

Lab9
使用 OpenMD 实现线程并行

Lab10
Virtual Memory 的计算及应用

Proj1
使用C语言实现贪吃蛇游戏，熟悉内存分配和内存泄漏的概念，加深对 C 语言，Debug 工具，内存泄漏检测工具等的理解与应用

Proj2
使用 RISC-V 汇编编写一个三层神经网络，结合 MNIST 数据集识别手写数字，加深对汇编代码的理解与应用

Proj3
使用 Logisim 画一个二级流水线的 CPU，并在上面运行 RISC-V指令，Part A 实现 addi 指令，Part B 每个 Task 实现一个 Format 类型的指令；
主要思路是通过每个指令的 Opcode Funct3 Funct7 部分来确定指令类型并生成对应的 RegWEn ImmSel BrUn ASel BSel ALUSel MemRW WBSel 等控制信号，从而决定该指令在 CPU 内的 DataPath；
在这个 Project 中能提高自己对于 ISA 指令集设计及硬件设计等的认识，感受指令集设计的精巧；

Proj4
Task 1 是使用 C 语言实现一个简易的 Numpy —— Numc ， Task 2 使用 OpenMP , SIMD 对 Numc 进行数据并行，线程并行的优化，并使用快速幂对 pow 函数进行算法层面的优化。对于性能优化，高性能计算等有了一个轮廓的认识与理解；