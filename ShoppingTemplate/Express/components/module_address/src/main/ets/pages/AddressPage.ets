import { AddressPageVM } from '../viewmodel/AddressPageVM';
import { CommonDivider, CommonUtil, RouterMap } from 'module_base';
import { ParamAddressPage, TypeAddressPage } from '../common/Constant';
import { IAddrInfo } from '../http/Type';
import { TipsDialog } from '@kit.ArkUI';
import { emitter } from '@kit.BasicServicesKit';


@Builder
export function AddressPageBuilder() {
  AddressPage();
}

@ComponentV2
export struct AddressPage {
  vm: AddressPageVM = AddressPageVM.instance
  dialogControllerDelete: CustomDialogController = new CustomDialogController({
    builder: TipsDialog({
      content: '是否删除当前地址?',
      primaryButton: {
        value: '取消',
        action: () => {
          console.info('Callback when the first button is clicked')
        },
      },
      secondaryButton: {
        value: '删除',
        role: ButtonRole.ERROR,
        action: () => {
          this.vm.deleteAddr()
          this.dialogControllerDelete.close()
        }
      },
    }),
  })

  build() {
    NavDestination() {
      Column() {
        Scroll() {
          Column() {
            if (!this.vm.isExpressOrder) {
              Row() {
                Image($r('app.media.ic_add'))
                  .width(24)
                  .height(24)
                  .margin({ right: 8 })
                Text('添加地址')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#466DFA')
              }
              .width('100%')
              .height(56)
              .justifyContent(FlexAlign.Center)
              .borderRadius(16)
              .backgroundColor(Color.White)
              .margin({ bottom: 12 })
              .onClick(() => {
                const param: ParamAddressPage = {
                  type: TypeAddressPage.NEW,
                };
                this.vm.stack.pushPath({
                  name: RouterMap.EDIT_ADDRESS_PAGE,
                  param,
                  onPop: (info: PopInfo) => {
                    if (info.result) {
                      this.vm.queryList();
                    }
                  },
                });
              })
            }

            ForEach(this.vm.list, (address: IAddrInfo) => {
              Column() {
                Column() {
                  Row() {
                    Text(address.name)
                      .fontSize(14)
                      .fontWeight(FontWeight.Regular)
                      .fontColor($r('sys.color.font_primary'))
                      .margin({ right: 12 })
                    Text(CommonUtil.encryptPhoneNo(address.cellphone))
                      .fontSize(14)
                      .fontWeight(FontWeight.Regular)
                      .fontColor($r('sys.color.font_primary'))
                  }
                  .width('100%')
                  .margin({ bottom: 4 })

                  Row() {
                    Text(address.province + address.city + address.area + address.detailAddress)
                      .fontSize(12)
                      .fontWeight(FontWeight.Regular)
                      .fontColor($r('sys.color.font_primary'))
                  }
                  .width('100%')

                  CommonDivider()
                }
                .onClick(() => {
                  const addressInfoData: IAddrInfo = {
                    id: address.id,
                    name: address.name,
                    cellphone: address.cellphone,
                    province: address.province,
                    city: address.city,
                    area: address.area,
                    detailAddress: address.detailAddress,
                    isDefault: address.isDefault
                  }
                  if (this.vm.isExpressOrder) {
                    let addressInfo: emitter.EventData = {
                      data: addressInfoData
                    };
                    emitter.emit('address', addressInfo);
                    this.vm.stack.pop()
                  }
                })

                Row() {
                  Row() {
                    Toggle({ type: ToggleType.Switch, isOn: address.isDefault })
                      .margin({ right: 12 })
                      .onChange((value) => {
                        address.isDefault = value
                        this.vm.update(address)
                        if (value) {
                          this.vm.list.forEach((item) => {
                            if (item.id !== address.id) {
                              item.isDefault = false
                              this.vm.update(item)
                            }
                          })
                        }
                      })
                    Text('默认地址')
                      .fontSize(12)
                      .fontWeight(FontWeight.Regular)
                      .fontColor($r('sys.color.font_primary'))
                  }

                  Row() {
                    Button('编辑')
                      .width(72)
                      .controlSize(ControlSize.SMALL)
                      .backgroundColor($r('sys.color.comp_background_tertiary'))
                      .fontColor($r('sys.color.font_primary'))
                      .margin({ right: 8 })
                      .onClick(() => {
                        const param: ParamAddressPage = {
                          type: TypeAddressPage.EDIT,
                          param: address,
                        };
                        this.vm.stack.pushPath({
                          name: RouterMap.EDIT_ADDRESS_PAGE,
                          param: param,
                          onPop: (info: PopInfo) => {
                            if (info.result) {
                              this.vm.queryList();
                            }
                          },
                        });
                      })
                    Button('删除')
                      .width(72)
                      .controlSize(ControlSize.SMALL)
                      .backgroundColor($r('sys.color.comp_background_tertiary'))
                      .fontColor($r('sys.color.font_primary'))
                      .onClick(() => {
                        this.vm.selectedAddress = address
                        this.dialogControllerDelete.open()
                      })
                  }
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)
              }
              .backgroundColor(Color.White)
              .padding(12)
              .borderRadius(16)
              .margin({ bottom: 12 })
            }, (item: IAddrInfo[]) => JSON.stringify(item))
          }
        }
        .scrollBar(BarState.Off)
      }
      .height('100%')
      .margin({
        left: 16,
        right: 16,
      });
    }
    .title('我的地址')
    .backgroundColor($r('sys.color.background_secondary'))
    .onReady((context) => {
      this.vm.setStack(context.pathStack);

      const params: boolean[] =
        this.vm.stack.getParamByName(RouterMap.ADDRESS_PAGE) as boolean[];
      this.vm.isExpressOrder = params[0]
    })
    .onShown(() => {
      this.vm.init()
    })
  }
}