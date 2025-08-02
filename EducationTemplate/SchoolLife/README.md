# 课程助手行业模板快速入门

## 目录

- [功能介绍](#功能介绍)
- [环境要求](#环境要求)
- [快速入门](#快速入门)
- [示例效果](#示例效果)
- [权限要求](#权限要求)
- [开源许可协议](#开源许可协议)

## 功能介绍

您可以基于此模板直接定制元服务，也可以挑选此模板中提供的多种组件使用，从而降低您的开发难度，提高您的开发效率。

此模板提供如下组件，所有组件存放在工程根目录的components下，如果您仅需使用组件，可参考对应组件的指导链接；如果您使用此模板，请参考本文档。

| 组件                           | 描述                         | 使用指导                                                  |
|------------------------------|----------------------------|-------------------------------------------------------|
| 课表组件（module_course_schedule） | 提供了基于课程信息渲染课表的UI组件         | [使用指导](./components/module_course_schedule/README.md) |
| 签到组件（module_secure_checkin）  | 提供了基于可实时位置与验证码进行课堂签到的场景化组件 | [使用指导](./components/module_secure_checkin/README.md)  |

本模板为课程助手类元服务提供了常用功能的开发样例，模板主要分首页和我的两大模块：

- 首页：展示今日课程、明日课程，以及学期所有课程。进入课程支持根据签到地点、签到码进行签到。
- 我的：展示账号相关信息，支持修改用户昵称、头像。

本模板已集成华为账号、定位服务，只需做少量配置和定制即可快速实现华为账号的登录、基于位置签到等功能。

| 首页                                                  | 我的                                                  |
|-----------------------------------------------------|-----------------------------------------------------|
| <img src="screenshots/首页.jpg" alt="首页" width="300"> | <img src="screenshots/我的.jpg" alt="我的" width="300"> |

本模板主要页面及核心功能如下所示：

```ts
课程助手
 |-- 首页
 |    |-- 上课签到
 |    |-- 课表展示卡片
 |    |    |-- 今日课表
 |    |    └-- 明日课表
 |    |-- 课表中心
 |-- 课表中心
 |    └-- 学周信息
 |    └-- 学周选择
 |    └-- 课表展示
 |    └-- 课程详情
 |-- 签到中心
 |    └-- 签到码输入
 |    └-- 点击签到
 └-- 我的
      └-- 用户信息
           |-- 修改头像
           └-- 关联解绑账号
```

工程目录结构如下：

```ts
SchoolLife
  ├─commons/commonLib/src/main
  │  ├───ets
  │  │   ├───constants
  │  │   │       CommonContants.ets            // 公共常量
  │  │   │       CommonEnums.ets               // 公共枚举
  │  │   ├───type
  │  │   │       CommonType.ets                // 公共类
  │  │   │       RouterInfo.ets                // 路由参数类
  │  │   └───utils
  │  │           AccountUtil.ets               // 账号工具类
  │  │           ColorUtil.ets                 // 颜色工具类
  │  │           CourseUtil.ets                // 课程工具类
  │  │           FileUtil.ets                  // 文件工具类
  │  │           FormatUtil.ets                // 日期格式化工具类
  │  │           Logger.ets                    // 日志工具类
  │  │           NumberUtil.ets                // 数字工具类
  │  │           PermissionUtil.ets            // 权限工具类
  │  │           RouterModule.ets              // 路由工具类
  │  │           ScheduleConfigUtil.ets        // 课程配置工具类
  │  │           SimpleDialog.ets              // 弹窗工具类
  │  └─resources
  │
  ├─commons/componentLib/src/main
  │   ├───ets
  │   │   ├───components
  │   │   │       CardWrapper.ets              // 卡片Wrapper
  │   │   │       index.ets            
  │   │   │       LoadingComponentWrapper.ets  // Loading组件容器
  │   │   │       LoadingPageWrapper.ets       // Loading页面容器
  │   │   │       NavigateBar.ets              // 自定义NavBar
  │   │   │       SegmentButtonAdapter.ets      
  │   │   │       SimpleCapsuleButton.ets      // 简易CapsuleButton
  │   │   └───constant
  │   │           ComponentConst.ets           // 公共组件常量/方法
  │   └─resources
  │
  ├─commons/network/src/main
  │   ├───ets
  │   │   ├───apis
  │   │   │       CourseApi.ets                // 课程Api
  │   │   │       UserApi.ets                  // 用户Api    
  │   │   ├───constants
  │   │   │       NetworkEnums.ets             // 网络常量
  │   │   ├───mocks
  │   │   │       HttpApisMock.ets             // Mock数据
  │   │   │       MockRequestMap.ets           // Mock数据
  │   │   ├───models
  │   │   │   │   AxiosHttpModel.ets           // 网络请求
  │   │   │   │   AxiosRequest.ets             // 网络请求
  │   │   │   ├───request                      // 请求体结构
  │   │   │   └───response                     // 响应体结构
  │   │   └───types
  │   │           ResponseTypes.ets            // 公共网络请求类
  │   └─resources
  │
  ├─components
  │   ├─module_course_schedule                 // 课表组件
  │   └─module_secure_checkin                  // 签到组件
  │
  │─entry/src/main
  │   ├───ets
  │   │   ├───constants
  │   │   │       Constants.ets                // 公共常量
  │   │   ├───entryability
  │   │   ├───entryformability
  │   │   ├───pages
  │   │   │       MainEntry.ets                // 入口页面
  │   │   ├───school_life_widget               // 卡片页面
  │   │   ├───types
  │   │   │       Types.ets                    // interface接口定义
  │   │   └───viewmodels                       // VM层
  │   └─resources
  │
  │─features/service/courseSchedule/src/main   
  │   └───ets
  │   │   ├───mapper
  │   │   │       DataMapper.ets               // 数据映射工具类
  │   │   └───pages
  │   │           CourseDetailPage.ets         // 课表详情页
  │   │           CourseSchedulePage.ets       // 课表中心页
  │   └─resources
  │
  │─features/tab/home/src/main   
  │   ├───ets
  │   │   ├───component
  │   │   │       ClassSignInButton.ets        // 签到按钮组件
  │   │   │       DayCourseInfoCard.ets        // 首页课表卡片组件
  │   │   ├───mapper
  │   │   │       ResponseMapper.ets           // 响应Mapper
  │   │   ├───pages
  │   │   │       HomePage.ets                 // 首页
  │   │   └───viewmodel
  │   │           HomePageVM.ets               // 首页 ViewModel
  │   └─resources
  │
  └─features/tab/mine/src/main   
      └───ets
      │   ├───pages
      │   │       MinePage.ets                 // 我的
      │   └───viewmodel
      │           MinePageVM.ets               // 我的 ViewModel
      └─resources
```

## 环境要求

### 软件

- DevEco Studio版本：DevEco Studio 5.0.3 Release及以上
- HarmonyOS SDK版本：HarmonyOS 5.0.3 Release及以上

### 硬件

* 设备类型：华为手机（直板机）
* HarmonyOS版本：HarmonyOS 5.0.3 Release及以上


## 快速入门

###  配置工程

在运行此模板前，需要完成以下配置：

1. 在AppGallery Connect创建元服务，将包名配置到模板中。

   a. 参考[创建元服务](https://developer.huawei.com/consumer/cn/doc/app/agc-help-createharmonyapp-0000001945392297)为元服务创建APP ID，并将APP ID与元服务进行关联。

   b. 返回应用列表页面，查看元服务的包名。

   c. 将模板工程根目录下AppScope/app.json5文件中的bundleName替换为创建元服务的包名。

2. 配置华为账号服务。

   a. 将元服务的client ID配置到entry/src/main路径下的module.json5文件，详细参考：[配置Client ID](https://developer.huawei.com/consumer/cn/doc/atomic-guides/account-atomic-client-id)。

   b. 如需获取用户真实手机号，需要申请phone权限，详细参考：[配置scope权限](https://developer.huawei.com/consumer/cn/doc/atomic-guides/account-guide-atomic-permissions)，并在端侧使用快速验证手机号码Button进行[验证获取手机号码](https://developer.huawei.com/consumer/cn/doc/atomic-guides/account-guide-atomic-get-phonenumber)。

3. 配置地图服务。

   a. 将元服务的client ID配置到entry/src/main路径下的module.json5文件，如果华为账号服务已配置，可跳过此步骤。

   b. [开通地图服务](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/map-config-agc)。

4. 对元服务进行[手工签名](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ide-signing#section297715173233)。

5. 添加手工签名所用证书对应的公钥指纹。详细参考：[配置应用签名证书指纹](https://developer.huawei.com/consumer/cn/doc/app/agc-help-signature-info-0000001628566748#section5181019153511)。

6. （可选）如果从应用自己服务器请求数据，需要配置服务器请求信息。
   打开SchoolLife\commons\commonLib\src\main\ets\constants\CommonContants.ets文件，将BASE_URL修改为请求服务器的地址。

7. 修改自定义开学时间
   打开SchoolLife\commons\commonLib\src\main\ets\utils\ScheduleConfigUtil.ets，修改开学时间semesterStartTime为最近日期，即可看到正常课表信息

###  运行调试工程

1. 连接调试手机和PC。

2. 菜单选择“Run > Run 'entry' ”或者“Run > Debug 'entry' ”，运行或调试模板工程。

## 示例效果

界面展示

| 首页                                          | 我的                                         | 课表                                          | 日期选择                                         | 签到                                         |
|---------------------------------------------|--------------------------------------------|---------------------------------------------|----------------------------------------------|--------------------------------------------|
| <img src="screenshots/首页.jpg"  width="300"> | <img src="screenshots/我的.jpg" width="300"> | <img src="screenshots/课表.jpg"  width="300"> | <img src="screenshots/日期选择.jpg" width="300"> | <img src="screenshots/签到.jpg" width="300"> |

录屏展示

| 课堂签到                                            | 课程中心                                                    |
|-------------------------------------------------|---------------------------------------------------------|
| <img src="screenshots/checkin.gif" width="300"> | <img src="screenshots/course_schedule.gif" width="300"> |

## 权限要求

- 获取位置权限：ohos.permission.APPROXIMATELY_LOCATION、ohos.permission.LOCATION
- 网络权限：ohos.permission.INTERNET

## 开源许可协议

该代码经过[Apache 2.0 授权许可](http://www.apache.org/licenses/LICENSE-2.0)。