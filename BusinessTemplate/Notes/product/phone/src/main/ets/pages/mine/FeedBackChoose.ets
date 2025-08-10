import { BreakpointType, GlobalInfoModel } from '@ohos_agcit/notes_utils';
import { SingleArrow } from '../../components/SettingComponents';
import { AppStorageV2 } from '@kit.ArkUI';

@Builder
export function FeedBackChooseBuilder() {
  FeedBackChoose();
}

@ComponentV2
export struct FeedBackChoose {
  @Consumer('appPathStack') appPathStack: NavPathStack = new NavPathStack();
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;

  build() {
    NavDestination() {
      Column({ space: 17 }) {
        SingleArrow({
          text: '反馈问题',
        })
          .onClick(() => {
            this.appPathStack.pushPathByName('FeedBackPage', undefined);
          });

        SingleArrow({
          text: '反馈记录',
        })
          .onClick(() => {
            this.appPathStack.pushPathByName('FeedbackRecordPage', undefined);
          });
      }
      .width('100%')
      .height('100%')
      .padding(new BreakpointType<Padding>({
        sm: {
          top: 10,
          left: $r('sys.float.padding_level8'),
          right: $r('sys.float.padding_level8'),
        },
        md: {
          top: 10,
          left: $r('sys.float.padding_level12'),
          right: $r('sys.float.padding_level12'),
        },
        lg: {
          top: 10,
          left: $r('sys.float.padding_level16'),
          right: $r('sys.float.padding_level16'),
        },
      }).getValue(this.globalInfo.currentBreakpoint))
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .title('意见反馈');
  }
}


