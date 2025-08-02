import { CommonConstants } from '../constants/CommonConstants';
import { BreakPointController } from '../controller/BreakPointController';

@ComponentV2
export struct FilterButton {
  private breakPointController: BreakPointController = BreakPointController.instance;

  @Param clickIndex: number = 0;
  @Param selfIndex: number = 0;
  @Param title: string = '';
  @Event invoke: (index: number) => void = () => {
  }

  build() {
    Text(this.title)
      .fontWeight(FontWeight.Medium)
      .fontColor(this.selfIndex === this.clickIndex ? Color.White : 'rgba(0,0,0,0.90)')
      .backgroundColor(this.selfIndex === this.clickIndex ? $r('app.color.common_blue') : $r('app.color.button_gray'))
      .padding({
        left: this.breakPointController.jobBarPadding,
        right: this.breakPointController.jobBarPadding,
        top: 9,
        bottom: 9
      })
      .borderRadius(21)
      .onClick(() => {
        this.invoke(this.selfIndex)
      })
  }
}