import { getMedia } from '@agctemplate/resources'
import { LiveCard, LiveCardModel } from '../models/LiveModel'

@ComponentV2
export struct BigCard {
  @Param @Require liveData: LiveCardModel

  build() {
    Column() {
      Stack() {
        Image(this.liveData.cover)
          .width(244)
          .height(138)
          .borderRadius({ topLeft: 8, topRight: 8 })

        if (this.liveData.status === '2') {
          Image(getMedia('app.media.start_soon'))
            .height(16)
            .position({ right: 4, top: 4 })
        }
      }

      Column() {
        Row() {
          Text(this.liveData.title)
            .fontSize(16)
            .fontWeight(400)
            .fontColor('#e6000000')
            .textAlign(TextAlign.Start)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({
              left: 12,
              right: 12,
              top: 6,
              bottom: 4
            })
        }
        .width('100%')

        Row() {
          Image(getMedia('app.media.watcher'))
            .width(16)
            .margin({ left: 13, right: 4, bottom: 9 })
          if (this.liveData.watching >= 10000) {
            Text(`${(this.liveData.watching / 10000).toFixed(1)}万`)
              .fontSize(12)
              .fontWeight(400)
              .fontColor($r('sys.color.mask_secondary'))
              .margin({ right: 4, bottom: 9 })
          } else {
            Text(this.liveData.watching.toString())
              .fontSize(12)
              .fontWeight(400)
              .fontColor($r('sys.color.mask_secondary'))
              .margin({ right: 4, bottom: 9 })
          }
        }
        .width('100%')
      }
      .width(244)
      .height(56)
      .backgroundColor('#fff')
      .borderRadius({ bottomLeft: 8, bottomRight: 8 })
    }
    .backgroundColor('#F1F3F5')
    .width(244)
    .height(194)
  }
}


@ComponentV2
export struct CommonCard {
  @Param @Require liveData: LiveCardModel

  build() {
    Column() {
      Stack() {
        Image(this.liveData.cover)
          .width(160)
          .height(90)
          .borderRadius({ topLeft: 8, topRight: 8 })

        if (this.liveData.status === '1') {
          Image(getMedia('app.media.streaming'))
            .height(16)
            .position({ left: 4, top: 4 })
        }

        Row() {
          Image(getMedia('app.media.watcher'))
            .width(12)
            .margin({
              left: 4,
              right: 3,
              bottom: 4,
              top: 4
            })
            .fillColor('#fff')
          if (this.liveData.watching >= 10000) {
            Text(`${(this.liveData.watching / 10000).toFixed(1)}w`)
              .fontSize(8)
              .fontWeight(400)
              .fontColor('#fff')
              .margin({ top: 5, bottom: 5 })
          } else {
            Text(this.liveData.watching.toString())
              .fontSize(8)
              .fontWeight(400)
              .fontColor('#fff')
              .margin({ top: 5, bottom: 5 })
          }

          Row() {
            Text(this.liveData.category)
              .fontSize(8)
              .fontWeight(400)
              .fontColor('#fff')
              .textAlign(TextAlign.End)
              .margin({ top: 6, bottom: 4, right: 4 })
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.End)

        }
        .width(160)
        .height(20)
        .backgroundColor($r('sys.color.mask_fourth'))
        .position({ top: 70 })
      }

      Row() {
        Image(this.liveData.avatar)
          .width(28)
          .borderRadius(14)
          .margin('6px 4px')

        Column() {
          Row() {
            Text(this.liveData.title)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontSize(12)
              .fontWeight(400)
              .textAlign(TextAlign.Start)
              .fontColor('#e6000000')
          }
          .width(120)
          .height(16)
          .margin({ top: 4, right: 4, bottom: 2 })

          Row() {
            Text(this.liveData.streamer)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontWeight(500)
              .fontSize(10)
              .fontColor($r('sys.color.mask_secondary'))
          }
          .width(120)
          .height(14)
          .margin({ right: 4, bottom: 4 })
        }

      }
      .width(160)
      .height(40)
      .backgroundColor('#fff')
      .borderRadius({ bottomLeft: 8, bottomRight: 8 })
    }
    .backgroundColor('#F1F3F5')
    .width(160)
    .height(130)
  }
}

export const cardsData: Array<LiveCard> = [
  {
    cover: getMedia('app.media.cover_3'),
    title: '旅行vlog直播',
    watching: 10000,
    category: '旅游',
    streamer: 'Leo在路上',
    status: '1',
    avatar: getMedia('app.media.likes')
  } as LiveCard,
  {
    cover: getMedia('app.media.cover_4'),
    title: '新版本BOSS速通',
    watching: 16666,
    category: '维京传奇',
    streamer: '暴躁桃子',
    avatar: getMedia('app.media.image_yu')
  } as LiveCard,
  {
    cover: getMedia('app.media.cover_1'),
    title: '游戏冲榜',
    watching: 18100,
    category: '王者荣耀',
    streamer: '轩哥开黑',
    avatar: getMedia('app.media.image_labubu')
  } as LiveCard,
  {
    cover: getMedia('app.media.cover_2'),
    title: '美食速递',
    watching: 666,
    category: '美食',
    streamer: '小雅吃',
    avatar: getMedia('app.media.avatar')
  } as LiveCard,
  {
    cover: getMedia('app.media.cover_2'),
    title: '外卖盲盒挑战',
    watching: 1800,
    category: '美食',
    streamer: '姜姜吃不胖',
    avatar: getMedia('app.media.avatar')
  } as LiveCard,
  {
    cover: getMedia('app.media.cover_4'),
    title: '弹唱网友点歌',
    watching: 1314,
    category: '唱歌',
    streamer: '吉他老张',
    avatar: getMedia('app.media.celebrate')
  } as LiveCard,
  {
    cover: getMedia('app.media.cover_3'),
    title: '监狱跑刀',
    watching: 78787878,
    category: '三角洲行动',
    streamer: '老飞鱼66',
    avatar: getMedia('app.media.image_hui')
  } as LiveCard,
  {
    cover: getMedia('app.media.cover_3'),
    title: 'Excel函数速成',
    watching: 1919,
    category: '学习',
    streamer: '职场小达人',
    avatar: getMedia('app.media.likes')
  } as LiveCard,
  {
    cover: getMedia('app.media.cover_4'),
    title: '15分钟燃脂训练',
    watching: 999,
    category: '运动',
    streamer: '健身小熊',
    avatar: getMedia('app.media.image_ti')
  } as LiveCard,
  {
    cover: getMedia('app.media.cover_1'),
    title: '学生党闭眼入评测',
    watching: 114514,
    category: '数码',
    streamer: '赛博阿力',
    avatar: getMedia('app.media.presents')
  } as LiveCard
]