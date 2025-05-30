import { MockService } from 'external_interactions';
import { TitleBar } from 'uicomponents';
import { VipRechargeItem } from '../bean/VipRechargeItem';
import { VipRechargeDataSource } from '../data/VipRechargeDataSource';
import { promptAction } from '@kit.ArkUI';

@Component
@Preview
export struct RechargePage {
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  pathStack: NavPathStack = new NavPathStack();
  private swiperController: SwiperController = new SwiperController()
  private data: VipRechargeDataSource = new VipRechargeDataSource()
  @State pay: number = 0;
  @State swiperReset: boolean = false;
  @State selectedIndex: number = -1;
  @State balance: number = MockService.account.balance
  @StorageLink('accountUpdate') accountUpdate: boolean = false
  @StorageLink('stackAnimated') stackAnimated: boolean = true

  aboutToAppear(): void {
    this.data.pushData(new VipRechargeItem(500, 50));
    this.data.pushData(new VipRechargeItem(1000, 150));
    this.data.pushData(new VipRechargeItem(2000, 350));
    this.data.pushData(new VipRechargeItem(3000, 550));
    this.data.pushData(new VipRechargeItem(4000, 750));
    this.data.pushData(new VipRechargeItem(5000, 1000));
  }

  build() {
    NavDestination() {
      TitleBar({ title: '会员充值', pathStack: this.pathStack })
        .margin({ left: 16, right: 16 })
      Stack() {
        Scroll() {
          Column({ space: 16 }) {
            Row() {
              Image($r('app.media.ic_vipIcon'))
                .width(44)
                .height(38)
              Text('会员余额：' + this.balance + '元')
                .fontSize(14)
                .margin({ left: 16 })
                .fontWeight(FontWeight.Bold)
            }
            .width('100%')
            .borderRadius(16)
            .backgroundColor($r('sys.color.comp_background_list_card'))
            .padding(16)

            Column() {
              Text('充值金额')
                .fontWeight(FontWeight.Bold)
                .fontSize(14)
                .alignSelf(ItemAlign.Start)
              Row() {
                Image($r('app.media.chevron_left'))
                  .width(13)
                  .height(13)
                  .onClick(() => {
                    this.swiperController.showPrevious()
                  })
                Swiper(this.swiperController) {
                  LazyForEach(this.data, (item: VipRechargeItem, index: number) => {
                    ListItem() {
                      Column() {
                        Text(item.getPayNumber() + '元')
                          .fontSize(14)
                          .fontWeight(FontWeight.Bold)
                        Text('立赠' + item.getDiscounts())
                          .fontSize(14)
                          .fontWeight(FontWeight.Bold)
                      }
                      .justifyContent(FlexAlign.SpaceAround)
                      .width(item.getPayNumber() >= 5000 ? 70 : 62)
                      .height(80)
                      .border(this.selectedIndex === index ? { width: 1, color: '#ED6F21', radius: 4 } : { width: 0 })
                      .backgroundImage($r('app.media.ic_recharge_bg'))
                      .backgroundImageSize({ width: '90%', height: '90%' })
                      .backgroundImagePosition(Alignment.Center)
                      .onClick(() => {
                        this.selectedIndex = index;
                        this.pay = item.getPayNumber()
                      })
                    }
                  })
                }
                .cachedCount(3)
                .autoPlay(false)
                .loop(false)
                .itemSpace(0)
                .displayCount(3)
                .effectMode(EdgeEffect.Spring)
                .indicator(false)
                .onChange((index: number) => {
                  console.info('onChange current index' + index.toString())
                  this.swiperController.changeIndex(index)
                })
                .onGestureSwipe(() => {
                  this.swiperReset = false;
                })
                .onAnimationStart((index: number, targetIndex: number) => {
                  if (index !== targetIndex) {
                    this.swiperReset = true;
                  }
                })
                .curve(Curve.Smooth)
                .layoutWeight(1)

                Image($r('app.media.chevron_right'))
                  .width(13)
                  .height(13)
                  .onClick(() => {
                    this.swiperController.showNext()
                  })
              }
              .width('100%')
              .height(80)
              .margin({ top: 16, bottom: 20 })
              .justifyContent(FlexAlign.SpaceBetween)


              Row() {
                Image($r('app.media.ic_rmb'))
                  .height(32)
                  .width(15)
                  .objectFit(ImageFit.Auto)
                TextInput({ placeholder: '请输入充值金额', text: this.pay === 0 ? '' : this.pay.toString() })
                  .type(InputType.Number)
                  .placeholderFont({ size: $r('sys.float.Body_L') })
                  .placeholderColor($r('sys.color.font_secondary'))
                  .width('60%')
                  .fontSize(14)
                  .fontWeight(FontWeight.Regular)
                  .backgroundColor(Color.White)
                  .maxLength(4)
                  .onChange((value) => {
                    if (value) {
                      let numValue = Number.parseInt(value);
                      if (numValue > 5000) {
                        this.pay = 5000;
                      } else {
                        this.pay = numValue;
                      }
                    } else {
                      this.pay = 0;
                    }
                  })
                  .onWillInsert((info: InsertValue) => {
                    let numValue = Number.parseInt(this.pay + info.insertValue)
                    if (numValue > 5000) {
                      this.pay = 5000;
                      promptAction.showToast({ message: '单次充值不超过5000元' })
                    }
                    return true;
                  })
              }
              .alignItems(VerticalAlign.Center)
              .width('100%')

              Divider()

              Row() {
                Text('支付' + this.pay + '元')
                  .fontSize(14)
                Text('实际到账' + this.getTotalMoney() + '元')
                  .fontSize(14)
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .visibility(this.pay > 0 ? Visibility.Visible : Visibility.None)
              .margin({ top: 16 })
            }
            .width('100%')
            .borderRadius(16)
            .backgroundColor($r('sys.color.comp_background_list_card'))
            .padding(16)
          }
        }
        .scrollBar(BarState.Off)
        .margin({ left: 16, right: 16 })
      }
      .layoutWeight(1)
      .alignContent(Alignment.Top)

      Row() {
        Text('需支付：' + this.pay + '元')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .width('40%')
          .height('60%')
          .textAlign(TextAlign.Start)
          .margin({ left: 16 })
        Text('确认充值')
          .textAlign(TextAlign.Center)
          .width('50%')
          .height('60%')
          .fontColor($r('sys.color.comp_background_list_card'))
          .fontWeight(FontWeight.Medium)
          .fontSize(14)
          .backgroundColor('#FF9019')
          .borderRadius(8)
          .onClick(() => {
            // 充值
            if (this.pay > 0) {
              MockService.account.balance += this.getTotalMoney()
              MockService.dataPreferences.putSync('account', JSON.stringify(MockService.account))
              MockService.dataPreferences.flush()
              this.accountUpdate = !this.accountUpdate
              this.pathStack.pop(this.stackAnimated)
              if (!this.stackAnimated) {
                this.stackAnimated = true
              }
            } else {
              promptAction.showToast({ message: '请输入金额' })
            }
          })
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .height(75)
      .width('100%')
      .padding({ bottom: 10 })
      .backgroundColor(Color.White)
    }
    .hideTitleBar(true)
    .hideToolBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx.pathStack
    })
    .onBackPressed(() => {
      this.pathStack.pop(this.stackAnimated)
      if (!this.stackAnimated) {
        this.stackAnimated = true
      }
      return true;
    })
    .backgroundColor($r('app.color.main_background_color'))
    .padding({ top: px2vp(this.topRectHeight) })
  }

  getTotalMoney(): number {
    for (let i = this.data.totalCount() - 1; i >= 0; i--) {
      const item: VipRechargeItem = this.data.getData(i)
      if (this.pay >= item.getPayNumber()) {
        return this.pay + item.getDiscounts()
      }
    }
    return this.pay
  }
}


