# 检测应用更新快速入门

## 目录

- [简介](#简介)
- [约束与限制](#约束与限制)
- [快速入门](#快速入门)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

本组件提供了检测应用是否存在新版本功能。


| 检测新版本                                                                 | 
|-----------------------------------------------------------------------| 
| <img src="screenshots/check_new_version.jpg" alt="检测新版本" width="300"> |    

## 约束与限制
### 环境
* DevEco Studio版本：DevEco Studio 5.0.1 Release及以上
* HarmonyOS SDK版本：HarmonyOS 5.0.1(13) Release SDK及以上
* 设备类型：华为手机（直板机）
* HarmonyOS版本：HarmonyOS 5.0.1 Release及以上


## 快速入门

1. 安装组件。

    如果是在DevEvo Studio使用插件集成组件，则无需安装组件，请忽略此步骤。
	
	如果是从生态市场下载组件，请参考以下步骤安装组件。	
	
	a. 解压下载的组件包，将包中所有文件夹拷贝至您工程根目录的XXX目录下。

    b. 在项目根目录build-profile.json5添加check_app_update模块。

    ```typescript
    // 在项目根目录build-profile.json5填写check_app_update路径。其中XXX为组件存放的目录名
    "modules": [
        {
          "name": "check_app_update",
          "srcPath": "./XXX/check_app_update",
        }
    ]
    ```
    c. 在项目根目录oh-package.json5中添加依赖。
    ```typescript
    // XXX为组件存放的目录名称
    "dependencies": {
      "check_app_update": "file:./XXX/check_app_update"
    }
   ```

   d. 在项目根目录AppScope/resources下创建文件夹rawfile, 在rawfile文件夹下创建data.json文件, 内容如下
   ```json
   {
      "app_gallery_url": "https://appgallery.huawei.com/app/detail?id="
    }

   ```
   
2. 引入组件。

   ```typescript
   import { checkUpdate, DialogController, findNewVersion, Params } from 'check_app_update';
   ```
   
3. 调用组件。

```typescript
import { ComponentContent } from '@kit.ArkUI';
import { checkUpdate, DialogController, findNewVersion, Params } from 'check_app_update';
import { common } from '@kit.AbilityKit';

@Entry
@ComponentV2
struct Index {
  @Local message: string = "hello";
  private ctx: UIContext = this.getUIContext();

  aboutToAppear(): void {
    checkUpdate(this.getUIContext().getHostContext() as common.UIAbilityContext)
        .then(version => {
        // 0 不存在新版本， 1 存在新版本
        if (version === 1) {
        this.showCallDialog(version);
      } else {
        // mock 新版本
        this.showCallDialog(version);
      }
      })
    }

    showCallDialog(version: number) {
      DialogController.setContext(this.ctx);
      let contentNode: ComponentContent<object> =
        new ComponentContent(this.ctx, wrapBuilder(findNewVersion), new Params(version))
      DialogController.setContentNode(contentNode);
      DialogController.setOptions({alignment:DialogAlignment.Center,offset:{dx:0, dy:0}})
      DialogController.openDialog();
    }

    build() {
    
    }
}
```

## API参考

### 子组件

无

### 接口

无

检测应用更新组件。

**参数：**

| 参数名    | 类型                                   | 必填 | 说明         |
|--------|--------------------------------------|----|------------|
| params | [Params](#Params对象说明) | 是  | 向弹窗视图传递的参数 |

### Params对象说明

| 参数名  | 类型     | 必填 | 说明           |
|------|--------|----|--------------|
| text | number | 是  | 是否存在新版本的查询结果 |


## 示例代码
```typescript
import { ComponentContent } from '@kit.ArkUI';
import { checkUpdate, DialogController, findNewVersion, Params } from 'check_app_update';
import { common } from '@kit.AbilityKit';

@Entry
@ComponentV2
struct Index {
  @Local message: string = "hello";
  private ctx: UIContext = this.getUIContext();

    aboutToAppear(): void {
        checkUpdate(this.getUIContext().getHostContext() as common.UIAbilityContext)
            .then(version => {
            // 0 不存在新版本， 1 存在新版本
            if (version === 1) {
            this.showCallDialog(version);
          } else {
            // mock 新版本
            this.showCallDialog(version);
          }
        })
    }

    showCallDialog(version: number) {
      DialogController.setContext(this.ctx);
      let contentNode: ComponentContent<object> =
        new ComponentContent(this.ctx, wrapBuilder(findNewVersion), new Params(version))
      DialogController.setContentNode(contentNode);
      DialogController.setOptions({alignment:DialogAlignment.Center,offset:{dx:0, dy:0}})
      DialogController.openDialog();
    }

    build() {
    
    }
}
```


| 发现新版本                                                                  | 
|-----------------------------------------------------------------------| 
| <img src="screenshots/check_new_version.jpg" alt="发现新版本" width="300"> |

