import { MessageList } from 'message_list';
import { DeviceNotifyListViewModel } from '../viewmodel/DeviceNotifyListViewModel';

@ComponentV2
export struct DeviceNotifyListView {
  @Require @Param messageListViewModel: DeviceNotifyListViewModel;

  build() {
    Column() {
      Row() {
        Column() {
          MessageList({
            messageList:this.messageListViewModel.deviceMessageRecords
          })
        }
        .width('90%')
        .margin({ top: 20, bottom: 20 });
      }
      .justifyContent(FlexAlign.Center)
      .width('90%')
      .backgroundColor('#FFFFFF')
      .borderRadius(16);
    }
    .height('80%');
  }
}