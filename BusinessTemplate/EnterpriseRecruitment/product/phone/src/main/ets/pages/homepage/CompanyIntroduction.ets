import { AvoidArea, CommonConstants, LeftReturnComponent, TitleBar } from '@ohos_agcit/common_component';
import { AppStorageV2, router } from '@kit.ArkUI';

@Entry
@ComponentV2
export struct CompanyIntroduction {
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;

  @Local title: Resource = router.getParams() as Resource;

  build() {
    Scroll(){
      Column(){
        Row() {
          LeftReturnComponent()
            .onClick(() => {
              router.back();
            });
          TitleBar({ text: this.title });
        }
        .height(56)
        .alignItems(VerticalAlign.Center)
        .width(CommonConstants.FULL_WIDTH)
        .alignItems(VerticalAlign.Center);

        Column({ space: 16 }) {
          Text('公司的文化企业期望让每个员工提升能力，为每 个客观提升核心竞争力。\n' +
            '首先，这个目标强调了员工的个人发展，说明公司重视员工的能力提升，这可能包括培训、学习资源等。其次，核心竞争力的提升意味着公司希望在市场中更具竞争力，这可能与公司的战略目标相关。')
            .fontSize(16)
            .fontColor('rgba(0,0,0,0.90)')
            .lineHeight(25);

          Image($r('app.media.company_introduction_1'))
            .width('100%')
            .height(180);

          Text('接下来，我应该考虑如何实现这一目标。比如，公司可能会提供哪些培训机会，是否有鼓励员工自主学习的机制，或者有没有绩效评估体系来跟踪员工的进步。')
            .fontSize(16)
            .fontColor('rgba(0,0,0,0.90)')
            .lineHeight(25);

          Image($r('app.media.company_introduction_2'))
            .width('100%')
            .height(180);

          Text('最后，我应该总结这种文化带来的好处，并可能建议一些具体的方法来支持员工的发展，比如建立导师制度、提供学习补贴等。')
            .fontSize(16)
            .fontColor('rgba(0,0,0,0.90)')
            .lineHeight(25);
        }

      }
      .backgroundColor($r('app.color.common_background'))
      .padding({
        top: px2vp(this.avoidArea.topRectHeight),
        bottom: px2vp(this.avoidArea.bottomRectHeight),
        left: '4%',
        right: '4%'
      })
    }
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
  }
}