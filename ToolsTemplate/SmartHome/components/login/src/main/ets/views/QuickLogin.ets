import { hilog } from '@kit.PerformanceAnalysisKit';
import { authentication, loginComponentManager, LoginWithHuaweiIDButton } from '@kit.AccountKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';
import { LoginErrorCode } from '../model/ErrorCodeEntity';
import { LevelMode } from '@kit.ArkUI';
import { AgreementDialog } from '../components/AgreementView';
import { PrivacyTextSpan } from '../components/PrivacyTextSpan';
import { prompt } from 'base_apis';

@ComponentV2
export struct QuickLogin {
  @Param privacyText: loginComponentManager.PrivacyText[] = []
  @Param clickPrivacyCallBack: (text: ResourceStr) => void = () => {}
  @Param loginCallBack: () => void = () => {}
  logTag: string = 'QuickLoginButtonComponent';
  domainId: number = 0x0000;
  @Local anonymousPhone: string = ''
  // 是否勾选协议
  @Local isSelected: boolean = false;
  response: loginComponentManager.HuaweiIDCredential = {} as loginComponentManager.HuaweiIDCredential;
  controller: loginComponentManager.LoginWithHuaweiIDButtonController =
    new loginComponentManager.LoginWithHuaweiIDButtonController()
      // 需要用户同意协议才能完成华为账号登录，请先设置协议状态为NOT_ACCEPTED，当用户同意协议后设置协议状态为ACCEPTED，才可以完成华为账号登录
      .setAgreementStatus(loginComponentManager.AgreementStatus.NOT_ACCEPTED)
      .onClickLoginWithHuaweiIDButton((_error: BusinessError, response: loginComponentManager.HuaweiIDCredential) => {
        // 处理用户点击一键登录按钮逻辑，灰度传入undefined模拟流程，应用申请权限后，传入error
        this.handleLoginWithHuaweiIDButton(undefined, response);
      });
  error?: BusinessError;
  agreementDialog: CustomDialogController = new CustomDialogController({
    builder:
    AgreementDialog({
      privacyText: this.privacyText,
      cancel: () => {
        this.agreementDialog.close();
        // 设置协议状态为NOT_ACCEPTED
        this.controller.setAgreementStatus(loginComponentManager.AgreementStatus.NOT_ACCEPTED);
      },
      confirm: () => {
        this.agreementDialog.close();
        this.isSelected = true;
        // 设置协议状态为ACCEPTED
        this.controller.setAgreementStatus(loginComponentManager.AgreementStatus.ACCEPTED);
        if (this.error?.code === LoginErrorCode.ERROR_CODE_AGREEMENT_STATUS_NOT_ACCEPTED) {
          this.handleLoginWithHuaweiIDButton(undefined, this.response);
        } else {
          this.handleLoginWithHuaweiIDButton(this.error, this.response);
        }
      },
      clickPrivacyCallBack: this.clickPrivacyCallBack
    }),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    levelMode: LevelMode.EMBEDDED
  });

  aboutToAppear(): void {
    this.getQuickLoginAnonymousPhone()
  }

