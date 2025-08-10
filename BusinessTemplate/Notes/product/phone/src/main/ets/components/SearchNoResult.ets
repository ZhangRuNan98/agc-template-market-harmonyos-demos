import { BreakpointType, GlobalInfoModel } from '@ohos_agcit/notes_utils';
import { AppStorageV2 } from '@kit.ArkUI';

@ComponentV2
export struct SearchNoResult {
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;
  build() {
    Column() {
      Text($r('app.string.no_match_note'))
        .fontSize(16)
        .fontColor(Color.Gray);
    }
    .width('100%')
    .height(100)
    .padding(new BreakpointType<Padding>({
      sm: {
        left: $r('sys.float.padding_level8'),
        right: $r('sys.float.padding_level8'),
      },
      md: {
        left: $r('sys.float.padding_level12'),
        right: $r('sys.float.padding_level12'),
      },
      lg: {
        left: $r('sys.float.padding_level16'),
        right: $r('sys.float.padding_level16'),
      },
    }).getValue(this.globalInfo.currentBreakpoint))
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center);
  }
}