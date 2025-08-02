@ObservedV2
export class UserInfo {
  idToken: string = ''
  authCode: string = ''
  @Trace avatar: string = ''
  @Trace phoneNumber: string = ''
  @Trace userName: string = ''

  constructor(userInfo?: UserInfo) {
    this.idToken = userInfo?.idToken || ''
    this.authCode = userInfo?.authCode || ''
    this.avatar = userInfo?.avatar || ''
    this.phoneNumber = userInfo?.phoneNumber || ''
    this.userName = userInfo?.userName || ''
  }
}

// 用户登录信息数据
@ObservedV2
export class UserInfoStorage {
  @Trace realName: boolean = false;
  @Trace isLogin: boolean = false;
  @Trace userInfo: UserInfo = new UserInfo();

  constructor(isLogin?: boolean, userInfo?: UserInfo) {
    this.userInfo = new UserInfo(userInfo)
    this.isLogin = isLogin ?? false
  }
}