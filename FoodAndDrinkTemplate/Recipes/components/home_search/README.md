# 搜索组件快速入门

## 目录

- [简介](#简介)
- [使用](#使用)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件提供了搜索菜谱，并展示搜索结果的相关功能。

| 搜索                                                   | 结果展示                                                   |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./screenshot/HomeSearch1.png" width="300"> | <img src="./screenshot/HomeSearch2.png" width="300"> |

## 使用

1. 安装组件。
   将模板根目录的components下[home_search](../../components/home_search)目录拷贝至您工程根目录components/，并添加如下依赖。
   ```typescript
   // 模块下的oh-package.json5
   "dependencies": {
     "home_search": "file:../components/home_search"
   }
   
   // 模板根目录的build-profile.json5
   "modules": [
     {
       "name": "home_search",
       "srcPath": "./components/home_search",
     }
   ]
   ```

2. 引入组件。

   ```typescript
   import { HomeSearch } from 'home_search';
   ```

3. 调用组件，详细参数配置说明参见[API参考](#API参考)。

   ```typescript
   HomeSearch({
       hotInfo: this.vm.hotInfo,
       resultList: this.vm.resultList,
       paramsKeyword: this.vm.paramsKeyword,
       isShowResult: this.vm.isShowResult,
       isShowSearch: this.vm.formPage === CommonConstants.CLASSIFICATION_PAGE,
       searchDishes: (keyword: string) => {
         // 调用搜索查询事件
       },
       changeIndex: (index: number, keyword: string) => {
         // 切换搜索排序的事件
       },
       changeShowResult: (flag: boolean) => {
         // 切换展示搜索结果的事件
       },
       goRecipeDetail: (id: number) => {
         // 跳转菜谱详情事件
       },
     })
   ```

## API参考

### 接口

HomeSearch(options?: HomeSearchOptions)

搜索菜谱组件。

**参数：**

| 参数名     | 类型                                          | 必填 | 说明       |
|---------|---------------------------------------------|----|----------|
| options | [HomeSearchOptions](#HomeSearchOptions对象说明) | 否  | 搜索菜谱的参数。 |

### HomeSearchOptions对象说明

| 名称            | 类型                                        | 必填 | 说明       |
|---------------|-------------------------------------------|----|----------|
| hotInfo       | string[]                                  | 否  | 热门搜索     |
| resultList    | [RecipeBriefInfo](#RecipeBriefInfo对象说明)[] | 否  | 搜索结果     |
| paramsKeyword | string                                    | 否  | 默认搜索词    |
| isShowResult  | boolean                                   | 否  | 是否展示搜索结果 |
| isShowSearch  | boolean                                   | 否  | 是否展示搜索框  |

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

#### searchDishes

searchDishes(callback: (keyword: string) => void)

调用搜索查询事件
#### changeIndex

changeIndex(callback: (index: number, keyword: string) => void)

切换搜索排序的事件
#### changeShowResult

changeShowResult(callback: (flag: boolean) => void)

切换展示搜索结果的事件
#### goRecipeDetail

goRecipeDetail(callback: (id: number) => void)

跳转菜谱详情事件
## 示例代码

```typescript
import { RecipeBriefInfo } from 'featured_recipes';
import { HomeSearch } from 'home_search';


@Entry
@ComponentV2
struct Index {
   @Local hotInfo: string[] = ['西红柿炒鸡蛋', '可乐鸡翅']
   @Local resultList: RecipeBriefInfo[] = [{
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
   } as RecipeBriefInfo];

   build() {
      RelativeContainer() {
         HomeSearch({
            hotInfo: this.hotInfo,
            resultList: this.resultList,
            paramsKeyword: '',
            isShowResult: true,
            isShowSearch: true,
            searchDishes: (keyword: string) => {
               // 调用搜索查询事件
            },
            changeIndex: (index: number, keyword: string) => {
               // 切换搜索排序的事件
            },
            changeShowResult: (flag: boolean) => {
               // 切换展示搜索结果的事件
            },
            goRecipeDetail: (id: number) => {
               // 跳转菜谱详情事件
            },
         })
      }
      .height('100%')
         .width('100%')
   }
}
```

