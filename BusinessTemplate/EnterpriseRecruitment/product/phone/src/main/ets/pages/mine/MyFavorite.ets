import {
  AvoidArea,
  CommonConstants,
  FavoriteDatabase,
  JobListItem,
  LeftReturnComponent,
  promptFun,
  TitleBar
} from '@ohos_agcit/common_component';
import { AppStorageV2, PersistenceV2, router } from '@kit.ArkUI';

@Entry
@ComponentV2
export struct MyFavorite {
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  @Local favoriteDatabase: FavoriteDatabase =
    PersistenceV2.connect(FavoriteDatabase, () => new FavoriteDatabase())!;
  favoriteListMirror: Array<string> = this.favoriteDatabase.favoriteList.slice();

  @Local allData: JobListItem[] = CommonConstants.JOB_LIST

  getItem(id:string):JobListItem {
    return this.allData.filter((item:JobListItem) => item.id === id)[0];
  }

  build() {
    Column() {
      Row() {
        LeftReturnComponent()
          .onClick(() => {
            router.back();
          });
        TitleBar({ text: '我的收藏' });
      }
      .height(56)
      .alignItems(VerticalAlign.Center)
      .width(CommonConstants.FULL_WIDTH)
      .alignItems(VerticalAlign.Center);

      List({ space: 12 }) {
        ForEach(this.favoriteListMirror, (id: string) => {
          ListItem() {
            Row() {
              Column() {
                Text(this.getItem(id)?.name)
                  .fontSize(16)
                  .fontColor('rgba(0,0,0,0.90)')
                  .fontWeight(FontWeight.Medium)
                Text(CommonConstants.ADDRESS_MAP.get(CommonConstants.JOB_LIST_MAP.get(id)?.address) + ' · ' +
                  CommonConstants.JOB_LIST_MAP.get(id)?.jobType)
                  .fontSize(14)
                  .fontColor('rgba(0,0,0,0.60)')
                  .margin({ top: '3%' })

              }
              .width('70%')
              .alignItems(HorizontalAlign.Start)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/jobRoute/JobDetail',
                  params: this.getItem(id)
                }, router.RouterMode.Standard)
              })

              Blank()

              Image(this.favoriteDatabase.favoriteList.includes(id) ?
              $r('app.media.active_collection_star') :
              $r('app.media.star'))
                .objectFit(ImageFit.Contain)
                .width('10%')
                .height('30%')
                .onClick(() => {
                  if (this.favoriteDatabase.favoriteList.includes(id)) {
                    this.favoriteDatabase.favoriteList.splice(this.favoriteDatabase.favoriteList.indexOf(id), 1)
                    promptFun('取消收藏', 1500)
                    return;
                  }
                  this.favoriteDatabase.favoriteList.push(id)
                  promptFun('收藏成功', 1500)
                })

            }
            .borderRadius(20)
            .backgroundColor(Color.White)
            .padding({
              left: 15,
              right: 10,
              top: 5,
              bottom: 5
            })
            .width('100%')
            .height(72)
          }
        }, (id: string) => id)
      }
      .edgeEffect(EdgeEffect.Spring)
      .scrollBar(BarState.Off)
      .padding({ top: 16 })
      .width('100%')
      .layoutWeight(1)
    }
    .backgroundColor($r('app.color.common_background'))
    .padding({
      top: px2vp(this.avoidArea.topRectHeight),
      left: '4%',
      right: '4%'
    })

  }
}