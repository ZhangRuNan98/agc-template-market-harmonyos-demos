import { scanBarcode, scanCore } from '@kit.ScanKit';
import { jumpDetailPage } from '@agctemplate/detail'
import { getMedia } from '@agctemplate/resources'
import { RouterMap, RouterModule } from '@agctemplate/router_module';
import { BigCard, cardsData, CommonCard } from '../components/LiveCards'
import { LiveCard } from '../models/LiveModel'
import { BarVM } from '@agctemplate/widgets';
import { WindowManager } from '@agctemplate/utils';

interface ScanInfo {
  articleId: string
}

@ComponentV2
export struct HomeMainPage {
  @Local curIndex: number = 0;
  private bigScroller: Scroller = new Scroller();
  private timer: number | null = null;

  aboutToAppear() {
    this.startAutoPlay();
  }

  // 生命周期：页面消失时停止自动轮播
  aboutToDisappear() {
    this.stopAutoPlay();
  }

  // 启动自动轮播
  startAutoPlay() {
    this.stopAutoPlay();
    this.timer = setInterval(() => {
      this.nextSlide();
    }, 3000);
  }

  // 停止自动轮播
  stopAutoPlay() {
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = null;
    }
  }

  // 切换到下一张
  nextSlide() {
    let nextIndex = (this.curIndex + 1) % 3;
    animateTo({ duration: 100 }, () => {
      this.bigScroller.scrollTo({ xOffset: 252 * nextIndex, yOffset: 0 });
    })
    this.curIndex = nextIndex;
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Text('直播')
            .width(232)
            .margin({ top: 12, bottom: 12 })
            .fontSize(24)
            .fontWeight(700)
            .fontColor('#e6000000')
            .textAlign(TextAlign.Start)

          Blank()
          Image(getMedia('app.media.search'))
            .width(40)
            .margin(8)
            .onClick(() => {
              RouterModule.push({ url: RouterMap.SEARCH_PAGE })
            })

          Image(getMedia('app.media.scan'))
            .width(40)
            .onClick(() => {
              scanBarcode.startScanForResult(getContext(this), {
                scanTypes: [scanCore.ScanType.ALL],
                enableMultiMode: true,
                enableAlbum: true
              }).then((result: scanBarcode.ScanResult) => {
                RouterModule.stack.pushPathByName(RouterMap.DETAIL_PAGE,
                  (JSON.parse(result.originalValue) as ScanInfo).articleId)
              })
            })
        }
        .width('100%')
        .height(56)
        .padding({ right: 16, left: 16 })
        .margin({ top: 12, bottom: 12 })

        Scroll(this.bigScroller) {
          Row({ space: 8 }) {
            ForEach([1, 2, 3], (i: number, index: number) => {
              BigCard({
                liveData: {
                  cover: getMedia(`app.media.cover_${i}`),
                  title: i === 1 ? '花瓣杯5V5总决赛' : i === 2 ? '来晚了，监狱跑刀' : '弹唱网友点歌',
                  watching: i === 1 ? 4225000 : i === 2 ? 7878787 : 666666,
                  status: i.toString()
                } as LiveCard
              })
                .onClick(() => {
                  jumpDetailPage('')
                })
            })
          }
          .margin({ left: 66, right: 66 })
          .width('100%')
        }
        .onScrollStop(() => {
          if (this.bigScroller.currentOffset().xOffset > 126 && this.bigScroller.currentOffset().xOffset <= 378) {
            this.bigScroller.scrollTo({ xOffset: 252, yOffset: 0 });
            this.curIndex = 1;
          } else if (this.bigScroller.currentOffset().xOffset > 378) {
            this.bigScroller.scrollTo({ xOffset: 504, yOffset: 0 });
            this.curIndex = 2;
          } else {
            this.bigScroller.scrollTo({ xOffset: 0, yOffset: 0 });
            this.curIndex = 0;
          }
          this.stopAutoPlay();
        })
        .margin({ bottom: 8 })
        .width(748)
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)

        Row() {
          Text('在线主播')
            .margin(16)
            .height(24)
            .fontSize(18)
            .fontWeight(700)
            .fontColor('#e6000000')
            .textAlign(TextAlign.Start)
        }
        .width('100%')


        Grid() {
          ForEach(cardsData, (card: LiveCard) => {
            GridItem() {
              CommonCard({ liveData: card })
            }
            .onClick(() => {
              jumpDetailPage('')
            })
          })
        }
        .layoutWeight(1)
        .edgeEffect(EdgeEffect.Spring)
        .width('100%')
        .columnsTemplate('1fr 1fr')
        .rowsGap(8)
        .columnsGap(8)
        .margin({ left: 16, right: 16, bottom: 12 })
        .scrollBar(BarState.Off)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')
      .padding({
        top: BarVM.instance.staBarH
      })
    }.hideTitleBar(true)
  }
}

@Builder
export function HomeMainPageBuilder() {
  HomeMainPage()
}