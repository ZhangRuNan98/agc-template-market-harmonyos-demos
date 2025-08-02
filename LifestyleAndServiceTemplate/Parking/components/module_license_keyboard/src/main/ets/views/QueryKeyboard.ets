import { LengthUnit, promptAction } from '@kit.ArkUI';
import { CommonKeyboard } from '../components/CommonKeyboard';
import { UsedLicenseModel, UsedLicenseUtil } from '../utils/LicenseUtil';

@ComponentV2
export struct QueryKeyboard {
  @Param myLicenses: string[] = [];
  @Event click: (carNumber: string) => void;
  @Once @Param curLicense: string = '';
  @Local isFull: boolean = false;
  @Local usedLicenses: UsedLicenseModel = UsedLicenseUtil.getLicenses();
  bgColor: ResourceStr = '#F1F3F5';
  btnBgColor: ResourceStr = '#387BF1';
  btnHeight: Length = 40;
  btnTextSize: Length = $r('sys.float.Body_L');
  btnTextColor: ResourceColor = $r('sys.color.font_on_primary');

  getBgColor(license: string, canDelete: boolean): ResourceStr {
    if (canDelete) {
      return $r('sys.color.background_primary');
    } else if (license.length < 8) {
      return $r('sys.color.brand');
    }
    return '';
  }

  build() {
    Column({ space: 8 }) {
      Scroll() {
        Column() {
          /** 车牌显示 **/
          CommonKeyboard({
            defaultNumbers: this.curLicense,
            onChange: (numbers, full) => {
              this.curLicense = numbers.join('');
              this.isFull = full;
            },
          }).margin({ top: 18 }).width('calc(100% - 24vp)')

          Column() {
            if (this.myLicenses.length) {
              Text('我的车牌').titleStyle()
              this.myLicensesBuilder()
            }

            if (this.usedLicenses.all.length) {
              Text('最近使用').titleStyle()
              this.usedLicensesBuilder()
            }
            Blank().layoutWeight(1)
          }
          .padding({ left: 16, right: 16 })
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)

      /** 查询按钮 **/
      Button('查询')
        .fontWeight(FontWeight.Medium)
        .height(this.btnHeight)
        .fontSize(this.btnTextSize)
        .fontColor(this.btnTextColor)
        .backgroundColor(this.btnBgColor)
        .width('calc(100% - 56vp)')
        .onClick(() => {
          if (!this.isFull) {
            promptAction.showToast({ message: '请补充完整车牌' });
            return;
          }
          if (!this.myLicenses.includes(this.curLicense) && UsedLicenseUtil.findIndex(this.curLicense) === -1) {
            UsedLicenseUtil.addLicense(this.curLicense);
          }
          this.click(this.curLicense);
        })
    }
    .width('100%')
    .backgroundColor(this.bgColor)
  }

  @Builder
  myLicensesBuilder() {
    Flex({
      wrap: FlexWrap.Wrap,
      space: { main: { value: 10, unit: LengthUnit.VP }, cross: { value: 10, unit: LengthUnit.VP } },
    }) {
      ForEach(this.myLicenses, (license: string) => {
        this.licenseItemBuilder(license, false)
      }, (license: string) => license)
    }
  }

  @Builder
  usedLicensesBuilder() {
    Flex({
      wrap: FlexWrap.Wrap,
      space: { main: { value: 10, unit: LengthUnit.VP }, cross: { value: 10, unit: LengthUnit.VP } },
    }) {
      ForEach(this.usedLicenses.all, (license: string) => {
        this.licenseItemBuilder(license, true)
      }, (license: string) => license)
    }
  }

  @Builder
  licenseItemBuilder(text: string, canDelete: boolean) {
    Column() {
      Text(text)
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .fontSize($r('sys.float.Body_M'))
        .fontColor(!canDelete && text.length < 8 ? $r('sys.color.font_on_primary') : $r('sys.color.font_primary'))
      if (canDelete) {
        Image($r('app.media.ic_used_delete'))
          .width(10)
          .position({ right: -4, top: -10 })
          .onClick(() => {
            UsedLicenseUtil.deleteLicense(text);
          })
      }
    }
    .width(96)
    .backgroundColor(this.getBgColor(text, canDelete))
    .linearGradient({
      angle: 90,
      colors: canDelete || text.length < 8 ? [] : [
        ['#7FDE3C', 0],
        ['#DDFFB8', 1],
      ],
    })
    .borderRadius(8)
    .padding({ top: 6, bottom: 6 })
    .onClick(() => {
      this.curLicense = text;
    })
  }
}

@Extend(Text)
function titleStyle() {
  .fontWeight(FontWeight.Medium)
  .width('100%')
  .fontSize($r('sys.float.Subtitle_M'))
  .fontColor($r('sys.color.font_primary'))
  .margin({ top: 24, bottom: 12 })
}