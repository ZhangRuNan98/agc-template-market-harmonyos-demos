import { https, IUserInfo, UpdateUserInfoRequest, MockStorageMap } from 'lib_foundation';
import { promptAction } from '@kit.ArkUI';
import { emitter } from '@kit.BasicServicesKit';
import { RouterMap, RouterModule } from 'module_base';

@ObservedV2
export class EditNamePageVM {
  private static _instance: EditNamePageVM;
  @Trace public userInfo: IUserInfo | undefined
  @Trace public nickname: string = ''
  @Trace public cellphone: string = ''
  @Trace title: string = ''

  public static get instance() {
    if (!EditNamePageVM._instance) {
      EditNamePageVM._instance = new EditNamePageVM();
    }
    return EditNamePageVM._instance;
  }

  init() {
    const param = RouterModule.getNavParam<string>({
      url: RouterMap.EDIT_PAGE,
    });
    if (param) {
      this.title = param
    }
    const userInfo = AppStorage.get<IUserInfo>(MockStorageMap.USER_INFO)
    if (userInfo) {
      this.userInfo = userInfo
      this.nickname = userInfo.nickname
      this.cellphone = userInfo.cellphone
    }
  }

  clear() {
    this.userInfo = undefined
    this.nickname = ''
    this.cellphone = ''
  }

  modify() {
    if (!this.userInfo) {
      return
    }
    if (this.title === '昵称') {
      if (!this.nickname) {
        promptAction.showToast({
          message: '昵称不能为空',
          duration: 2000,
          alignment: Alignment.Center
        });
        return
      }
      if (this.nickname.length > 8) {
        promptAction.showToast({
          message: '昵称不能超过8位',
          duration: 2000,
          alignment: Alignment.Center
        });
        return
      }
    } else {
      if (!this.cellphone) {
        promptAction.showToast({
          message: '手机号不能为空',
          duration: 2000,
          alignment: Alignment.Center
        });
        return
      }

      if (this.cellphone.length !== 11) {
        promptAction.showToast({
          message: '手机号不是11位',
          duration: 2000,
          alignment: Alignment.Center
        });
        return
      }
    }
    const updateUserInfoRequest: UpdateUserInfoRequest =
      {
        id: this.userInfo.id,
        name: this.userInfo.name,
        nickname: this.nickname,
        sex: this.userInfo.sex,
        cellphone: this.cellphone,
        birthday: this.userInfo.birthday,
        avatar: this.userInfo.avatar,
      }
    this.updateUserInfo(updateUserInfoRequest)
  }

  public async updateUserInfo(data: UpdateUserInfoRequest) {
    await https.updateUserInfo(data);
    promptAction.showToast({
      message: '修改成功',
      duration: 2000,
      alignment: Alignment.Center
    });
    let uerInfo: emitter.EventData = {
      data: {
        isLogin: true,
      },
    };
    emitter.emit('isLogin', uerInfo);
  }
}
