# 搜索组件快速入门

## 目录

- [简介](#简介)
- [使用](#使用)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件提供了搜索文本的模板，开发者可以根据业务需要快速搭建搜索页面。

<img src="./screenshot/0012.jpg" width="300">

## 使用

1. 在项目中安装组件，需要将模板根目录的components下search目录拷贝至您的工程相应目录。
    ```
   // 在项目根目录build-profile.json5填写search路径
   "modules": [
   {
   "name": "search",
   "srcPath": "./search",
   }
   ]
   ```
   ```
   // 在entry目录下oh-package.json5填写依赖情况
   "dependencies": {
      "search": "file:../search"
     }
   ```

2. 引入搜索组件句柄

   ```
   import { SearchPage } from 'search';
   ```
3. 调用组件，详细参数配置说明参见[API参考](#API参考)。

   ``` 
   import { SearchPage } from 'search';
   
   @Entry
   @Component
   struct Index {
     build() {
       Column() {
         // 搜索页面
         SearchPage({
           mockSearchValue: "会计",
           searchSourceData: ["2023初级会计-初级会计实务题库", "初级会计实务", "初级会计实务真题", "初级会计实务真题",
             "2024初级会计经济法冲刺"],
           initParam: () => {
             console.log("搜索页面初始化")
           },
           clickSearchItem: (data) => {
             console.log("点击搜索按钮")
           },
           back: () => {
             console.log("点击返回按钮")
           },
         })
       }
       .width('100%')
       .height('100%')
     }
   }
   ```

## API参考

### 接口

SearchPage({mockSearchValue?:string,searchSourceData?:string[]})

搜索组件。

**参数：**

| 参数名              | 类型       | 必填 | 说明         |
|:-----------------|:---------|:---|:-----------|
| mockSearchValue  | string   | 否  | 标识传入页面的搜索值 | | 否  | 传入页面的搜索值                                                                                                                          |
| searchSourceData | string[] | 否  | 搜索源数据      | | 否  | 搜索源数据                                                                                                                           |

### 事件

支持以下事件：

#### initParam

initParam: () => void = () => {}

初始化搜索页面的事件。

#### clickSearchItem

clickSearchItem: () => void = () => {}

搜索结果的一项的点击事件

#### back

back: () => void = () => {}

回退按钮回调函数。

## 示例代码

   ``` 
   import { SearchPage } from 'search';
   
   @Entry
   @Component
   struct Index {
     build() {
       Column() {
         // 搜索页面
         SearchPage({
           mockSearchValue: "会计",
           searchSourceData: ["2023初级会计-初级会计实务题库", "初级会计实务", "初级会计实务真题", "初级会计实务真题",
             "2024初级会计经济法冲刺"],
           initParam: () => {
             console.log("搜索页面初始化")
           },
           clickSearchItem: (data) => {
             console.log("点击搜索按钮")
           },
           back: () => {
             console.log("点击返回按钮")
           },
         })
       }
       .width('100%')
       .height('100%')
     }
   }
   ```
