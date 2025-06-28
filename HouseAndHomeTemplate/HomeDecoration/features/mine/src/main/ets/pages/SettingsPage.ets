import { LengthMetrics, promptAction } from '@kit.ArkUI';
import { CommonConstants, RouterModule, BuildTitleBar, WindowUtil } from 'commonlib';
import { MinePageVM } from '../viewModels/MinePageVM';
import { SettingItem } from '../types/Index';


@Builder
export function SettingsPageBuilder() {
  SettingsPage();
}

@ComponentV2
struct SettingsPage {
  vm: MinePageVM = MinePageVM.instance;

  build() {
    NavDestination() {
      Column() {
        Column({ space: 12 }) {
          ForEach(this.vm.settingList, (item: SettingItem, index: number) => {
            Row() {
              Text(item.label)
                .fontColor($r('sys.color.font_primary'))
                .fontSize($r('sys.float.Body_L'))
                .fontWeight(FontWeight.Regular);
              Image($r('app.media.ic_right')).size({ height: 16, width: 16 });
            }
            .height(61)
            .padding(18)
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .backgroundColor('#FFFFFF')
            .borderRadius(16)
            .onClick(() => {
              RouterModule.push(item.page);
            });
          }, (item: SettingItem) => item.label);
        };

        Button('退出登录')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_on_primary'))
          .backgroundColor($r('sys.color.alert'))
          .width(CommonConstants.FULL_WIDTH)
          .height(40)
          .constraintSize({ maxWidth: CommonConstants.FULL_WIDTH })
          .margin({ left: 12, right: 12, bottom: 28 })
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
    .title(BuildTitleBar('设置'), { paddingStart: LengthMetrics.vp(16) })
    .padding({ top: WindowUtil.avoidAreaSize.top, bottom: WindowUtil.avoidAreaSize.bottom });
  }
}

