# 上传菜谱组件快速入门

## 目录

- [简介](#简介)
- [使用](#使用)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件提供了上传菜谱的相关功能，上传的图片目前保存在沙箱，如需上传至服务器需要自行实现。

<img src="./screenshot/UploadRecipe1.png" width="300">

## 使用

1. 安装组件。
   将模板根目录的components下[upload_recipe](../../components/upload_recipe)目录拷贝至您工程根目录components/，并添加如下依赖。

   ```typescript
   // 模块下的oh-package.json5
   "dependencies": {
     "upload_recipe": "file:../components/upload_recipe"
   }
   
   // 模板根目录的build-profile.json5
   "modules": [
     {
       "name": "upload_recipe",
       "srcPath": "./components/upload_recipe",
     }
   ]
   ```

2. 引入组件。

   ```typescript
   import { UploadRecipe } from 'upload_recipe';
   ```

3. 调用组件，详细参数配置说明参见[API参考](#API参考)。

   ```typescript
   UploadRecipe({
     uploadRecipe: (data: UploadRecipeData) => {
       // 调用上传菜谱接口
     },
   })
   ```

## API参考

### 接口
UploadRecipe(options?: UploadRecipeOptions)

上传菜谱组件。


### UploadRecipeData对象说明

| 名称          | 类型                                        | 必填 | 说明    |
|-------------|-------------------------------------------|----|-------|
| title       | string                                    | 否  | 菜谱标题  |
| mainImg     | string                                    | 否  | 菜谱缩略图 |
| description | string                                    | 否  | 菜谱描述  |
| ingredients | [RecipeIngredient](#RecipeIngredient对象说明) | 否  | 用料列表  |
| steps       | [Step](#Step对象说明)                         | 否  | 步骤列表  |

### RecipeIngredient对象说明

| 名称       | 类型     | 必填 | 说明   |
|----------|--------|----|------|
| name     | string | 是  | 用料名称 |
| quantity | string | 是  | 用料数量 |
| unit     | string | 是  | 用料单位 |

### Step对象说明

| 名称          | 类型     | 必填 | 说明   |
|-------------|--------|----|------|
| description | string | 是  | 步骤描述 |
| stepImg     | string | 是  | 步骤图  |

### 事件

支持以下事件：

#### uploadRecipe

uploadRecipe(callback: (data: [UploadRecipeData](#UploadRecipeData对象说明)) => void)

调用上传菜谱接口

## 示例代码

```typescript
import { promptAction } from '@kit.ArkUI';
import { UploadRecipe, UploadRecipeData } from 'upload_recipe';

@Entry
@ComponentV2
struct Index {
   build() {
      RelativeContainer() {
         UploadRecipe({
            uploadRecipe: (data: UploadRecipeData) => {
               promptAction.showToast({ message: '上传成功' })
            },
         })
      }
      .height('100%')
         .width('100%')
   }
}
```

<img src="./screenshot/UploadRecipe1.png" width="300">