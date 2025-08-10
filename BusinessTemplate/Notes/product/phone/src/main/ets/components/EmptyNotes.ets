import { BreakpointType, GlobalInfoModel } from '@ohos_agcit/notes_utils';
import { ThemeController } from '../controller/ThemeController';
import { AppStorageV2 } from '@kit.ArkUI';

@ComponentV2
export struct EmptyNotes {
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;
  build() {
    Column() {
      Image($r('app.media.empty_notes'))
        .width(120)
        .height(120)

      Text('岁月悠悠，心事悄悄，记录一下吧')
        .fontSize(12)
        .fontColor($r('sys.color.font_tertiary'))
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
    .alignItems(HorizontalAlign.Center)
    .padding({ top: 70 })
  }
}