import { Avatar, AvoidArea, CommonConstants, Route, TitleBar, TopBar } from '@ohos_agcit/common_component';
import MineListItem from '../mine/MineListItem';
import { AppStorageV2, router } from '@kit.ArkUI';
import { showToast } from './mine/common/ShowToast';
import { FileDataSource } from 'file_management';
import { AccountUtil, CommonModel, ROUTES_TYPE } from '@ohos_agcit/common_component';
import { MessageManagerService } from 'message_manager';
import { authentication } from '@kit.AccountKit';

@Entry
@ComponentV2
export struct Mine {
  logTag: string = 'PrepareLoginPage';
  domainId: number = 0x0000;
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  routes: Route[] = CommonConstants.ROUTES;
  data: FileDataSource<Route> = new FileDataSource();
  vm: CommonModel = CommonModel.instance;
  messageManagerService: MessageManagerService = MessageManagerService.instance;

  @Monitor('messageManagerService.unReadCount')
  messageUnReadCountChange() {
    this.data.getDataArray().forEach((item: Route) => {
      if (item.type === ROUTES_TYPE.MY_MESSAGE) {
        item.unReadCount = this.messageManagerService.unReadCount;
      }
    });
  }

  aboutToAppear() {
    for (let i = 0; i <= this.routes.length - 1; i++) {
      this.data.pushData(this.routes[i]);
    }
    this.messageUnReadCountChange();
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          TopBar({ text: $r('app.string.mine') })
            .width('100%')
            .height(56)
            .alignSelf(ItemAlign.Start)
            .margin({ bottom: 10 });

          Column({ space: 16 }) {
            // information area
            Column() {
              Row() {
                Avatar({
                  avatar: AccountUtil.getUserInfo().avatar || $r('app.media.ic_avatar'),
                });

                Text(AccountUtil.getAccountInfo().idToken ? AccountUtil.getUserInfo().nickname :
                $r('app.string.mine_login'))
                  .fontWeight(FontWeight.Medium)
                  .fontSize($r('app.float.font_size_20'))
                  .fontWeight(FontWeight.Medium)
                  .textAlign(TextAlign.Start)
                  .margin({ left: 10 });

                Blank();

                Image($r('app.media.ic_public_arrow_right'))
                  .fillColor($r('sys.color.ohos_id_color_foreground'))
                  .opacity(0.2)
                  .width(12)
                  .height(24);
              }
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .padding({ left: '5%', right: '3.5%' })
              .height(50)
              .width('100%')
              .onClick(() => {
                if (AccountUtil.getAccountInfo().idToken === '') {
                  obtainAnonymousPhone().then(anonymousPhone => {
                    this.jumpLoginPage(anonymousPhone);
                  })
                } else {
                  router.pushUrl({
                    url: 'pages/mine/PersonalInfo',
                    params: {},
                  }, router.RouterMode.Standard);
                }
              });
            }
            .height(72)
            .width(CommonConstants.FULL_WIDTH)
            .backgroundColor(Color.White)
            .borderRadius(CommonConstants.COMMON_RADIUS)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center);

            // service
            Column() {
              Text('常用服务')
                .fontSize($r('app.float.font_size_22'))
                .fontWeight(800)
                .fontColor(Color.Black)
                .textAlign(TextAlign.Start)
                .width(CommonConstants.FULL_WIDTH)
                .margin({
                  bottom: 18,
                });

              Column() {
                List({ space: 36 }) {
                  LazyForEach(this.data, (item: Route, index: number) => {
                    ListItem() {
                      Column() {
                        MineListItem({
                          imagePath: item.img,
                          text: item.title,
                          unReadCount: item.unReadCount,
                          onClickItem: (event: ClickEvent) => {
                            if (event) {
                              this.toPage(item.path);
                            }
                          },
                        });
                      };
                    };
                  });
                }
                .divider({
                  strokeWidth: 1,
                  startMargin: 40,
                })
                .edgeEffect(EdgeEffect.Spring)
                .scrollBar(BarState.Off);
              };
            }
            .backgroundColor(Color.White)
            .borderRadius(CommonConstants.COMMON_RADIUS)
            .width(CommonConstants.FULL_WIDTH)
            .justifyContent(FlexAlign.Start)
            .padding({
              top: 28,
              left: 12,
              right: 12,
              bottom: 18,
            });
          };
        };
      }
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
    }
    .padding({
      top: px2vp(this.avoidArea.topRectHeight),
      left: 16,
      right: 16,
    })
    .backgroundColor($r('app.color.common_background'))
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_WIDTH);
  }

  private toPage(url: string): void {
    router.pushUrl({ url: url }, router.RouterMode.Standard);
  }

  private jumpLoginPage(quickLoginAnonymousPhone: string | undefined) {
    if (quickLoginAnonymousPhone) {
      router.pushUrl({
        url: 'pages/mine/QuickLoginPage',
        params: {
          anonymousPhone: quickLoginAnonymousPhone,
        },
      }, router.RouterMode.Standard);
    } else {
      const hint: string = getContext().resourceManager.getStringSync($r('app.string.get_mobile_number_error'));
      showToast(hint);
    }
  }


}
export async function obtainAnonymousPhone(): Promise<string> {
  // Create an authorization request.
  const authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
  // User information requested by the app.
  authRequest.scopes = ['quickLoginAnonymousPhone'];
  // In the one-tap sign-in scenario, forceAuthorization must be set to false.
  authRequest.forceAuthorization = false;
  const controller = new authentication.AuthenticationController();
  try {
    const response: authentication.AuthorizationWithHuaweiIDResponse = await controller.executeRequest(authRequest)
    return response.data?.extraInfo?.quickLoginAnonymousPhone as string;
  } catch (error) {
    console.error('obtain anonymous phone failed')
    // mock数据，实际项目应使用真实登录
    return 'a00****0000';
  }
}
