# 房产与装修（家居装修）应用模板快速入门

## 目录

- [功能介绍](#功能介绍)
- [组件](#组件)
- [环境要求](#环境要求)
- [快速入门](#快速入门)
- [示例效果](#示例效果)
- [权限要求](#权限要求)
- [开源许可协议](#开源许可协议)

## 功能介绍

本模板为家居装修类应用提供了常用功能的开发样例，模板主要分首页、找设计师、定制设计和我的四大模块：

- 首页：展示热门装修经验贴和设计师案例，支持案例搜索和城市选择。
- 找设计师：按筛选条件展示设计师，支持查看详情、在线预约和直接电话联系设计师。
- 定制设计：支持根据所选条件，获取推荐装修方案。
- 我的：展示账号相关信息，支持联系客服和意见反馈，展示收藏的家装案例以及设置等功能。

本模板已集成华为账号服务，只需做少量配置和定制即可快速实现华为账号的登录等功能。

| 首页                                                                | 找设计师                                                                | 定制设计                                                                  | 我的                                                                |
|-------------------------------------------------------------------|---------------------------------------------------------------------|-----------------------------------------------------------------------|-------------------------------------------------------------------|
| <img src="screenshots/Screenshot_home.jpeg" alt="首页" width="300"> | <img src="screenshots/Screenshot_find.jpeg" alt="找设计师" width="300"> | <img src="screenshots/Screenshot_custom.jpeg" alt="定制设计" width="300"> | <img src="screenshots/Screenshot_mine.jpeg" alt="我的" width="300"> |

本模板主要页面及核心功能清单如下所示：

```ts
家居装修模板
 |-- 首页
 |    |-- 城市选择
 |    |-- 搜索
 |    |-- banner
 |    |-- 家装案例
 |    |    |-- 条件筛选
 |    |    └-- 案例列表  
 |    |-- 找设计师
 |    |-- 装修报价
 |    |    |-- 信息填写
 |    |    └-- 报价结果  
 |    └-- 装修案例瀑布流
 |         └-- 案例详情 
 |-- 找设计师
 |    |-- 筛选条件
 |    └-- 设计师列表
 |         |-- 设计师信息
 |         |-- 案例列表
 |         |-- 文章列表
 |         |-- 联系TA
 |         |-- 在线预约
 |         └-- 评论
 |
 |-- 定制设计
 |    |-- 房屋信息填写
 |    └-- 装修方案推荐
 |       
 └-- 我的
      |-- 用户信息
      |    |-- 登录
      |    |-- 用户信息
      |-- 我的装修信息
      |    |-- 新增装修信息
      |-- 我的收藏
      |-- 联系客服
      |-- 意见反馈
      |    |-- 我想要
      |    |-- 我建议
      |    └-- 反馈历史
      └-- 设置
           |-- 隐私政策
           |-- 用户协议
           └-- 退出登录
           
```

本模板工程代码结构如下所示：

```
HomeDecoration
  ├─commons/commonlib/src/main
  │  ├─ets
  │  │  ├─components
  │  │  │      BaseHeader.ets                  // 一级页面标题组件
  │  │  │      BuildTitleBar.ets               // 二级页面标题组件
  │  │  │      TelBar.ets                      // 拨号组件  
  │  │  ├─constants
  │  │  │      CommonContants.ets              // 公共常量
  │  │  │      CommonEnums.ets                 // 公共枚举值
  │  │  ├─types
  │  │  │      Types.ets                       // 公共抽象类
  │  │  └─utils
  │  │         AccountUtil.ets                 // 账号工具类
  │  │         LocationUtil.ets                // 定位工具类
  │  │         Logger.ets                      // 日志工具类
  │  │         PermissionUtil.ets              // 权限获取工具类
  │  │         RouterModule.ets                // 路由工具类
  │  │         WindowUtil.ets                  // 窗口管理工具类
  │  └─resources
  ├─commons/network/src/main
  │  ├─ets
  │  │  ├─apis
  │  │  │      APIList.ets                     // 网络请求API
  │  │  │      HttpRequest.ets                 // 网络请求
  │  │  ├─mocks
  │  │  │  └─MockData
  │  │  │         CaseList.ets                 // mock数据
  │  │  │      AxiosMock.ets                   // mock请求
  │  │  │      RequestMock.ets                 // mock API
  │  │  └─types
  │  │         Decoration.ets                  // 装修抽象类
  │  └─resources
  │─components/module_city_select/src/main     // 城市选择组件模块
  │  ├─ets
  │  │  ├─common
  │  │  │      Constant.ets                    // 常量定义
  │  │  │      Model.ets                       // 模型定义
  │  │  │      Utils.ets                       // 方法定义
  │  │  ├─components
  │  │  │      SingleBtn.ets                   // 按钮组件
  │  │  └─pages
  │  │         Index.ets                       // 城市选择主体
  │  └─resources
  │─components/module_decoration_form/src/main // 装修表单组件模块
  │  ├─ets
  │  │  ├─components
  │  │  │      FormDecoration.ets              // 装修表单组件
  │  │  ├─types
  │  │  │      Index.ets                       // 数据类型
  │  │  └─utils
  │  │         CascaderUtils.ets               // 地址级联工具类
  │  └─resources
  │─components/module_filter_list/src/main     // 列表筛选组件模块
  │  ├─ets
  │  │  ├─components
  │  │  │      CommonPicker.ets                // 选择项组件
  │  │  │      Drawer.ets                      // 抽屉容器组件
  │  │  │      FilterList.ets                  // 列表筛选组件
  │  │  ├─types
  │  │  │      Index.ets                       // 数据类型
  │  │  └─utils
  │  │         Logger.ets                      // 日志打印工具类
  │  │         WindowUtil.ets                  // 窗口管理工具类
  │  └─resources
  │─components/module_login/src/main           // 登录组件模块
  │  ├─ets
  │  │  ├─common
  │  │  │      Constant.ets                    // 常量类
  │  │  │      Logger.ets                      // 日志类
  │  │  ├─components
  │  │  │      AgreementDialog.ets             // 协议弹窗组件
  │  │  │      LoginService.ets                // 登录组件
  │  │  ├─model
  │  │  │      Index.ets                       // 数据类型
  │  │  │      WXApiWrap.ets                   // 微信登录数据类型
  │  │  └─viewmodel
  │  │         AggregatedLoginVM.ets           // 登录组件数据模型
  │  └─resources
  │─components/module_posting/src/main         // 意见反馈组件模块
  │  ├─ets
  │  │  ├─components
  │  │  │      Constant.ets                    // 常量类
  │  │  │      WindowUtil.ets                  // 窗口管理工具类
  │  │  ├─components
  │  │  │      BuildTitleBar.ets               // 页面标题组件
  │  │  │      Posting.ets                     // 反馈表单组件
  │  │  ├─http
  │  │  │      Api.ets                         // mock数据类
  │  │  │      Types.ets                       // 数据类型类
  │  │  ├─pages
  │  │  │      FeedbackDetail.ets              // 反馈历史详情页面
  │  │  │      FeedbackHistory.ets             // 反馈历史页面
  │  │  │      FeedbackPage.ets                // 意见反馈页面
  │  │  └─viewModels                           // 与页面一一对应的vm层
  │  └─resources
  │─features/custom/src/main   
  │  ├─ets
  │  │  ├─pages
  │  │  │      CustomPage.ets                  // 定制设计页面
  │  │  │      CustomResult.ets                // 定制结果页面
  │  │  ├─types
  │  │  │      Index.ets                       // 数据对象
  │  │  └─viewModels                           // 与页面一一对应的vm层
  │  └─resources
  │─features/find/src/main   
  │  ├─ets
  │  │  ├─pages
  │  │  │      DesignerPage.ets                // 设计师页面
  │  │  │      FindPage.ets                    // 找设计师页面
  │  │  │      OwnCasePage.ets                 // 案例文章页面
  │  │  ├─types
  │  │  │      Index.ets                       // 数据类型
  │  │  └─viewModels                           // 与页面一一对应的vm层
  │  └─resources
  │─features/home/src/main   
  │  ├─ets
  │  │  ├─components
  │  │  │      SearchKeys.ets                  // 关键词组件
  │  │  ├─pages
  │  │  │      AllCityPage.ets                 // 添加城市页面
  │  │  │      CaseDetailPage.ets              // 案例详情页面
  │  │  │      HomeCasePage.ets                // 家装案例页面
  │  │  │      HomePage.ets                    // 首页
  │  │  │      ListPage.ets                    // 报价清单页面
  │  │  │      PricePage.ets                   // 装修报价页面
  │  │  │      SearchPage.ets                  // 搜索页面
  │  │  ├─types
  │  │  │      Index.ets                       // 首页数据对象
  │  │  └─viewModels                           // 与页面一一对应的vm层
  │─features/mine/src/main   
  │  ├─ets
  │  │  ├─pages
  │  │  │      MinePage.ets                    // 我的页面
  │  │  │      MyCollection.ets                // 我的收藏页面
  │  │  │      MyDecorationInfo.ets            // 我的装修信息页面
  │  │  │      PersonalInfo.ets                // 个人信息页面
  │  │  │      PrivacyPolicyPage.ets           // 用户协议页面
  │  │  │      QuickLoginPage.ets              // 一键登录页面
  │  │  │      SettingsPage.ets                // 设置页面
  │  │  │      TermsOfServicePage.ets          // 隐私政策页面
  │  │  ├─types 
  │  │  │      Index.ets                       // 抽象类
  │  │  └─viewModels                           // 与页面一一对应的vm层
  │  └─resources
  └─products/entry/src/main   
     ├─ets
     │  ├─entryability
     │  │      EntryAbility.ets                // 应用程序入口
     │  ├─entrybackupability 
     │  │      EntryBackupAbility.ets          // 应用程序扩展与备份
     │  ├─entryformability 
     │  │      EntryFormAbility.ets            // 卡片程序入口
     │  ├─pages 
     │  │      MainEntry.ets                   // 主页面
     │  ├─types 
     │  │      Index.ets                       // 抽象类
     │  ├─viewModels 
     │  │      MainEntryVM.ets                 // 入口页面数据
     │  └─widget/pages 
     │         WidgetCard.ets                  // 卡片页面
     └─resources
```

## 组件

本模板中提供了多种组件，您可以按需选择合适的组件进行使用，所有组件存放在工程根目录的components下。

| 组件                             | 描述            | 使用指导                                                |
|--------------------------------|---------------|-----------------------------------------------------|
| 登录组件（module_login）             | 支持华为一键登录和微信登录 | [使用指导](components/module_login/README.md)           |
| 列表筛选组件（module_filter_list）     | 支持条件筛选与列表展示   | [使用指导](components/module_filter_list/README.md)     |
| 城市选择组件（module_city_select）     | 支持城市选择与定位     | [使用指导](components/module_city_select/README.md)     |
| 意见反馈组件（module_posting）         | 支持意见建议的填写与发布  | [使用指导](components/module_posting/README.md)         |
| 装修表单组件（module_decoration_form） | 支持装修信息填写与提交   | [使用指导](components/module_decoration_form/README.md) |

## 环境要求

### 软件

* DevEco Studio版本：DevEco Studio 5.0.4 Release及以上
* HarmonyOS SDK版本：HarmonyOS 5.0.4 Release SDK及以上

### 硬件

* 设备类型：华为手机（直板机）
* HarmonyOS版本：HarmonyOS 5.0.4 Release及以上

## 快速入门

### 配置工程

在运行此模板前，需要完成以下配置：

1. 在AppGallery Connect创建应用，将包名配置到模板中。

   a. 参考[创建HarmonyOS应用](https://developer.huawei.com/consumer/cn/doc/app/agc-help-createharmonyapp-0000001945392297)为应用创建APP ID，并将APP ID与应用进行关联。

   b. 返回应用列表页面，查看应用的包名。

   c. 将模板工程根目录下AppScope/app.json5文件中的bundleName替换为创建应用的包名。

2. 配置华为账号服务。

   a. 将应用的client ID配置到products/entry/src/main路径下的module.json5文件中，详细参考：[配置Client ID](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/account-client-id)。

   b. 申请华为账号一键登录所需的quickLoginMobilePhone权限，详细参考：[配置scope权限](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/account-config-permissions)。

3. 对应用进行[手工签名](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ide-signing#section297715173233)。

4. 添加手工签名所用证书对应的公钥指纹。详细参考：[配置应用签名证书指纹](https://developer.huawei.com/consumer/cn/doc/app/agc-help-signature-info-0000001628566748#section5181019153511)

### 运行调试工程

1. 连接调试手机和PC。

2. 菜单选择“Run > Run 'entry' ”或者“Run > Debug 'entry' ”，运行或调试模板工程。

## 示例效果

| 案例筛选                                                             | 设计师预约                                                             | 装修报价                                                             | 定制推荐                                                             |
|------------------------------------------------------------------|-------------------------------------------------------------------|------------------------------------------------------------------|------------------------------------------------------------------|
| <img src="screenshots/Screenshot_1.jpeg" alt="案例筛选" width="300"> | <img src="screenshots/Screenshot_2.jpeg" alt="设计师预约" width="300"> | <img src="screenshots/Screenshot_3.jpeg" alt="装修报价" width="300"> | <img src="screenshots/Screenshot_4.jpeg" alt="定制推荐" width="300"> |

## 权限要求

- 网络权限：ohos.permission.INTERNET
- 获取位置权限：ohos.permission.APPROXIMATELY_LOCATION

## 开源许可协议

该代码经过[Apache 2.0 授权许可](http://www.apache.org/licenses/LICENSE-2.0)。
