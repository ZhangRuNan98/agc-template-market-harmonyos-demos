import { NavHeaderBar } from 'lib_widget'
import { SettingFontCore } from 'module_setfontsize';
import { SettingFontViewModel } from '../viewmodels/SettingFontVM';

@Builder
export function SettingFontBuilder() {
  SettingFont()
}

@ComponentV2
struct SettingFont {
  @Local vm: SettingFontViewModel = new SettingFontViewModel();

  build() {
    NavDestination() {
      NavHeaderBar({
        title: '字体大小'
      })

      SettingFontCore({
        currentRatio: this.vm.currentRatio,
        confirm: (ratio: number) => {
          this.vm.confirm(ratio);
        },
      })
        .layoutWeight(1)
    }
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({
      bottom: this.vm.windowModel.windowBottomPadding,
    })
  }
}