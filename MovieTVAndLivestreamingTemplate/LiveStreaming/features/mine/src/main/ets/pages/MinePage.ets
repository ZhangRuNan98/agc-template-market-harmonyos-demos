import { AppStorageV2, promptAction } from '@kit.ArkUI'
import { call } from '@kit.TelephonyKit'
import { RouterMap, RouterModule } from '@agctemplate/router_module'
import { NumbObj } from '../viewModel/MessageModel'
import { MineItem } from '../viewModel/MineModel'
import { AccountUtil, BarVM, UserInfo } from '@agctemplate/widgets'
import { getMedia } from '@agctemplate/resources'
import { NewFansList } from './NewFansMessagePage'
import { SystemMsgList } from './SystemMessagePage'

@Builder
export function MinePageBuilder() {
  MinePage()
}

@ComponentV2
struct OuterFrameCard {
  @BuilderParam content: () => void
  @Param title: string = '常用服务'

  build() {
    Column() {
      Text(this.title)
        .fontSize(18)
        .fontWeight(700)
        .lineHeight(24)
        .fontColor($r('sys.color.font_primary'))
        .margin({ top: 24, bottom: 8 })
        .width('100%')

      if (this.content) {
        this.content()
      }
    }
    .size({ width: '100%' })
    .padding({ left: 12, right: 12 })
    .backgroundColor($r('sys.color.background_primary'))
    .borderRadius(16)
  }
}


@ComponentV2
struct UserItem {
  @Param title: string = ''
  @Param image: ResourceStr = ''
  @Param url: string = ''
  @Param isLine: boolean = true
  @Param @Once messageNum: number = 0

  build() {
    Row() {
      Image(this.image)
        .size({ width: 24, height: 24 })
      Row() {
        Text(this.title)
          .fontSize($r('sys.float.Subtitle_M'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))

        Blank()
        if (this.messageNum > 0) {
          Text(this.messageNum > 99 ? '99+' : this.messageNum.toString())
            .textAlign(TextAlign.Center)
            .backgroundColor($r('sys.color.warning'))
            .borderRadius(8)
            .size({ width: 30, height: 16 })
            .fontColor($r('sys.color.font_on_primary'))
            .fontSize(10)
            .fontWeight(400)
            .margin({ right: 4 })
        }
        Image($r('app.media.iconRight'))
          .size({ width: 18, height: 18 })
      }
      .margin({ left: 16 })
      .padding({
        top: 17,
        bottom: 17,
        left: 0,
        right: 0
      })
      .layoutWeight(1)
      .border({ width: { bottom: this.isLine ? 0.5 : 0 }, color: $r('sys.color.comp_divider') })

    }
    .size({ width: '100%' })
    .alignItems(VerticalAlign.Center)
  }
}

@ComponentV2
export struct MinePage {
  @Local isOpen: boolean = false
  @Local logoUser: UserInfo = AccountUtil.getUserInfo();
  // 在AppStorageV2中创建一个key为Sample的键值对（如果存在，则返回AppStorageV2中的数据），并且和prop关联
  @Local propNumber: NumbObj = AppStorageV2.connect(NumbObj, () => new NumbObj())!;
  @Local systemMsgList: SystemMsgList = AppStorageV2.connect(SystemMsgList, () => new SystemMsgList())!
  @Local newFansList: NewFansList = AppStorageV2.connect(NewFansList, () => new NewFansList())!
  @Local mineArr: MineItem[] = [
    new MineItem('观看记录', $r('app.media.icon_history'), RouterMap.WATCH_RECORD),
    new MineItem('消息通知', $r('app.media.icon_message2'), RouterMap.MESSAGE_CENTER_PAGE),
    new MineItem('意见反馈', $r('app.media.icon_feedback'), RouterMap.FEEDBACK_PAGE),
    new MineItem('联系客服', $r('app.media.ic_public_headphones_mic'), ''),
    new MineItem('设置', $r('app.media.icon_Setting'), RouterMap.SET_UP_PAGE)
  ]

  @Monitor('logoUser.isLogin','propNumber.totalUnreadCount')
  onStrChange(monitor: IMonitor) {
    if (this.logoUser.isLogin) {
      this.propNumber.listArr[0].count = this.systemMsgList.listArr.filter(item => !item.isRead).length
      this.propNumber.listArr[1].count = this.newFansList.listArr.filter(item => !item.isRead).length
      monitor.dirty.forEach(() => {
        this.mineArr[1] =
          new MineItem('消息通知', $r('app.media.icon_message2'), RouterMap.MESSAGE_CENTER_PAGE, this.propNumber,
            this.propNumber.totalUnreadCount)
      })
    } else {
      this.mineArr[1] =
        new MineItem('消息通知', $r('app.media.icon_message2'), RouterMap.MESSAGE_CENTER_PAGE)
    }

  }

