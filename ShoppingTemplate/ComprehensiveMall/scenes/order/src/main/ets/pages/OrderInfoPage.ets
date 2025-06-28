import { OrderInfoPageVM } from '../viewModels/OrderInfoPageVM';
import { emitter } from '@kit.BasicServicesKit';
import { CustomContentDialog, promptAction, TipsDialog } from '@kit.ArkUI';
import { OrderApi } from '../http/Api';
import { OrderSkuDto } from '../http/Type'
import { CallButton, iResourceMgr, PreOrderItem, PreOrderRequest, routerStack, Style, TitleBar } from 'lib_foundation';
import { AddressManage } from 'module_address_manage';
import { CommonButton } from '../components/CommonButton';
import { copyText } from '../utils';
import { OrderType } from '../common';


@ComponentV2
struct OrderInfoPage {
  vm: OrderInfoPageVM = OrderInfoPageVM.instance
  dialogControllerCancel: CustomDialogController = new CustomDialogController({
    builder: TipsDialog({
      content: '是否取消当前订单?',
      primaryButton: {
        value: '取消',
        action: () => {
          console.info('Callback when the first button is clicked')
        },
      },
      secondaryButton: {
        value: '确认',
        role: ButtonRole.ERROR,
        action: () => {
          OrderApi.cancelOrderByCode(this.vm.orderInfo?.orderCode!!).then(() => {
            const eventData: emitter.EventData = {
              data: {
                'content': 'content',
              }
            };
            emitter.emit('updateOrder', eventData)
            promptAction.showToast({ message: '取消成功！', alignment: Alignment.Center })
            routerStack.pop()
          })
          this.dialogControllerCancel.close()
        }
      },
    }),
  })
  dialogControllerConfirm: CustomDialogController = new CustomDialogController({
    builder: TipsDialog({
      content: '是否确认收货?',
      primaryButton: {
        value: '取消',
        action: () => {
          console.info('Callback when the first button is clicked')
        },
      },
      secondaryButton: {
        value: '确认',
        role: ButtonRole.ERROR,
        action: () => {
          OrderApi.agreeOrderByCode(this.vm.orderInfo!.orderCode)
            .then(() => {
              const eventData: emitter.EventData = {
                data: {
                  'content': 'content',
                }
              };
              emitter.emit('updateOrder', eventData)
              this.vm.getOrderInfo()
            })
          this.dialogControllerCancel.close()
        }
      },
    }),
  })
  payDialogController: CustomDialogController = new CustomDialogController({
    builder: CustomContentDialog({
      contentBuilder: () => {
        this.payBuilder();
      },
    }),
    width: '100%',
    offset: { dx: 0, dy: 28 },
    cornerRadius: {
      topLeft: 32,
      topRight: 32,
      bottomLeft: 0,
      bottomRight: 0
    },
    alignment: DialogAlignment.Bottom,
  })
  editDialogController: CustomDialogController = new CustomDialogController({
    builder: CustomContentDialog({
      contentBuilder: () => {
        this.buildContent();
      },
      contentAreaPadding: {
        top: 0,
        left: 0,
        right: 0,
        bottom: 0
      }
    }),
    cancel: () => {
      this.vm.tempShopPhone = ''
    },
  })

  aboutToAppear(): void {
    this.vm.init()
  }

  aboutToDisappear(): void {
    this.vm.clear()
  }

