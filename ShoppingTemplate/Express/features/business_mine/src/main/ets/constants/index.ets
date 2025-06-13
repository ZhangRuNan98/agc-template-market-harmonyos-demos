import { IMainServiceItem } from '../types';
import { ControllerModule, RouterMap, TelUtil } from 'module_base';
import { IUserInfo, RouterModule } from 'lib_foundation';
import { MinePageVM } from '../viewModels/MinePageVM';
import { promptAction } from '@kit.ArkUI';

export const userInfoData: IUserInfo = {
  loginToken: '',
  id: 0,
  name: '',
  nickname: '',
  sex: '',
  cellphone: '',
  birthday: '',
  avatar: '',
  isVip: false,
  points: 0,
  couponList: [],
  realNameAuthFlag: 0
}

export const mainServiceList: IMainServiceItem[] = [
  {
    text: '我的快递',
    image: $r('app.media.ic_mine_express'),
    func: () => {
      const controller = ControllerModule.get()
      if (controller) {
        controller.changeIndex(1)
      }
    }
  },
  {
    text: '地址簿',
    image: $r('app.media.wc'),
    func: () => {
      RouterModule.push({ url: RouterMap.ADDRESS_PAGE, param: false })
    }
  },
  {
    text: '实名认证',
    image: $r('app.media.ic_card'),
    func: (vm: MinePageVM) => {
      if (vm.userInfo && vm.userInfo.realNameAuthFlag === 1) {
        promptAction.showToast({ message: '已实名！', alignment: Alignment.Center })
        return
      }
      RouterModule.push({ url: RouterMap.REAL_NAME_AUTH_PAGE })
    }
  },
  {
    text: '联系客服',
    image: $r('app.media.service'),
    func: () => {
      TelUtil.makeCall('联系客服', '10000000000');
    }
  },
]

export const privacy: string = '欢迎您使用我们的快递物流模板，您的信任对我们很重要，我们将严格遵守法律法规要求的安全保护措施，保护您的个人信息安全可控。'