import { FunctionalButton, functionalButtonComponentManager } from '@kit.ScenarioFusionKit';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { UserInfoStorage } from 'common';
import { PersistenceV2 } from '@kit.ArkUI';

@ObservedV2
export class AvatarIcon {
  @Trace avatarUrl: string = '';

  height: number = 64;
  width: number = 64;

  constructor(avatarUrl?: string, width?: number, height?: number) {
    if (avatarUrl) {
      this.avatarUrl = avatarUrl;
    }

    if (width) {
      this.width = width;
    }

    if (height) {
      this.height = height;
    }
  }
}

@ComponentV2
export struct SelectAvatarCard {
  @Param @Require avatarIcon: AvatarIcon;
  @Param @Require isLogin: boolean;
  @Local avatarUrl: string = '';
  @Local userInfoStorage: UserInfoStorage = PersistenceV2.connect(UserInfoStorage, 'UserInfoStorage', () => new UserInfoStorage())!

  aboutToAppear(): void {
    this.avatarUrl = this.avatarIcon.avatarUrl;
  }

  build() {
    FunctionalButton({
      params: {
        // OpenType.CHOOSE_AVATAR表示Button为选择头像类型
        openType: functionalButtonComponentManager.OpenType.CHOOSE_AVATAR,
        label: '',
        // 调整Button样式
        styleOption: {
          styleConfig: new functionalButtonComponentManager.ButtonConfig()
            .type(ButtonType.Normal)
            .backgroundImage(this.isLogin && this.avatarIcon.avatarUrl? this.avatarIcon.avatarUrl :
            $r('app.media.default_avatar'))
            .backgroundImageSize(ImageSize.Cover)
            .width(this.avatarIcon.width)
            .height(this.avatarIcon.height)
            .borderRadius(50)
            .backgroundColor('#E5E5E5')
        },
      },
      // OpenType为“CHOOSE_AVATAR”时，回调必须选择“onChooseAvatar”
      controller: new functionalButtonComponentManager.FunctionalButtonController().onChooseAvatar((err, data) => {
        if (err) {
          // 错误日志处理
          return;
        }
        // 成功日志处理
        try {
          let userInfo = this.userInfoStorage.userInfo
          if (userInfo) {
            this.avatarUrl = data.avatarUri as string
            this.userInfoStorage.userInfo.avatar = data.avatarUri as string
            emitter.emit('change_avatar')
          }
        } catch (error) {
          let err: BusinessError = error as BusinessError;
          console.error(`PhotoViewPicker failed with err: ${err.code}, ${err.message}`);
        }
      }),
    })
  }
}