  build(): void {
    NavDestination() {
      Column() {
        TitleBar({
          barPadding: { right: Style.MENU_BAR_MARGIN_RIGHT },
          barColor: Color.White
        }) {
          this.titleBar()
        }

        Column() {
          Scroll() {
            Column() {
              this.buildStateCard()
              if (this.vm.orderInfo?.type === OrderType.REFUND) {
                this.buildRefundCard()
              } else {
                this.buildAddressCard()
                this.buildGoodsCard()
                this.buildPriceCard()
                this.buildOrderInfoCard()
              }
            }
            .margin({ bottom: 12 })
            .constraintSize({ minHeight: '100%' })
          }
          .scrollBar(BarState.Off)
          .height('100%')
        }
        .layoutWeight(1)
        .backgroundColor('#F1F3F5')
        .padding({
          left: 12,
          right: 12
        })

        Row() {
          if (this.vm.orderInfo?.type === OrderType.PENDING_PAY || this.vm.orderInfo?.type === OrderType.PENDING_SEND) {
            Button('取消订单')
              .width(96)
              .fontSize(14)
              .fontColor($r('sys.color.font_secondary'))
              .backgroundColor(Color.White)
              .borderWidth(1)
              .borderColor('rgba(0,0,0,0.40)')
              .margin({ left: 8 })
              .onClick(() => {
                this.dialogControllerCancel.open()
              })
          }
          if (this.vm.orderInfo?.type === OrderType.PENDING_PAY) {
            Button('继续支付')
              .width(96)
              .fontSize(14)
              .fontColor(Color.White)
              .backgroundColor('#E64566')
              .margin({ left: 8 })
              .onClick(() => {
                this.payDialogController.open()
              })
          }
          if (this.vm.orderInfo?.type === OrderType.PENDING_GET) {
            Button('确认收货')
              .width(96)
              .fontSize(14)
              .fontColor(Color.White)
              .backgroundColor('#E64566')
              .margin({ left: 8 })
              .onClick(() => {
                this.dialogControllerConfirm.open()
              })
          }
          if (this.vm.orderInfo?.type === OrderType.SUCCESS || this.vm.orderInfo?.type === OrderType.CANCEL ||
            this.vm.orderInfo?.type === OrderType.REFUND) {
            Button('再买一单')
              .width(96)
              .fontSize(14)
              .fontColor(Color.White)
              .backgroundColor('#E64566')
              .margin({ left: 8 })
              .onClick(() => {
                const items: PreOrderItem[] = [];
                if (this.vm.orderInfo) {
                  for (let sku of this.vm.orderInfo.skuList) {
                    const preOrderItem: PreOrderItem = {
                      skuCode: sku.skuCode,
                      quantity: sku.count
                    };
                    items.push(preOrderItem);
                  }
                  const preOrderRequest: PreOrderRequest = {
                    items: items,
                    removeFromCart: true
                  };
                  routerStack.pushPathByName('OrderSubmitPage', preOrderRequest);
                }
              })
          }
        }
        .width('100%')
        .height(62)
        .backgroundColor(Color.White)
        .justifyContent(FlexAlign.End)
        .alignItems(VerticalAlign.Center)
        .padding({ left: 16, right: 16 })
      }
    }
    .hideTitleBar(true)
  }

