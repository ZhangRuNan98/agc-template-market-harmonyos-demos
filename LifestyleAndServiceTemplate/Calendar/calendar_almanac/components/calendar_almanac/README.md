# 黄历组件快速入门

## 目录

- [简介](#简介)
- [使用](#使用)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

黄历组件支持日期动态选择，阴历阳历、五行等信息展示。

<img src="./screenshot/CalendarAlmanac.png">

## 使用

1. 组件依赖

   由于CalendarAlmanac组件依赖**base_apis** har包以及**lunar、dayjs**三方库，所以需要将模板根目录的components下**base_apis** 目录拷贝至您的工程相应目录

   ```typescript
   // date_toggle har包依赖情况
   "dependencies": {
       "lunar": "^1.0.0",
       "dayjs": "^1.11.13",
       "base_apis": "file:../base_apis",
   }
   ```

2. 安装组件。

   ```typescript
   // 在项目根目录build-profile.json5填写calendar_almanac和base_apis路径
     "modules": [
       {
         "name": "calendar_almanac",
         "srcPath": "./calendar_almanac",
       },
       {
         "name": "base_apis",
         "srcPath": "./base_apis",
       }
     ]
   ```

   ```typescript
   "dependencies": {
     "calendar_almanac": "file:../calendar_almanac"
   }
   ```

3. 引入组件。

   ```typescript
    import { CalendarAlmanac } from 'calendar_almanac';
   ```

4. 调用组件，详细参数配置说明参见[API参考](#API参考)。

   ```typescript
   // 引入组件
   import { CalendarAlmanac } from 'calendar_almanac';
   
   @Entry
   @Component
   struct Index {
     build() {
       Column() {
         CalendarAlmanac({
           selectDate: new Date('2025-06-01'),
           arrowColor: 'standard',
           selectTextColor: '#c4272b',
           onDateChange: (date: Date) => {
             console.log('日期切换，当前的日期是' + date);
           },
         });
       }
     }
   }
   ```

## API参考

### 子组件

无

### 接口

CalendarAlmanac(options?: CalendarAlmanacOptions)

日历黄历组件，支持日期动态选择，阴历阳历、五行等信息展示。

**参数：**

| 参数名  | 类型                                                      | 必填 | 说明             |
| ------- | --------------------------------------------------------- | ---- | ---------------- |
| options | [CalendarAlmanacOptions](#CalendarAlmanacOptions对象说明) | 否   | 黄历组件的参数。 |

### CalendarAlmanacOptions对象说明

| 名称        | 类型                                                                                                    | 必填 | 说明                           |
| ----------- |-------------------------------------------------------------------------------------------------------| ---- |------------------------------|
| selectDate  | string                                                                                                | 否   | 传入当前日期，默认当日日期 时间格式YYYY-MM-DD |
| selectTextColor | [ResourceStr](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-types#resourcestr) | 否   | 文本按钮颜色，默认颜色#c4272b           |
| arrowColor     | 'standard'\|'blue' \|'red'                                                                               | 否   | 左右切换箭头颜色，默认主题颜色standard         |

### 事件

支持以下事件：

#### onDateChange

onDateChange(callback: date:Date)) => void)

日期变化事件，返回当前日期

## 示例代码

### 示例1（修改传入日期）

本示例通过selectDate实现不同日期的切换。
   ```typescript
   // 引入组件
   import { CalendarAlmanac } from 'calendar_almanac';
   
   @Entry
   @Component
   struct Index {
     build() {
       Column() {
         CalendarAlmanac({
            selectDate: new Date('2025-06-01'),
            arrowColor: "blue",
            selectTextColor: "#c4272b",
         });
       }
     }
   }
   ```
<img src="./screenshot/CalendarAlmanac_1.png">