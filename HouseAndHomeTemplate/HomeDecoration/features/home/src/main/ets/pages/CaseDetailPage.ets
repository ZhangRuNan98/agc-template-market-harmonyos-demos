import { LengthMetrics, promptAction, window } from '@kit.ArkUI';
import { RouterModule, TelBar, AccountUtil, WindowUtil, RouterMap } from 'commonlib';
import { CaseDetailPageVM } from '../viewModels/CaseDetailPageVM';
import { RangeItem } from '../types/Index';


@Builder
export function CaseDetailPageBuilder() {
  CaseDetailPage();
}


@ComponentV2
struct CaseDetailPage {
  vm: CaseDetailPageVM = CaseDetailPageVM.instance;

  aboutToAppear(): void {
    this.vm.getCaseInfo();
    this.vm.getCollectionList();
  }

  aboutToDisappear(): void {
    let systemBarProperties: window.SystemBarProperties = {
      statusBarContentColor: '#000000',
    };
    WindowUtil.currentWindow.setWindowSystemBarProperties(systemBarProperties);
  }

  @Builder
  TelSheetBuilder() {
    Column() {
      TelBar({
        phone: this.vm.caseInfo?.designer.phone,
        onCancel: () => {
          this.vm.isPhoneOpen = false;
        },
      });
    }.width('100%').padding(16);
  }

  @Builder
  OrderDesignerBuilder() {
    Column() {
      Column() {
        Text('选择房屋面积').baseTitle();
        Row() {
          ForEach(this.vm.areaList, (item: RangeItem, index) => {
            Text(item.label)
              .backgroundColor(this.vm.curAreaIndex === index ? $r('sys.color.alert') :
              $r('sys.color.comp_background_tertiary'))
              .fontColor(this.vm.curAreaIndex === index ? $r('sys.color.font_on_primary') :
              $r('sys.color.font_primary'))
              .baseBtnExtend()
              .onClick(() => {
                this.vm.curAreaIndex = index;
              });
          }, (item: RangeItem) => item.label);
        }.justifyContent(FlexAlign.SpaceBetween).margin({ bottom: 16 }).width('100%');

        Text('选择装修预算').baseTitle();
        Row() {
          ForEach(this.vm.budgetList, (item: RangeItem, index) => {
            Text(item.label)
              .backgroundColor(this.vm.curBudgetIndex === index ? $r('sys.color.alert') :
              $r('sys.color.comp_background_tertiary'))
              .fontColor(this.vm.curBudgetIndex === index ? $r('sys.color.font_on_primary') :
              $r('sys.color.font_primary'))
              .baseBtnExtend()
              .onClick(() => {
                this.vm.curBudgetIndex = index;
              });
          }, (item: RangeItem) => item.label);
        }.justifyContent(FlexAlign.SpaceBetween).margin({ bottom: 16 }).width('100%');
      }.padding({ left: 12, right: 12 }).width('100%').alignItems(HorizontalAlign.Start);

      TextInput({ placeholder: '请留下您的姓', text: this.vm.firstName })
        .width('100%')
        .height(40)
        .margin({ bottom: 16 })
        .placeholderColor($r('sys.color.font_secondary'))
        .placeholderFont({
          size: $r('sys.float.Body_M'),
          weight: FontWeight.Regular,
        })
        .onChange((res) => {
          this.vm.firstName = res;
        });

      Column() {
        Button('预约TA')
          .height(40)
          .backgroundColor($r('sys.color.alert'))
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.font_on_primary'))
          .width('100%')
          .onClick(() => {
            this.vm.toOrder();
          });


        Row({ space: 2 }) {
          Image($r('app.media.ic_warming')).width(10).height(10);
          Text('允许软件来电了解详细装修需求')
            .fontWeight(FontWeight.Regular)
            .fontSize($r('sys.float.Caption_L'))
            .fontColor($r('sys.color.font_tertiary'));
        }.margin({ top: 8 }).width('100%').justifyContent(FlexAlign.Center);
      }.padding({ left: 12, right: 12 });
    }
    .padding({
      top: 8,
      left: 16,
      right: 16,
      bottom: 23,
    })
    .alignItems(HorizontalAlign.Start);
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Row() {
            Image($r('app.media.ic_nav_left')).fillColor(Color.White).width(9).height(16);
          }
          .justifyContent(FlexAlign.Center)
          .width(40)
          .height(40)
          .borderColor(20)
          .onClick(() => {
            RouterModule.pop();
          });
        }
        .width('100%')
        .height(56)
        .padding({
          left: 16,
          top: 8,
          bottom: 8,
          right: 16,
        });