  @Builder
  titleBar() {
    Row() {
      Text('订单详情')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_primary'))
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  buildStateCard() {
    Column() {
      if (this.vm.orderInfo?.statusDesc) {
        Text() {
          Span(this.vm.orderInfo.statusDesc)
          if (this.vm.orderInfo.type === OrderType.PENDING_PAY || this.vm.orderInfo.type === OrderType.PENDING_SEND) {
            Span('...')
          }
          if (this.vm.orderInfo.type === OrderType.REFUND) {
            Span('￥' + this.vm.orderInfo.totalPrice.toString())
          }
        }
        .fontSize(24)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_primary'))

        if (this.vm.orderInfo.statusDesc === '待付款') {
          Text() {
            Span('订单将在 ')
            Span(this.vm.time)
            Span(' 后取消')
          }
          .fontSize(14)
          .fontColor($r('sys.color.font_secondary'))
          .margin({ top: 4 })
        }
        if (this.vm.orderInfo.type === OrderType.REFUND) {
          Text(this.vm.orderInfo.refundTime)
            .fontSize(14)
            .fontColor($r('sys.color.font_secondary'))
            .margin({ top: 4 })
        }
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .padding({ left: 8 })
    .margin({ top: 20, bottom: 12 })
  }

  @Builder
  buildAddressCard() {
    Column() {
      if (this.vm.orderInfo && this.vm.orderInfo.receivingMethod === '快递物流' && this.vm.orderInfo.statusDesc &&
        this.vm.orderInfo.statusDesc === '待收货') {
        Flex() {
          Image($r('app.media.transit'))
            .width(16)
            .height(16)
            .margin({ left: 4, right: 12 })
            .flexShrink(0)

          Row() {
            Text('运输中')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor('#E64566')
          }
          .width(42)
          .margin({ right: 8 })
          .flexShrink(0)

          Row() {
            Text('您的快件离开【深圳市】广东深圳xxxxxxxx')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .flexGrow(1)
        }
        .margin({ bottom: 12 })
      }
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        if (this.vm.orderInfo?.receivingMethod !== '到店自提') {
          Image($r('app.media.position'))
            .width(24)
            .height(24)
            .margin({ right: 8 })
            .flexShrink(0)
          Column() {
            Text(this.vm.address?.address)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ bottom: 4 })
            Row() {
              Text(this.vm.address?.name)
                .margin({ right: 8 })
                .fontSize(12)
                .fontWeight(FontWeight.Regular)
                .fontColor($r('sys.color.font_tertiary'))
              Text(this.vm.address?.cellphone)
                .fontSize(12)
                .fontWeight(FontWeight.Regular)
                .fontColor($r('sys.color.font_tertiary'))
            }
          }
          .alignItems(HorizontalAlign.Start)
          .flexGrow(1)
        }

        if (this.vm.orderInfo!.statusDesc === '待收货' && this.vm.orderInfo?.receivingMethod !== '到店自提') {
          AddressManage({
            navPathStack: routerStack,
            isSelectMode: true,
            onSelect: (data) => {
              this.vm.address!.name = data.name
              this.vm.address!.cellphone = data.phone
              this.vm.address!.address = data.province + data.city + data.district + data.street + data.detail
              OrderApi.updateOrderAddressByCode(this.vm.orderInfo!.orderCode, this.vm.address)
            }
          }) {
            Button('修改')
              .controlSize(ControlSize.SMALL)
              .width(52)
              .fontSize(12)
              .fontColor($r('sys.color.font_secondary'))
              .backgroundColor(Color.White)
              .borderWidth(1)
              .borderColor('rgba(0,0,0,0.40)')
              .margin({ left: 8 })
              .flexShrink(0)
          }
        }
        if (this.vm.orderInfo!.statusDesc === '待收货' && this.vm.orderInfo?.receivingMethod === '到店自提') {
          Row() {
            Image($r('app.media.shop'))
              .width(25)
              .height(25)
              .draggable(false)
              .margin({ right: 10 })
            Row() {
              Column() {
                Text(this.vm.address.address)
                  .fontColor('#E6000000')
                  .fontSize(16)
                  .fontWeight(500)
                Row() {
                  Text('预留电话')
                    .fontSize(12)
                    .fontWeight(FontWeight.Medium)
                    .fontColor($r('sys.color.font_tertiary'))
                    .margin({ right: 8 })

                  Text(this.vm.address.cellphone)
                    .fontSize(12)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#E64566')

                  Image($r('app.media.edit'))
                    .width(12)
                    .height(12)
                    .margin({ left: 4 })
                    .onClick(() => {
                      this.editDialogController.open()
                    })
                }
                .margin({ top: 10 })
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
            }
            .layoutWeight(1)
            .justifyContent(FlexAlign.SpaceBetween)
          }
        }
      }
      .width('100%')
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(8)
    .padding({
      top: 16,
      bottom: 16,
      left: 12,
      right: 12
    })
    .margin({ bottom: 8 })
  }

  @Builder
  buildGoodsCard() {
    Column() {
      this.buildGoods()
      CallButton() {
        Row() {
          Image($r('app.media.tel'))
            .width(14)
            .height(15)
            .margin({ right: 5 })
          Text('联系客服')
            .fontSize(14)
            .fontColor($r('sys.color.font_primary'))
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
      }
    }
    .borderRadius(8)
    .backgroundColor(Color.White)
    .padding({
      top: 16,
      bottom: 12,
      left: 12,
      right: 12
    })
    .margin({ bottom: 8 })
  }

  @Builder
  buildPriceCard() {
    Column() {
      this.buildPriceContent('商品金额', '', this.vm.orderInfo!.totalPrice, 12, $r('sys.color.font_secondary'))
      if (this.vm.oldPrice !== 0) {
        this.buildPriceContent('优惠', '- ', this.vm.oldPrice, 12, '#E84026')
      }
      this.buildPriceContent('实付金额', '', this.vm.orderInfo!.totalPrice, 12, $r('sys.color.font_secondary'))
    }
    .borderRadius(8)
    .backgroundColor(Color.White)
    .padding({
      top: 18,
      bottom: 4,
      left: 12,
      right: 12
    })
    .margin({ bottom: 8 })
  }

  @Builder
  buildOrderInfoCard() {
    Column() {
      Row() {
        Text('订单信息')
          .fontSize(14)
          .fontColor($r('sys.color.font_primary'))
      }
      .width('100%')
      .margin({ bottom: 11 })

      Divider().height(1).color('#CCCCCC').margin({ bottom: 12 })

      Column() {
        this.buildCopyRow()
        this.buildInfoContent('下单时间', this.vm.orderInfo?.time ?? '')
        this.buildInfoContent('配送方式', this.vm.orderInfo?.receivingMethod ?? '')
        this.buildInfoContent('用户备注', this.vm.orderInfo?.remark ?? '')
      }
    }
    .borderRadius(8)
    .backgroundColor(Color.White)
    .padding({ top: 16, left: 12, right: 12 })
  }

  @Builder
  buildRefundCard() {
    Column() {
      Row() {
        Text('退回华为支付')
          .fontSize(12)
          .fontWeight(FontWeight.Regular)
          .fontColor($r('sys.color.font_primary'))
        Text(this.vm.orderInfo?.totalPrice.toString())
          .fontSize(12)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: 15 })

      Divider().width('100%').height(1).color('#CCCCCC').margin({ bottom: 16 })
      this.buildGoods()
      this.buildInfoContent('退款原因', '多拍/错拍')
      this.buildInfoContent('申请时间', this.vm.orderInfo!.refundTime)
      this.buildCopyRow()

      Divider().width('100%').height(1).color('#CCCCCC').margin({ bottom: 12 })

      CallButton() {
        Row() {
          Image($r('app.media.tel'))
            .width(14)
            .height(15)
            .margin({ right: 5 })
          Text('联系客服')
            .fontSize(14)
            .fontColor($r('sys.color.font_primary'))
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
      }
    }
    .backgroundColor(Color.White)
    .padding({
      top: 16,
      bottom: 16,
      left: 12,
      right: 12
    })
    .borderRadius(8)
  }

  @Builder
  buildGoods() {
    Column() {
      ForEach(this.vm.orderInfo?.skuList, (sku: OrderSkuDto) => {
        Column() {
          Row() {
            Image(iResourceMgr.resolveUri(sku.banner))
              .width(65)
              .height(65)
              .draggable(false)
              .objectFit(ImageFit.Cover)
              .borderRadius(7)
              .margin({ right: 10 })
              .backgroundColor('#90E5E7E9')
            Column() {
              Row() {
                Text(sku.title)
                  .layoutWeight(1)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .fontSize(14)
                  .fontColor($r('sys.color.mask_secondary'))
                Text() {
                  Span('¥')
                    .fontSize(13)
                  Span(sku.price.toString())
                    .fontSize(13)
                }
                .fontColor($r('sys.color.mask_secondary'))
                .margin({ left: 8 })
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)

              if (sku.oldPrices) {
                Row() {
                  Text('￥' + sku.oldPrices.toString())
                    .fontSize(12)
                    .fontColor($r('sys.color.font_tertiary'))
                    .decoration({ type: TextDecorationType.LineThrough })
                }
                .width('100%')
                .justifyContent(FlexAlign.End)
              }

              Row() {
                Text(sku.skuDesc)
                  .layoutWeight(1)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .fontColor($r('sys.color.mask_tertiary'))
                  .fontSize(12)
                Text('x' + sku.count)
                  .fontColor($r('sys.color.mask_tertiary'))
                  .fontSize(12)
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
            }
            .height(65)
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('100%')
          .margin({ bottom: 12 })

          Divider().height(1).color('#CCCCCC').margin({ bottom: 12 })
        }
      }, (item: OrderSkuDto[]) => JSON.stringify(item))
    }
  }

  @Builder
  buildPriceContent(title: string, code: string, price: number, size: number, color: ResourceStr) {
    Row() {
      Text(title)
        .fontSize(12)
        .fontColor($r('sys.color.font_tertiary'))
      Text() {
        if (code) {
          Span(code + ' ')
        }
        Span('¥')
        Span(price.toString())
          .fontSize(size)
      }
      .fontSize(12)
      .fontColor(color)
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ bottom: 16 })
  }

  @Builder
  buildInfoContent(title: string, value: string) {
    Row() {
      Text(title)
        .width(80)
        .fontSize(12)
        .fontColor($r('sys.color.font_tertiary'))
      Text(value)
        .fontSize(12)
        .fontColor($r('sys.color.font_primary'))
        .layoutWeight(1)
        .textAlign(TextAlign.End)
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Top)
    .margin({ bottom: 16 })
  }

  @Builder
  buildCopyRow() {
    Row() {
      Text('订单号码')
        .fontSize(12)
        .fontColor($r('sys.color.font_tertiary'))
      Row() {
        Text(this.vm.orderInfo?.orderCode)
          .fontSize(12)
          .fontColor($r('sys.color.font_primary'))
          .margin({ right: 8 })

        Button('复制')
          .controlSize(ControlSize.SMALL)
          .width(44)
          .height(20)
          .borderWidth(1)
          .borderColor('#E64566')
          .fontColor('#E64566')
          .fontSize(10)
          .backgroundColor(Color.White)
          .onClick(() => {
            copyText(this.vm.orderInfo?.orderCode ?? 'ON000000000000000000000')
          })
      }
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ bottom: 16 })
  }

  // 自定义弹出框的内容区
  @Builder
  payBuilder(): void {
    Column() {
      Scroll() {
        Column() {
          Row() {
            Text('预估金额')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
          }
          .justifyContent(FlexAlign.Center)
          .width('100%')
          .margin({ bottom: 12 })

          Row() {
            Text(this.vm.orderInfo?.totalPrice.toString())
              .fontSize(24)
              .fontWeight(FontWeight.Medium)
              .fontColor('#FE543A')
          }
          .justifyContent(FlexAlign.Center)
          .width('100%')
          .margin({ bottom: 12 })

          CommonButton({
            cancelFunc: () => {
              this.payDialogController.close()
            }, saveButton: () => {
              this.vm.prepay()
              this.payDialogController.close()
            }
          })
        }
        .width('100%')
        .padding({
          top: 24,
          bottom: 16,
          left: 24,
          right: 24
        })
        .backgroundColor('rgba(255,255,255,0.80)')
      }
      .scrollBar(BarState.Off)
    }
  }

  // 自定义弹出框的内容区
  @Builder
  buildContent(): void {
    Column() {
      Scroll() {
        Column() {
          Row() {
            Text('修改预留号码')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
          }
          .justifyContent(FlexAlign.Center)
          .width('100%')
          .margin({ bottom: 12 })

          Row() {
            TextInput({ text: $$this.vm.tempShopPhone, placeholder: '请输入预留号码' })
              .placeholderColor('#999999')
              .placeholderFont({ size: 14, weight: FontWeight.Regular })
              .height(40)
              .fontSize(14)
              .backgroundColor(Color.Transparent)
              .maxLength(11)
              .type(InputType.Number)
              .onChange((value: string) => {
                if (!/^\d+$$/.test(value)) {
                  // 如果包含非数字字符，可以将输入恢复为只包含数字
                }
              })
          }
          .width('100%')
          .height(40)
          .padding({ left: 12, right: 12 })
          .margin({ bottom: 18 })
          .backgroundColor('rgba(0,0,0,0.05)')
          .borderRadius(8)

          Row() {
            Row() {
              Text('取消')
            }
            .width('50%')
            .height(40)
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              this.vm.tempShopPhone = ''
              this.editDialogController.close()
            })

            Row() {
              Button('确认')
                .width('100%')
                .height(40)
                .backgroundColor('#0A59F7')
            }
            .width('50%')
            .height(40)
            .onClick(async () => {
              this.vm.orderInfo!.address.cellphone = this.vm.tempShopPhone
              this.vm.address.cellphone = this.vm.tempShopPhone
              this.editDialogController.close()
            })
          }
          .margin({ top: 28 })
        }
        .width('100%')
        .padding({
          top: 24,
          bottom: 16,
          left: 24,
          right: 24
        })
        .backgroundColor('rgba(255,255,255,0.80)')
      }
      .scrollBar(BarState.Off)
    }
  }
}

@Builder
export function buildOrderInfoPage() {
  OrderInfoPage()
}
