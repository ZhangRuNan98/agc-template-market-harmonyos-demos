# 实名认证场景组件快速入门

## 目录

- [简介](#简介)
- [前提](#前提)
- [使用](#使用)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件提供实名认证场景组件。

<img src="screenshots/auth.png" width="300">

## 前提

## 使用

1. 安装组件。

   由于实名认证场景组件依赖module_base、module_auth，所以需要将模板根目录的components下
   [module_base](../module_base)、[lib_foundation](../../commons/lib_foundation)
   目录拷贝至您的工程相应目录，并添加依赖。

```
"dependencies": {
  "module_auth": "file:../module_auth"
}
```

## API参考

由于本组件内流程闭环，以页面的方式注册并对外提供，不涉及API介绍。

## 示例代码

### 示例1

```
@Entry
@ComponentV2
struct AddrSample {
  stack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.stack) {
      Column({ space: 10 }) {
        Text('实名认证').fontSize(20).fontWeight(FontWeight.Bold)
        Button('go').width('100%').onClick(() => {
          this.stack.pushPath({
            name: 'RealNameAuthPage',
          })
        })
      }
      .padding(10)
    }
    .hideTitleBar(true)
  }
}
```
