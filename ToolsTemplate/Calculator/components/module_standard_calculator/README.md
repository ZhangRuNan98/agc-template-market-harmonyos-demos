# 标准计算器组件快速入门

## 目录

- [简介](#简介)
- [约束与限制](#约束与限制)
- [快速入门](#快速入门)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件提供了标准计算器以及查看历史记录能力。

<img src="./screenshot/StandardCalcKeyboard.png" width="300">

## 约束与限制
### 环境
* DevEco Studio版本：DevEco Studio 5.0.4 Release及以上
* HarmonyOS SDK版本：HarmonyOS 5.0.4 Release SDK及以上
* 设备类型：华为手机（直板机）
* HarmonyOS版本：HarmonyOS 5.0.4(16)及以上

## 快速入门

1. 安装组件。

   如果是在DevEvo Studio使用插件集成组件，则无需安装组件，请忽略此步骤。

   如果是从生态市场下载组件，请参考以下步骤安装组件。

   a. 解压下载的组件包，将包中所有文件夹拷贝至您工程根目录的XXX目录下。

   b. 在项目根目录build-profile.json5添加module_standard_calculator和module_base_apis模块。

    ```typescript
    // 在项目根目录build-profile.json5填写module_base_apis和module_standard_calculator路径。其中XXX为组件存放的目录名
    "modules": [
        {
        "name": "module_base_apis",
        "srcPath": "./XXX/module_base_apis",
        },
        {
        "name": "module_standard_calculator",
        "srcPath": "./XXX/module_standard_calculator",
        }
    ]
    ```
   c. 在项目根目录oh-package.json5中添加依赖。
    ```typescript
    // XXX为组件存放的目录名称
    "dependencies": {
      "module_standard_calculator": "file:./XXX/module_standard_calculator"
    }
   ```

2. 引入组件与计算器组件句柄。。

   ```typescript
   import { StandardCalculator } from 'module_standard_calculator';
   ```

3. 调用组件，详细参数配置说明参见[API参考](#API参考)。

   ```typescript
   import { StandardCalculator } from 'module_standard_calculator';

   @Entry
   @ComponentV2
   struct Index {
      @Local stack: NavPathStack = new NavPathStack()
      build() {
         Navigation(this.stack) {
            Column() {
               StandardCalculator({ routerModule: this.stack })
            }
         }
      }
   }
   ```

## API参考

StandardCalculator({routerModule: NavPathStack})

**参数：**

| 参数名        | 类型                                                         | 是否必填 | 说明  |
| ----------- | ------------------------------------------------------------ |------|-----|
| routerModule | [NavPathStack](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-basic-components-navigation#navpathstack10) | 是    | 路由栈 |


标准计算器以及查看历史记录功能。

## 示例代码
   ```typescript
   import { StandardCalculator } from 'module_standard_calculator';

   @Entry
   @ComponentV2
   struct Index {
      @Local stack: NavPathStack = new NavPathStack()
      build() {
         Navigation(this.stack) {
            Column() {
               StandardCalculator({ routerModule: this.stack })
            }
         }.title('示例')
      }
   }
   ```
<img src="./screenshot/StandardCalcKeyboardDemo.png" width="300">