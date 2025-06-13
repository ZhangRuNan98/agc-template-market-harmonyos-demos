# 地址管理组件快速入门

## 目录

- [简介](#简介)
- [前提](#前提)
- [使用](#使用)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件提供地址管理相关功能。

| 地址列表                                         | 地址编辑                                        |
|----------------------------------------------|---------------------------------------------|
| <img src="screenshots/list.png" width="300"> | <img src="screenshots/add.png" width="300"> |

## 使用

1. 安装组件。

   由于地址管理场景组件依赖module_base、module_city组件，所以需要将模板根目录的components下
   [module_base](../module_base)、[module_city](../module_city)、[module_address](../module_address)
   目录拷贝至您的工程相应目录，并添加依赖。

```
"dependencies": {
  "module_address": "file:../module_address"
}
```

## API参考

不涉及。

## 示例代码

```
@Entry
@ComponentV2
struct AddrSample1 {
  stack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.stack) {
      Column({ space: 10 }) {
        Text('地址管理').fontSize(20).fontWeight(FontWeight.Bold)
        Button('go').width('100%').onClick(() => {
          this.stack.pushPath({
            name: 'AddressPage',
          })
        })
      }
      .padding(10)
    }
    .hideTitleBar(true)
  }
}
```

```
@Entry
@ComponentV2
struct AddrSample2 {
  stack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.stack) {
      Column({ space: 10 }) {
        Text('地址编辑管理').fontSize(20).fontWeight(FontWeight.Bold)
        Button('go').width('100%').onClick(() => {
           const param: ParamAddressPage = {
              type: TypeAddressPage.EDIT,
              param: address,
            };
          this.stack.pushPath({
            name: RouterMap.EDIT_ADDRESS_PAGE,
            param: param,
          })
        })
      }
      .padding(10)
    }
    .hideTitleBar(true)
  }
}
```
