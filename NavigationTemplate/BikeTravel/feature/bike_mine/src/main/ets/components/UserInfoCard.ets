import { RouterPageEnum, UserInfoStorage } from 'common';
import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';
import { fileIo as fs } from '@kit.CoreFileKit';
import { emitter } from '@kit.BasicServicesKit';

@ComponentV2
export struct UserInfoCard {
  @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack()
  @Local userInfoStorage: UserInfoStorage = PersistenceV2.connect(UserInfoStorage, 'UserInfoStorage', () => new UserInfoStorage())!
  @Local isLogin: boolean = this.userInfoStorage.isLogin
  @Local avatarUrl: string | ResourceStr = ''

  async aboutToAppear(): Promise<void> {
    if (!this.userInfoStorage.userInfo?.avatar){
      this.avatarUrl=$r('app.media.default_avatar')
    } else{
      this.avatarUrl = this.userInfoStorage.userInfo?.avatar
    }
    emitter.on('change_avatar',()=>{
      if (this.userInfoStorage.isLogin){
        this.avatarUrl = this.userInfoStorage.userInfo?.avatar
      } else {
        this.avatarUrl = $r('app.media.default_avatar')
      }
    })
  }

  build() {
    Row() {
      Row({ space: 8 }) {
        Image(this.avatarUrl)
          .width(48)
          .height(48)
          .objectFit(ImageFit.Contain)
          .borderRadius(1000)

        if (this.userInfoStorage.isLogin) {
          Text(this.userInfoStorage.userInfo.userName ? this.userInfoStorage.userInfo.userName : '华为用户')
            .fontWeight('medium')
            .fontSize(18)
            .maxLines(1)
            .width('70%')
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        } else {
          Text('点击登录')
            .fontWeight('medium')
            .fontSize(18)
        }
      }
      Image($r('app.media.ic_arrow_right'))
        .size({ height: 14, width: 14 })
        .objectFit(ImageFit.Contain)
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor($r('app.color.pure_white'))
    .borderRadius(16)
    .width('100%')
    .padding({
      left: 8,
      right: 12,
      top: 12,
      bottom: 12
    })
    .onClick(() => {
      if (this.userInfoStorage.isLogin) {
        this.pageInfos.pushPathByName(RouterPageEnum.PERSONAL_INFO_ROUTER, null)
      } else {
        this.pageInfos.pushPathByName(RouterPageEnum.QUICK_LOGIN_ROUTER, null)
      }
    })
  }
}