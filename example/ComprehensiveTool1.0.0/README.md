# 工具（综合工具）应用模板快速入门

## 目录

- [功能介绍](#功能介绍)
- [约束与限制](#约束与限制)
- [快速入门](#快速入门)
- [示例效果](#示例效果)
- [开源许可协议](#开源许可协议)

## 功能介绍

您可以基于此模板直接定制应用，也可以挑选此模板中提供的多种组件使用，从而降低您的开发难度，提高您的开发效率。

此模板提供如下组件，所有组件存放在工程根目录的components下，如果您仅需使用组件，可参考对应组件的指导链接；如果您使用此模板，请参考本文档。

| 组件                         | 描述                                       | 使用指导                                                  |
|----------------------------| ------------------------------------------ | --------------------------------------------------------- |
| 黄历（almanac）                | 提供了查看黄历和白话文的功能。      | [使用指导](./components/almanac/README.md) |
| 基础计算器（basic_calculator）    | 提供了基础计算的功能。       | [使用指导](./components/basic_calculator/README.md)     |
| 热量计算（calories_calculate）   | 提供了按日和按周根据摄入计算热量的功能。 | [使用指导](./components/calories_calculate/README.md)     |
| 日期计算（date_calculate）       | 提供了日起计算和日期间隔计算的功能。         | [使用指导](./components/date_calculate/README.md)   |
| 汇率计算器（exchange_calculator） | 提供了多种币种之间实时汇率计算的功能。        | [使用指导](./components/exchange_calculator/README.md)   |
| 个税计算器（income_calculator）   | 提供了工资、劳动报酬等收入个税计算的功能。      | [使用指导](./components/income_calculator/README.md)   |
| 房贷计算器（mortgage_calculator） | 提供了商业贷款、公积金贷款和组合贷款的还款计划计算功能。   | [使用指导](./components/mortgage_calculator/README.md)   |
| 万能空调遥控器（remote_control）    | 提供了空调遥控器创建，删除及以发射红外信号控制对应空调等功能。 | [使用指导](./components/remote_control/README.md)   |


本模板为工具类应用提供了常用功能的开发样例，模板主要分首页、我的两大模块：

* 首页：提供计算器、黄历、汇率计算、热量计算等工具功能。
* 我的：支持问题反馈、用户协议、隐私政策查看。

本模板只需做少量配置和定制即可快速实现数字计算、日期查询、空调遥控、个税计算等功能。

| 首页                                                      | 我的                                                      |
|---------------------------------------------------------|---------------------------------------------------------|
| <img src="screenshots/home.png" alt="工具管理" width="300"> | <img src="screenshots/mine.png" alt="工具管理" width="300"> |


本模板主要页面及核心功能如下所示：

```ts
综合工具
 |-- 首页
 |    |-- 顶部操作区
 |    |    |    └-- 工具管理
 |    |-- 计算器
 |    |    └-- 数字计算
 |    |-- 个税计算器
 |    |    └-- 个税计算
 |    |-- 汇率计算器
 |    |    |-- 汇率计算
 |    |-- 热量计算
 |    |    |-- 饮食计划
 |    |    |    └-- 食物搜索
 |    |    |    └-- 食物添加
 |    |-- 日期计算
 |    |    |-- 日期间隔
 |    |    |-- 日期计算
 |    |-- 黄历
 |    |    |-- 黄历查看
 |    |-- 万能空调遥控器
 |    |    |-- 遥控器列表
 |    |-- 房贷计算器
 |    |    |-- 房贷计算
 └-- 我的
      |-- 问题反馈
      |    └-- 提交反馈
      |-- 用户协议
      └-- 隐私政策
```

本模板工程代码结构如下所示：

```ts
ComprehensiveTool
  |- components                                            // 可分可合组件层
  |   |- almanac/src/main/ets                              // 黄历(har)
  |   |    |- apis                                         // 模块接口
  |   |    |- constants                                    // 模块常量     
  |   |    |- components                                   // 公共组件
  |   |    |- model                                        // 模型定义  
  |   |    |- pages                                        // 页面
  |   |    |- style                                        // 模块样式
  |   |    |- utils                                        // 模块工具
  |   |    |- viewmodel                                    // 与页面一一对应的vm层           
  |   |    
  |   |- basic_calculator/src/main/ets                     // 计算器(har)
  |   |    |- common                                       // 模块常量
  |   |    |- components                                   // 组件
  |   |    |- model                                        // 模型定义 
  |   |    └- pages                                        // 页面
  |   |    └- utils                                        // 模块工具类
  |   |    └- viewmodel                                    // 与页面一一对应的vm层
  |   |                               
  |   |- calories_calculate/src/main/ets                   // 热量计算(har)
  |   |    |- common                                       // 公共路由
  |   |    |- apis                                         // 模块接口
  |   |    |- components                                   // 模块组件
  |   |    |- pages                                        // 页面      
  |   |    |- mocks                                        // mock数据
  |   |    |- model                                        // 模型定义
  |   |    |- viewmodel                                    // 与页面一一对应的vm层
  |   |    └- utils                                        // 模块工具类
  |   |- date_calculate/src/main/ets                       // 日期计算(har)    
  |   |    |- apis                                         // 模块接口
  |   |    |- constants                                    // 模块常量     
  |   |    |- components                                   // 模块组件
  |   |    |- model                                        // 模型定义  
  |   |    |- pages                                        // 页面
  |   |    |- utils                                        // 模块工具
  |   |- exchange_calculator/src/main/ets                  // 汇率计算器(har)
  |   |    |- common                                       // 公共路由
  |   |    |- constants                                    // 模块常量     
  |   |    |- components                                   // 模块组件
  |   |    |- model                                        // 模型定义  
  |   |    |- pages                                        // 页面
  |   |    |- viewmodel                                    // 与页面一一对应的vm层 
  |   |- income_calculator/src/main/ets                    // 个税计算器(har)
  |   |    |- common                                       // 模块常量   
  |   |    |- components                                   // 模块组件
  |   |    |- model                                        // 模型定义  
  |   |    |- pages                                        // 页面
  |   |    |- utils                                        // 模块工具类
  |   |    |- viewmodel                                    // 与页面一一对应的vm层
  |   |- remote_control/src/main/ets                       // 空调遥控器(har)
  |   |    |- constant                                     // 模块常量定义   
  |   |    |- components                                   // 模块组件
  |   |    |- model                                        // 模型定义  
  |   |    |- util                                         // 模块工具类 
  |   |    |- http                                         // 请求定义  
  |   |    |- pages                                        // 页面
  |   |    |- viewmodel                                    // 与页面一一对应的vm层  
  |   |- mortgage_calculator/src/main/ets                  // 房贷计算器(har)
  |   |    |- common                                       // 模块常量定义   
  |   |    |- components                                   // 模块组件
  |   |    |- types                                        // 模型定义  
  |   |    |- pages                                        // 页面
  |   |    |- viewmodel                                    // 与页面一一对应的vm层             
  |
  |   |- entry/src/main/ets    
  |   |    |- apis                                         // 模块接口  
  |   |    |- constant                                     // 主页常量  
  |   |    |- components                                   // UIAbility实例                                                 
  |   |    |- utils                                        // 工具类
  |   |    |- entryability                                 // UIAbility实例
  |   |    |- entrybackupability                           // 备份实例                                                                                                             
  |   |    |- pages                                        // 页面  
  |   |    |- mocks                                        // mock数据   
  |   |    |- model                                        // 模型定义  
  |   |    |- viewmodel                                    // 与页面一一对应的vm层         
```

## 约束与限制

### 环境
* DevEco Studio版本：DevEco Studio 5.0.5 Release及以上
* HarmonyOS SDK版本：HarmonyOS 5.0.5 Release SDK及以上
* 设备类型：华为手机（包括双折叠和阔折叠）
* HarmonyOS版本：HarmonyOS 5.0.5(17)及以上

### 权限

* 红外发射权限权限：ohos.permission.MANAGE_INPUT_INFRARED_EMITTER

## 快速入门

###  配置工程
在运行此模板前，需要完成以下配置：

1. 在AppGallery Connect创建应用，将包名配置到模板中。

   a. 参考[创建应用](https://developer.huawei.com/consumer/cn/doc/app/agc-help-create-app-0000002247955506)为应用创建APP ID，并将APP ID与应用进行关联。

   b. 返回应用列表页面，查看应用的包名。

   c. 将模板工程根目录下AppScope/app.json5文件中的bundleName替换为创建应用的包名。

###  运行调试工程
1. 连接调试手机和PC。

2. 对应用进行[手工签名](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ide-signing#section297715173233)。

3. 点击"Run"，运行模板工程。

## 示例效果

* 工具管理

  <img src="screenshots/manage.png" alt="工具管理" width="300">

## 开源许可协议

该代码经过[Apache 2.0 授权许可](http://www.apache.org/licenses/LICENSE-2.0)。

