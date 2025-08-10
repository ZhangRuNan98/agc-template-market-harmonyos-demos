// 一镜到底转场动画封装
import { curves, NodeController, UIContext, window } from '@kit.ArkUI';
import { RectInfoInPx } from './ComponentAttrUtils';
import { common } from '@kit.AbilityKit';

const DEVICE_BORDER_RADIUS: number = 34;


// 将自定义一镜到底转场动画进行封装，其他界面也需要做自定义一镜到底转场的话，可以直接复用，减少工作量
@ObservedV2
export class AnimationProperties {
  public windowWidth: number = 1080
  public windowHeight: number = 1920
  public navDestinationBgColor: ResourceColor = Color.Transparent;
  public translateX: number = 0;
  public translateY: number = 0;
  public scaleValue: number = 1;
  public clipWidth: Dimension = 0;
  public clipHeight: Dimension = 0;
  public radius: number = 0;
  public positionValue: number = 0;
  public showDetailContent: boolean = false;
  private uiContext: UIContext;

  constructor(uiContext: UIContext) {
    this.uiContext = uiContext;
    let context: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext
    let windowClass: window.Window = context.windowStage.getMainWindowSync();
    this.windowWidth = windowClass.getWindowProperties().windowRect.width;
    this.windowHeight = windowClass.getWindowProperties().windowRect.height;
  }

  public doAnimation(
    cardItemInfo: RectInfoInPx,
    isPush: boolean,
    isExit: boolean,
    transitionProxy: NavigationTransitionProxy,
    prePageOnFinish: (index: NodeController) => void,
    myNodeController: NodeController | undefined
  ): void {
    // 首先计算卡片的宽高与窗口宽高的比例
    let widthScaleRatio = cardItemInfo.width / this.windowWidth;
    let heightScaleRatio = cardItemInfo.height / this.windowHeight;
    let isUseWidthScale = widthScaleRatio > heightScaleRatio;
    let initScale: number = isUseWidthScale ? widthScaleRatio : heightScaleRatio;

    let initTranslateX: number = 0;
    let initTranslateY: number = 0;
    let initClipWidth: Dimension = 0;
    let initClipHeight: Dimension = 0;

    // 转场动画开始前通过计算scale、translate、position和clip height & width，确定节点迁移前后位置一致
    if (isUseWidthScale) {
      initTranslateX = this.uiContext.px2vp(cardItemInfo.left -
        (this.windowWidth - cardItemInfo.width) / 2);
      initClipWidth = '100%';
      initClipHeight = this.uiContext.px2vp((cardItemInfo.height) / initScale);
      initTranslateY = this.uiContext.px2vp(cardItemInfo.top -
        ((this.uiContext.vp2px(initClipHeight) -
          this.uiContext.vp2px(initClipHeight) * initScale) / 2)
      );
    } else {
      initTranslateY = this.uiContext.px2vp(cardItemInfo.top -
        (this.windowHeight - cardItemInfo.height) / 2
      );
      initClipHeight = '100%';
      initClipWidth = this.uiContext.px2vp((cardItemInfo.width) / initScale);
      initTranslateX = this.uiContext.px2vp(cardItemInfo.left -
        (this.windowWidth / 2 - cardItemInfo.width / 2)
      );
    }
    // 转场至新页面
    if (isPush && !isExit) {
      this.scaleValue = initScale;
      this.translateX = initTranslateX;
      this.clipWidth = initClipWidth;
      this.clipHeight = initClipHeight;
      this.translateY = initTranslateY;

      this.uiContext?.animateTo({
        curve: curves.interpolatingSpring(0, 1, 328, 36),
        onFinish: () => {
          if (transitionProxy) {
            transitionProxy.finishTransition();
          }
        }
      }, () => {
        this.scaleValue = 1.0;
        this.translateX = 0;
        this.translateY = 0;
        this.clipWidth = '100%';
        this.clipHeight = '100%';
        // 页面圆角与系统圆角一致
        this.radius = DEVICE_BORDER_RADIUS;
        this.showDetailContent = true;
      })

      this.uiContext?.animateTo({
        duration: 100,
        curve: Curve.Sharp,
      }, () => {
        // 页面由透明逐渐变为设置背景色
        this.navDestinationBgColor = '#00ffffff';
      })
    } else if (!isPush && isExit) {// 返回旧页面
      this.uiContext?.animateTo({
        duration: 350,
        curve: Curve.EaseInOut,
        onFinish: () => {
          if (transitionProxy) {
            transitionProxy.finishTransition();
          }
          prePageOnFinish(myNodeController);
        }
      }, () => {
        this.scaleValue = initScale;
        this.translateX = initTranslateX;
        this.translateY = initTranslateY;
        this.radius = 0;
        this.clipWidth = initClipWidth;
        this.clipHeight = initClipHeight;
        this.showDetailContent = false;
      })


      this.uiContext?.animateTo({
        duration: 200,
        delay: 150,
        curve: Curve.Friction,
      }, () => {
        this.navDestinationBgColor = Color.Transparent;
      })
    }
  }
}