import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import fs from '@ohos.file.fs';
import { util } from '@kit.ArkTS';
import { functionalButtonComponentManager } from '@kit.ScenarioFusionKit';
import { https, IUserInfo, UpdateUserInfoRequest } from 'lib_foundation';
import { RouterModule } from 'module_base';

@ObservedV2
export class PersonalInformationVM {
  private static _instance: PersonalInformationVM;
  @Trace public userInfo: IUserInfo | undefined
  @Trace public avatar: string = ''
  @Trace public nickname: string = ''
  @Trace public cellphone: string = ''

  public static get instance() {
    if (!PersonalInformationVM._instance) {
      PersonalInformationVM._instance = new PersonalInformationVM();
    }
    return PersonalInformationVM._instance;
  }

  init() {
    this.getUserInfo()
  }

  public async getUserInfo() {
    const res = await https.getUserInfo();
    if (res.code === 0) {
      this.userInfo = res.data;
      this.avatar = this.userInfo.avatar
      this.nickname = this.userInfo.nickname
      this.cellphone = this.userInfo.cellphone
    }
  }

  getAvatarSrc(
    error: BusinessError,
    data: functionalButtonComponentManager.ChooseAvatarResult,
  ) {
    if (error) {
      promptAction.showToast({ message: '获取头像失败，请稍后重试' });
      return;
    }
    let avatarFile: fs.File | null = null;
    try {
      avatarFile = fs.openSync(data.avatarUri!, fs.OpenMode.READ_ONLY);
      let newPath =
        getContext().cacheDir + `/${util.generateRandomUUID(false)}.png`;
      fs.copyFileSync(avatarFile.fd, newPath);
      this.avatar = 'file://' + newPath;
    } catch (err) {
      console.error('get photo error:' + err);
    } finally {
      if (avatarFile) {
        try {
          fs.closeSync(avatarFile);
          this.avatar = data.avatarUri!;
          this.modify()
        } catch (err) {
          console.error('close file failed,error:' + JSON.stringify(err));
        }
      }
    }
  }

  modify() {
    if (!this.userInfo) {
      return
    }
    if (!this.userInfo.cellphone) {
      promptAction.showToast({
        message: '手机号不能为空',
        duration: 2000,
        alignment: Alignment.Center
      });
      return
    }
    const updateUserInfoRequest: UpdateUserInfoRequest =
      {
        id: this.userInfo.id,
        name: this.userInfo.name,
        nickname: this.userInfo.nickname,
        sex: this.userInfo.sex,
        cellphone: this.userInfo.cellphone,
        birthday: this.userInfo.birthday,
        avatar: this.avatar,
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
