import { MessageRecordViewModel } from 'message_list';
import { AddedDeviceObserverIntf, AddedDevicesModel, DeviceNotifyRecord } from '../model/AddedDevicesModel';

@ObservedV2
export class DeviceNotifyListViewModel extends AddedDeviceObserverIntf {
  deviceId: string = '';
  deviceName: string = '';
  deviceImage: ResourceStr = '';
  @Trace deviceMessageRecords: MessageRecordViewModel[] = [];
  private deviceMngModel: AddedDevicesModel = AddedDevicesModel.getInstance();

  constructor(deviceId: string) {
    super();
    let addedDeviceInfo = this.deviceMngModel.getAddedDeviceInfo(deviceId);
    if (addedDeviceInfo === undefined) {
      return;
    }

    this.deviceId = addedDeviceInfo.deviceId;
    this.deviceName = addedDeviceInfo.deviceName;
    this.deviceImage = addedDeviceInfo.deviceImage;
    addedDeviceInfo.deviceNotifyRecords.forEach((item) => {
      this.deviceMessageRecords.unshift(new MessageRecordViewModel(item.message, item.date));
    });
    this.deviceMngModel.registerAddedDeviceObserver(this.deviceId, this);
  }

  public setDeviceMessageRead() {
    this.deviceMngModel.setDeviceMessageRead(this.deviceId, true);
  }

  override OnDeviceNotifyRecordAdd(record: DeviceNotifyRecord): void {
    this.deviceMessageRecords.unshift(new MessageRecordViewModel(record.message, record.date));
  }
}