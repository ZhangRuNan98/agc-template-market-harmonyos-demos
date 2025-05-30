import { MockService } from 'external_interactions';
import { qrCodeDialog } from './QrCodeDialog';
import { CustomContentDialog } from '@kit.ArkUI';
import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';

@Component
export struct UserInfoCard {
  // qrCode弹窗
  private qrCodeDialogController?: CustomDialogController;
  @State pathStack: NavPathStack = new NavPathStack();
  @StorageLink('loginState') loginState: boolean = false;
  @State cardNumber: string = '';
  @State balance: number = 0;
  @State nickname: string = '';
  @State avatar: ResourceStr = '';
  @StorageLink('accountUpdate') @Watch('refreshUserInfo') accountUpdate: boolean = false;
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomContentDialog({
      primaryTitle: '账号解除关联',
      contentBuilder: () => {
        this.buildContent();
      },
      buttons: [
        {
          value: '取消',
          buttonStyle: ButtonStyleMode.TEXTUAL,
          action: () => {
          }
        },
        {
          value: '确定',
          buttonStyle: ButtonStyleMode.TEXTUAL,
          action: () => {
            this.loginState = false;
            MockService.dataPreferences.putSync('loginState', false)
            MockService.dataPreferences.flush()
            this.refreshUserInfo();
          }
        }
      ],
    }),
  });

  @Builder
  buildContent() {
    Text('请确认是否解除账号关联')
      .width('100%')
      .textAlign(TextAlign.Center)
      .fontSize(14)
  }

  refreshUserInfo() {
    if (this.loginState) {
      this.cardNumber = MockService.account.memberId
      this.balance = MockService.account.balance
      this.nickname = MockService.account.nickname
      this.avatar = MockService.account.avatar
    }
  }

  aboutToAppear(): void {
    this.refreshUserInfo();
  }

  build() {
    Column() {
      Row() {
        Row() {
          Row() {
            Image(this.loginState ? (this.avatar ? this.avatar : $r('app.media.avatar_no_login')) :
            $r('app.media.avatar_no_login'))
              .width(72)
              .height(72)
              .borderRadius(36)
            Row() {
              Image($r('app.media.associate_avator'))
                .width(12)
                .height(12)
              Text(this.loginState ? '解除关联' : '关联账号')
                .fontSize(10)
                .fontColor(Color.White)
                .margin({ left: 5 })
            }
            .justifyContent(FlexAlign.Center)
            .width(72)
            .height(24)
            .borderRadius(12)
            .backgroundColor('#FF9019')
            .margin({ left: 12 })
            .onClick(() => {
              if (this.loginState) {
                this.dialogController.open()
              } else {
                // 取消授权重新获取，强制弹窗
                this.cancelAuthorization()
              }
            })
          }
          .onClick(() => {
            if (this.loginState) {
              if (this.pathStack) {
                this.pathStack.pushPath({ name: 'vip/MineInfoPage', param: this.loginState })
              }
            }
          })

          Column() {
            if (this.loginState) {
              Row() {
                Image($r('app.media.qr_icon'))
                  .width(24)
                  .height(24)
              }
              .alignItems(VerticalAlign.Top)
              .justifyContent(FlexAlign.Center)
              .margin({ bottom: 4 })
            }

            Text(this.loginState ? '会员码' : '无会员码')
              .fontSize(12)
              .fontColor($r('sys.color.comp_background_list_card'))
          }
          .onClick(() => {
            if (this.loginState) {
              this.openQrCodeConfirmDialog();
            }
          })
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)
        .layoutWeight(1)
      }

      Row() {
        Text('卡号：' + (this.loginState ? this.cardNumber : '无'))
          .fontSize(12)
          .fontColor($r('sys.color.comp_background_list_card'))

        Text('余额：' + (this.loginState ? this.balance : '无'))
          .fontSize(12)
          .fontColor($r('sys.color.comp_background_list_card'))
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .margin({ top: 15 })
    }
    .width('100%')
    .backgroundImage($r('app.media.user_card_background'))
    .backgroundImageSize({ width: '100%', height: '100%' })
    .borderRadius(16)
    .padding({
      left: 16,
      right: 16,
      top: 12,
      bottom: 20
    })
  }

  /**
   * 创建删除提示弹框的Controller
   */
  private openQrCodeConfirmDialog(): void {
    this.qrCodeDialogController = new CustomDialogController({
      builder: qrCodeDialog(),
      autoCancel: true,
      offset: { dx: 0, dy: -16 }
    })
    this.qrCodeDialogController.open();
  }

  private getPhone() {
    const authRequest: authentication.AuthorizationWithHuaweiIDRequest =
      new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
    authRequest.scopes = ['phone'];
    authRequest.permissions = ['serviceauthcode'];
    authRequest.forceAuthorization = true;
    authRequest.state = util.generateRandomUUID();
    try {
      const controller: authentication.AuthenticationController =
        new authentication.AuthenticationController(getContext(this));
      controller.executeRequest(authRequest)
        .then((data: authentication.AuthenticationResponse) => {
          const authorizationWithHuaweiIDResponse = data as authentication.AuthorizationWithHuaweiIDResponse;
          const state: string = authorizationWithHuaweiIDResponse.state!;
          if (state && authRequest.state !== state) {
            return;
          }
          this.updateLogin()
        })
        .catch(() => {
          // Mock逻辑，不管是否有证书权限，都直接关联
          this.updateLogin()
        })
    } catch (error) {
      // Mock逻辑，不管是否有证书权限，都直接关联
      this.updateLogin()
      console.error(`Failed to authorize. errCode: ${error.code}, errMessage: ${error.message}`);
    }
  }

  cancelAuthorization() {
    const cancelRequest: authentication.CancelAuthorizationRequest =
      new authentication.HuaweiIDProvider().createCancelAuthorizationRequest();
    cancelRequest.state = util.generateRandomUUID();
    try {
      const controller: authentication.AuthenticationController = new authentication.AuthenticationController();
      controller.executeRequest(cancelRequest)
        .then((data: authentication.AuthenticationResponse) => {
          let cancelAuthorizationResponse = data as authentication.CancelAuthorizationResponse;
          let state: string = cancelAuthorizationResponse.state!;
          if (cancelRequest.state !== state) {
            console.error('Failed to cancel. The state is different');
            return;
          }
          this.getPhone()
        })
        .catch((err: BusinessError) => {
          this.getPhone()
          console.error(`Failed to authorize. errCode: ${err.code}, errMessage: ${err.message}`);
        })
    } catch (err) {
      this.getPhone()
      console.error(`Failed to authorize. errCode: ${err.code}, errMessage: ${err.message}`);
    }
  }

  updateLogin() {
    this.loginState = true;
    MockService.dataPreferences.putSync('loginState', true)
    MockService.dataPreferences.flush()
    this.refreshUserInfo();
  }
}