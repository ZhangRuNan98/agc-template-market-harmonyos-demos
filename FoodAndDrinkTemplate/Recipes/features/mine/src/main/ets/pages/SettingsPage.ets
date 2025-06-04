import { buildTitleBar, CommonConstants, RouterModule } from 'commonlib';
import { LengthMetrics, promptAction } from '@kit.ArkUI';
import { SettingsPageVM } from '../viewModels/SettingsPageVM';
import { FunctionItem } from '../types/Index';

@Builder
export function SettingsPageBuilder() {
  SettingsPage();
}

@ComponentV2
struct SettingsPage {
  vm: SettingsPageVM = new SettingsPageVM();

  build() {
    NavDestination() {
      Column() {
        Column({ space: 12 }) {
          ForEach(this.vm.settingList, (item: FunctionItem) => {
            Row() {
              Text(item.label).opacity(0.9);
              Row({ space: 8 }) {
                Text(item.rightLabel)
                  .fontSize(16)
                  .fontColor($r('sys.color.font_secondary'))
                  .visibility(item.rightLabel ? Visibility.Visible : Visibility.None);
                Image($r('app.media.ic_right')).size({ height: 26, width: 8 });
              };
            }
            .height(60)
            .padding(20)
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .backgroundColor($r('sys.color.background_primary'))
            .borderRadius(16)
            .onClick(() => {
              item.callback()
            });
          }, (item: FunctionItem) => item.label);
        };

        Button('退出登录')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_on_primary'))
          .backgroundColor('#E84026')
          .width(CommonConstants.FULL_WIDTH)
          .constraintSize({ maxWidth: CommonConstants.FULL_WIDTH })
          .margin({ left: 24, right: 24, bottom: 12 })
          .onClick(() => {
            this.vm.logout();
            promptAction.showToast({ message: '退出成功~！' });
            RouterModule.pop();
          })
          .visibility(this.vm.userInfo.isLogin ? Visibility.Visible : Visibility.Hidden);
      }
      .padding({ top: 12, left: 16, right: 16 })
      .height('100%')
      .backgroundColor('#F1F3F5')
      .justifyContent(FlexAlign.SpaceBetween);
    }
    .title(buildTitleBar('设置'), { paddingStart: LengthMetrics.vp(16) });
  }
}