  @Builder
  perMine() {
    Row() {
      Image(this.logoUser.isLogin ?
        (this.logoUser.avatar && this.logoUser.avatar !== '') ? this.logoUser.avatar : $r('app.media.path2x') :
      $r('app.media.person'))
        .borderRadius(40)
        .width(48)
        .aspectRatio(1)

      Row() {
        Column() {
          Text(this.logoUser.isLogin ? this.logoUser.name : '点击登录')
            .height(24)
            .fontSize($r('sys.float.Subtitle_L'))
            .fontColor($r('sys.color.font_primary'))
            .fontWeight(FontWeight.Medium)
            .margin({ left: 16, bottom: 2 })

          if (this.logoUser.isLogin) {
            Text(`ID：${this.logoUser?.id.toString().padStart(7, '0')}`)
              .fontSize(12)
              .fontWeight(400)
              .fontColor($r('sys.color.font_secondary'))
              .margin({ left: 16 })
          }
        }
        .alignItems(HorizontalAlign.Start)

        Blank()
        Image($r('app.media.iconRight'))
          .width(18)
          .aspectRatio(1)
          .margin({ right: 2 })
      }
      .layoutWeight(1)
    }
    .onClick(() => {
      if (!this.logoUser.isLogin) {
        RouterModule.push({ url: RouterMap.LOGIN_PAGE, param: true })
      } else {
        RouterModule.push({ url: RouterMap.PROFILE_PAGE, param: this.logoUser })
      }
    })
    .width('100%')
    .height(72)
    .padding(12)
    .backgroundColor($r('sys.color.background_primary'))
    .borderRadius(16)
  }

  @Builder
  buildMakeCallComponent() {
    Column() {
      Column() {
        Text('0000-00000000')
          .fontSize(18)
          .fontColor('#E6000000')
          .lineHeight(30)
          .halfLeading(true)
        Button() {
          Row() {
            Image($r('app.media.path_1'))
              .height(14)
              .objectFit(ImageFit.Contain)
              .margin({ right: 5 })
            Text('一键拨号')
              .fontSize(15)
              .fontColor(Color.White)
              .fontWeight(600)
          }
        }
        .width('100%')
        .height(45)
        .type(ButtonType.Normal)
        .backgroundColor($r('sys.color.alert'))
        .borderRadius(21)
        .onClick(() => {
          if (canIUse('SystemCapability.Applications.Contacts')) {
            call.makeCall('0000-00000000');
          }
          this.isOpen = false;
        })

        Button() {
          Text('取消')
            .fontSize(15)
            .fontColor($r('sys.color.mask_secondary'))
            .fontWeight(600)
        }
        .width('100%')
        .height(45)
        .type(ButtonType.Normal)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .borderRadius(20)
        .onClick(() => this.isOpen = false)
      }
      .width('100%')
      .height(170)
      .backgroundColor(Color.White)
      .borderRadius(16)
      .padding({ left: 16, right: 16 })
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .padding({
      left: 16,
      right: 16,
      bottom: 56,
      top: 8
    })
  }

  @Builder
  buildTitle() {
    Text('联系客服')
      .fontSize($r('sys.float.Title_S'))
      .fontWeight(FontWeight.Medium)
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        Row() {
          Text('我的')
            .size({ width: 328, height: 32 })
            .fontSize($r('sys.float.Title_M'))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('sys.color.font_primary'))
            .margin({ top: 12, bottom: 12 })
        }

        this.perMine()

        OuterFrameCard() {
          ForEach(this.mineArr, (item: MineItem, index: number) => {
            if (item.titleName === '联系客服') {
              UserItem({
                title: item.titleName,
                image: item.icon,
                url: item.url,
                isLine: !(index === this.mineArr.length - 1),
                messageNum: item.messageNum
              })
                .bindSheet($$this.isOpen, this.buildMakeCallComponent(), {
                  title: this.buildTitle(),
                  height: 265
                })
                .onClick(() => {
                  this.isOpen = true
                })
            } else {
              UserItem({
                title: item.titleName,
                image: item.icon,
                url: item.url,
                isLine: !(index === this.mineArr.length - 1),
                messageNum: item.messageNum
              })
                .onClick(() => {
                  if (this.logoUser.isLogin && item.url) {
                    RouterModule.push({ url: item.url, param: item.params });
                  } else {
                    RouterModule.push({ url: RouterMap.LOGIN_PAGE })
                  }
                })
            }
          }, (item: MineItem) => JSON.stringify(item))
        }
      }
      .backgroundImage(getMedia('app.media.profile_background'))
      .backgroundImageSize(ImageSize.FILL)
      .alignItems(HorizontalAlign.Start)
      .width('100%')
      .height('100%')
      .padding({ left: 16, right: 16, top: BarVM.instance.staBarH })
    }.hideTitleBar(true)
  }
}

