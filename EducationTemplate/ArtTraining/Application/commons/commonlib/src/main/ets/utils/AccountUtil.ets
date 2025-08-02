import auth from '@hw-agconnect/auth';
import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';
import { AppStorageV2, PersistenceV2, promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { AppStorageMap } from '../constants/CommonEnums';
import { UserInfo } from '../types/Index';
import { Logger } from './Logger';

const TAG = '[AccountUtil]';

enum ErrorCode {
  EXIST_USER = 1210005,
}

@ObservedV2
export class HuaweiAccountModel {
  @Trace public uid: string = ''; // 认证服务ID
}

@ObservedV2
export class UserInfoModel {
  @Trace public avatar: string = '';
  @Trace public nickname: string = '';
  @Trace public phone: string = '';
  @Trace public studentID: string = '';
  @Trace public wechat: string = '';
  @Trace public birthday: string = '';
}

@ObservedV2
export class AccountUtil {
  @Trace private static _accountInfo: HuaweiAccountModel = PersistenceV2.connect(
    HuaweiAccountModel,
    AppStorageMap.HUAWEI_ACCOUNT,
    () => new HuaweiAccountModel(),
  )!;
  @Trace private static _userInfo: UserInfoModel = AppStorageV2.connect(
    UserInfoModel,
    AppStorageMap.USER_INFO,
    () => new UserInfoModel(),
  )!;

  public static async authSignIn() {
    if (AccountUtil._accountInfo.uid) {
      return;
    }
    try {
      const signInResult = await auth.signIn({
        autoCreateUser: true,
        credentialInfo: {
          kind: 'hwid',
        },
      });
      Logger.info(TAG, `signInHwid success. result: ${signInResult.getUser().getUid()}`);
      AccountUtil._accountInfo.uid = signInResult.getUser().getUid();
    } catch (error) {
      // 当前用户已登录
      if (error.code === ErrorCode.EXIST_USER) {
        const signInResult = await auth.getCurrentUser();
        AccountUtil._accountInfo.uid = signInResult!.getUid();
        Logger.info(TAG, 'already sign in a user');
      } else {
        Logger.error(TAG, `signInHwid error, Code: ${error.code}, message: ${error.message}`);
      }
    }
  }

  public static async cancelAuthorization() {
    const cancelRequest: authentication.CancelAuthorizationRequest =
      new authentication.HuaweiIDProvider().createCancelAuthorizationRequest();
    cancelRequest.state = util.generateRandomUUID();
    try {
      const controller: authentication.AuthenticationController = new authentication.AuthenticationController();
      controller
        .executeRequest(cancelRequest)
        .then((data: authentication.AuthenticationResponse) => {
          const cancelAuthorizationResponse = data as authentication.CancelAuthorizationResponse;
          const state: string = cancelAuthorizationResponse.state!;
          if (cancelRequest.state !== state) {
            Logger.error('Failed to cancel. The state is different');
            return;
          }
          AccountUtil.clearUserInfo();
          promptAction.showToast({ message: '解除账号关联成功！' });
          Logger.debug(TAG, 'cancel authorization success');
        })
        .catch((err: BusinessError) => {
          Logger.error(`Failed to cancel. errCode is ${err.code}, errMessage is ${err.message}`);
        });
    } catch (err) {
      Logger.error(`Failed to cancel. errCode is ${err.code}, errMessage is ${err.message}`);
    }
  }

  public static getAccountInfo() {
    return AccountUtil._accountInfo;
  }

  public static clearUserInfo() {
    AccountUtil._userInfo.avatar = '';
    AccountUtil._userInfo.nickname = '';
    AccountUtil._userInfo.phone = '';
    AccountUtil._userInfo.studentID = '';
    AccountUtil._userInfo.wechat = '';
    AccountUtil._userInfo.birthday = '';
  }

  public static setUserInfo(info: UserInfo) {
    AccountUtil._userInfo.avatar = info.avatar;
    if (info.studentID) {
      AccountUtil._userInfo.studentID = info.studentID;
    }
    AccountUtil._userInfo.nickname = info.nickname;
    AccountUtil._userInfo.wechat = info.wechat;
    AccountUtil._userInfo.birthday = info.birthday;
    AccountUtil._userInfo.phone = info.phone;
  }

  public static getUserInfo() {
    return AccountUtil._userInfo;
  }
}
