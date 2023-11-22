# ZYNQ_Target-Recognition

> **描述：**实现了一个卷积神经网络加速器，成功搭载`Yolov3tiny`。配合摄像头采集+显示器回显环路，构建了一个高性能实时目标识别与检测系统。

> **实现方式：**
>
> 1. `Verilog实现卷积加速器的设计`，
> 2. `C语言实现Zynq PS端的开发`，
> 3. `Python实现神经网络的搭建与量化`

> **开发工具套件：**
>
> 1. `Vivado2019.2`，
> 2. `Vitis2019.2`，
> 3. `Python`，
> 4. `Pytorch`

**验证平台：**`Xilinx Zynq xc7z100`

> **文件目录：**
>
> 1. `src文件夹是所有代码文件`
> 2. `sim文件夹是testbench文件`
> 3. `vivado_prj文件夹是卷积加速器硬件Vivado工程`
> 4. `vitis_prj文件夹是基于vivado_prj硬件工程的软件Vitis工程`



