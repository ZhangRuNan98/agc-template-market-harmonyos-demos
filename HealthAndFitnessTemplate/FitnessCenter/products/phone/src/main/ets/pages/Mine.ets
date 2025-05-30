import { MockService } from 'external_interactions';
import { UserInfoCard } from 'vip';
import { promptAction } from '@kit.ArkUI';

@Component
export struct Mine {
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  pathStack: NavPathStack = new NavPathStack()
  @StorageLink('accountUpdate') @Watch('refreshUserInfo') accountUpdate: boolean = false;
  @State cardCount: number = MockService.userCardList.length
  @StorageLink('loginState') @Watch('refreshUserInfo') loginState: boolean = false;

  aboutToAppear(): void {
    this.refreshUserInfo()
  }

  refreshUserInfo() {
    this.cardCount =
      this.loginState ? MockService.userCardList.filter((item) => MockService.userCardCanUse(item)).length : 0
  }

  @Builder
  entryBuilder(imgStr: string, text: string, pagePath: string) {
    Column() {
      Image($r(imgStr))
        .width(40)
        .width(40)
        .margin({ bottom: 4 })
      Text(text)
        .fontSize(12)
        .opacity(0.9)
    }.onClick(() => {
      if (this.loginState) {
        this.pathStack.pushPath({ name: pagePath })
      } else {
        promptAction.showToast({ message: '请先关联账号' })
      }
    })
  }

  build() {
    Column() {
      Row() {
        Text('我的')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .width('100%')
      }
      .justifyContent(FlexAlign.Start)
      .height(40)
      .margin({
        top: 8,
        bottom: 8,
        left: 16,
        right: 16
      })

      Stack() {
        Scroll() {
          Column({ space: 16 }) {
            UserInfoCard({
              pathStack: this.pathStack
            })
            Row() {
              Image($r('app.media.card_button'))
                .width(36)
                .height(36)
                .objectFit(ImageFit.Auto)
              Text() {
                Span('卡项 ')
                  .fontSize(12)
                  .opacity(0.6)
                Span(this.cardCount.toString())
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
              }
              .margin({ left: 16 })
            }
            .width('100%')
            .backgroundColor(Color.White)
            .borderRadius(16)
            .padding(16)
            .onClick(() => {
              if (this.loginState) {
                this.pathStack.pushPath({ name: 'card/userCards' })
              } else {
                promptAction.showToast({ message: '请先关联账号' })
              }
            })

            Row() {
              this.entryBuilder('app.media.booking_record', '预约记录', 'course/BookingRecord')
              this.entryBuilder('app.media.order', '我的订单', 'card/order')
              this.entryBuilder('app.media.recharge', '会员充值', 'vip/VipRecharge')
            }
            .justifyContent(FlexAlign.SpaceAround)
            .width('100%')
            .backgroundColor(Color.White)
            .borderRadius(16)
            .padding(16)
          }
        }
        .margin({ left: 16, right: 16 })
      }
      .layoutWeight(1)
      .alignContent(Alignment.Top)
    }
    .padding({ top: px2vp(this.topRectHeight), bottom: px2vp(this.bottomRectHeight) })
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.main_background_color'))
  }
}