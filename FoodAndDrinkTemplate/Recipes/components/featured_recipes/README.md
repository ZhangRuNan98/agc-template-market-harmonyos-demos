# 瀑布流组件快速入门

## 目录

- [简介](#简介)
- [使用](#使用)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件提供了展示菜谱列表搜瀑布流的相关功能。

<img src="./screenshot/FeaturedRecipes1.png" width="300">

## 使用

1. 安装组件。
   将模板根目录的components下[featured_recipes](../../components/featured_recipes)目录拷贝至您工程根目录components/，并添加如下依赖。
   ```typescript
   // 模块下的oh-package.json5
   "dependencies": {
     "featured_recipes": "file:../components/featured_recipes"
   }
   
   // 模板根目录的build-profile.json5
   "modules": [
     {
       "name": "featured_recipes",
       "srcPath": "./components/featured_recipes",
     }
   ]
   ```

2. 引入组件。

   ```typescript
   import { FeaturedRecipes } from 'featured_recipes';
   ```

3. 调用组件，详细参数配置说明参见[API参考](#API参考)。

   ```typescript
   FeaturedRecipes({
      dishesList: this.vm.dishesList,
      showTitle: true,
      onClickCb: (id: number) => {
        // 点击跳转菜谱详情
      },
      jumpBloggerInfo: (id: number) => {
        // 点击跳转菜谱作者主页
      },
    })
   ```

## API参考

### 接口

FeaturedRecipes(options?: FeaturedRecipesOptions)

展示菜谱列表搜瀑布流组件。

**参数：**

| 参数名     | 类型                                                    | 必填 | 说明                     |
|---------|-------------------------------------------------------|----|------------------------|
| options | [FeaturedRecipesOptions](#FeaturedRecipesOptions对象说明) | 否  | 展示菜谱列表搜瀑布流的参数。 |

### FeaturedRecipesOptions对象说明

| 名称         | 类型                                                                             | 必填 | 说明      |
|------------|--------------------------------------------------------------------------------|----|---------|
| dishesList | [LazyDataSource](#LazyDataSource对象说明)<[RecipeBriefInfo](#RecipeBriefInfo对象说明)> | 否  | 菜谱懒加载列表 |
| showTitle  | boolean                                                                        | 否  | 是否展示标题  |
| canDelete  | boolean                                                                        | 否  | 是否可以删除  |
| isToDelete | boolean                                                                        | 否  | 是否是删除状态 |

### LazyDataSource对象说明

| 名称        | 类型                                        | 必填 | 说明   |
|-----------|-------------------------------------------|----|------|
| dataArray | [RecipeBriefInfo](#RecipeBriefInfo对象说明)[] | 是  | 菜谱列表 |

### RecipeBriefInfo对象说明

| 名称           | 类型     | 必填 | 说明     |
|--------------|--------|----|--------|
| id           | number | 是  | 菜谱序号   |
| title        | string | 是  | 菜谱名称   |
| description  | string | 否  | 菜谱描述   |
| category     | string | 否  | 菜谱分类   |
| cookingTime  | number | 否  | 菜谱制作时间 |
| difficulty   | string | 否  | 菜谱难度   |
| authorId     | number | 是  | 作者id序号 |
| author       | string | 是  | 作者名称   |
| authorAvatar | string | 是  | 作者头像   |
| thumbnail    | string | 是  | 菜谱缩略图  |
| views        | number | 否  | 浏览数    |
| likes        | number | 是  | 收藏数    |

### 事件

支持以下事件：

#### onClickCb

onClickCb(callback: (id: number) => void)

点击跳转菜谱详情

#### jumpBloggerInfo

jumpBloggerInfo(callback: (id: number) => void)

点击跳转菜谱作者主页

#### deleteRecipes

deleteRecipes(callback: (ids: number[]) => void)

点击删除菜谱事件

#### changeSelect

changeSelect(callback: (id: number,flag:boolean) => void)

删除时点击修改选中菜谱事件

#### changeDeleteState

changeDeleteState(callback: (isToDelete:boolean) => void)

长按菜谱时触发删除状态变更

## 示例代码

```typescript
import { FeaturedRecipes, LazyDataSource, RecipeBriefInfo } from 'featured_recipes';

@Entry
@ComponentV2
struct Index {
   @Local dishesList: LazyDataSource<RecipeBriefInfo> = new LazyDataSource();

   aboutToAppear(): void {
      this.dishesList.pushArrayData([{
         id: 1,
         title: '西红柿炒鸡蛋',
         authorId: 1,
         author: '美食博主',
         authorAvatar: 'startIcon',
         thumbnail: 'startIcon',
         likes: 100,
      } as RecipeBriefInfo, {
         id: 2,
         title: '可乐鸡翅',
         authorId: 1,
         author: '美食博主',
         authorAvatar: 'startIcon',
         thumbnail: 'startIcon',
         likes: 100,
      } as RecipeBriefInfo])
   }

   build() {
      RelativeContainer() {
         FeaturedRecipes({
            dishesList: this.dishesList,
            showTitle: true,
            onClickCb: (id: number) => {
               // 点击跳转菜谱详情
            },
            jumpBloggerInfo: (id: number) => {
               // 点击跳转菜谱作者主页
            },
         })
      }
      .height('100%')
         .width('100%')
   }
}
```

<img src="./screenshot/FeaturedRecipes1.png" width="300">