  build() {
    Column() {
      Column() {
        Row() {
          Image($r('app.media.appmarket'))
            .width(80)
            .height(80)
            .draggable(false)
            .copyOption(CopyOptions.None)
            .borderRadius(20)
        }.margin({
          top: 44,
          left: 124,
          right: 124
        })

        Column() {
          Text(this.anonymousPhone)
            .fontSize(36)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
            .fontWeight(FontWeight.Bold)
            .lineHeight(48)
            .textAlign(TextAlign.Center)
            .maxLines(1)
            .constraintSize({ maxWidth: '100%', minHeight: 48 })

          Text('华为账号绑定号码')
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
            .fontWeight(FontWeight.Regular)
            .lineHeight(19)
            .textAlign(TextAlign.Center)
            .maxLines(1)
            .constraintSize({ maxWidth: '100%' })
            .margin({
              top: 8
            })
        }.margin({
          top: 64
        })

        Column() {
          LoginWithHuaweiIDButton({
            params: {
              style: loginComponentManager.Style.BUTTON_RED,
              loginType: loginComponentManager.LoginType.QUICK_LOGIN,
              supportDarkMode: true,
            },
            controller: this.controller
          }).id('login_with_huaweiId_button')
        }
        .height(40)
        .width('100%')
        .constraintSize({ maxWidth: 448 })
        .margin({
          top: 56
        })
      }

      Row() {
        Row() {
          Checkbox({ name: 'privacyCheckbox', group: 'privacyCheckboxGroup' })
            .width(24)
            .height(24)
            .focusable(true)
            .focusOnTouch(true)
            .selectedColor('#CE0E2D')
            .select(this.isSelected)
            .margin({ top: 0 })
            .onChange((value: boolean) => {
              hilog.info(this.domainId, this.logTag, `agreementChecked: ${value}`);
              if (value) {
                this.isSelected = true;
                // 设置协议状态为ACCEPTED
                this.controller.setAgreementStatus(loginComponentManager.AgreementStatus.ACCEPTED);
              } else {
                this.isSelected = false;
                // 设置协议状态为NOT_ACCEPTED
                this.controller.setAgreementStatus(loginComponentManager.AgreementStatus.NOT_ACCEPTED);
              }
            })
        }.padding({
          right: 12
        })

        Row() {
          PrivacyTextSpan({
            privacyTexts: this.privacyText,
            clickPrivacyCallBack: this.clickPrivacyCallBack
          })
        }.width('100%')
        .layoutWeight(1)
        .constraintSize({ minHeight: 24 })
      }
      .alignItems(VerticalAlign.Top)
      .margin({
        bottom: 44
      })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .constraintSize({ minHeight: '100%' })
    .margin({
      left: 16,
      right: 16
    })
  }

  getQuickLoginAnonymousPhone() {
    // 创建授权请求，并设置参数
    const authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
    // 获取匿名手机号需传quickLoginAnonymousPhone这个scope，传参之前需要先申请“华为账号一键登录”权限
    authRequest.scopes = ['quickLoginAnonymousPhone'];
    // 用于防跨站点请求伪造
    authRequest.state = util.generateRandomUUID();
    // 一键登录场景该参数必须设置为false
    authRequest.forceAuthorization = false;
    const controller = new authentication.AuthenticationController();
    try {
      controller.executeRequest(authRequest).then((response: authentication.AuthorizationWithHuaweiIDResponse) => {
        // 获取到匿名手机号
        const anonymousPhone = response.data?.extraInfo?.quickLoginAnonymousPhone as string;
        if (anonymousPhone) {
          hilog.info(0x0000, 'testTag', 'Succeeded in authentication.');
          this.anonymousPhone = anonymousPhone
          return;
        }
        hilog.info(0x0000, 'testTag', 'Succeeded in authentication. AnonymousPhone is empty.');
      }).catch((error: BusinessError) => {
        // 以下内容配置好可用的调试证书和client_id后删除，当前为写死虚拟号码
        this.anonymousPhone = '123******90'
        hilog.error(0x0000, 'testTag',
          `Failed to get quickLoginAnonymousPhone, errorCode is ${error.code}, errorMessage is ${error.message}`);
      })
    } catch (error) {
      hilog.error(0x0000, 'testTag',
        `Failed to get quickLoginAnonymousPhone, errorCode is ${error.code}, errorMessage is ${error.message}`);
    }
  }

  // 处理点击一键登录后的方法
  handleLoginWithHuaweiIDButton(error: BusinessError | undefined,
    response: loginComponentManager.HuaweiIDCredential) {
    // if部分内容配置好可用的调试证书和client_id后再放开
    if (error) {
      hilog.error(this.domainId, this.logTag,
        `Failed to click LoginWithHuaweiIDButton. Code is ${error.code}, message is ${error.message}`);
      this.error = error;
      if (error.code === LoginErrorCode.ERROR_CODE_NETWORK_ERROR) {
        AlertDialog.show(
          {
            message: $r('app.string.hwid_no_internet_connect'),
            offset: { dx: 0, dy: -12 },
            alignment: DialogAlignment.Bottom,
            autoCancel: false,
            confirm: {
              value: $r('app.string.hwid_text_button_known'),
              action: () => {
              }
            }
          }
        );
      } else if (error.code === LoginErrorCode.ERROR_CODE_AGREEMENT_STATUS_NOT_ACCEPTED) {
        // 未同意协议，弹出协议弹框，推荐使用该回调方式
        this.agreementDialog.open();
      } else if (error.code === LoginErrorCode.ERROR_CODE_LOGIN_OUT) {
        // 华为账号未登录提示
        prompt($r('app.string.not_login_in'))
      } else if (error.code === LoginErrorCode.ERROR_CODE_NOT_SUPPORTED) {
        // 账号不支持该scopes或permissions提示
        prompt($r('app.string.scope_not_supported'));
      } else if (error.code === LoginErrorCode.ERROR_CODE_NOT_REQUIRED_SCOPE_OR_PERMISSION) {
        // 应用没有申请scope权限
        prompt($r('app.string.app_not_required_scopes_or_permissions'));
      } else {
        // 其他提示系统或服务异常
        prompt($r('app.string.service_error'));
      }
      return;
    }
    try {
      if (this.isSelected) {
        // 配置好可用的调试证书和client_id后再放开校验
        // if (response) {
        hilog.info(this.domainId, this.logTag, 'Succeed in clicking LoginWithHuaweiIDButton.');
        if (this.response.unionID === undefined) {
          this.response = response;
        }
        if (this.loginCallBack) {
          this.loginCallBack()
        }
      } else {
        this.agreementDialog.open();
      }
    } catch (e) {
      hilog.info(this.domainId, this.logTag,
        `Failed to LoginWithHuaweiIDButton, errCode: ${e.code}, errMessage: ${e.message}`);
      AlertDialog.show(
        {
          message: $r('app.string.service_error'),
          offset: { dx: 0, dy: -12 },
          alignment: DialogAlignment.Bottom,
          autoCancel: false,
          confirm: {
            value: $r('app.string.hwid_text_button_known'),
            action: () => {
            }
          }
        }
      );
    }
  }
}