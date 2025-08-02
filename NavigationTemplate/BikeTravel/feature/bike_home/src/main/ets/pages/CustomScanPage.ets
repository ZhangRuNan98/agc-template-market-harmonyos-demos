import { customScan, scanBarcode, scanCore } from '@kit.ScanKit';
// 导入功能涉及的权限申请、回调接口
import { display } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { abilityAccessCtrl, common } from '@kit.AbilityKit';
import { PermissionUtil } from 'common/src/main/ets/utils/PermissionUtil';
import { RouterPageEnum } from 'common';

const TAG: string = '[customScanPage]';

@ComponentV2
export struct CustomScanPage {
  @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack()
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  private mXComponentController: XComponentController = new XComponentController()
  @Local userGrant: boolean = false // 是否已申请相机权限
  @Local cameraHeight: number = 640 // 设置预览流高度，默认单位：vp
  @Local cameraWidth: number = 360 // 设置预览流宽度，默认单位：vp
  @Local offsetX: number = 0 // 设置预览流x轴方向偏移量，默认单位：vp
  @Local offsetY: number = 0 // 设置预览流y轴方向偏移量，默认单位：vp
  @Local displayHeight: number = 0 // 屏幕高度，单位vp
  @Local displayWidth: number = 0 // 屏幕宽度，单位vp
  @Local isFlashLightEnable: boolean = false // 是否开启了闪光灯
  @Local isSensorLight: boolean = false // 记录当前环境亮暗状态
  @Local surfaceId: string = '' // xComponent组件生成id
  @Local scanResult: Array<scanBarcode.ScanResult> = [] // 扫码结果

  async onShown() {
    this.userGrant = await PermissionUtil.checkPermissions(this.context,
      ['ohos.permission.CAMERA']);
    if (!this.userGrant) {
      this.userGrant = await this.cameraSetting()
    }
    if (this.userGrant)
    {
      let options: scanBarcode.ScanOptions = {
        scanTypes: [scanCore.ScanType.ALL],
        enableMultiMode: false,
        enableAlbum: false
      }
      // 设置预览流布局尺寸
      this.setDisplay()
      try {
        // 初始化接口
        customScan.init(options);
        // 返回该页面时重新启动相机
        if (this.mXComponentController.getXComponentSurfaceId() !== '') {
          this.initCamera();
        }
      } catch (error) {
        hilog.error(0x0001, TAG, `Failed to init customScan. Code: ${error.code}, message: ${error.message}`);
      }
    }
  }

  async cameraSetting() : Promise<boolean> {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    let context: Context = getContext(this) as common.UIAbilityContext;
    let grantStatus: Array<abilityAccessCtrl.GrantStatus> = await atManager.requestPermissionOnSetting(context, ['ohos.permission.CAMERA'])
    let applyResult: boolean = false;
      for (let res of grantStatus) {
        if (res === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
          applyResult = true;
        } else {
          applyResult = false
        }
      }
    return new Promise(async (resolve, reject) => {
      resolve(applyResult)
    })
  }

  onHidden() {
    // 页面消失或隐藏时，停止并释放相机流
    this.isFlashLightEnable = false;
    this.isSensorLight = false;
    try {
      customScan.off('lightingFlash');
    } catch (error) {
      hilog.error(0x0001, TAG, `Failed to off lightingFlash. Code: ${error.code}, message: ${error.message}`);
    }
    try {
      customScan.stop();
    } catch (error) {
      hilog.error(0x0001, TAG, `Failed to stop customScan. Code: ${error.code}, message: ${error.message}`);
    }
    try {
      // 自定义相机流释放接口
      customScan.release().then(() => {
        hilog.info(0x0001, TAG, 'Succeeded in releasing customScan by promise.');
      }).catch((error: BusinessError) => {
        hilog.error(0x0001, TAG,
          `Failed to release customScan by promise. Code: ${error.code}, message: ${error.message}`);
      })
    } catch (error) {
      hilog.error(0x0001, TAG, `Failed to release customScan. Code: ${error.code}, message: ${error.message}`);
    }
  }

  // 竖屏时获取屏幕尺寸，设置预览流全屏示例
  setDisplay() {
    try {
      // 默认竖屏
      let displayClass = display.getDefaultDisplaySync();
      this.displayHeight = px2vp(displayClass.height);
      this.displayWidth = px2vp(displayClass.width);
      let maxLen: number = Math.max(this.displayWidth, this.displayHeight);
      let minLen: number = Math.min(this.displayWidth, this.displayHeight);
      const RATIO: number = 16 / 9;
      this.cameraHeight = maxLen;
      this.cameraWidth = maxLen / RATIO;
      this.offsetX = (minLen - this.cameraWidth) / 2;
    } catch (error) {
      hilog.error(0x0001, TAG, `Failed to getDefaultDisplaySync. Code: ${error.code}, message: ${error.message}`);
    }
  }

