import { IStyle } from './CommonConst';

@Builder
export function buildLoadingMask(showLoadingProgress: boolean = true): void {
  Column() {
    if (showLoadingProgress) {
      LoadingProgress()
        .width(32)
        .height(32)
    }
  }
  .width('100%')
  .height('100%')
  .padding({ bottom: IStyle.TITLE_BAR_HEIGHT })
  .justifyContent(FlexAlign.Center)
  .hitTestBehavior(HitTestMode.Block)
}
