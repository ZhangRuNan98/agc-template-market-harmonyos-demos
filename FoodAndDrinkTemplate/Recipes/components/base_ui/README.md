# BaseTabs组件快速入门

## 目录

- [简介](#简介)
- [使用](#使用)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件提供了展示tab栏的相关功能。

<img src="./screenshot/BaseTabs1.png" width="300">

## 使用

1. 安装组件。
   将模板根目录的components下[base_ui](../../components/base_ui)目录拷贝至您工程根目录components/，并添加如下依赖。

   ```typescript
   // 模块下的oh-package.json5
   "dependencies": {
     "base_ui": "file:../components/base_ui"
   }
   
   // 模板根目录的build-profile.json5
   "modules": [
     {
       "name": "base_ui",
       "srcPath": "./components/base_ui",
     }
   ]
   ```
   
2. 引入组件。

   ```typescript
   import { BaseTabs } from 'base_ui';
   ```

3. 调用组件，详细参数配置说明参见[API参考](#API参考)。

   ```typescript
   BaseTabs({
     tabsTitle: ['菜谱', '收藏'], 
     currentIndex: this.vm.currentIndex, 
     changeTabs: (index: number) => {
       this.vm.changeTabs(index)
     },
   })
   ```

## API参考

### 接口

BaseTabs(options?: BaseTabsOptions)

展示tab栏组件。

**参数：**

| 参数名     | 类型                                      | 必填 | 说明         |
|---------|-----------------------------------------|----|------------|
| options | [BaseTabsOptions](#BaseTabsOptions对象说明) | 否  | 展示tab栏的参数。 |

### BaseTabsOptions对象说明

| 名称           | 类型       | 必填 | 说明       |
|--------------|----------|----|----------|
| tabsTitle    | string[] | 否  | tab栏文字标题 |
| currentIndex | number   | 是  | 当前选中的tab |

## 示例代码

```typescript
// 引入组件
import { BaseTabs } from 'base_ui';

@Entry
@Component
struct Index {
   @State currentIndex: number = 1;

   build() {
      RelativeContainer() {
         BaseTabs({
            tabsTitle: ['菜谱', '收藏'],
            currentIndex: this.currentIndex,
            changeTabs: (index: number) => {
               this.currentIndex = index
            },
         })
      }
      .height('100%')
         .width('100%')
   }
}

```

<img src="./screenshot/BaseTabs1.png" width="300">