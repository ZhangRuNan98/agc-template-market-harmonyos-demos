import { CardInfo, ConsumeType, CourseDetailModel, DateUtil, MockService, UserCard } from 'external_interactions';
import { Consulting, TitleBar } from 'uicomponents';
import { promptAction } from '@kit.ArkUI';

@Component
export struct CardDetail {
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @Prop pathStack: NavPathStack;
  @Prop cardInfo: CardInfo;
  courseDetail?: CourseDetailModel = undefined
  @State purchased: boolean = false;
  @StorageLink('loginState') loginState: boolean = false;
  @StorageLink('jumpLogin') jumpLogin: boolean = false
  userCard: UserCard[] = []

  @Builder
  cardBasicInfoBuilder() {
    Column() {
      Column() {
        Text(this.cardInfo.name)
          .fontSize(20)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
        Text() {
          Span('¥' + this.cardInfo.price + '/')
            .fontSize(20)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
          Span(this.cardInfo.consumeType === ConsumeType.TIMES ? this.cardInfo.quota + '次' : '不限次')
            .fontSize(14)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Medium)
        }

        Row() {
          Text('预计可省¥' + this.cardInfo.saveMoney)
            .fontSize(12)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Medium)
          Text('永久有效')
            .fontSize(12)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Medium)
            .visibility(this.cardInfo.consumeType === ConsumeType.TIMES ? Visibility.Visible : Visibility.None)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .backgroundImage($r(this.cardInfo.advImage))
      .backgroundImageSize({ width: '100%', height: '100%' })
      .width('100%')
      .height(132)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.SpaceEvenly)
      .padding({ left: 16, right: 16 })
      .borderRadius(16)
      .margin({ bottom: 16 })

