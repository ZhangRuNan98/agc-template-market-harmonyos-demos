import { BleClientModel } from 'bluetooth_scan';
import { AdapterModel } from 'external_interactions';

export class SelectWifiViewModel {
  deviceId: string
  deviceName: string = ''
  deviceImage: ResourceStr = ''

  bleClientModel = BleClientModel.getInstance()

  constructor(deviceId: string) {
    this.deviceId = deviceId

    let deviceInfo = this.bleClientModel.getBleDeviceInfo(deviceId)
    if (deviceInfo === undefined) {
      return
    }
    this.deviceName = deviceInfo.deviceName
    this.deviceImage = AdapterModel.getInstance().getDeviceInfo(this.deviceName).deviceInfo.deviceImage
  }

  setWifi(wifiName: string, wifiPassword: string) {
    this.bleClientModel.setWifi(this.deviceId, wifiName, wifiPassword)
  }
}