import { CommonDivider, RouterMap } from 'module_base';
import { CommonCascade } from 'module_city';
import { ParamAddressPage } from '../common/Constant';
import { CommonUtils } from '../common/Utils';
import { EditAddressPageVM } from '../viewmodel/EditAddressPageVM';


@Builder
export function EditAddressPageBuilder() {
  EditAddressPage();
}

@ComponentV2
export struct EditAddressPage {
  @Local vm: EditAddressPageVM = new EditAddressPageVM();

  build() {
    NavDestination() {
      Column() {
        Column() {
          Scroll() {
            Column() {
              Row() {
                Row() {
                  Image($r('app.media.ic_link'))
                    .width(24)
                    .height(24)
                    .margin({ right: 8 })
                  Text('获取关联账号地址')
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#466DFA')
                }

                Image($r('app.media.ic_arrow_right'))
                  .width(12)
                  .height(24)
              }
              .width('100%')
              .height(56)
              .padding({ left: 12, right: 12 })
              .justifyContent(FlexAlign.SpaceBetween)
              .borderRadius(16)
              .backgroundColor(Color.White)
              .margin({ bottom: 12 })
              .onClick(async () => {
                const address = await CommonUtils.chooseAddress()
                if (address) {
                  this.vm.name = address.name
                  this.vm.cellphone = address.cellphone
                  this.vm.province = address.province
                  this.vm.city = address.city
                  this.vm.area = address.area
                  this.vm.detailAddress = address.detailAddress
                }
              })

              Column() {
                Row() {
                  Flex() {
                    Text('姓名')
                      .fontSize(14)
                      .fontWeight(FontWeight.Regular)
                      .fontColor($r('sys.color.font_primary'))
                  }
                  .width(60)

                  TextInput({ text: $$this.vm.name, placeholder: '名字' })
                    .backgroundColor(Color.Transparent)
                    .layoutWeight(1)
                    .placeholderFont({ size: 12, weight: FontWeight.Regular })
                    .placeholderColor($r('sys.color.font_tertiary'))
                    .fontSize(12)
                }

                CommonDivider()
                Row() {
                  Row() {
                    Text('手机号码')
                      .fontSize(14)
                      .fontWeight(FontWeight.Regular)
                      .fontColor($r('sys.color.font_primary'))
                  }
                  .width(60)

                  TextInput({ text: $$this.vm.cellphone, placeholder: '手机号' })
                    .backgroundColor(Color.Transparent)
                    .layoutWeight(1)
                    .placeholderFont({ size: 12, weight: FontWeight.Regular })
                    .placeholderColor($r('sys.color.font_tertiary'))
                    .fontSize(12)
                }

                CommonDivider()
                Row() {
                  Row() {
                    Text('地区')
                      .fontSize(14)
                      .fontWeight(FontWeight.Regular)
                      .fontColor($r('sys.color.font_primary'))
                  }
                  .width(60)

                  CommonCascade({
                    province: this.vm.province,
                    city: this.vm.city,
                    area: this.vm.area,
                    onChange: (data) => {
                      this.vm.province = data[0] ?? ''
                      this.vm.city = data[1] ?? ''
                      this.vm.area = data[2] ?? ''
                    }
                  })
                }

                CommonDivider()
                Row() {
                  Row() {
                    Text('详细地址')
                      .fontSize(14)
                      .fontWeight(FontWeight.Regular)
                      .fontColor($r('sys.color.font_primary'))
                  }
                  .width(60)

                  TextInput({ text: $$this.vm.detailAddress, placeholder: '详细的街道门牌、楼栋、居民号等信息' })
                    .backgroundColor(Color.Transparent)
                    .layoutWeight(1)
                    .placeholderFont({ size: 12, weight: FontWeight.Regular })
                    .placeholderColor($r('sys.color.font_tertiary'))
                    .fontSize(12)
                }
              }
              .width('100%')
              .padding(12)
              .borderRadius(16)
              .backgroundColor(Color.White)
              .margin({ bottom: 12 })

              Row() {
                Text('设置为默认地址')
                  .fontSize(14)
                  .fontWeight(FontWeight.Regular)
                  .fontColor($r('sys.color.font_primary'))

                Toggle({ type: ToggleType.Switch, isOn: this.vm.isDefault })
                  .onChange((value) => {
                    this.vm.isDefault = value
                  })
              }
              .width('100%')
              .height(44)
              .padding({ left: 12, right: 12 })
              .justifyContent(FlexAlign.SpaceBetween)
              .borderRadius(16)
              .backgroundColor(Color.White)
              .margin({ bottom: 12 })
            }
          }
          .scrollBar(BarState.Off)
        }
        .height('calc(100% - 40vp)')

        Row() {
          Button('保存')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
            .width('100%')
            .backgroundColor('#0A59F7')
            .onClick(() => {
              this.vm.onSubmit().then(() => {
                this.vm.stack.pop('ok');
              });
            })
        }
        .width('100%')
      }
      .height('100%')
      .margin({
        left: 16,
        right: 16,
      });
    }
    .title(this.vm.isNew() ? '添加地址' : '修改地址')
    .backgroundColor($r('sys.color.background_secondary'))
    .onReady((context) => {
      this.vm.stack = context.pathStack;

      const params: ParamAddressPage[] =
        this.vm.stack.getParamByName(RouterMap.EDIT_ADDRESS_PAGE) as ParamAddressPage[];
      if (params.length && params[params.length - 1]) {
        const param = params[params.length - 1];
        if (param.param) {
          this.vm.address = param.param
          this.vm.type = param.type
          this.vm.name = param.param.name
          this.vm.cellphone = param.param.cellphone
          this.vm.province = param.param.province
          this.vm.city = param.param.city
          this.vm.area = param.param.area
          this.vm.detailAddress = param.param.detailAddress
          this.vm.isDefault = param.param.isDefault
        }
      }
    })
  }
}