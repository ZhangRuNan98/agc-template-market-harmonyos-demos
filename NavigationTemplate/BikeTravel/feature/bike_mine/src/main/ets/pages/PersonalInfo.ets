import { RouterPageEnum, UserInfoStorage } from 'common';
import { PersistenceV2 } from '@kit.ArkUI';
import { AvatarIcon, SelectAvatarCard } from '../components/SelectAvatarCard';
import { emitter } from '@kit.BasicServicesKit';

@ComponentV2
export struct PersonalInfo {
  @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack();
  @Local userInfoStorage: UserInfoStorage = PersistenceV2.connect(UserInfoStorage, 'UserInfoStorage', () => new UserInfoStorage())!
  @Local avatarIcon: AvatarIcon = new AvatarIcon('');
  @Local modifyContent: string = '';
  @Local userName: string = '';
  @Local phoneNumber: string = '';
  @Local isShowModifyBind: boolean = false;
  @Local isModifyUserName: boolean = false;
  @Local isModifyPhoneNumber: boolean = false;

  async aboutToAppear(): Promise<void> {
    this.avatarIcon = new AvatarIcon(this.userInfoStorage.userInfo?.avatar,40,40);
    this.phoneNumber = this.userInfoStorage.userInfo.phoneNumber as string;
    this.userName = this.userInfoStorage.userInfo.userName;
    emitter.on('change_avatar',()=>{
      this.avatarIcon.avatarUrl = this.userInfoStorage.userInfo?.avatar
    })
  }

  submitModifyMsg(){
    if (this.userInfoStorage.userInfo) {
      if (this.isModifyUserName) {
        this.userInfoStorage.userInfo.userName = this.modifyContent;
        this.userName = this.modifyContent;
        this.isModifyUserName = false;
      } else if (this.isModifyPhoneNumber) {
        this.userInfoStorage.userInfo.phoneNumber = this.modifyContent;
        this.phoneNumber= this.modifyContent;
        this.isModifyPhoneNumber = false;
      }
    }
    this.isShowModifyBind = false;
    const uiContext = this.getUIContext?.();
    if (uiContext) {
      const promptAction = uiContext.getPromptAction();
      promptAction.showToast({ message: '修改成功' });
    }
  }

  getModifyContent(): string {
    if (this.isModifyUserName) {
      return this.userName;
    } else if (this.isModifyPhoneNumber) {
      return this.phoneNumber;
    }

    return '';
  }

  @Builder
  modify() {
    Column() {
      TextInput({ text: this.getModifyContent() })
        .enableKeyboardOnFocus(true)
        .onChange((value: string) => {
          this.modifyContent = value;
        })
        .onSubmit(() => {
          this.submitModifyMsg()
        })
      Button('确定')
        .width(304)
        .height(40)
        .borderRadius(20)
        .backgroundColor($r('sys.color.multi_color_08'))
        .onClick(()=>{
          this.submitModifyMsg()
        })
    }
    .height('90%')
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left: 12, right: 12 })
  }

  build() {
    NavDestination() {
      Column() {
        Scroll() {
          Column({ space: 12 }) {
            Row() {
              Text('头像')
                .fontWeight('medium')
                .fontSize(16)

              Row({ space: 7 }) {
                if (this.userInfoStorage.isLogin) {
                  SelectAvatarCard({ avatarIcon: this.avatarIcon, isLogin: this.userInfoStorage.isLogin })
                } else {
                  Image($r('app.media.default_avatar'))
                    .width(40)
                    .height(40)
                    .borderRadius(1000)
                    .onClick(() => {
                      const promptAction = this.getUIContext().getPromptAction();
                      promptAction.showToast({ message: '没有登录' })
                    })
                }

                Image($r('app.media.ic_arrow_right'))
                  .height(24)
                  .width(12)
                  .objectFit(ImageFit.Contain)
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .backgroundColor($r('app.color.pure_white'))
            .borderRadius(16)
            .padding({
              left: 12,
              right: 12,
              top: 8,
              bottom: 8
            })

            Row() {
              Text('昵称')
                .fontWeight('medium')
                .fontSize(16)

              Row({ space: 7 }) {
                Text(this.userInfoStorage.userInfo.userName)
                  .fontColor($r('app.color.font_gray'))
                  .fontSize(14)
                  .textAlign(TextAlign.End)
                  .width('80%')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                Image($r('app.media.ic_arrow_right'))
                  .height(24)
                  .width(12)
                  .objectFit(ImageFit.Contain)
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .backgroundColor($r('app.color.pure_white'))
            .borderRadius(16)
            .padding({
              left: 12,
              right: 12,
              top: 18,
              bottom: 18
            })
            .onClick(() => {
              this.isShowModifyBind = true;
              this.isModifyUserName = true;
            })

            Row() {
              Text('手机号')
                .fontWeight('medium')
                .fontSize(16)

              Row({ space: 7 }) {
                Text(this.userInfoStorage.userInfo.phoneNumber)
                  .fontColor($r('app.color.font_gray'))
                  .fontSize(14)

                Image($r('app.media.ic_arrow_right'))
                  .height(24)
                  .width(12)
                  .objectFit(ImageFit.Contain)
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .backgroundColor($r('app.color.pure_white'))
            .borderRadius(16)
            .padding({
              left: 12,
              right: 12,
              top: 18,
              bottom: 18
            })
            .onClick(() => {
              this.isShowModifyBind = true;
              this.isModifyPhoneNumber= true;
            })

            Row() {
              Text('实名认证')
                .fontWeight('medium')
                .fontSize(16)

              Row({ space: 7 }) {
                if (this.userInfoStorage.realName) {
                  Text('已认证')
                    .fontColor($r('app.color.font_gray'))
                    .fontSize(14)
                } else {
                  Text('未认证')
                    .fontColor($r('app.color.font_orange'))
                    .fontSize(14)
                }
                Image($r('app.media.ic_arrow_right'))
                  .height(24)
                  .width(12)
                  .objectFit(ImageFit.Contain)
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .backgroundColor($r('app.color.pure_white'))
            .borderRadius(16)
            .padding({
              left: 12,
              right: 12,
              top: 18,
              bottom: 18
            })
            .onClick(() => {
              if (!this.userInfoStorage.realName) {
                this.pageInfos.pushPathByName(RouterPageEnum.REAL_NAME_AUTH_ROUTER, null)
              }
            })
          }
          .layoutWeight(1)
          .bindSheet($$this.isShowModifyBind, this.modify(), {
            detents: [SheetSize.MEDIUM, SheetSize.LARGE, 800],
            height: SheetSize.FIT_CONTENT,
            preferType: SheetType.BOTTOM,
            title: { title: this.isModifyUserName ? '修改昵称' : '修改电话' },
            onWillDismiss: ()=>{
              this.isShowModifyBind = false;
              this.isModifyUserName = false;
              this.isModifyPhoneNumber = false;
            }
          })




        }
        .edgeEffect(EdgeEffect.Spring)
      }
      .height('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ top: 8, left: 16, right: 16 })

    }
    .backgroundColor($r('app.color.common_background'))
    .title('个人信息')
  }
}