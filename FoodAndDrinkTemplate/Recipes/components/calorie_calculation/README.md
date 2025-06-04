# 热量计算组件快速入门

## 目录

- [简介](#简介)
- [使用](#使用)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件提供了展示卡路里计算和统计的相关功能。

| 计算卡路里                                                   | 统计卡路里                                                   |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./screenshot/CalorieCalculation1.png" width="300"> | <img src="./screenshot/CalorieCalculation2.png" width="300"> |




## 使用

1. 安装组件。
   需要将模板根目录的components下[base_ui](../../components/base_ui)和[calorie_calculation](../../components/calorie_calculation)目录拷贝至您工程根目录components/，并添加如下依赖。
   ```typescript
   // 模块下的oh-package.json5
   "dependencies": {
     "calorie_calculation": "file:../components/calorie_calculation"
   }
   
   // 模板根目录的build-profile.json5
   "modules": [
     {
       "name": "base_ui",
       "srcPath": "./components/base_ui",
     },
     {
       "name": "calorie_calculation",
       "srcPath": "./components/calorie_calculation",
     }
   ]
   ```

2. 引入组件。

   ```typescript
   import { CalorieCalculation } from 'calorie_calculation';
   ```

3. 调用组件，详细参数配置说明参见[API参考](#API参考)。

   ```typescript
   CalorieCalculation({
      seriesData: this.vm.seriesData,
      dietPlanList: this.vm.dietPlanList,
      addMeal: (id: number) => {
        RouterModule.push(RouterMap.DIET_PLAN_PAGE, { 'id': id } as Record<string, number>,
          (popInfo: PopInfo) => {
            this.vm.init()
          })
      },
    })
   ```

## API参考

### 接口

CalorieCalculation(options?: CalorieCalculationOptions)

展示卡路里计算和统计组件。

**参数：**

| 参数名     | 类型                                                          | 必填 | 说明             |
|---------|-------------------------------------------------------------|----|----------------|
| options | [CalorieCalculationOptions](#CalorieCalculationOptions对象说明) | 否  | 展示卡路里计算和统计的参数。 |

### CalorieCalculationOptions对象说明

| 名称           | 类型          | 必填 | 说明      |
|--------------|-------------|----|---------|
| seriesData   | number[]    | 否  | 每日摄入卡路里 |
| dietPlanList | [DietPlans](#DietPlans对象说明)[] | 否  | 卡路里餐食计划 |

### DietPlans对象说明

| 名称            | 类型                 | 必填 | 说明       |
|---------------|--------------------|----|----------|
| id            | number             | 否  | 餐食计划id   |
| name          | string             | 否  | 餐食计划名称   |
| desc          | string             | 否  | 餐食计划描述   |
| totalCalories | number             | 否  | 餐食计划总卡路里 |
| foodList      | [FoodPlanCalories](#FoodPlanCalories对象说明)[] | 否  | 餐食计划食物列表 |

### FoodPlanCalories对象说明

| 名称       | 类型     | 必填 | 说明    |
|----------|--------|----|-------|
| id       | number | 否  | 食物id  |
| name     | string | 否  | 食物名称  |
| weight   | number | 否  | 食物重量  |
| calories | number | 否  | 食物卡路里 |

### 事件

支持以下事件：

#### addMeal

addMeal(callback: (id: number) => void)

点击添加餐食计划的回调。

## 示例代码

```typescript
import { CalorieCalculation, DietPlans, FoodPlanCalories } from 'calorie_calculation';
import { promptAction } from '@kit.ArkUI';

@Entry
@ComponentV2
struct Index {
   @Local seriesData: number[] = [1500, 1250, 1200, 1280, 1650, 1700, 1600];
   @Local dietPlanList: DietPlans[] =
      [new DietPlans(1, '早餐', '描述', 100, [new FoodPlanCalories(1, '面包', 100, 100)])];

   build() {
      RelativeContainer() {
         CalorieCalculation({
            seriesData: this.seriesData,
            dietPlanList: this.dietPlanList,
            addMeal: (id: number) => {
               promptAction.showToast({ message: '跳转加餐' })
            },
         })
      }
      .height('100%')
         .width('100%')
   }
}
```

<img src="./screenshot/CalorieCalculation1.png" width="300">