      Text(this.cardInfo.name)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 16 })

      Text(this.cardInfo.shortName)
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 16 })
        .opacity(0.4)

      Text('¥' + this.cardInfo.price)
        .fontSize(18)
        .fontColor('#333333')
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 11 })

      Divider()
        .margin({ bottom: 11 })

      Text('卡项权益')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 8 })
      if (this.purchased) {
        ForEach(this.userCard, (item: UserCard) => {
          Row() {
            Image($r(this.cardInfo.advImage))
              .width(80)
              .height(80)
              .borderRadius(8)
            Column() {
              Text(this.cardInfo.shortName)
                .textAlign(TextAlign.Start)
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
              this.purchasedCardRightsBuilder(item)
            }
            .layoutWeight(1)
            .justifyContent(FlexAlign.SpaceEvenly)
            .alignItems(HorizontalAlign.Start)
            .margin({ left: 16 })
            .height('100%')
          }.justifyContent(FlexAlign.Start)
          .width('100%')
          .height(80)
          .margin({ bottom: 10 })
        }, (item: UserCard) => JSON.stringify(item))
      } else {
        Row() {
          Image($r(this.cardInfo.advImage))
            .width(80)
            .height(80)
            .borderRadius(8)
          Column() {
            Text(this.cardInfo.shortName)
              .textAlign(TextAlign.Start)
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
            this.notPurchasedCardRightsBuilder()
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.SpaceEvenly)
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 16 })
          .height('100%')
        }.justifyContent(FlexAlign.Start)
        .width('100%')
        .height(80)
        .margin({ bottom: 10 })
      }

    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(16)
    .padding(16)
  }

  @Builder
  purchasedCardRightsBuilder(userCard: UserCard) {
    Row() {
      Text(this.cardInfo.consumeType === ConsumeType.TIMES ? this.cardInfo.quota + '次' :
        MockService.getQuotaDurationDesc(this.cardInfo.quota) + '卡')
        .fontSize(14)
      Text() {
        if (this.cardInfo.consumeType === ConsumeType.TIMES) {
          Span('剩余次数:')
          Span(MockService.getUserCardById(userCard.id).restQuota.toString())
            .fontColor('#FF9019')
        } else {
          Span('到期时间:')
          Span(DateUtil.formatDate(MockService.getCardExpireDate(MockService.getUserCardById(userCard.id))))
            .fontColor('#FF9019')
        }
      }
      .fontSize(14)
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  notPurchasedCardRightsBuilder() {
    Row() {
      Text(this.cardInfo.consumeType === ConsumeType.TIMES ?
        '¥' + (this.cardInfo.price / this.cardInfo.quota).toFixed(1) + '/次' :
        '¥' + this.cardInfo.price + '/' + MockService.getQuotaDurationDesc(this.cardInfo.quota))
        .textAlign(TextAlign.Start)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
      Text('原价¥' + this.cardInfo.originPrice + '/次')
        .fontSize(12)
        .margin({ left: 12 })
    }
    .width('100%')
  }

  @Builder
  courseShowBuilder() {
    Column() {
      Text('卡项课程')
        .textAlign(TextAlign.Start)
        .fontSize(14)
        .width('100%')
        .fontColor('#333333')
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 8 })
      Column() {
        Image($r(this.courseDetail?.advImage))
          .width('100%')
          .height(76)
          .borderRadius({ topLeft: 8, topRight: 8 })
        Column() {
          Text(this.courseDetail?.courseName)
            .fontSize(10)
            .fontWeight(FontWeight.Medium)
            .margin({ left: 5 })
          Text('¥' + this.courseDetail?.price)
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
            .margin({ left: 5 })
        }
        .borderRadius({ bottomLeft: 8, bottomRight: 8 })
        .justifyContent(FlexAlign.SpaceEvenly)
        .alignItems(HorizontalAlign.Start)
        .shadow({
          radius: 2,
          color: '#ECECEC',
          offsetY: 5,
        })
        .width('100%')
        .height(50)
      }
      .width('50%')
      .height(126)
      .onClick(() => {
        let cardIndex = this.pathStack.getIndexByName('course/CourseDetail')
        // 防止课程和卡项互相跳转导致路由路径过长，查找是否路由已存在，存在删除之前的页面
        if (cardIndex.length > 0) {
          this.pathStack.removeByName('course/CourseDetail')
          this.pathStack.pushPath({ name: 'course/CourseDetail', param: this.courseDetail })
        } else {
          this.pathStack.pushPath({ name: 'course/CourseDetail', param: this.courseDetail })
        }
      })
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .borderRadius(16)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .padding(16)
  }

  @Builder
  useInstructionBuilder() {
    Column() {
      Text('使用说明')
        .textAlign(TextAlign.Start)
        .fontSize(14)
        .width('100%')
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 8 })
      Text(this.cardInfo.useInstruction)
        .textAlign(TextAlign.Start)
        .align(Alignment.Top)
        .fontSize(12)
        .width('100%')
        .fontColor(Color.Black)
        .opacity(0.6)
        .fontWeight(FontWeight.Regular)
    }
    .width('100%')
    .borderRadius(16)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .padding(16)
    .margin({ bottom: 16 })
  }

  build() {
    NavDestination() {
      Column() {
        TitleBar({ title: '卡项详情', pathStack: this.pathStack })
          .margin({ left: 16, right: 16 })
        Scroll() {
          Column({ space: 16 }) {
            this.cardBasicInfoBuilder()
            this.courseShowBuilder()
            this.useInstructionBuilder()
          }.margin({ left: 16, right: 16 })
          .justifyContent(FlexAlign.Start)
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)

        // 下方咨询和跳转预约
        Row() {
          Row() {
            Consulting()
          }.justifyContent(FlexAlign.Center)
          .width('20%')
          .height('60%')

          Text('立即购买')
            .textAlign(TextAlign.Center)
            .width('70%')
            .height('60%')
            .fontColor($r('sys.color.comp_background_list_card'))
            .fontWeight(FontWeight.Medium)
            .fontSize(14)
            .backgroundColor('#FF9019')
            .borderRadius(8)
            .onClick(() => {
              if (this.loginState) {
                this.pathStack.pushPath({ name: 'card/buyCard', param: this.cardInfo })
              } else {
                promptAction.showToast({ message: '请先关联账号' })
                this.jumpLogin = !this.jumpLogin
                this.pathStack.clear(false)
              }
            })
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .height(75)
        .width('100%')
        .padding({ bottom: 10 })
        .backgroundColor(Color.White)
        .visibility(this.purchased ? Visibility.None : Visibility.Visible)
      }

    }
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx?.pathStack
      this.cardInfo = ctx?.pathInfo?.param as CardInfo;
      MockService.userCardList.forEach((item: UserCard) => {
        if (item.cardId === this.cardInfo.id && MockService.userCardCanUse(item)) {
          this.purchased = true
          this.userCard.push(item)
        }
      })
      this.getCourseDetail()
    })
    .backgroundColor($r('app.color.main_background_color'))
    .padding({ top: px2vp(this.topRectHeight) })
  }

  getCourseDetail() {
    this.courseDetail = MockService.getCourseById(this.cardInfo.avaiCourse)
  }
}
