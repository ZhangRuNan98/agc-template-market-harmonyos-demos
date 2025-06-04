import { AccountUtil, DialogParams, DialogUtil, RouterMap, RouterModule, UserInfo } from 'commonlib';
import { ConfirmDialogComponent } from '../components/ConfirmDialogComponent';
import { FunctionItem } from '../types/Index';

@ObservedV2
export class SettingsPageVM {
  @Trace wBuilder: WrappedBuilder<[DialogParams]> = wrapBuilder(ConfirmDialogComponent);
  @Trace userInfo: UserInfo = AccountUtil.getUserInfo();
  @Trace settingList: FunctionItem[] =
    [
      new FunctionItem('个人信息', () => {
        RouterModule.push(RouterMap.PERSON_INFO_PAGE)
      }),
      new FunctionItem('隐私政策', () => {
        RouterModule.push(RouterMap.TERMS_OF_SERVICE_PAGE)
      }),
      new FunctionItem('用户协议', () => {
        RouterModule.push(RouterMap.PRIVACY_POLICY_DETAIL_PAGE)
      }),
      new FunctionItem('清除缓存', () => {
        this.clearCache()
      }, '100.33M'),
    ];

  clearCache() {
    DialogUtil.openDialog(this.wBuilder, {
      title: '确认清除缓存？', confirmFunc: () => {
        this.settingList.forEach(item => {
          if (item.label === '清除缓存') {
            item.rightLabel = '0M';
          }
        })
        DialogUtil.close()
      },
      cancelFunc: () => {
        DialogUtil.close()
      },
    });
  }

  logout() {
    // 退出登录并清除登录信息
    this.userInfo.id = 0
    this.userInfo.avatar = ''
    this.userInfo.name = ''
    this.userInfo.nickname = ''
    this.userInfo.sex = ''
    this.userInfo.cellphone = ''
    this.userInfo.birthday = ''
    this.userInfo.code = ''
    this.userInfo.isLogin = false
  }
}