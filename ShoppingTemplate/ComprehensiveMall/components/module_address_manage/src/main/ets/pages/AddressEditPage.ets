import { Context } from '../common/Context';
import { TitleBar } from '../common/TitleBar';
import { buildLoadingMask } from '../common/CommonBuilders';
import { IColor, IFontSize, IStyle, Operation } from '../common/CommonConst';
import { AddressDTO } from '../model/AddressDTO';
import { AddressVM } from '../viewmodel/AddressVM';

import { promptAction } from '@kit.ArkUI';
import { sceneMap } from '@kit.MapKit';

@ComponentV2
struct AddressEditPage {

  @Param
  public ctx: Context = new Context();

  @Local
  private address: AddressVM = new AddressVM();

  public aboutToAppear(): void {
    if (this.ctx.operation === Operation.EDIT && this.ctx.editingAddressDTO) {
      this.address.assignFromDTO(this.ctx.editingAddressDTO);
    }
  }

  public build(): void {
    NavDestination() {
      Column() {
        TitleBar({
          onBackButtonClick: () => this.ctx.navPathStack.pop(),
          barColor: IColor.WHITE,
        }) {
          Text(this.ctx.operation === Operation.EDIT ? '编辑地址' : '新增地址')
            .fontSize(IFontSize.TITLE)
            .fontColor(IColor.BLACK_TRANSPARENT_90)
            .fontWeight(500)
        }
        Stack() {
          this.buildMainContent();
          if (this.ctx.addressMgr.isLoading) {
            buildLoadingMask();
          }
        }
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .backgroundColor(IColor.BACKGROUND)
      .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.BOTTOM, SafeAreaEdge.TOP])
    }
    .hideTitleBar(true)
  }

  @Builder
  private buildMainContent(): void {
    Column() {
      Scroll() {
        Column() {
          // 收货人 & 手机号码
          Column() {
            Row() {
              Text('收货人')
                .width(56)
                .fontSize(14)
                .fontColor(IColor.BLACK_TRANSPARENT_60)
                .textAlign(TextAlign.Start)
                .margin({ right: 24 })
              TextInput({ text: this.address.name, placeholder: '请填写收货人姓名' })
                .layoutWeight(1)
                .placeholderColor(IColor.BLACK_TRANSPARENT_40)
                .caretColor(IColor.THEME_PRIMARY)
                .maxLength(25)
                .fontColor(IColor.BLACK_TRANSPARENT_90)
                .fontSize(14)
                .placeholderFont({ size: 14 })
                .borderRadius(0)
                .padding(0)
                .maxLines(1)
                .backgroundColor(IColor.WHITE)
                .onChange((value: string) => this.address.name = value)
            }
            .width('100%')
            .height(48)
            .alignItems(VerticalAlign.Center)
            Divider()
              .height(IStyle.DIVIDER_HEIGHT)
              .backgroundColor(IColor.BACKGROUND)
            Row() {
              Text('手机号码')
                .width(56)
                .fontSize(14)
                .fontColor(IColor.BLACK_TRANSPARENT_60)
                .textAlign(TextAlign.Start)
                .margin({ right: 24 })
              TextInput({ text: this.address.phone, placeholder: '请填写收货人手机号' })
                .layoutWeight(1)
                .type(InputType.PhoneNumber)
                .placeholderColor(IColor.BLACK_TRANSPARENT_40)
                .caretColor(IColor.THEME_PRIMARY)
                .maxLength(11)
                .fontColor(IColor.BLACK_TRANSPARENT_90)
                .fontSize(14)
                .placeholderFont({ size: 14 })
                .borderRadius(0)
                .padding(0)
                .maxLines(1)
                .backgroundColor(IColor.WHITE)
                .onChange((value: string) => this.address.phone = value)
            }
            .width('100%')
            .height(48)
            .alignItems(VerticalAlign.Center)
          }
          .width('100%')
          .backgroundColor(IColor.WHITE)
          .borderRadius(8)
          .padding({ left: 16, right: 16 })
          // 所在区域 & 详细地址
          Column() {
            Row() {
              Text('所在区域')
                .width(56)
                .fontSize(14)
                .fontColor(IColor.BLACK_TRANSPARENT_60)
                .textAlign(TextAlign.Start)
                .margin({ right: 24 })
              Column() {
                if (this.address.region) {
                  Text(this.address.region)
                    .width('100%')
                    .fontSize(14)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .fontColor(IColor.BLACK_TRANSPARENT_90)
                    .textAlign(TextAlign.Start)
                } else {
                  Text('省市区县、乡镇等')
                    .width('100%')
                    .fontSize(14)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .fontColor(IColor.BLACK_TRANSPARENT_40)
                    .textAlign(TextAlign.Start)
                }
              }
              .layoutWeight(1)
              .onClick(() => this.handleSelectDistrict())
            }
            .width('100%')
            .height(48)
            .alignItems(VerticalAlign.Center)
            Divider()
              .height(IStyle.DIVIDER_HEIGHT)
              .backgroundColor(IColor.BACKGROUND)
            Row() {
              Text('详细地址')
                .width(56)
                .height(48)
                .fontSize(14)
                .fontColor(IColor.BLACK_TRANSPARENT_60)
                .textAlign(TextAlign.Start)
                .margin({ right: 24 })
              TextArea({ text: this.address.detail, placeholder: '小区、写字楼、门牌号等' })
                .layoutWeight(1)
                .placeholderColor(IColor.BLACK_TRANSPARENT_40)
                .placeholderFont({ size: 14 })
                .caretColor(IColor.THEME_PRIMARY)
                .fontColor(IColor.BLACK_TRANSPARENT_90)
                .fontSize(14)
                .maxLength(80)
                .showCounter(true, { thresholdPercentage: 50, highlightBorder: false })
                .barState(BarState.Off)
                .onChange((value: string) => this.address.detail = value)
                .borderRadius(0)
                .padding({ top: 15.85, bottom: 15.85, left: 0, right: 0 })
                .backgroundColor(IColor.WHITE)
                .height(130)
            }
            .width('100%')
            .alignItems(VerticalAlign.Top)
          }
          .width('100%')
          .backgroundColor(IColor.WHITE)
          .borderRadius(8)
          .padding({ left: 16, right: 16 })
          .margin({ top: IStyle.CARD_GAP })
          // 设为默认地址
          Row() {
            Text('设为默认地址')
              .fontSize(14)
              .fontColor(IColor.BLACK_TRANSPARENT_60)
            Toggle({ type: ToggleType.Switch, isOn: this.address.isDefault })
              .selectedColor(IColor.THEME_PRIMARY)
              .switchPointColor(IColor.WHITE)
              .onChange((isOn: boolean) => {
                this.address.isDefault = isOn;
              })
          }
          .width('100%')
          .height(48)
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.SpaceBetween)
          .backgroundColor(IColor.WHITE)
          .borderRadius(8)
          .padding({ left: 16, right: 16 })
          .margin({ top: IStyle.CARD_GAP })
        }
        .width('100%')
        .constraintSize({ minHeight: '100%' })
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
        .padding(IStyle.CARD_GAP)
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.None)
      this.buildSaveButton();
    }
    .height('100%')
  }

  @Builder
  private buildSaveButton(): void {
    Column() {
      Row() {
        Button() {
          Text('保存')
            .fontSize(IFontSize.BODY)
            .fontColor(IColor.WHITE)
        }
        .width('80%')
        .height(40)
        .borderRadius(21)
        .fontWeight(500)
        .type(ButtonType.Normal)
        .backgroundColor(IColor.THEME_PRIMARY)
        .onClick(() => {
          if (this.verify()) {
            const address: AddressDTO = this.address.toDTO();
            this.ctx.operation === Operation.CREATE ?
              this.ctx.addressMgr.create(address, () => this.ctx.navPathStack.pop()) :
              this.ctx.addressMgr.update(address, () => this.ctx.navPathStack.pop());
          }
        })
      }
      .width('100%')
      .height(52)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .backgroundColor(IColor.WHITE)
    .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.BOTTOM, SafeAreaEdge.TOP])
  }

  private handleSelectDistrict(): void {
    const options: sceneMap.DistrictSelectOptions = {
      countryCode: 'CN',
      language: 'zh',
    };
    sceneMap.selectDistrict(this.getUIContext().getHostContext(), options)
      .then((result: sceneMap.DistrictSelectResult) => {
        this.address.countryCode = '';
        this.address.country = '';
        this.address.province = '';
        this.address.city = '';
        this.address.district = '';
        this.address.street = '';
        for (let district of result.districts) {
          switch (district.adminLevel) {
            case 'COUNTRY':
              this.address.countryCode = district.countryCode ?? '';
              this.address.country = district.name ?? '';
              break;
            case 'ADMINISTRATIVE_AREA_LEVEL_1':
              this.address.province = district.name ?? '';
              break;
            case 'ADMINISTRATIVE_AREA_LEVEL_2':
              this.address.city = district.name ?? '';
              break;
            case 'ADMINISTRATIVE_AREA_LEVEL_3':
              this.address.district = district.name ?? '';
              break;
            case 'ADMINISTRATIVE_AREA_LEVEL_4':
              this.address.street = district.name ?? '';
              break;
          }
        }
      });
  }

  private verify(): boolean {
    if (!this.address.name) {
      promptAction.showToast({ message: '请输入收货人姓名' });
      return false;
    }
    if (!this.address.phone) {
      promptAction.showToast({ message: '请输入手机号码' });
      return false;
    }
    if (!/^1[3-9]\d{9}$/.test(this.address.phone)) {
      promptAction.showToast({ message: '手机号码不正确' });
      return false;
    }
    if (!this.address.region) {
      promptAction.showToast({ message: '请选择所在地区' });
      return false;
    }
    if (!this.address.detail) {
      promptAction.showToast({ message: '请输入详细地址' });
      return false;
    }
    return true;
  }
}

@Builder
export function buildAddressEditPage(_: string, context: Context) {
  AddressEditPage({ ctx: context })
}
