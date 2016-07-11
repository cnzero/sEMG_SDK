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