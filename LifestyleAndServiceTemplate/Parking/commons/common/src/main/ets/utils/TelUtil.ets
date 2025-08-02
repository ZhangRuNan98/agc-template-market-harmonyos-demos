import { ComponentContent, UIContext, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { call } from '@kit.TelephonyKit';
import { Logger } from './Logger';

interface CallParams {
  title: string;
  phoneNum: string;
}

export class TelUtil {
  private static _uiContext: UIContext;
  private static _sheetOption: SheetOptions = {
    showClose: true,
    height: SheetSize.FIT_CONTENT,
  };
  private static _contentNode: ComponentContent<CallParams>;

  public static async open(params: CallParams) {
    if (!TelUtil._uiContext) {
      let windowClass: window.Window = await window.getLastWindow(getContext());
      let uiContext = windowClass.getUIContext();
      TelUtil._uiContext = uiContext;
    }
    TelUtil._contentNode = new ComponentContent(TelUtil._uiContext, wrapBuilder(callBuilder), params);
    TelUtil._uiContext.openBindSheet(TelUtil._contentNode, TelUtil._sheetOption);
  }

  public static close() {
    TelUtil._uiContext.closeBindSheet(TelUtil._contentNode);
  }

  public static desensitizePhoneNumber(phoneNum: string) {
    if (phoneNum.length === 11) {
      return phoneNum.slice(0, 3) + '****' + phoneNum.slice(7);
    }
    return phoneNum;
  }
}

class ButtonConstant {
  static readonly BG_COLOR_CONFIRM: ResourceColor = '#387BF1';
  static readonly BG_COLOR_CANCEL: ResourceColor = $r('sys.color.comp_background_tertiary');
  static readonly HEIGHT: Length = 40;
  static readonly FULL_WIDTH: Length = '100%';
}

@Builder
export function callBuilder(params: CallParams) {
  Column({ space: 22 }) {
    Text(params.title)
      .fontWeight(FontWeight.Medium)
      .width('100%')
      .fontSize($r('sys.float.Title_S'))
      .fontColor($r('sys.color.ohos_id_color_text_primary'))

    Column({ space: 12 }) {
      Text(TelUtil.desensitizePhoneNumber(params.phoneNum))
        .fontWeight(FontWeight.Medium)
        .fontSize($r('sys.float.Subtitle_L'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))

      Button() {
        Row({ space: 8 }) {
          SymbolGlyph($r('sys.symbol.phone'))
            .fontColor([$r('sys.color.white')])
            .fontWeight(FontWeight.Medium)
            .fontSize(20)
          Text('一键拨号')
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.font_on_primary'))
        }
      }
      .height(ButtonConstant.HEIGHT)
      .width(ButtonConstant.FULL_WIDTH)
      .backgroundColor(ButtonConstant.BG_COLOR_CONFIRM)
      .onClick(() => {
        if (canIUse('SystemCapability.Applications.Contacts')) {
          call.makeCall(params.phoneNum, (error: BusinessError) => {
            if (error) {
              Logger.error('Make call fail, error is: ' + JSON.stringify(error));
            } else {
              Logger.info('Make call success');
            }
          });
        }
      })

      Button('取消')
        .height(ButtonConstant.HEIGHT)
        .width(ButtonConstant.FULL_WIDTH)
        .backgroundColor(ButtonConstant.BG_COLOR_CANCEL)
        .fontColor($r('sys.color.font_tertiary'))
        .fontWeight(FontWeight.Medium)
        .onClick(() => {
          TelUtil.close();
        })
    }
    .backgroundColor(Color.White)
    .width('100%')
    .borderRadius(16)
    .padding({
      left: 12,
      right: 12,
      top: 16,
      bottom: 16,
    })
  }
  .width('100%')
  .padding({
    left: 16,
    right: 16,
    top: 32,
    bottom: 32,
  })
}