import { Constants } from 'utils';
import { DeviceBaseInfoView } from 'uicomponents';
import { SelectWifiViewModel } from '../viewmodel/SelectWifiViewModel';
import { window } from '@kit.ArkUI';
import { WifiSelectView } from 'wifi_scan';

@Builder
export function SelectWifiPageBuilder(name: string, param: Object) {
  SelectWifiPage({ deviceId: param as string })
}

@ComponentV2
export struct SelectWifiPage {
  pathStack: NavPathStack = new NavPathStack()
  @Require @Param deviceId: string = ''
  selectWifiViewModel: SelectWifiViewModel = new SelectWifiViewModel(this.deviceId)
  windowClass: window.Window | undefined
  options: Array<SelectOption> = [];
  selectedWifiIndex: number = 0

  aboutToAppear(): void {
    window.getLastWindow(getContext(this), (error, data) => {
      if (error.code) {
        return
      }
      this.windowClass = data
      this.setWindowPrivacyMode(true)
    })
  }

  setWindowPrivacyMode(isPrivacy: boolean) {
    try {
      this.windowClass?.setWindowPrivacyMode(isPrivacy, (err) => {
        if (err.code) {
          console.error('Failed to set the window privacy mode ' + isPrivacy + '. Cause:' + JSON.stringify(err));
          return;
        }
      });
    } catch (exception) {
      console.error('Failed to set the window privacy mode ' + isPrivacy + '. Cause:' + JSON.stringify(exception));
    }
  }

  build() {
    NavDestination() {
      Column() {
        DeviceBaseInfoView({ image: this.selectWifiViewModel.deviceImage, name: this.selectWifiViewModel.deviceName })
        WifiSelectView({
          clickEvent: (wifiName: string, wifiPassWord) => {
            this.selectWifiViewModel.setWifi(wifiName, wifiPassWord)
            this.pathStack.pushPathByName('ConfigDevicePage', this.deviceId)
          }
        })
      }
      .height('100%')
      .width('100%')
      .expandSafeArea([SafeAreaType.SYSTEM])
    }
    .title('选择Wi-Fi')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
    .onShown(() => {
      this.setWindowPrivacyMode(true)
    })
    .onHidden(() => {
      this.setWindowPrivacyMode(false)
    })
    .backgroundColor(Constants.NAV_DESTINATION_BACKGROUND_COLOR)
  }
}