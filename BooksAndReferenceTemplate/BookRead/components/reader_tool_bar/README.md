# 阅读器工具栏组件快速入门

## 目录

- [简介](#简介)
- [约束与限制](#约束与限制)
- [快速入门](#快速入门)
- [API参考](#API参考)
- [示例代码](#示例代码)

## 简介

阅读器工具栏支持打开书籍目录，并跳转到目标章节，调节屏幕亮度，切换深浅色模式，设置字号、字体、行间距、背景颜色和翻页方式。

<img src="./screenshot/example_tool.png">

## 约束与限制

### 环境

- DevEco Studio版本：DevEco Studio 5.0.4 Release及以上
- HarmonyOS SDK版本：HarmonyOS 5.0.4 Release SDK及以上
- 设备类型：华为手机（直板机）
- HarmonyOS版本：HarmonyOS 5.0.4(16)及以上

## 快速入门

1. 安装组件
   如果是在DevEvo Studio使用插件集成组件，则无需安装组件，请忽略此步骤。
   如果是从生态市场下载组件，请参考以下步骤安装组件。  
   a. 解压下载的组件包，将包中所有文件夹拷贝至您工程根目录的xxx目录下。  
   b. 在项目根目录build-profile.json5并添加reader_tool_bar和base_common模块。
    ```typescript
    // 在项目根目录的build-profile.json5填写reader_tool_bar和base_common路径。其中xxx为组件存在的目录名
     "modules": [
        {
          "name": "reader_tool_bar",
        "srcPath": "./xxx/reader_tool_bar",
        },
        {
          "name": "base_common",
        "srcPath": "./xxx/base_common",
        }
     ]
    ```
   c. 在项目根目录oh-package.json5中添加依赖
    ```typescript
    // xxx为组件存放的目录名称
    "dependencies": {
      "reader_tool_bar": "file:./xxx/reader_tool_bar",
      "base_common": "file:./xxx/base_common"
    }
    ```

2. 引入组件。

    ```typescript
    import { ReaderToolBar } from 'reader_tool_bar';
    ```

3. 调用组件。详细参数配置说明参见[API参考](#API参考)。

    ```typescript
    ReaderToolBar({
      spineList: this.spineList,
      catalogItemList: this.catalogItemList,
      readerSetting: this.readerSetting,
      lockedStatus: this.lockedStatus,
      curChapterId: this.curChapterId,
      bookParserHandler: this.bookParserHandler,
      readerComponentController: this.readerComponentController,
    })
    ```

## API参考

### 接口

    ReaderToolBar({
      spineList: bookParser.SpineItem[],
      catalogItemList: bookParser.CatalogItem[],
      readerSetting: readerCore.ReaderSetting,
      lockedStatus: boolean[],
      curChapterId: number,
      bookParserHandler: bookParser.BookParserHandler,
      readerComponentController: readerCore.ReaderComponentController,
    })

展示阅读器工具栏页面组件。

**参数：**

| 名称                      | 类型                                                                            | 是否必填 | 说明               |
| ------------------------- |-------------------------------------------------------------------------------| -------- | ------------------ |
| spineList                 | bookParser.[SpineItem](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/reader-book-parser#section1029864651619)[]                           | 是       | 书籍的书脊项列表   |
| catalogItemList           | bookParser.[CatalogItem](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/reader-book-parser#section12325515195) []                      | 是       | 书籍目录项列表     |
| readerSetting             | readerCore.[ReaderSetting](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/reader-read-core#section13615732174218)                     | 是       | 阅读设置项         |
| lockedStatus              | boolean[]                                                                     | 是       | 需要付费的章节列表 |
| curChapterId              | number                                                                        | 是       | 当前阅读的章节数   |
| bookParserHandler         | bookParser.[BookParserHandler](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/reader-book-parser#section59035422210)             | 是       | 书籍解析句柄       |
| readerComponentController | readerCore.[ReaderComponentController](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/reader-read-core#section1917812014110) | 是       | 阅读组件控制器     |


## 示例代码

```typescript
// 引入组件
import { ReaderToolBar } from 'reader_tool_bar';
import { bookParser, readerCore, ReadPageComponent } from '@kit.ReaderKit';
import { common } from '@kit.AbilityKit';
import { buffer } from '@kit.ArkTS';
import { fileIo } from '@kit.CoreFileKit';
import { display } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@ComponentV2
struct Index {
  pageInfo:NavPathStack = new NavPathStack()
  @Local spineList: bookParser.SpineItem[] = []
  @Local catalogItemList: bookParser.CatalogItem[] = []
  @Local lockedStatus: boolean[] = []
  @Local curChapterId: number = 0
  @Local bookParserHandler: bookParser.BookParserHandler | null = null;
  @Local readerComponentController: readerCore.ReaderComponentController =
    new readerCore.ReaderComponentController();
  @Local readerSetting: readerCore.ReaderSetting = {
    fontName: '',
    fontPath: '',
    fontSize: 18,
    fontColor: '#000000E6',
    fontWeight: 100,
    lineHeight: 2,
    nightMode: false,
    themeColor: 'rgba(251, 240, 219, 1)',
    themeBgImg: '',
    flipMode: '0',
    scaledDensity: display.getDefaultDisplaySync().scaledDensity > 0 ? display.getDefaultDisplaySync().scaledDensity :
      1,
    viewPortWidth: 700, // 应该设为实际的屏幕尺寸
    viewPortHeight: 2000 // 应该设为实际的屏幕尺寸
  }
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  private resourceRequest: bookParser.CallbackRes<string, ArrayBuffer> = (fontName: string): ArrayBuffer => {
    if (this.isFont(fontName)) {
      let res = $rawfile(this.readerSetting.fontPath);
      let context = this.getUIContext().getHostContext();
      if (res && context) {
        try {
          // 获取资源路径下的字体数据
          let value: Uint8Array = context.resourceManager.getRawFileContentSync(this.readerSetting.fontPath);
          hilog.info(0x0000, 'testTag', 'resourceRequest : get success');
          return value.buffer as ArrayBuffer;
        } catch (error) {
          let code = (error as BusinessError).code;
          let message = (error as BusinessError).message;
          hilog.error(0x0000, 'testTag',
            `callback getRawFileContent failed, error code: ${code}, message: ${message}.`);
        }
      }
    }
    return new ArrayBuffer(0);
  }

  private isFont(filePath: string): boolean {
    let options = ['.ttf', '.woff2', '.otf'];
    let path = filePath.toLowerCase();
    let result = path.indexOf(options[0]) !== -1 || path.indexOf(options[1]) !== -1 || path.indexOf(options[2]) !== -1;
    hilog.info(0x0000, 'testTag', 'isFont = ' + result);
    return result;
  }

  async aboutToAppear() {
    let uint8Array: Uint8Array = this.context.resourceManager.getRawFileContentSync("example.epub");
    let bf = buffer.from(uint8Array).buffer;
    let filePath: string = getContext(this).cacheDir + "/abc.epub";
    // 打开文件
    const file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.READ_ONLY | fileIo.OpenMode.CREATE | fileIo.OpenMode.TRUNC)
    fileIo.writeSync(file.fd, bf);

    fileIo.closeSync(file)
    let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let initPromise: Promise<void> = this.readerComponentController.init(context);
    let defaultHandlerPromise: Promise<bookParser.BookParserHandler> =
      bookParser.getDefaultHandler(filePath);
    let result: [bookParser.BookParserHandler, void] = await Promise.all([defaultHandlerPromise, initPromise]);
    this.bookParserHandler = result[0];
    // 获取目录列表
    this.catalogItemList = this.bookParserHandler.getCatalogList() || [];
    // 获取书脊内容列表
    this.spineList = this.bookParserHandler.getSpineList();
    this.readerComponentController.registerBookParser(this.bookParserHandler);
    this.readerComponentController.setPageConfig(this.readerSetting)
    this.readerComponentController.on('resourceRequest', this.resourceRequest);
    this.readerComponentController.on('pageShow', (data: readerCore.PageDataInfo): void => {
      hilog.info(0x0000, 'testTag', 'pageshow: data is: ' + JSON.stringify(data));
      if (data.state === readerCore.PageState.PAGE_ON_SHOW) {
        let spineItem = this.spineList[data.resourceIndex]
        let catalogItem = this.catalogItemList.filter(item => item.resourceFile === spineItem.href)
        this.curChapterId = catalogItem[0].catalogId
      }
    })
    this.readerComponentController.startPlay(0, '');

  }

  build() {
    Navigation(this.pageInfo) {
      Stack({ alignContent: Alignment.Bottom }) {
        ReadPageComponent({
          controller: this.readerComponentController,
          readerCallback: (err, data: readerCore.ReaderComponentController) => {
            this.readerComponentController = data;
          }
        })
        ReaderToolBar({
          spineList: this.spineList,
          catalogItemList: this.catalogItemList,
          readerSetting: this.readerSetting,
          lockedStatus: this.lockedStatus,
          curChapterId: this.curChapterId,
          bookParserHandler: this.bookParserHandler,
          readerComponentController: this.readerComponentController,
        })
      }
    }
    .hideTitleBar(true)
  }
}
```