  // 自定义扫码界面的顶部返回按钮和扫码提示
  @Builder
  TopTool() {
    Column() {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Image($r('app.media.close'))
          .height(40)
          .width(40)
          .onClick(async () => {
            this.pageInfos.pop()
          })
      }
      .padding({ left: 11, right: 11 })

      Column({space: 8}) {
        Text('扫描二维码')
          .fontSize(20)
          .fontWeight('medium')
          .fontColor('#FFFFFF')
        Text('使用华为智能设备扫描二维码，来完成xxx操作')
          .fontSize(14)
          .fontColor('#99FFFFFF')
      }
      .padding({ left: 36, right: 36, top: 24 })
    }
    .width('100%')
  }

  initCamera() {
    this.scanResult = [];
    let viewControl: customScan.ViewControl = {
      width: this.cameraWidth,
      height: this.cameraHeight,
      surfaceId: this.surfaceId
    };
    try {
      // 自定义启动第四步，请求扫码接口，通过Promise方式回调
      customScan.start(viewControl)
        .then(async (result: Array<scanBarcode.ScanResult>) => {
          hilog.info(0x0001, TAG, `result: ${JSON.stringify(result)}`);
          if (result.length) {
            // 解析码值结果跳转应用服务页
            this.scanResult = result;
            // 获取到扫描结果后暂停相机流
            try {
              customScan.stop();
            } catch (error) {
              hilog.error(0x0001, TAG, `Failed to stop customScan. Code: ${error.code}, message: ${error.message}`);
            }
            this.pageInfos.pop(this.scanResult[0].originalValue)
          }
        });
    } catch (error) {
      hilog.error(0x0001, TAG, `Failed to start customScan. Code: ${error.code}, message: ${error.message}`);
    }
  }

  build() {
    NavDestination() {
      Stack() {
        if (this.userGrant) {
          Column() {
            XComponent({
              id: 'componentId',
              type: XComponentType.SURFACE,
              controller: this.mXComponentController
            })
              .onLoad(async () => {
                hilog.info(0x0001, TAG, 'Succeeded in loading, onLoad is called.');
                // 获取XComponent组件的surfaceId
                this.surfaceId = this.mXComponentController.getXComponentSurfaceId();
                hilog.info(0x0001, TAG, `Succeeded in getting surfaceId: ${this.surfaceId}`);
                this.initCamera();
                // 闪光灯监听接口
                customScan.on('lightingFlash', (error, isLightingFlash) => {
                  if (error) {
                    hilog.error(0x0001, TAG,
                      `Failed to on lightingFlash. Code: ${error.code}, message: ${error.message}`);
                    return;
                  }
                  if (isLightingFlash) {
                    this.isFlashLightEnable = true;
                  } else {
                    try {
                      if (!customScan.getFlashLightStatus()) {
                        this.isFlashLightEnable = false;
                      }
                    } catch (error) {
                      hilog.error(0x0001, TAG,
                        `Failed to get FlashLightStatus. Code: ${error.code}, message: ${error.message}`);
                    }
                  }
                  this.isSensorLight = isLightingFlash;
                });
              })
              .width(this.cameraWidth)
              .height(this.cameraHeight)
              .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
          }
          .height('100%')
          .width('100%')
        }

        Column() {
          this.TopTool()

          Column() {
          }
          .layoutWeight(1)
          .width('100%')

          Column({ space: 48 }) {
            Column({ space: 8 }) {
              Image($r('app.media.light'))
                .height(40)
                .width(40)

              Text('轻触照亮')
                .fontWeight('medium')
                .fontSize(14)
                .fontColor($r('app.color.pure_white'))
            }
            .onClick(() => {
              let lightStatus: boolean = false;
              try {
                lightStatus = customScan.getFlashLightStatus();
              } catch (error) {
                hilog.error(0x0001, TAG,
                  `Failed to get flashLightStatus. Code: ${error.code}, message: ${error.message}`);
              }

              // 根据当前闪光灯状态，选择打开或关闭闪关灯
              if (lightStatus) {
                try {
                  customScan.closeFlashLight();
                  setTimeout(() => {
                    this.isFlashLightEnable = this.isSensorLight;
                  }, 200);
                } catch (error) {
                  hilog.error(0x0001, TAG,
                    `Failed to close flashLight. Code: ${error.code}, message: ${error.message}`);
                }
              } else {
                try {
                  customScan.openFlashLight();
                } catch (error) {
                  hilog.error(0x0001, TAG,
                    `Failed to open flashLight. Code: ${error.code}, message: ${error.message}`);
                }
              }
            })
            .visibility(this.userGrant? Visibility.Visible : Visibility.None)
            // .visibility((this.userGrant && this.isFlashLightEnable) ? Visibility.Visible : Visibility.None)


            Button('手动输入')
              .fontColor($r('app.color.pure_white'))
              .fontWeight('medium')
              .fontSize(16)
              .padding({
                left: 28,
                right: 28,
                top: 10,
                bottom: 10
              })
              .backgroundColor($r('app.color.scan_page'))
              .borderRadius(20)
              .onClick(() => {
                this.pageInfos.pushPathByName(RouterPageEnum.MANUAL_INPUT_ROUTER, null,
                  (res: PopInfo) => {
                    this.pageInfos.pop(res.result)
                  })
              })
              .visibility(this.userGrant? Visibility.Visible : Visibility.None)
          }
          .alignItems(HorizontalAlign.Center)
          .width('100%')
          .position({ bottom: 100 })
        }
      }
      .height('100%')
      .width('100%')
    }
    .onShown(() => {
      this.onShown()
    })
    .onHidden(() => {
      this.onHidden()
    })
    .hideTitleBar(true)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

  }
}
