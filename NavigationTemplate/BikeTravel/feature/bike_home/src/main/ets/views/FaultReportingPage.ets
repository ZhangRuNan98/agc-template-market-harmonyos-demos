import { LengthMetrics, promptAction, PromptAction } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { image } from '@kit.ImageKit';
import fs from '@ohos.file.fs';
import { Logger, ScanUtils } from 'common';

@ComponentV2
export struct FaultReportingPage {
  @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack()
  @Local pixelMap: Array<image.PixelMap> = []
  @Local faultReasonsList: FaultReasonsItem[] = [new FaultReasonsItem('车辆异响'),
    new FaultReasonsItem('加油门不走'),
    new FaultReasonsItem('无挡风被'),
    new FaultReasonsItem('无法变速'),
    new FaultReasonsItem('刹车不灵敏'),
    new FaultReasonsItem('扎胎/爆胎')]
  private photoMax: number = 4
  @Local bikeId: string = ''
  @Local faultIssues: string = ''
  controller: TextAreaController = new TextAreaController()
  private faultIssuesMax: number = 50
  // 至少输入的问题字数
  private faultIssuesMin = 4

  build() {
    NavDestination() {
      Column({ space: 14 }) {
        Row() {
          TextInput({ placeholder: '扫码或输入车辆编号', text: this.bikeId })
            .fontSize(14)
            .fontWeight('medium')
            .placeholderColor(Color.Black)
            .layoutWeight(1)
            .onChange((value: string) => { // this.inputValue = value; // 同步输入值
              this.bikeId = value
            })
            .backgroundColor($r('app.color.pure_white'))
            .height(20)
            .padding({
              top:0,
              right:0,
              bottom:0,
              left:0
            })
            .borderRadius(0)

          // 扫码图标
          Image($r('app.media.Scan'))// 图片放在media目录
            .width(24)
            .height(24)
            .onClick(async () => {
              this.bikeId = await ScanUtils.getScanResult(this)
              Logger.info('the bike id is:', this.bikeId)
            })
        }
        .backgroundColor($r('app.color.pure_white'))
        .borderRadius(16)
        .width('100%')
        .height(44)
        .padding({
          right: 12,
          top: 10,
          bottom: 10,
          left: 12
        })

        Text('请选择故障类型（可多选）')
          .fontColor($r('app.color.tab_font_color'))
          .fontSize(12)

        this.faultReasons()

        Text('请上传故障照片')
          .fontColor($r('app.color.tab_font_color'))
          .fontSize(12)

        this.faultPhoto()

        TextArea({ text: this.faultIssues, placeholder: '请描述具体问题，最少4个字，最多50字', controller: this.controller })
          .fontSize(14)
          .placeholderColor($r('app.color.tab_font_color'))
          .height(120)
          .borderRadius(16)
          .textAlign(TextAlign.Start)
          .onChange((value: string) => {
            this.faultIssues = value
          })
          .showCounter(true, { thresholdPercentage: 1, highlightBorder: true })
          .maxLength(this.faultIssuesMax)
          .backgroundColor($r('app.color.pure_white'))

        Button('提交')
          .onClick(() => {
            if(this.bikeId) {
              this.faultReporting()
            } else {
              promptAction.showDialog({
                message: '请输入车辆编号'
              })
            }
          })
          .backgroundColor($r('app.color.orange'))
          .fontColor($r('app.color.pure_white'))
          .fontSize(16)
          .fontWeight('medium')
          .position({ bottom: 0, left: 0 })
          .width('100%')
      }
      .height('100%')
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 16, right: 16, top: 8 })
    }
    .title('故障申报')
    .backgroundColor($r('app.color.common_background'))
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }

  // 故障上报
  faultReporting() {
    if (this.faultIssues.length < this.faultIssuesMin) {
      this.showDialog()
      return
    }

    let todoFaultReasons = this.faultReasonsList.filter((item) => item.selected);

    console.log('BikeTravel 车辆编号：' + this.bikeId)
    console.log('BikeTravel 车辆故障原因：' + JSON.stringify(todoFaultReasons))
    this.pixelMap.forEach((item) => {
      this.packToFile(item).then((fileUrl) => {
        console.log('BikeTravel 图片：' + fileUrl)
      })
    })

    console.log('BikeTravel 具体问题：' + this.faultIssues)
    this.thankForReport()
  }

  thankForReport() {
    let uiContext = this.getUIContext();
    let promptAction: PromptAction = uiContext.getPromptAction();
    try {
      promptAction.showDialog({
        title: '非常感谢您的反馈',
        message: '单车出行有您更优秀，研发团队正在拼命优化中',
        buttons: [
          {
            text: '确定',
            color: Color.Blue.toString()
          }
        ]
      }, (err, data) => {
        if (err) {
          console.error('showDialog err: ' + err);
        } else {
          console.info('showDialog success callback, click button: ' + data.index);
        }
        this.pageInfos.pop()
      });
    } catch (error) {
      console.info('showDialog exception:' + JSON.stringify(error))
    }
  }

  showDialog() {
    let uiContext = this.getUIContext();
    let promptAction: PromptAction = uiContext.getPromptAction();
    try {
      promptAction.showDialog({
        message: `至少输入${this.faultIssuesMin}个字`,
      }, (err, data) => {
        if (err) {
          console.error('showDialog err: ' + err);
          return;
        }
        console.info('showDialog success callback, click button: ' + data.index);
      });
    } catch (error) {
      console.info('showDialog exception:' + JSON.stringify(error))
    }
  }

  //保存到沙盒路径
  async packToFile(pixelMap?: PixelMap): Promise<string> {
    // 获取应用文件路径
    let context = getContext(this) as common.UIAbilityContext;
    let filesDir: string = context.cacheDir;
    let picName = '/faultReporting' + new Date().getTime() + '.jpg'
    // 成功日志处理
    let file: fs.File = null!;
    // 新建并打开文件
    return new Promise(async (resolve) => {
      try {
        file = fs.openSync(filesDir + picName, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
        // 创建图像编码ImagePacker对象
        const imagePackerApi = image.createImagePacker();
        // 设置编码输出流和编码参数。format为图像的编码格式；quality为图像质量，范围从0-100，100为最佳质量
        const options: image.PackingOption = { format: 'image/jpeg', quality: 98 };
        await imagePackerApi.packToFile(pixelMap, file.fd, options)
        console.log(file.path);
        resolve(file.path);
      } catch (error) {
        let err: BusinessError = error as BusinessError;
        console.error(`open file failed with err: ${err.code}, ${err.message}`);
        resolve('')
      } finally {
        fs.closeSync(file);
      }
    })
  }

  @Builder
  faultPhoto() {
    Row({ space: 8 }) {
      if (this.pixelMap.length < this.photoMax) {
        Row() {
          Image($r('app.media.ic_public_plus'))
            .width(24)
            .height(24)
        }
        .onClick(() => {
          this.photoPicker();
        })
        .justifyContent(FlexAlign.Center)
        .width(80)
        .height(80)
        .borderRadius(8)
        .backgroundColor($r('app.color.pure_white'))
      }

      List({ space: 8 }) {
        ForEach(this.pixelMap, (item: image.PixelMap, index: number) => {
          ListItem() {
            Stack() {
              Image(this.pixelMap[index])
                .width(80)
                .borderRadius(8)
                .height(80)
              Image($r('app.media.ic_public_close'))
                .width(16)
                .borderRadius(8)
                .height(16)
                .backgroundColor(Color.Gray)
                .position({ x: 70, y: 0 })
                .onClick(() => {
                  this.pixelMap.splice(index, 1)
                })
            }
          }
        })
      }
      .listDirection(Axis.Horizontal)
      .layoutWeight(1)
      .height(85)
      .alignListItem(ListItemAlign.Center)
    }
  }

  @Builder
  faultReasons() {
    Flex({ wrap: FlexWrap.Wrap, space: { main: new LengthMetrics(14), cross: new LengthMetrics(12) } }) {
      ForEach(this.faultReasonsList, (item: FaultReasonsItem, index: number) => {
        ListItem() {
          Row() {
            Text(item.text)
              .fontSize(12)
              .fontWeight('medium')
              .fontColor(item.selected ? $r('app.color.pure_white') : $r('app.color.contentColor'))
              .textAlign(TextAlign.Center)
          }
          .onClick(() => {
            item.selected = !item.selected
          })
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .padding({ top: 6, bottom: 6 })
          .width('30%')
          .borderRadius(14)
          .backgroundColor(item.selected ? $r('app.color.orange') : $r('app.color.item_gray'))
        }
      })
    }
  }

  photoPicker() {
    try {
      let photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.maxSelectNumber = this.photoMax - this.pixelMap.length;
      let photoPicker = new photoAccessHelper.PhotoViewPicker();
      photoPicker.select(photoSelectOptions,
        (err: BusinessError, photoSelectResult: photoAccessHelper.PhotoSelectResult) => {
          if (err) {
            console.error(`PhotoViewPicker.select failed with err: ${err.code}, ${err.message}`);
            return;
          }
          console.info('PhotoViewPicker.select successfully, PhotoSelectResult uri: ' +
          JSON.stringify(photoSelectResult));
          const photoURLs = photoSelectResult.photoUris; // 图片Uris的数组
          photoURLs.forEach((url) => {
            this.getPixelMap(url)
          })
        });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`PhotoViewPicker failed with err: ${err.code}, ${err.message}`);
    }
  }

  async getPixelMap(url: string) {
    let file: fs.File = null!;
    try {
      file = fs.openSync(url, fs.OpenMode.READ_ONLY);
      this.pixelMap?.push(await image.createImageSource(file.fd).createPixelMap());
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`open file failed with err: ${err.code}, ${err.message}`);
    } finally {
      fs.closeSync(file);
    }
  }
}

// 定义列表项数据模型
@ObservedV2
class FaultReasonsItem {
  text: string;
  @Trace selected: boolean;

  constructor(content: string) {
    this.text = content;
    this.selected = false;
  }
}