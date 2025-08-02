import { hilog } from '@kit.PerformanceAnalysisKit';
import { inputMethod } from '@kit.IMEKit';
import { camera } from '@kit.CameraKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';

@ComponentV2
export struct ManualInput {
  @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack()
  @Local codeTxt: string = '';
  private inputController: inputMethod.InputMethodController = inputMethod.getController();
  private isAttach: boolean = false;
  private isTorch: camera.TorchMode = camera.TorchMode.OFF;

  // 单个验证码的格式
  @Styles
  fancyUse(){
    .width(50)
    .border({
      width: 1,
      color: '#1a000000',
      style: BorderStyle.Solid
    })
    .borderRadius(8)
    .backgroundColor($r('app.color.pure_white'))
  }

  /*
 * 订阅输入法回调
 */
  async attachListener(): Promise<void> {
    // 将焦点放到输入框
    focusControl.requestFocus('customInput');
    // 输入法配置项
    let textConfig: inputMethod.TextConfig = {
      inputAttribute: {
        textInputType: inputMethod.TextInputType.NUMBER,
        enterKeyType: inputMethod.EnterKeyType.GO
      }
    };
    // 控件绑定输入法
    await this.inputController.attach(true, textConfig)
    if (!this.isAttach) {
      // 订阅输入法应用插入文本事件
      this.inputController.on('insertText', (text) => {
        if (this.codeTxt.length >= 6) {
          return
        }
        this.codeTxt += text;
        hilog.info(0x0001, 'testTag', 'this.inputText', 'insertText this.inputText===' + this.codeTxt)
      })

      // 订阅输入法应用向左删除事件
      this.inputController.on('deleteLeft', (length) => {
        this.codeTxt = this.codeTxt.substring(0, this.codeTxt.length - 1);
        hilog.info(0x0001, 'testTag', 'this.inputText', 'deleteLeft  this.inputText===' + this.codeTxt,
          'length' + length)
      })
      this.isAttach = true;
    }
  }

  async off() {
    await this.inputController.detach()
    this.isAttach = false;
    this.inputController.off('insertText')
    this.inputController.off('deleteLeft')
  }

  @Builder
  buildCustomInput() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.SpaceBetween
    }) {
      Text(this.codeTxt[0])
        .fontSize(24)
        .textAlign(TextAlign.Center)
        .fancyUse()
        .height(50)

      Text(this.codeTxt[1])
        .fontSize(24)
        .textAlign(TextAlign.Center)
        .fancyUse()
        .height(50)

      Text(this.codeTxt[2])
        .fontSize(24)
        .textAlign(TextAlign.Center)
        .fancyUse()
        .height(50)


      Text(this.codeTxt[3])
        .fontSize(24)
        .textAlign(TextAlign.Center)
        .fancyUse()
        .height(50)


      Text(this.codeTxt[4])
        .fontSize(24)
        .textAlign(TextAlign.Center)
        .fancyUse()
        .height(50)


      Text(this.codeTxt[5])
        .fontSize(24)
        .textAlign(TextAlign.Center)
        .fancyUse()
        .height(50)
    }
    .id('customInput')
    .onBlur(() => {
      this.off();
    })
    .onClick(async () => {
      this.attachListener()
    })
  }

  build() {
    NavDestination() {
      Column() {
        Column({ space: 15 }) {
          this.buildCustomInput()

          Text('请输入6位车辆编号')
            .fontColor($r('app.color.tab_font_color'))
            .fontSize(14)

          Row({ space: 4 }) {
            Image($r('app.media.attention_gray'))
              .height(16)
              .width(16)

            Text('6位车辆编号一般位于车辆后轮左侧')
              .fontColor($r('app.color.tab_font_color'))
              .fontSize(12)
          }

          Button('确认')
            .backgroundColor($r('app.color.orange'))
            .fontColor($r('app.color.pure_white'))
            .fontSize(16)
            .fontWeight('medium')
            .width('100%')
            .onClick(() => {
              if (this.codeTxt.length === 6){
                this.pageInfos.pop(this.codeTxt)
              } else {
                promptAction.showToast({ message: '请输入正确车辆编号！' })
              }
            })
        }
        .padding({ left: 16, right: 16, top: 24 })
        .alignItems(HorizontalAlign.Start)

        Column({ space: 8 }) {
          Image($r('app.media.light_orange'))
            .height(40)
            .width(40)
            .onClick(() => {
              let context = getContext(this) as common.BaseContext;
              try {
                let cameraManager = camera.getCameraManager(context)
                this.isTorch = cameraManager.getTorchMode()
                if (cameraManager.isTorchSupported()) {
                  if (this.isTorch === camera.TorchMode.OFF) {
                    cameraManager.setTorchMode(camera.TorchMode.ON)
                  } else {
                    cameraManager.setTorchMode(camera.TorchMode.OFF)
                  }
                }
              } catch (error) {
                // 失败返回错误码error.code并处理。
                let err = error as BusinessError;
                console.error(`The setTorchMode call failed. error code: ${err.code}`);
              }
            })

          Text('轻触照亮')
            .fontWeight('medium')
            .fontSize(14)
            .fontColor($r('app.color.orange'))
        }
        .alignItems(HorizontalAlign.Center)
        .width('100%')
        .position({ bottom: 200 })
      }
      .height('100%')
      .alignItems(HorizontalAlign.Center)

    }
    .backgroundColor($r('app.color.common_background'))
    .title('手动输入')
  }
}