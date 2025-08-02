import { CallbackParam, CardRecognition, CardSide, CardType, ShootingMode } from '@kit.VisionKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
const TAG = 'CardRecognition'

@ComponentV2
export struct FrontID {
  @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack();

  build() {
    Column() {
      //身份证
      CardRecognition({
        supportType: CardType.CARD_ID,
        // 身份证可双面识别
        cardSide: CardSide.FRONT,
        cardRecognitionConfig: {
          defaultShootingMode: ShootingMode.MANUAL,
          isPhotoSelectionSupported: true
        },
        callback: ((params: CallbackParam) => {
          hilog.info(0x0001, TAG, `params cardInfo front: ${JSON.stringify(params.cardInfo?.front)}`)
          this.pageInfos.pop(params.cardInfo?.front.cardImageUri)
        })
      })
    }
    .height('100%')
    .width('100%')
  }
}