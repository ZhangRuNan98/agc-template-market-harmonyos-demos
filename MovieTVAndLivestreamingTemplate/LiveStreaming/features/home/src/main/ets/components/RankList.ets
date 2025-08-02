import { getMedia } from '@agctemplate/resources'

@ComponentV2
export struct RankList {
  @Event onLiveClick: Function

  @Builder
  recommendItem(rank: number) {
    Row() {
      if (rank <= 3) {
        Image(getMedia(rank === 1 ? 'app.media.rank1' : rank === 2 ? 'app.media.rank2' : 'app.media.rank3'))
          .width(24)
          .margin({ right: 5.5 })
      } else {
        Stack() {
          Image(getMedia('app.media.ranks'))
            .width(24)
            .margin({ right: 5.5 })
          Text(rank.toString())
            .fontSize(8)
            .fontWeight(700)
            .fontColor('#fff')
            .position({ left: 13, top: 13 })
            .width(10)
            .textAlign(TextAlign.Center)
        }
      }

      Column() {
        Row() {
          Text('花瓣杯5V5总决赛')
            .fontSize(14)
            .fontWeight(500)
            .fontColor('#e6000000')

          Row() {
            Image(getMedia('app.media.watcher'))
              .width(16)
              .margin({ right: 4 })
            Text('422.5万')
              .fontSize(12)
              .fontWeight(400)
              .fontColor($r('sys.color.mask_secondary'))
          }
        }
        .width(273)
        .height(19)
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ bottom: 2 })

        Row() {
          Text('大家都在看')
            .fontSize(10)
            .fontWeight(400)
            .fontColor($r('sys.color.mask_secondary'))
        }
        .width(273)
      }
      .justifyContent(FlexAlign.Start)
    }
    .width(304)
    .height(51)
    .margin({ left: 12, right: 12 })
    .onClick(() => {
       this.onLiveClick()
    })
  }

  build() {
    Column() {
      ForEach([1,2,3,4,5,6,7,8,9,10], (i: number) => {
        this.recommendItem(i)
      }, (i: number) => { return i.toString() })
    }
    .width(342)
    .height(542)
    .padding({ top: 4, bottom: 28 })
    .backgroundColor('#0dee5d1a')
    .borderRadius(16)
  }
}