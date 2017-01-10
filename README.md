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
