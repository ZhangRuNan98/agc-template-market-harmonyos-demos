# 装修表单组件快速入门

## 目录

- [简介](#简介)
- [约束与限制](#约束与限制)
- [快速入门](#快速入门)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件提供装修表单组件。

<img src="screenshot/form.png" width="300">

## 约束与限制

### 环境

* DevEco Studio版本：DevEco Studio 5.0.4 Release及以上
* HarmonyOS SDK版本：HarmonyOS 5.0.4 Release SDK及以上
* 设备类型：华为手机（直板机）
* HarmonyOS版本：HarmonyOS 5.0.4 Release及以上

## 快速入门

1. 安装组件。

   如果是在DevEvo Studio使用插件集成组件，则无需安装组件，请忽略此步骤。

   如果是从生态市场下载组件，请参考以下步骤安装组件。
   a. 解压下载的组件包，将包中所有文件夹拷贝至您工程根目录的XXX目录下。

   b. 在项目根目录build-profile.json5添加module_decoration_form模块。

    ```typescript
    // 在项目根目录build-profile.json5填写module_decoration_form路径。其中XXX为组件存放的目录名
    "modules": [
        {
        "name": "module_decoration_form",
        "srcPath": "./XXX/module_decoration_form",
        }
    ]
    ```
   c. 在项目根目录oh-package.json5中添加依赖。
    ```typescript
    // XXX为组件存放的目录名称
    "dependencies": {
      "module_decoration_form": "file:./XXX/module_decoration_form"
    }
   ```

2. 引入组件。

    ```
    import { FormDecoration } from 'module_decoration_form';
    ```


## API参考

### FormDecoration(option: FormDecorationOptions)

#### FormDecorationOptions对象说明

| 参数名          | 类型                                                    | 是否必填 | 说明                              |
|:-------------|:------------------------------------------------------|:-----|:--------------------------------|
| buttonText   | string                                                | 否    | 提交按钮文本                          |
| homeType     | string                                                | 否    | 所选中房屋类型对应value，默认值第一个选项对应的value |
| address      | string                                                | 否    | 小区地区                            |
| cellName     | string                                                | 否    | 小区名称                            |
| area         | string                                                | 否    | 房屋面积                            |
| homeLayout   | [HomeLayout](#HomeLayout对象说明)                         | 否    | 房屋户型                            |
| typeOptions  | [TypeOption](#TypeOption对象说明)[]                       | 否    | 房屋类型选项信息                        |
| onFormSubmit | (data: [DecorationData](#DecorationData对象说明)) => void | 否    | 表单提交的回调事件                       |

#### TypeOption对象说明

| 参数名   | 类型     | 是否必填 | 说明      |
|:------|:-------|:-----|:--------|
| label | string | 是    | 房屋类型名称  |
| value | string | 是    | 房屋类型对应值 |
| desc  | string | 是    | 补充说明    |

#### HomeLayout对象说明

| 参数名      | 类型     | 是否必填 | 说明    |
|:---------|:-------|:-----|:------|
| room     | string | 是    | 卧室数量  |
| hall     | string | 是    | 客厅数量  |
| washroom | string | 是    | 卫生间数量 |
| kitchen  | string | 是    | 厨房数量  |
| balcony  | string | 是    | 阳台数量  |

#### DecorationData对象说明

| 参数名        | 类型                            | 说明              |
|:-----------|:------------------------------|:----------------|
| homeLayout | [HomeLayout](#HomeLayout对象说明) | 小区户型            |
| homeType   | string                        | 所选中房屋类型对应value值 |
| address    | string                        | 小区地区            |
| cellName   | string                        | 小区名称            |
| area       | string                        | 房屋面积            |

## 示例代码

```
import { promptAction } from '@kit.ArkUI';
import { FormDecoration } from 'module_decoration_form';

@Entry
@ComponentV2
struct Index {
  build() {
    Column() {
      FormDecoration({
        onFormSubmit: (data) => {
          console.log('填写的房屋信息为', JSON.stringify(data));
          promptAction.showToast({ message: '提交成功！' });
        },
      });
    }.backgroundColor($r('sys.color.background_secondary')).padding(16).height('100%');
  }
}
```
