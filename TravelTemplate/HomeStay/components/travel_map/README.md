# 地图（定位选点）组件快速入门

## 目录

- [简介](#简介)
- [使用](#使用)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件提供地图展示能力，并支持地图定位和选点定制功能。

| 全屏地图                           | 嵌入式地图                          |
|--------------------------------|--------------------------------|
| <img src="screenshots/full.jpg" width="300"> | <img src="screenshots/part.jpg" width="300"> |

## 使用

1. 安装组件。

   需要将模板根目录的components下[travel_map](../travel_map)目录拷贝至您工程根目录components/，并添加依赖和module声明。

```
// main/oh-package.json5
"dependencies": {
  "travel_map": "file:../components/travel_map"
}

// build-profile.json5
"modules": [
  {
    "name": "travel_map",
    "srcPath": "./components/travel_map",
  }
]
```

2. 引入组件。

```
import { CommonMap } from 'travel_map';
```

3. 配置地图相关权限。

   在主工程的module.json5文件中配置如下地图相关权限。
```
"requestPermissions": [
      {
        "name": "ohos.permission.LOCATION",
        "reason": "$string:add_remark",
        "usedScene": {
          "abilities": [
            "EntryAbility"
          ],
          "when": "inuse"
        }
      },
      {
        "name": "ohos.permission.APPROXIMATELY_LOCATION",
        "reason": "$string:about",
        "usedScene": {
          "abilities": [
            "EntryAbility"
          ],
          "when": "inuse"
        }
      }
    ],
```

## API参考

### DateInfo(travelMapOptions: TravelMapOptions)

#### TravelMapOptions对象说明

| 参数名              | 类型            | 必填 | 说明       |
|:-----------------|:--------------|:---|:---------|
| location       | [Location](#Location类型说明)      | 是  | 位置信息     |
| icon       | ResourceStr   | 是  | 标记点图标    |
| titleOptions       | [TitleOptions](#TitleOptions类型说明)  | 是  | 标记点名称属性  |
| cameraSpeed       | number        | 是  | 相机定位移动速度 |
| zoom       | number        | 是  | 地图放大倍数   |
| height       | number/string | 是  | 地图高度     |
| pointClickCallBack       | () => void    | 是  | 标记点点击回调  |

#### Location类型说明

| 参数名       | 类型     | 必填 | 说明 |
|:----------|:-------|:---|:---|
| latitude  | number | 是  | 纬度 |
| longitude | number | 是  | 经度 |



#### TitleOptions类型说明

| 参数名                | 类型     | 必填 | 说明 |
|:-------------------|:-------|:---|:---|
| name              | string | 是  | 标记点名称 |
| strokeColor      | number | 是  | 标记点展示颜色 |

## 示例代码

```
import { CommonMap } from 'travel_map';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
export struct Home {
  build() {
    Column() {
      CommonMap(
        {
          travelMapOptions: {
            location: {
              latitude: 30.56,
              longitude: 119.89,
            },
            icon: $r('app.media.point'),
            titleOptions: {
              name: '原舍望山民宿',
              strokeColor: 0xFFFFFFFF,
            },
            cameraSpeed: 1000,
            zoom: 10,
            height: '100%',
            pointClickCallBack: () => {
              promptAction.showToast({ message: '点击标记点' });
            },
          },
        });
    };
  }
}
```
