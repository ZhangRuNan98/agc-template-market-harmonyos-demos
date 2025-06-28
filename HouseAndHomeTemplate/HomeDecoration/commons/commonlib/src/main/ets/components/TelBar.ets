import { promptAction } from '@kit.ArkUI';
import { call } from '@kit.TelephonyKit';
import { Logger } from '../utils/Logger';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = '[TelBar]';


@ComponentV2
export struct TelBar {
  @Param phone: string = '';
  @Local isSupport: boolean = call.hasVoiceCapability();
  @Event onCancel: () => void = () => {

  };

  build() {
    Column({ space: 12 }) {
      Text(this.phone)
        .fontColor($r('sys.color.font_primary'))
        .fontSize($r('sys.float.Subtitle_L'))
        .fontWeight(FontWeight.Medium);
      Button() {
        Row({ space: 8 }) {
          Image($r('app.media.ic_light_phone')).width(24).height(24);
          Text('一键拨号')
            .fontColor($r('sys.color.font_on_primary'))
            .fontSize($r('sys.float.Body_L'))
            .fontWeight(FontWeight.Medium);
        };
      }.width('100%').height(40).backgroundColor($r('sys.color.alert'))
      .onClick(() => {
        if (this.isSupport) {
          call.makeCall(this.phone, (error: BusinessError) => {
            if (error) {
              Logger.error(TAG, 'make call fail, error is: ' + JSON.stringify(error));
            } else {
              Logger.info(TAG, 'make call success.');
            }
          });
        } else {
          promptAction.showToast({ message: '该设备暂不支持拨号' });
        }
      });

      Button('取消')
        .width('100%')
        .height(40)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .fontSize($r('sys.float.Body_L'))
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_secondary'))
        .onClick(() => {
          this.onCancel();
        });

    }
    .width('100%')
    .backgroundColor($r('sys.color.background_primary'))
    .borderRadius(16)
    .padding({
      left: 12,
      right: 12,
      top: 16,
      bottom: 16,
    });
  }
}