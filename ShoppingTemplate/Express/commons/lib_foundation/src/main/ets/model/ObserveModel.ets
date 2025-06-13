import { IUserInfo } from './IResponse'
import { AppStorageV2 } from '@kit.ArkUI'

/**
 * 签到
 */
@ObservedV2
export class CheckIn {
  @Trace id: number = 0
  @Trace isChecked: boolean = false
  @Trace value: number = 0

  constructor(id: number, isChecked: boolean, value: number) {
    this.id = id
    this.isChecked = isChecked
    this.value = value
  }
}

/**
 * 优惠券
 */
@ObservedV2
export class Coupon {
  @Trace id: number = 0
  @Trace name: string = ''
  @Trace type: number = 0
  @Trace promotion: number = 0
  @Trace promotionsLimit: string = ''
  @Trace goodsLimit: string = ''
  @Trace time: string = ''
  @Trace isAvailable: boolean = true
  @Trace isShow: boolean = false
  @Trace instructionList?: string[]

  constructor(id: number, name: string, type: number, promotion: number, promotionsLimit: string, goodsLimit: string,
    time: string, isAvailable: boolean, isShow: boolean, instructionList?: string[]) {
    this.id = id
    this.name = name
    this.type = type
    this.promotion = promotion
    this.promotionsLimit = promotionsLimit
    this.goodsLimit = goodsLimit
    this.time = time
    this.isAvailable = isAvailable
    this.isShow = isShow
    this.instructionList = instructionList
  }
}

/**
 * 读取用户信息响应
 */
@ObservedV2
export class UserInfo implements IUserInfo {
  @Trace loginToken: string = ''
  @Trace id: number = 0;
  @Trace name: string = '';
  @Trace nickname: string = '';
  @Trace sex: string = '';
  @Trace cellphone: string = '';
  @Trace birthday: string = '';
  @Trace avatar: string = '';
  @Trace isVip: boolean = false;
  @Trace points: number = 0;
  @Trace couponList: number[] = []
  @Trace realNameAuthFlag: number = 0
}

/**
 * AppStorageV2应用全局缓存库
 */
export class AppStorageBank {
  static userInfo: UserInfo = AppStorageV2.connect(UserInfo, () => new UserInfo())!;

  static updateUserInfo(v: IUserInfo) {
    AppStorageBank.userInfo.loginToken = v.loginToken;
    AppStorageBank.userInfo.id = v.id;
    AppStorageBank.userInfo.name = v.name;
    AppStorageBank.userInfo.nickname = v.nickname;
    AppStorageBank.userInfo.sex = v.sex;
    AppStorageBank.userInfo.cellphone = v.cellphone;
    AppStorageBank.userInfo.birthday = v.birthday;
    AppStorageBank.userInfo.avatar = v.avatar;
    AppStorageBank.userInfo.isVip = v.isVip;
    AppStorageBank.userInfo.points = v.points;
    AppStorageBank.userInfo.couponList = v.couponList;
    AppStorageBank.userInfo.realNameAuthFlag = v.realNameAuthFlag;
  }
}