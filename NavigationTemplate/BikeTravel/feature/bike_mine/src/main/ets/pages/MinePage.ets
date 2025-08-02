import { PersistenceV2 } from '@kit.ArkUI'
import { RouterPageEnum, UserInfoStorage } from 'common'
import { UserInfoCard } from '../components/UserInfoCard'

@ComponentV2
export struct MinePage {
  @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack()
  // 需要支持华为账号一键登录
  @Local userInfoStorage: UserInfoStorage = PersistenceV2.connect(UserInfoStorage, 'UserInfoStorage', () => new UserInfoStorage())!

  @Builder
  buildItem(image: ResourceStr, name: string, path: RouterPageEnum) {
    Row() {
      Row({ space: 4 }) {
        Image(image)
          .height(24)
          .width(24)
          .objectFit(ImageFit.Contain)

        Text(name)
          .fontSize(14)
          .fontWeight('regular')
          .fontColor('#333333')
      }

      Image($r('app.media.ic_arrow_right'))
        .height(14)
        .width(14)
        .objectFit(ImageFit.Contain)
    }
    .borderRadius(16)
    .backgroundColor($r('app.color.pure_white'))
    .width('100%')
    .height(40)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      left: 12,
      right: 12,
      top: 8,
      bottom: 8
    })
    .onClick(() => {
      this.pageInfos.pushPathByName(path, null)
    })
  }

  build() {
    NavDestination() {
      Column() {
        Column({ space: 12 }) {
          UserInfoCard()

          this.buildItem($r('app.media.ic_record'), '骑行记录', RouterPageEnum.CYCLE_RECORD_ROUTER)

          this.buildItem($r('app.media.ic_setting'), '设置', RouterPageEnum.SETTING_ROUTER)

        }
        .width('100%')
        .padding({ top: 8, left: 16, right: 16 })
      }
      .align(Alignment.TopStart)
    }
    .title('我的')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundColor($r('app.color.common_background'))
    .height('100%')
    .width('100%')
    .onWillShow(() => {
      this.userInfoStorage = PersistenceV2.connect(UserInfoStorage, 'UserInfoStorage', () => new UserInfoStorage())!
    })
  }
}