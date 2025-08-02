import { PersistenceV2 } from '@kit.ArkUI';
import { RouterPageEnum, UserInfo, UserInfoStorage } from 'common';
import { emitter } from '@kit.BasicServicesKit';

@ComponentV2
export struct SettingPage {
  @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack();
  @Local userInfoStorage: UserInfoStorage = PersistenceV2.connect(UserInfoStorage, 'UserInfoStorage', () => new UserInfoStorage())!

  @Builder
  buildSettingItem ( name1: string, name2: string , path1: RouterPageEnum, path2: RouterPageEnum) {
    Column(){
      Column({space:18}){
        Row(){
          Text(name1)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .width(191)
            .height(21)
            .textAlign(TextAlign.Start)
          Image($r('app.media.ic_arrow_right'))
            .height(24)
            .width(12)
            .objectFit(ImageFit.Contain)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .onClick(() => {
          this.pageInfos.pushPathByName(path1, null)
        })
        Divider()
        Row(){
          Text(name2)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .width(191)
            .height(21)
            .textAlign(TextAlign.Start)
          Image($r('app.media.ic_arrow_right'))
            .height(24)
            .width(12)
            .objectFit(ImageFit.Contain)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .onClick(() => {
          this.pageInfos.pushPathByName(path2, null)
        })
      }
      .borderRadius(16)
      .padding({
        top:18,
        bottom:18,
        left:12,
        right:12
      })
      .backgroundColor('#FFFFFF')
    }
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          Column({ space: 12 }){
            this.buildSettingItem('用户协议','隐私政策',RouterPageEnum.USER_AGREEMENT_ROUTER,RouterPageEnum.PRIVACY_POLICY_ROUTER)
            this.buildSettingItem('第三方信息共享清单','个人信息收集清单',RouterPageEnum.DATA_SHARING_ROUTER,RouterPageEnum.DATA_COLLECTION_ROUTER)
          }
          if(this.userInfoStorage.isLogin){
            Button('退出登录')
              .width('100%')
              .padding({ top: 10, bottom: 10 })
              .fontSize(16)
              .borderRadius(20)
              .fontColor($r('sys.color.multi_color_09'))
              .backgroundColor('#0D000000')
              .fontWeight('medium')
              .onClick(() => {
                this.userInfoStorage.isLogin = false
                this.userInfoStorage.userInfo = new UserInfo()
                this.pageInfos.pop();
                emitter.emit('change_avatar')
              })
          }
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .height('100%')
        .width('100%')
        .padding({ top: 12, left: 16, right: 16, bottom: 36})
      }
      .align(Alignment.TopStart)
      .edgeEffect(EdgeEffect.Spring)
    }
    .title('设置')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundColor($r('app.color.common_background'))
    .height('100%')
    .width('100%')
  }
}