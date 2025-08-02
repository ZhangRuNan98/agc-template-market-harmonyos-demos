# 停车场卡片组件快速入门

## 目录

- [简介](#简介)
- [约束与限制](#约束与限制)
- [快速入门](#快速入门)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本模块为module_parking_map停车场地图列表组件和module_parking_spots停车场页签组件提供了基础能力。

<img src="./screenshots/park_base.jpeg" alt="基础" width="300" >

## 约束与限制

### 环境

* DevEco Studio版本：DevEco Studio 5.0.0 Release及以上
* HarmonyOS SDK版本：HarmonyOS 5.0.0 Release SDK及以上
* 设备类型：华为手机（直板机）
* HarmonyOS版本：HarmonyOS 5.0.0 Release及以上

### 权限

无

## 快速入门

1. 安装组件。

   如果是在DevEvo Studio使用插件集成组件，则无需安装组件，请忽略此步骤。

   如果是从生态市场下载组件，请参考以下步骤安装组件。

   a. 解压下载的组件包，将包中所有文件夹拷贝至您工程根目录的XXX目录下。

   b. 在项目根目录build-profile.json5添加module_parking_base模块。

   ```
   // 项目根目录下build-profile.json5填写module_parking_base路径。其中XXX为组件存放的目录名
   "modules": [
      {
      "name": "module_parking_base",
      "srcPath": "./XXX/module_parking_base"
      }
   ]
   ```

   ```
   // 在项目根目录oh-package.json5中添加依赖
   "dependencies": {
      "module_parking_base": "file:./XXX/module_parking_base"
   }
   ```

2. 引入组件句柄。

   ```
   import { BasicParkInfo, CommonSpotItem, ServiceUtil } from 'module_parking_base';
   ```

3. 停车场搜索。详细入参配置说明参见[API参考](#API参考)。

   ```
   ServiceUtil.searchParking({ latitude: 39.9, longitude: 116.4 })；
   ```

4. 停车场卡片展示。详细入参配置说明参见[API参考](#API参考)。

   ```
   CommonSpotItem({ item: this.spotInfoMock, selected: true })
   ```

## API参考

### 子组件

无

### 接口 

CommonSpotItem(options?: CommonSpotItemOptions)

停车场卡片组件。

**参数：**

| 参数名     | 类型                                                  | 必填 | 说明            |
|---------|-----------------------------------------------------|----|---------------|
| options | [CommonSpotItemOptions](#CommonSpotItemOptions对象说明) | 否  | 配置停车场卡片组件的参数。 |

### CommonSpotItemOptions对象说明

| 参数        | 类型                                                                                                                                                                                           | 是否必填 | 说明      |
|-----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------|---------|
| item      | [BasicParkInfo](#BasicParkInfo)                                                                                                                                                              | 是    | 停车场基本信息 |
| cardClick | number                                                                                                                                                                                       | 否    | 点击回调事件  |
| selected  | boolean                                                                                                                                                                                      | 否    | 是否选中高亮  |
| pad       | [Padding](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-types#padding) \| [Length](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-types#length) | 否    | 内边距     |

### BasicParkInfo

停车场基本信息类型。

| 字段名             | 类型                                                                                                                     | 说明     |
|-----------------|------------------------------------------------------------------------------------------------------------------------|--------|
| siteId          | string                                                                                                                 | ID     |
| name            | string                                                                                                                 | 简称     |
| addr            | string                                                                                                                 | 全称     |
| location        | [mapCommon.LatLng](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/map-common#section20691173773810) | 经纬度    |
| distance        | number                                                                                                                 | 距离     |
| totalSpots      | number                                                                                                                 | 总车位数   |
| leftSpots       | number                                                                                                                 | 剩余车位数  |
| chargeSpots     | number                                                                                                                 | 总充电位数  |
| leftChargeSpots | number                                                                                                                 | 剩余充电位数 |


### searchParking

ServiceUtil.searchParking(center: mapCommon.LatLng)

根据经纬度搜索附近停车场。

| 参数名    | 类型                                                                                                                     | 是否必填 | 说明   |
|--------|------------------------------------------------------------------------------------------------------------------------|------|------|
| center | [mapCommon.LatLng](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/map-common#section20691173773810) | 是    | 搜索中心 |


## 示例代码

本示例通过searchParking搜索指定位置附近停车场，并通过CommonSpotItem卡片组件实现展示。

```
import { BasicParkInfo, CommonSpotItem, ServiceUtil } from 'module_parking_base';

@Entry
@ComponentV2
struct Index {
  @Local spotInfo: BasicParkInfo | undefined = undefined;

  aboutToAppear(): void {
    ServiceUtil.searchParking({ latitude: 39.9, longitude: 116.4 }).then(res => {
      this.spotInfo = res.pop();
    });
  }

  build() {
    Column() {
      if (!this.spotInfo) {
        Column({ space: 10 }) {
          LoadingProgress().size({ width: 36, height: 36 })
          Text('搜索停车场中').fontSize(20)
        }
      } else {
        CommonSpotItem({ item: this.spotInfo, selected: true })
      }
    }
    .justifyContent(FlexAlign.Center)
    .padding(16)
    .width('100%')
    .height('100%')
  }
}
```