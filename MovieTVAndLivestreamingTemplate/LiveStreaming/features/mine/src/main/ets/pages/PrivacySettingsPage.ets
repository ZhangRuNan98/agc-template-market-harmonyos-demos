import { window } from '@kit.ArkUI';
import { RouterMap, RouterModule } from '@agctemplate/router_module';
import { Header } from '../component/Header';
import { AccountUtil, BarVM, UserInfo } from '@agctemplate/widgets';
import { UserInfoRow } from '../component/UserInfoRow';

@ComponentV2
export struct PrivacySettingsPage {
  @Local bottomHeight: number = 0;
  @Local isPersonalized: boolean = false
  @Local isVersionCheckSheet: boolean = false

  aboutToAppear(): void {
    window.getLastWindow(getContext(), (_err, data) => {
      const avoidAreaBottom = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      this.bottomHeight = avoidAreaBottom.bottomRect.height;
    })
  }

  @Builder
  line() {
    Divider().strokeWidth(0.5).width('100%').color($r('sys.color.comp_divider')).padding({ left: 12, right: 12 })
  }

  build() {
    NavDestination() {
      Column() {
        Header({ title: '隐私设置' })
        Column() {
          Column() {
            GenericCard() {
              Personalized({
                switchButton: (isOn) => {
                  this.isPersonalized = isOn
                }
              })
            }

            GenericCard() {
              UserInfoRow({
                leftTitle: '用户协议',
                rightOnClick: () => {
                  RouterModule.push({ url: RouterMap.TERMS_SERVICE_PAGE })
                }
              })
              this.line()
              UserInfoRow({
                leftTitle: '隐私政策',
                rightOnClick: () => {
                  RouterModule.push({ url: RouterMap.PRIVACY_STATEMENT_PAGE })
                }
              })
            }

            GenericCard() {
              UserInfoRow({
                leftTitle: '第三方信息共享清单',
                rightOnClick: () => {
                  RouterModule.push({ url: RouterMap.PRIVACY_3RD_PARTY_SHARE_PAGE })
                }
              })
              this.line()
              UserInfoRow({
                leftTitle: '个人信息收集清单',
                rightOnClick: () => {
                  RouterModule.push({ url: RouterMap.PRIVACY_INFO_COLLECT_PAGE })
                }
              })
            }
          }
          .height(388)

        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .height('100%')
        .padding({
          left: 16,
          right: 16,
          bottom: this.bottomHeight
        })
        .backgroundColor($r('sys.color.comp_background_gray'))
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .padding({ bottom: BarVM.instance.aiBarH })
    }
    .backgroundColor($r('sys.color.comp_background_gray'))
    .hideTitleBar(true)
    .padding({ top: BarVM.instance.staBarH, bottom: BarVM.instance.aiBarH })
  }
}

@Builder
export function PrivacySettingsPageBuilder() {
  PrivacySettingsPage()
}

@ComponentV2
export struct GenericCard {
  @BuilderParam content: () => void

  build() {
    Column() {
      this.content()
    }
    .width('100%')
    .borderRadius(16)
    .margin({ top: 8, bottom: 6 })
    .borderRadius(16)
    .backgroundColor($r('sys.color.comp_background_list_card'))
  }
}

@ComponentV2
export struct Personalized {
  @Param leftTitle: string = '个性化推荐'
  @Param subTitle: string = '想我推荐审核我的个性化内容'
  @Event switchButton: (isOn: boolean) => void
  @Local isToggleOn: boolean = false

  build() {
    Row() {
      Column({ space: 2 }) {
        Text(this.leftTitle)
          .height(21)
        if (this.subTitle) {
          Text(this.subTitle).height(19).fontWeight(400).fontSize(14).fontColor($r('sys.color.font_secondary'))
        }
      }
      .alignItems(HorizontalAlign.Start)

      Blank()

      Toggle({ type: ToggleType.Switch, isOn: this.isToggleOn })
        .size({ width: 36, height: 20 })
        .onChange(() => {
          this.isToggleOn = !this.isToggleOn
          if (this.switchButton) {
            this.switchButton(this.isToggleOn)
          }
        })
    }
    .size({ width: '100%', height: 64 })
    .padding({ left: 12, right: 12 })
  }
}
