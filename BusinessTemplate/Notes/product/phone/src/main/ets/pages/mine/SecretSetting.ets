import { BreakpointType, GlobalInfoModel } from '@ohos_agcit/notes_utils';
import { SecretLockSwitch } from 'secretlock';
import { AppStorageV2 } from '@kit.ArkUI';

@Builder
export function SecretSettingBuilder() {
  SecretSetting();
}

@ComponentV2
export struct SecretSetting {
  @Consumer('appPathStack') appPathStack: NavPathStack = new NavPathStack();
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;

  build() {
    NavDestination() {
      SecretLockSwitch({
        appPathStack: this.appPathStack
      })
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

    }
    .title('保密设置')
    .backgroundColor($r('sys.color.background_secondary'))
  }
}
