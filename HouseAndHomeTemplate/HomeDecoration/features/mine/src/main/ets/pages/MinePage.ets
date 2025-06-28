import { ComponentContent, LengthMetrics, promptAction } from '@kit.ArkUI';
import { AccountUtil, RouterMap, RouterModule, CommonConstants, BaseHeader, TelBar } from 'commonlib';
import { MinePageVM } from '../viewModels/MinePageVM';
import { ServerItem } from '../types/Index';


@Builder
export function MinePageBuilder() {
  MinePage();
}


@ComponentV2
struct MinePage {
  @Local titleBgOpacity: number = 0;
  scroller: Scroller = new Scroller();
  vm: MinePageVM = MinePageVM.instance;

  @Builder
  telSheetBuilder() {
    Column() {
      TelBar({
        phone: CommonConstants.TEL_NUMBER,
        onCancel: () => {
          this.vm.isShow = false;
        },
      });
    }.width('100%').padding(16);
  }

  build() {
    NavDestination() {
      BaseHeader('我的');
      Scroll() {
        Column({ space: 12 }) {
          this.userInfoBuilder();
          List({ space: 12 }) {
            ForEach(this.vm.serverList, (item: ServerItem, index) => {
              if (index === 2) {
                ListItem() {
                  this.serverItemBuilder(item);
                }
                .bindSheet($$this.vm.isShow, this.telSheetBuilder, {
                  title: {
                    title: '联系客服',
                  },
                  height: 280,
                  radius: LengthMetrics.vp(16),
                })
                .onClick(() => {
                  this.vm.isShow = true;
                });

              } else {
                ListItem() {
                  this.serverItemBuilder(item);
                }.onClick(() => {
                  if (AccountUtil.getUserInfo().isLogin) {
                    RouterModule.push(this.vm.pageList[index]);
                  } else {
                    promptAction.showToast({ message: '未登录，请登录后重试！' });
                    RouterModule.push(RouterMap.QUICK_LOGIN_PAGE,
                      { 'url': this.vm.pageList[index] } as Record<string, string>);
                  }
                });
              }


            }, (item: ServerItem) => item.label);
          };
        }.padding({ left: 16, right: 16 });

      }
      .width('100%')
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .align(Alignment.Top)
      .backgroundColor($r('sys.color.background_secondary'));

    }.hideTitleBar(true);
  }

  @Builder
  serverItemBuilder(item: ServerItem) {

    Row({ space: 8 }) {
      Image(item.icon).width(24).height(24);
      Text(item.label).fontColor($r('sys.color.font_primary')).fontSize($r('sys.float.Subtitle_M')).layoutWeight(1);
      Image($r('app.media.ic_right')).width(16).height(16);

    }
    .width('100%')
    .height(46)
    .borderRadius(16)
    .backgroundColor($r('sys.color.background_primary'))
    .padding({
      left: 12,
      right: 12,
      bottom: 11,
      top: 11,
    });
  }

  @Builder
  userInfoBuilder() {
    Row() {
      Row({ space: 16 }) {
        Image(this.vm.userInfo.avatar ?
          this.vm.userInfo.avatar.startsWith('file://') ? this.vm.userInfo.avatar :
          $r(`app.media.${this.vm.userInfo.avatar}`) : $r('app.media.ic_avatar'))
          .width(48)
          .height(48)
          .borderRadius(24)
          .alt($r('app.media.ic_avatar'));
        Column({ space: 2 }) {
          Text(this.vm.userInfo.nickname ? this.vm.userInfo.nickname : '立即登录')
            .fontSize($r('sys.float.Subtitle_L'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_primary'))
            .height(24);

          if (AccountUtil.getUserInfo().isLogin) {
            Row({ space: 8 }) {
              Image($r('app.media.ic_public_mobile')).width(16).height(16);
              Text(this.vm.userInfo.cellphone)
                .fontColor($r('sys.color.font_secondary'))
                .fontSize($r('sys.float.Caption_L'))
                .fontWeight(FontWeight.Regular);
            }.height(16);
          } else {
            Text('登录后享受更多服务')
              .fontColor($r('sys.color.font_primary'))
              .fontSize($r('sys.float.Body_S'))
              .fontWeight(FontWeight.Regular)
              .height(16);
          }
        }.alignItems(HorizontalAlign.Start).layoutWeight(1);

        Image($r('app.media.ic_right_small')).width(12).height(24);
      }.onClick(() => {
        if (AccountUtil.getUserInfo().isLogin) {
          RouterModule.push(RouterMap.PERSON_INFO_PAGE);
        } else {
          RouterModule.push(RouterMap.QUICK_LOGIN_PAGE);
        }
      });
    }
    .height(72)
    .width('100%')
    .backgroundColor($r('sys.color.background_primary'))
    .borderRadius(16)
    .padding(12)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Top)
    .margin({ top: 12 });
  }
}

