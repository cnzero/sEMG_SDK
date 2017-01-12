[TOC]


### sEMG_SDK
SDK of sEMG functions of matlab

##### 目的

##### 实现思路
1. 先对大量复用性代码进行抽象化与模块化;
2. 对不同功能的函数代码进行分而治之；

### 说明文档
##### 1. 采集程序
##### 2. 基于窗函数的特征提取
##### 3. 模型参数的输入与输出


### README of directories/folders
##### acquisition
1. functions of acquiring sEMG/ACC online/offline

##### controlAPI
1. module function of controlling movement pictures exhibition
2. module function of controlling iLimb
3. module funciton of controlling HOH(Hand of Hope)
4. module function of controlling virtual hand

##### funs_help
Functions description and parameters settings if necessary.

##### general
In generally, it is described how these codes are involved into your own project, such as path involvement. 

##### models
Common models functions are described here. For example,
1. LDA
2. PCA
3. ICA
4. NMF and so on.


#### Explanations on TCPIP parameters
##### Common
1. `HOST_IP=127.0.0.1`  `50040` or something like that
    `properties of tcpip`
    `LocalHost` = '127.0.0.1'
    `LocalPort` = `50040`
2. `InputBufferSize`,
    `BytesAvailableFcnMode`
    `BytesAvailableFcnCount`
    `BytesAvailableFcn`
##### EMG
1. `InputBufferSize` = 6400
    `BytesAvailableFcnMode` = 'byte'
    `BytesAvailableFcnCount` = 1728
    `BytesAvailableFcn` , @Function
    when the cache in LocalHost:LocalPort is acquried enough to 1728bytes, 
    Function is trigged.
2. why __1728__
    1728 = (27 samples)x(4 bytes/sample)x(16 channels)


##### ACC
1. `InputBufferSize` = 6400
    `BytesAvailableFcnMode` = 'byte'
    `BytesAvailableFcnCount` = 384
    `BytesAvailableFcn` , @Function
    when the cache in LocalHost:LocalPort is acquried enough to 1728bytes, 
    Function is trigged.
2. why __384__
    384 = (2 samples)x(4 bytes/sample)x(48 channels)
    3-axes: x-y-z
    16 channels
3. 27:2, is the simplest proportion

##### Summary of TCPIP on EMG&ACC
All data from 16 channels, including EMG signal and ACC data, are stored in the tcpip cache.

In your self-defined functions, you should seperate your wanting data that relating to the selected Sensor channels.

Select the right data to update plotting or stored in the .txt or csv files. 

#### A common error about TCPIP
Error Messages as following:
```
Error using icinterface/fread (line ...)
OBJ must be connected to the hardware with FOPEN.

Error in Model/NotifyEMG (line ...)
    data = cast(fread(obj.interfaceObjects{2},bytesReady), 'uint8');

Error in Model>@(varargin)obj.NotifyEMG(varargin{:}) (line ...)
    'BytesAvailableFcn', {@obj.NotifyEMG}) ...
Error instrcb (line ...)
    feval(val{1}, obj, eventStruct, var{2:end});
```
原因分析：
根本原因在于MATLAB里面没有中断优先级的机制。
也就是当前执行的任务，无论如何都要执行完毕。
然后，当CPU空闲的时候，就去查中断的堆栈，如果堆栈中有来自某个的中断请求，CPU就回去执行；
只要有任何一方提中断，就会将响应地址写到中断向量的堆栈中，等CPU来响应。

所以，就有可能产生一个矛盾，（针对当前的情况分析如下）
因为某一个函数执行时间比较长，在此期间TCPIP中断已经提了20个中断，都被压在堆栈中了；
正常情况下当该函数被执行完毕后，就去逐一执行堆栈中的中断；
而恰恰不巧的是，在执行该函数的过程中，其中有些命令直接把TCPIP端口关闭了，
啊？此时，中断的堆栈中竟然还有TCPIP的中断请求，
好吧，函数执行完毕后，去响应TCPIP中断请求，不巧的是，TCPIP已经关闭了，怎么办呢？
就报错呗，要求用`FOPEN`进行设备连接，也就错误提示的第一句话。
