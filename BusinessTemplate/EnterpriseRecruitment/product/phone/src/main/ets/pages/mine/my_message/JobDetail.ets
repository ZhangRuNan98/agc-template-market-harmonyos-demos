import { AvoidArea, LeftReturnComponent,FavoriteDatabase } from '@ohos_agcit/common_component';
import { ArticleCardDetail, CardData } from 'message_manager'
import { AppStorageV2, PersistenceV2, router } from '@kit.ArkUI';


@Entry
@ComponentV2
export struct JobDetailView {
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  @Local jobInfo: CardData = router.getParams() as CardData;
  @Local favoriteDatabase: FavoriteDatabase =
    PersistenceV2.connect(FavoriteDatabase, () => new FavoriteDatabase())!;

  build() {
    Column() {
      Column() {
        Row() {
          LeftReturnComponent()
            .onClick(() => {
              router.back();
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
      }
      .height('8%')
      .width('100%')
      .justifyContent(FlexAlign.Start)

      ArticleCardDetail({
        jobItem:this.jobInfo
      })

      Blank()
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.common_background'))
    .padding({
      top: px2vp(this.avoidArea.topRectHeight),
      bottom: px2vp(this.avoidArea.bottomRectHeight),
      left: '6%',
      right: '6%'
    })
  }
}