import { GetWifiInfoModel } from '../model/GetWifiInfoModel';

@ComponentV2
export struct WifiSelectView {
  @Local wifiPassword: string = ''
  @Local wifiName: string = ''
  options: Array<SelectOption> = [];
  @Param clickEvent?: (wifiName: string, wifiPassword: string) => void = () => {}

  aboutToAppear(): void {
    this.GetWifi()
  }

  build() {
    Column() {
      this.BuildWifiNameInput()
      this.BuildWifiPasswordInput()
      this.BuildNextButton()
    }
  }

  GetWifi(): void {
    let scanInfoList = GetWifiInfoModel.getInstance().getScanInfo();
    scanInfoList.forEach((item) => {
      if (item.ssid) {
        this.options.push({ value: item.ssid, icon: $r('app.media.wlan') });
      }
    })
  }

  @Builder
  BuildWifiNameInput() {
    Select(this.options)
      .optionHeight(300)
      .value('点击选择Wi-Fi')
      .margin({ top: 50 })
      .InputStyle()
      .onSelect((_index: number, text?: string | undefined) => {
        if (text) {
          this.wifiName = text
        }
      })
  }

  @Builder
  BuildWifiPasswordInput() {
    TextInput({ placeholder: 'Wi-Fi密码' })
      .type(InputType.Password)
      .margin({ top: 20 })
      .InputStyle()
      .onChange((value: string) => {
        this.wifiPassword = value
      })
  }

  @Builder
  BuildNextButton() {
    Button('下一步')
      .margin({ top: 100 })
      .width('60%')
      .onClick(() => {
        if (this.clickEvent) {
          this.clickEvent(this.wifiName, this.wifiPassword)
        }
      })
  }

  @Styles
  InputStyle() {
    .width('80%')
    .backgroundColor(Color.White)
  }
}