        Scroll() {
          Column() {
            Stack({ alignContent: Alignment.BottomEnd }) {
              Swiper() {
                ForEach(this.vm.caseInfo?.detail, (item: string) => {
                  Image($r(`app.media.${item}`)).width('100%').height(512);
                }, (item: string) => item);
              }
              .index($$this.vm.curIndex)
              .height(512)
              .autoPlay(true)
              .loop(true)
              .borderRadius(4)
              .indicator(false);

              Text(`${this.vm.curIndex + 1}/${this.vm.caseInfo?.detail.length}`)
                .width(36)
                .height(24)
                .textAlign(TextAlign.Center)
                .borderRadius(12)
                .backgroundColor('rgba(255,255,255,0.4)')
                .fontColor($r('sys.color.font_on_primary'))
                .fontWeight(FontWeight.Medium)
                .fontSize($r('sys.float.Caption_S'))
                .margin({ right: 16, bottom: 12 });
            }.height(512);


            Row({ space: 4 }) {
              Image($r(`app.media.${this.vm.caseInfo?.designer.avatar}`)).width(44).height(44).borderRadius(22);
              Text(this.vm.caseInfo?.designer.name)
                .fontSize($r('sys.float.Body_M'))
                .fontColor($r('sys.color.font_on_primary'))
                .fontWeight(FontWeight.Regular);
            }.margin({ top: 16, bottom: 12 }).width('100%').padding({ left: 16 });

            Text(this.vm.caseInfo?.title)
              .fontSize($r('sys.float.Body_S'))
              .fontColor($r('sys.color.font_on_primary'))
              .fontWeight(FontWeight.Regular)
              .width('100%')
              .padding({ left: 16, right: 16 });


            Row({ space: 16 }) {
              Column({ space: 4 }) {
                Image($r('app.media.ic_detail_phone')).width(32).height(32);
                Text('电话').fontSize(12).fontColor(Color.White);
              }
              .bindSheet($$this.vm.isPhoneOpen, this.TelSheetBuilder, {
                title: {
                  title: '联系设计师',
                },
                height: 280,
                radius: LengthMetrics.vp(16),
              })
              .onClick(() => {
                this.vm.isPhoneOpen = true;
              });

              Column({ space: 4 }) {
                Image(this.vm.isCollection ? $r('app.media.ic_star_on') : $r('app.media.ic_star_off'))
                  .width(32)
                  .height(32);
                Text('收藏').fontSize(12).fontColor(Color.White);
              }.onClick(() => {
                if (AccountUtil.getUserInfo().isLogin) {
                  if (this.vm.isCollection) {
                    this.vm.removeCollection();
                  } else {
                    this.vm.addCollection();
                  }
                } else {
                  promptAction.showToast({ message: '请先登录享受，更多精彩！' });
                  RouterModule.push(RouterMap.QUICK_LOGIN_PAGE);
                }

              });

              Column({ space: 4 }) {
                Image($r('app.media.ic_detail_order')).width(32).height(32);
                Text('预约').fontSize(12).fontColor(Color.White);
              }.bindSheet($$this.vm.isOrderOpen, this.OrderDesignerBuilder, {
                height: 342,
                title: {
                  title: '预约',
                },
                radius: LengthMetrics.vp(16),
              }).onClick(() => {
                if (AccountUtil.getUserInfo().isLogin) {
                  this.vm.isOrderOpen = true;
                } else {
                  promptAction.showToast({ message: '请先登录，享受更多精彩！' });
                  RouterModule.push(RouterMap.QUICK_LOGIN_PAGE);
                }

              });
            }.width('100%').padding({ top: 20, bottom: 16, left: 20 });

          }.padding({ top: 12 });

        }.layoutWeight(1).scrollBar(BarState.Off).align(Alignment.Top);

      }.width('100%').height('100%').backgroundColor('#000000')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP]);
    }
    .hideTitleBar(true)
    .padding({ top: WindowUtil.avoidAreaSize.top, bottom: WindowUtil.avoidAreaSize.bottom })
    .backgroundColor('#000000')
    .onShown(()=>{
      let systemBarProperties: window.SystemBarProperties = {
        statusBarContentColor: '#FFFFFF',
      };
      WindowUtil.currentWindow.setWindowSystemBarProperties(systemBarProperties);
    })

  }
}

@Extend(Text)
function baseBtnExtend() {
  .width(70)
  .height(28)
  .fontSize($r('sys.float.Caption_M'))
  .fontWeight(FontWeight.Regular)
  .padding(0)
  .borderRadius(8)
  .textAlign(TextAlign.Center);
}

@Extend(Text)
function baseTitle() {
  .fontSize($r('sys.float.Body_S'))
  .fontWeight(FontWeight.Regular)
  .fontColor($r('sys.color.font_primary'))
  .margin({ bottom: 8 });
}