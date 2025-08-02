import { emitter } from '@kit.BasicServicesKit';
import { FormatUtil, RouterMap } from 'module_base';
import { PersonalInformationVM } from '../viewModels/PersonalInformationVM';
import { TipsDialog } from '@kit.ArkUI';
import { FunctionalButton, functionalButtonComponentManager } from '@kit.ScenarioFusionKit';

@Builder
export function PersonalInformationPageBuilder() {
  PersonalInformationPage();
}

@ComponentV2
export struct PersonalInformationPage {
  vm: PersonalInformationVM = PersonalInformationVM.instance

  aboutToAppear(): void {
    emitter.on('isLogin', (data) => {
      if (data.data?.isLogin) {
        this.vm.init()
      }
    });
    this.vm.init()
  }

  build() {
    NavDestination() {
      Column() {
        Scroll() {
          Column({ space: 16 }) {
            Row() {
              Text('头像')
                .fontSize(16)
                .layoutWeight(1)
                .lineHeight(22)
              Row() {
                FunctionalButton({
                  params: {
                    openType: functionalButtonComponentManager.OpenType.CHOOSE_AVATAR,
                    label: '',
                    styleOption: {
                      styleConfig: new functionalButtonComponentManager.ButtonConfig()
                        .type(ButtonType.Circle)
                        .backgroundImage(this.vm.avatar ? this.vm.avatar : $r('app.media.avatar'))
                        .backgroundImageSize(ImageSize.Cover)
                        .width(28)
                        .height(28)
                        .borderRadius('99vp')
                        .backgroundColor('#E5E5E5'),
                    },
                  },
                  controller: new functionalButtonComponentManager.FunctionalButtonController().onChooseAvatar((error,
                    data) => {
                    this.vm.getAvatarSrc(error, data);
                  }),
                });

                Image($r('app.media.icc_arrow_right')).rightIconStyle();
              }
            }
            .height(56)
            .backgroundColor(Color.White)
            .formContainerStyle()
            .margin({ top: 16 });

            Column() {
              Row() {
                Text('昵称')
                  .fontSize(16)
                  .layoutWeight(1)
                  .lineHeight(22)

                Row() {
                  Text(this.vm.nickname)
                    .fontSize(14)
                    .fontWeight(FontWeight.Regular)
                    .fontColor($r('sys.color.font_secondary'))
                  Image($r('app.media.icc_arrow_right')).rightIconStyle();
                }
              }
              .formContainerStyle()
              .onClick(() => {
                FormatUtil.jumpToNext(RouterMap.EDIT_PAGE, '昵称')
              })

              Divider().color($r('sys.color.comp_divider'))

              Row() {
                Text('手机号')
                  .fontSize(16)
                  .layoutWeight(1)
                  .lineHeight(22)
                Row() {
                  Text(FormatUtil.encryptPhoneNo(this.vm.cellphone ?? ''))
                    .fontSize(14)
                    .fontWeight(FontWeight.Regular)
                    .fontColor($r('sys.color.font_secondary'))
                  Image($r('app.media.icc_arrow_right')).rightIconStyle();
                }
              }
              .formContainerStyle()
              .onClick(() => {
                FormatUtil.jumpToNext(RouterMap.EDIT_PAGE, '手机号')
              })
            }
            .backgroundColor($r('sys.color.white'))
            .borderRadius(16);
          }
          .margin({ left: 16, right: 16 })
        }
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: false })
      }
    }
    .title('个人信息')
    .backgroundColor($r('sys.color.background_secondary'))
  }
}

@Extend(Row)
function formContainerStyle() {
  .width('100%')
  .alignItems(VerticalAlign.Center)
  .borderRadius(16)
  .padding({
    top: 12,
    bottom: 12,
    left: 12,
    right: 4,
  })
}

@Extend(Image)
function rightIconStyle() {
  .width(24)
  .height(24)
  .margin({ left: 4 })
}