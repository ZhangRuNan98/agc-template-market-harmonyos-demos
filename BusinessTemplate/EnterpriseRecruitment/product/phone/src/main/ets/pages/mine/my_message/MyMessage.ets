import { MessageList, TabButton, TabController, MessageManagerService, MessageItem,
  CardData } from 'message_manager'
import { AppStorageV2, router } from '@kit.ArkUI';
import {
  AvoidArea,
  CommonConstants,
  LeftReturnComponent,
  TitleBar
} from '@ohos_agcit/common_component';
import { CardHome } from './CardHome'
import { JobNewList } from './JobNewList'

@Entry
@ComponentV2
export struct MyMessage {
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  @Local currentIndex: number = 0;
  messageManagerService:MessageManagerService = MessageManagerService.instance;
  tabList: TabController[] = [
    new TabController('新职位发布'),
    new TabController('推送消息', true),
    new TabController('消息样式')
  ]
  swiperController: SwiperController = new SwiperController();
  messageList: MessageItem[] = this.messageManagerService.getMessageList();
  newJobList: CardData[] = this.messageManagerService.getJobDataList();
  cardList: CardData[] = this.messageManagerService.getCardDataList()

  aboutToAppear(): void {
    this.swiperController.changeIndex(this.currentIndex)
  }

  build() {
    Column({space:24}) {
      Row() {
        LeftReturnComponent()
          .onClick(() => {
            router.back();
          })
        Row() {
          TitleBar({ text: '我的消息' })
        }
        .layoutWeight(1)
        Image($r('app.media.clear'))
          .width(40)
          .height(40)
          .onClick(() => {
            this.messageManagerService.setReadAll();
          })
      }
      .height('5%')
      .width(CommonConstants.FULL_WIDTH)
      .alignItems(VerticalAlign.Center)

      Row({space:16}) {
        ForEach(this.tabList, (item: TabController, index: number) => {
          TabButton({
            isActive: index === this.currentIndex,
            tabController:item,
            statusChange:() => {
              this.currentIndex = index;
              this.swiperController.changeIndex(index)
            }
          })
        }, (item:TabController) => JSON.stringify(item))
      }
      .width(CommonConstants.FULL_WIDTH)

      Swiper(this.swiperController) {
        JobNewList({
          list: this.newJobList,
          itemClick:(item:CardData) => {
            router.pushUrl({
              url: 'pages/mine/my_message/JobDetail',
              params:item
            }, router.RouterMode.Standard);
          }
        })
        MessageList({
          list:this.messageList,
          itemClick:(item:MessageItem) => {
            router.pushUrl({
              url: 'pages/mine/my_message/MessageDetail',
              params: {
                title: item.title,
                time: item.time,
                content: item.content
              }
            }, router.RouterMode.Standard);
          }
        })
        CardHome({
          list: this.cardList,
          itemClick:(item:CardData) => {
            router.pushUrl({
              url: 'pages/mine/my_message/JobDetail',
              params:item
            }, router.RouterMode.Standard);
          }
        })
      }
      .width(CommonConstants.FULL_WIDTH)
      .loop(false)
      .indicator(false)
      .onChange((index:number) => {
         this.currentIndex = index;
      })
      .layoutWeight(1)

    }
    .backgroundColor('#F1F3F5')
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
    .padding({
      top: px2vp(this.avoidArea.topRectHeight) + 10,
      left: '4%',
      right: '4%',
      bottom:28
    })
  }
}