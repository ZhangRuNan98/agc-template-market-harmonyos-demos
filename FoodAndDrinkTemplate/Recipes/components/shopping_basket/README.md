# 菜篮子组件快速入门

## 目录

- [简介](#简介)
- [使用](#使用)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件提供了展示菜篮子页面的相关功能。


| 展示所有用料                                                   | 展示菜谱中用料                                                   |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./screenshot/ShoppingBasket1.png" width="300"> | <img src="./screenshot/ShoppingBasket2.png" width="300"> |


## 使用

1. 安装组件。
   将模板根目录的components下[base_ui](../../components/base_ui)和[shopping_basket](../../components/shopping_basket)目录拷贝至您工程根目录components/，并添加如下依赖。

   ```typescript
   // 模块下的oh-package.json5
   "dependencies": {
     "shopping_basket": "file:../components/shopping_basket"
   }
   
   // 模板根目录的build-profile.json5
   "modules": [
     {
       "name": "base_ui",
       "srcPath": "./components/base_ui",
     },
     {
       "name": "shopping_basket",
       "srcPath": "./components/shopping_basket",
     }
   ]
   ```
   
2. 引入组件。

   ```typescript
   import { ShoppingBasket } from 'shopping_basket';
   ```

3. 调用组件，详细参数配置说明参见[API参考](#API参考)。

   ```typescript
   ShoppingBasket({
     basketList: this.basketList.list,
     goRecipeDetail: (id: number) => {
       // 跳转菜谱详情
     },
     removeRecipe: (param: BasketItem) => {
       // 删除菜篮子里的菜谱
     },
   })
   ```

## API参考

### 接口

ShoppingBasket(options?: ShoppingBasketOptions)

展示菜篮子页面组件。

**参数：**

| 参数名     | 类型                                                  | 必填 | 说明          |
|---------|-----------------------------------------------------|----|-------------|
| options | [ShoppingBasketOptions](#ShoppingBasketOptions对象说明) | 否  | 展示菜篮子页面的参数。 |

### ShoppingBasketOptions对象说明

| 名称         | 类型                              | 必填 | 说明       |
|------------|---------------------------------|----|----------|
| basketList | [BasketItem](#BasketItem对象说明)[] | 否  | 菜篮子里菜谱列表 |

### BasketItem对象说明

| 名称           | 类型                                      | 必填 | 说明      |
|--------------|-----------------------------------------|----|---------|
| id           | number                                  | 是  | 菜谱序号    |
| title        | string                                  | 是  | 菜谱名称    |
| todoList     | [IngredientItem](#IngredientItem对象说明)[] | 是  | 菜谱待完成用料 |
| finishedList | [IngredientItem](#IngredientItem对象说明)[] | 是  | 菜谱已完成用料 |

### IngredientItem对象说明

| 名称       | 类型     | 必填 | 说明      |
|----------|--------|----|---------|
| name     | string | 是  | 用料名称    |
| quantity | string | 是  | 用料数量    |
| unit     | string | 否  | 用料单位    |
| sum      | string | 否  | 总用料     |
| sumArr   | string | 否  | 已完成用料数量 |

### 事件

支持以下事件：

#### goRecipeDetail

goRecipeDetail(callback: (id: number) => void)

跳转菜谱详情

#### removeRecipe

removeRecipe(callback: (param: [BasketItem](#BasketItem对象说明)) => void)

删除菜篮子里的菜谱
## 示例代码

```typescript
import { BasketItem, IngredientItem, ShoppingBasket } from 'shopping_basket';

@Entry
@ComponentV2
struct Index {
   @Local currentIndex: number = 1
   @Local basketList: BasketItem[] =
      [new BasketItem(1, '可乐鸡翅', [new IngredientItem('鸡翅', '500', '克'), new IngredientItem('可乐', '1', '罐')],
         []),
         new BasketItem(2, '西红柿牛腩',
            [new IngredientItem('牛腩', '500', '克'), new IngredientItem('西红柿', '3', '个')], [])]

   build() {
      RelativeContainer() {
         ShoppingBasket({
            basketList: this.basketList,
            goRecipeDetail: (id: number) => {
               // 跳转菜谱详情
            },
            removeRecipe: (param: BasketItem) => {
               // 删除菜篮子里的菜谱
            },
         })
      }
      .height('100%')
         .width('100%')
   }
}
```

<img src="./screenshot/ShoppingBasket3.png" width="300">