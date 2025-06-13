# 组件基础能力快速入门

## 目录

- [简介](#简介)
- [使用](#使用)
- [API参考](#API参考)

## 简介

本组件提供components目录下组件的基础能力集合。

## 使用

1. 安装组件。

   需要将模板根目录的components下[module_base](../module_base)目录拷贝至您的工程相应目录，并添加依赖。

```
"dependencies": {
  "module_base": "file:../module_base"
}
```

2. 引入组件。

```
import { CommonUtils, PopViewUtils } from 'module_base';
```

## API参考

### 公共方法

#### CommonUtil

通用方法类

##### assign

assign(target: Object, ...source: Object[])

对象赋值

##### encryptPhoneNo

encryptPhoneNo(phoneNo: string): string

手机号码中间四位隐藏

##### getAddressesFromLocationName

getAddressesFromLocationName(position: string)

根据地址获取经纬度

##### rand

rand(min: number, max: number): number

随机四位数

##### copyText

copyText(text: string)

剪贴板内容

#### PopViewUtils

基础弹窗类

---

#### ControllerModule

tab控制类

---

#### Logger

日志打印类

---

#### PickerUtil

拉起相册类

---

#### PreferenceUtil

首选项类

---

#### ScanUtil

扫码类

---

#### TelUtil

打电话类

---

#### WindowUtil

窗口工具类

### 公共常量

#### RouterMap枚举说明

| 名称             | 说明     |
|:---------------|:-------|
| ADDRESS_MANAGE | 地址管理页面 |
| EDIT_ADDRESS   | 编辑地址页面 |

#### AppStorageMap枚举说明

| 名称         | 说明    |
|:-----------|:------|
| UI_CONTEXT | UI上下文 |
