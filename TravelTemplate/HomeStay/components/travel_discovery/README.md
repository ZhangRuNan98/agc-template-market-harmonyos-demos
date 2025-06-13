# 游记组件快速入门

## 目录

- [简介](#简介)
- [使用](#使用)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件提供游记浏览搜索、详情查看及评论等功能。

<img src="screenshots/discovery.jpg" width="300">

## 使用

1. 安装组件。

   需要将模板根目录的components下[travel_discovery](../travel_discovery)目录拷贝至您工程根目录components/，并添加依赖和module声明。

```
// main/oh-package.json5
"dependencies": {
  "travel_discovery": "file:../components/travel_discovery"
}

// build-profile.json5
"modules": [
  {
    "name": "travel_discovery",
    "srcPath": "./components/travel_discovery",
  }
]
```

2. 引入组件。

```
import { PageGround } from 'travel_discovery';
```

## API参考

### PageGround(isShowBack: boolean)

#### 参数说明

| 参数名              | 类型                                | 必填 | 说明     |
|:-----------------|:----------------------------------|:---|:-------|
| isShowBack       | boolean                       | 是  | 是否展示返回 |

## 示例代码

```
import { PageGround } from 'travel_discovery';

@Entry
@Component
struct Main {
  build() {
    NavDestination() {
      Column() {
        PageGround({
          isShowBack: false,
        })
      }
    }
  }
}
```
