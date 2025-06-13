import { Authentication } from '../components/Authentication'
import { PurchaseBar } from '../components/PurchaseBar'
import { ShippingInfo } from '../components/ShippingInfo'
import { ExpressPageVM } from '../viewModels/ExpressPageVM'
import { emitter } from '@kit.BasicServicesKit'
import { methodList } from '../constants'
import { HomeVisit } from '../components/HomeVisit'
import { IAddrInfo, IGoods, IServicePoint, ITemplate, OrderType, RouterModule } from 'lib_foundation'
import { RouterMap, CommonAddress, ISetting } from 'module_base'

@Builder
export function ExpressPageBuilder() {
  ExpressPage()
}

@Entry
@ComponentV2
struct ExpressPage {
  vm: ExpressPageVM = ExpressPageVM.instance

  aboutToAppear(): void {
    this.vm.init()
    emitter.on('goods', (data) => {
      if (data.data) {
        this.vm.selectedGoods = data.data as IGoods
        this.vm.goodsName = this.vm.selectedGoods.name + ' ' + this.vm.selectedGoods.weight + 'kg'
        this.vm.getEstimatedPrice()
      }
    });

    emitter.on('servicePoint', (data) => {
      if (data.data) {
        this.vm.selectedServicePoint = data.data as IServicePoint
        this.vm.getEstimatedPrice()
      }
    });

    emitter.on('address', (data) => {
      if (data.data) {
        if (this.vm.selectedAddress === OrderType.SEND) {
          this.vm.sendAddress = data.data as IAddrInfo
        } else {
          this.vm.getAddress = data.data as IAddrInfo
        }
      }
    });
    emitter.on('template', (data) => {
      if (data.data) {
        this.vm.getTemplateList()
      }
    });
  }

  aboutToDisappear(): void {
    this.vm.clear()
  }

  build() {
    NavDestination() {
      Column() {
        Scroll() {
          Column() {
            if (this.vm.userInfo.realNameAuthFlag === 0) {
              Authentication()
            }
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              List() {
                ForEach(this.vm.templateList, (template: ITemplate) => {
                  ListItem() {
                    Row() {
                      Text(template?.name)
                        .fontSize(14)
                        .fontWeight(FontWeight.Medium)
                        .fontColor(this.vm.selectedTemplateId === template.id ? Color.White :
                        $r('sys.color.font_primary'))
                    }
                    .height(28)
                    .padding({ left: 16, right: 16 })
                    .backgroundColor(this.vm.selectedTemplateId === template.id ? $r('sys.color.icon_secondary') :
                      'rgba(0,0,0,0.05)')
                    .margin({ right: 8 })
                    .borderRadius(21)
                  }
                  .onClick(() => {
                    this.vm.changeTemplate(template)
                  })
                }, (item: ITemplate[]) => JSON.stringify(item))
              }
              .scrollBar(BarState.Off)
              .height(28)
              .listDirection(Axis.Horizontal)
              .margin({ right: 8 })
              .flexGrow(1)

              Row() {
                Text('添加模板')
                  .fontSize(14)
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('sys.color.font_primary'))
                  .margin({ right: 2 })
                Image($r('app.media.ic_arrow_right'))
                  .width(12)
                  .height(12)
              }
              .width(110)
              .height(28)
              .justifyContent(FlexAlign.Center)
              .backgroundColor('rgba(0,0,0,0.05)')
              .borderRadius(21)
              .onClick(() => {
                this.vm.isFresh = false
                RouterModule.push({ url: RouterMap.TEMPLATE_PAGE })
              })
            }
            .width('100%')
            .margin({ bottom: 12 })

            CommonAddress({
              stack: RouterModule.stack,
              sendAddress: this.vm.sendAddress,
              getAddress: this.vm.getAddress,
              select: (value) => {
                this.vm.isFresh = false
                this.vm.selectedAddress = value
              },
              change: () => {
                const temp = this.vm.sendAddress
                this.vm.sendAddress = this.vm.getAddress
                this.vm.getAddress = temp
              }
            })

            Row() {
              ForEach(methodList, (method: ISetting, index: number) => {
                Button(method.text)
                  .height(36)
                  .fontSize(14)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(this.vm.selectedMethod === method.value ? Color.White : $r('sys.color.font_primary'))
                  .backgroundColor(this.vm.selectedMethod === method.value ? '#0A59F7' : 'rgba(0,0,0,0.05)')
                  .margin({ right: 8 })
                  .onClick(() => {
                    this.vm.selectedMethod = method.value
                    this.vm.getEstimatedPrice()
                  })
              }, (item: ISetting[]) => JSON.stringify(item))
            }
            .width('100%')
            .margin({ bottom: 12 })

            if (this.vm.selectedMethod === 1) {
              HomeVisit()
            } else {
              ShippingInfo()
            }
          }
          .padding({ left: 16, right: 16 })
        }
        .scrollBar(BarState.Off)
      }
      .height('calc(100% - 56vp)')

      PurchaseBar()
    }
    .backgroundColor('#F1F3F5')
    .title('寄快递')
  }
}