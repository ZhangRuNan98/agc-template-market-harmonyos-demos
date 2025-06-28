import { OrderSkuDto, PreOrderRequest, routerStack } from 'lib_foundation';
import { iResourceMgr } from 'lib_foundation';
import { TitleBar } from 'lib_foundation';
import { AddressManage, getDefaultAddress } from 'module_address_manage';
import { OrderSubmitPageLogic } from '../logic/OrderSubmitPageLogic';
import { CustomContentDialog } from '@kit.ArkUI';

@ComponentV2
export struct OrderSubmitPage {
  @Param
  public preOrderRequest: PreOrderRequest | null = null;
  private logic: OrderSubmitPageLogic = new OrderSubmitPageLogic(this.getUIContext());

  async aboutToAppear(): Promise<void> {
    this.logic.init(this.preOrderRequest);
    const res = await getDefaultAddress()
    if (res) {
      this.logic.nickname = res.name
      this.logic.phone = res.phone
      this.logic.addressDesc = res.province + res.city + res.district + res.street + res.detail
    }
  }

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
      this.logic.tempShopPhone = ''
    },
  })

  build(): void {
    NavDestination() {
      Stack({ alignContent: Alignment.TopStart }) {
        Column()
          .width('100%')
          .height('40%')
          .linearGradient({
            colors: [['#FFE64566', 0.3], ['#00E67C92', 1.0]],
          })
          .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.TOP])
        Column() {
          TitleBar()
          if (this.logic.isLoading) {
            Column() {
              LoadingProgress()
                .width(37)
                .height(37)
                .offset({ y: -50 })
            }
            .width('100%')
            .layoutWeight(1)
            .justifyContent(FlexAlign.Center)
          } else {
            Stack({ alignContent: Alignment.BottomStart }) {
              Scroll() {
                Column() {
                  Text('确认订单')
                    .fontColor(Color.White)
                    .fontSize(24)
                    .fontWeight(500)
                    .margin({ left: 11 })
                  buildAddressSelector(this.logic, this.editDialogController);
                  buildOrderInfo(this.logic);
                }
                .width('100%')
                .constraintSize({ minHeight: '100%' })
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Start)
                .padding({ left: 13, right: 13 })
              }
              .height('100%')
              .padding({ bottom: 80 })

              Row() {
                Text() {
                  Span('¥')
                    .fontSize(15)
                    .fontColor('#FFE84026')
                    .fontWeight(500)
                  Span(this.logic.totalPrice.toString())
                    .fontSize(24)
                    .fontWeight(500)
                    .fontColor('#FFE84026')
                }
                .layoutWeight(1)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.MARQUEE })
                .textAlign(TextAlign.Start)

                Button() {
                  Text('提交订单')
                    .fontSize(13)
                    .fontColor(Color.White)
                    .fontWeight(500)
                }
                .width(95)
                .height(37)
                .type(ButtonType.Normal)
                .backgroundColor('#FFE64566')
                .borderRadius(21)
                .onClick(() => this.logic.onSubmit())
              }
              .width('100%')
              .height(52)
              .backgroundColor(Color.White)
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({ left: 16, right: 16 })
            }
            .width('100%')
            .layoutWeight(1)
          }
        }
        .width('100%')
        .height('100%')
        if (this.logic.isShowRemarkEditor) {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor($r('sys.color.mask_fourth'))
            .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#FFF1F3F5')
    }
    .hideTitleBar(true)
    .backgroundColor(Color.White)
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
            TextInput({ text: $$this.logic.tempShopPhone, placeholder: '请输入预留号码' })
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
              this.logic.tempShopPhone = ''
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
              this.logic.shopPhone = this.logic.tempShopPhone
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
export function buildOrderSubmitPage(_: string, preOrderRequest: PreOrderRequest) {
  OrderSubmitPage({ preOrderRequest: preOrderRequest })
}

@Builder
function buildOrderInfo(logic: OrderSubmitPageLogic) {
  Column() {
    Column() {
      ForEach(logic.skuList, (item: OrderSkuDto) => {
        buildSkuCard(item);
      }, (item: OrderSkuDto[]) => JSON.stringify(item))
    }
    .width('100%')

    Row() {
      Text('配送服务')
        .fontColor($r('sys.color.mask_secondary'))
        .fontSize(14)
      Text('快递发货')
        .fontColor('#E6000000')
        .fontSize(14)
        .fontWeight(600)
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .height(50)

    Row() {
      Text('订单总金额')
        .fontColor($r('sys.color.mask_secondary'))
        .fontSize(14)
      Text('¥' + logic.totalPrice)
        .fontColor('#E6000000')
        .fontSize(14)
        .fontWeight(600)
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .height(46)

    Row() {
      Text('备注')
        .width(85)
        .fontColor($r('sys.color.mask_secondary'))
        .fontSize(14)
      Row() {
        Row() {
          Text(logic.remark === '' ? '选填，建议先与商家沟通后再填写' : logic.remark)
            .layoutWeight(1)
            .fontSize(14)
            .fontColor(logic.remark === '' ? $r('sys.color.mask_tertiary') : 'E6000000')
            .textAlign(TextAlign.End)
            .maxLines(1)
          Image($r('app.media.ic_left_arrow'))
            .height(16)
            .objectFit(ImageFit.Contain)
            .rotate({ angle: 180 })
            .fillColor($r('sys.color.mask_tertiary'))
            .draggable(false)
            .margin({ left: 4 })
        }
        .width('100%')
        .justifyContent(FlexAlign.End)
        .alignItems(VerticalAlign.Center)
        .bindContentCover(logic.isShowRemarkEditor, buildRemarkEditor(logic), {
          modalTransition: ModalTransition.DEFAULT,
          onWillDismiss: () => logic.closeRemarkEditor()
        })
        .onClick(() => {
          logic.remarkCache = logic.remark;
          logic.isShowRemarkEditor = true;
        })
      }
      .layoutWeight(1)
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .height(46)
  }
  .width('100%')
  .padding({ left: 13, right: 13 })
  .borderRadius(13)
  .backgroundColor(Color.White)
  .margin({ top: 20 })
}

@Builder
function buildRemarkEditor(logic: OrderSubmitPageLogic): void {
  Column() {
    Row()
      .width('100%')
      .layoutWeight(1)
      .onClick(() => logic.closeRemarkEditor())
    Column() {
      Stack({ alignContent: Alignment.End }) {
        Text('订单备注')
          .width('100%')
          .fontSize(18)
          .fontColor('#E6000000')
          .textAlign(TextAlign.Center)
          .fontWeight(600)
          .maxLines(1)
        Image($r('app.media.ic_x_mark'))
          .width(24)
          .height(24)
          .draggable(false)
          .fillColor('#E6000000')
          .responseRegion({ x: -12, y: -12, width: 48, height: 48 })
          .onClick(() => logic.closeRemarkEditor())
      }
      .height(60)
      Scroll() {
        Column() {
          TextArea({ text: logic.remarkCache, placeholder: '选填，建议先与商家沟通后再填写' })
            .width('100%')
            .height(160)
            .placeholderColor($r('sys.color.mask_tertiary'))
            .placeholderFont({ size: 14 })
            .caretColor('#FFE64566')
            .fontColor('#E6000000')
            .fontSize(14)
            .maxLength(100)
            .showCounter(true, { thresholdPercentage: 10, highlightBorder: false })
            .barState(BarState.Off)
            .onChange((value: string) => logic.remarkCache = value)
            .borderRadius(12)
            .padding({ left: 16, right: 16, top: 12, bottom: 12 })
            .margin({ top: 4 })
            .backgroundColor('#0D000000')
            .focusable(logic.isShowRemarkEditor)
          Button() {
            Text('确定')
              .fontSize(14)
              .fontColor(Color.White)
              .fontWeight(600)
          }
          .width('100%')
          .height(40)
          .borderRadius($r('sys.float.corner_radius_level10'))
          .type(ButtonType.Normal)
          .backgroundColor('#FFE64566')
          .onClick(() => {
            logic.remark = logic.remarkCache;
            logic.isShowRemarkEditor = false;
          })
          .margin({ top: 12, bottom: 12 })
        }
        .width('100%')
        .constraintSize({ minHeight: '100%' })
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .height('75%')
    .padding({ left: 12, right: 12 })
    .backgroundColor(Color.White)
    .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.BOTTOM])
    .borderRadius({ topLeft: 16, topRight: 16 })
  }
  .width('100%')
  .height('100%')
  .justifyContent(FlexAlign.End)
}

@Builder
function buildSkuCard(sku: OrderSkuDto) {
  Row() {
    Image(iResourceMgr.resolveUri(sku.banner))
      .width(80)
      .height(80)
      .draggable(false)
      .objectFit(ImageFit.Cover)
      .borderRadius(7)
      .margin({ right: 10 })
      .backgroundColor('#90E5E7E9')
    Column() {
      Column() {
        Row() {
          Text(sku.title)
            .layoutWeight(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontSize(14)
            .fontColor($r('sys.color.mask_secondary'))
            .fontWeight(500)
          Text() {
            Span('¥')
              .fontSize(12)
            Span(sku.price.toString())
              .fontSize(16)
          }
          .fontColor('#FFE84026')
          .fontWeight(500)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Text('规格：' + sku.skuDesc)
          .fontColor($r('sys.color.mask_tertiary'))
          .fontSize(12)
          .margin({ top: 3 })
        Text('数量：' + sku.count)
          .fontColor($r('sys.color.mask_tertiary'))
          .fontSize(12)
          .margin({ top: 3 })
      }
      .alignItems(HorizontalAlign.Start)

      Text(sku.serviceDesc)
        .fontColor($r('sys.color.mask_tertiary'))
        .fontSize(10)
    }
    .height(80)
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.SpaceBetween)
  }
  .width('100%')
  .margin({ top: 13 })
}

@Builder
function buildAddressSelector(logic: OrderSubmitPageLogic, editDialogController: CustomDialogController) {
  Column() {
    Row() {
      Row() {
        Text('快递发货')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_secondary'))
      }
      .width('50%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        logic.positionX = 0
        logic.toggleName = '快递发货'
      })

      Row() {
        Text('到店自提')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_secondary'))
      }
      .width('50%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        logic.positionX = 152
        logic.toggleName = '到店自提'
      })

      Row() {
        Text(logic.toggleName)
      }
      .width('50%')
      .height('100%')
      .position({ left: logic.positionX, top: 0 })
      .borderRadius(22)
      .backgroundColor(Color.White)
      .shadow({
        offsetX: 0,
        offsetY: 0,
        radius: 3,
        color: 'rgba(0,0,0,0.20)'
      })
      .justifyContent(FlexAlign.Center)
    }
    .width(304)
    .height(44)
    .backgroundColor('rgba(0,0,0,0.05)')
    .borderRadius(22)
    .margin({ bottom: 16 })

    if (logic.toggleName === '快递发货') {
      AddressManage({
        navPathStack: routerStack,
        isSelectMode: true,
        onSelect: (data) => {
          logic.nickname = data.name
          logic.phone = data.phone
          logic.addressDesc = data.province + data.city + data.district + data.street + data.detail
        }
      }) {
        Row() {
          Image($r('app.media.ic_address'))
            .width(25)
            .height(25)
            .draggable(false)
            .margin({ right: 10 })
          Row() {
            Column() {
              Text(logic.addressDesc)
                .fontColor('#E6000000')
                .fontSize(16)
                .fontWeight(500)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
              Text(logic.nickname + ' ' + logic.phone)
                .fontColor($r('sys.color.mask_tertiary'))
                .fontSize(12)
                .margin({ top: 10 })
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)

            Image($r('app.media.ic_left_arrow'))
              .height(16)
              .objectFit(ImageFit.Contain)
              .rotate({ angle: 180 })
              .fillColor($r('sys.color.mask_tertiary'))
              .draggable(false)
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.SpaceBetween)
        }
      }
    } else {
      Row() {
        Image($r('app.media.shop'))
          .width(25)
          .height(25)
          .draggable(false)
          .margin({ right: 10 })
        Row() {
          Column() {
            Text(logic.shopAddress)
              .fontColor('#E6000000')
              .fontSize(16)
              .fontWeight(500)
            Row() {
              Text('预留电话')
                .fontSize(12)
                .fontWeight(FontWeight.Medium)
                .fontColor($r('sys.color.font_tertiary'))
                .margin({ right: 8 })

              Text(logic.shopPhone)
                .fontSize(12)
                .fontWeight(FontWeight.Medium)
                .fontColor('#E64566')

              Image($r('app.media.edit'))
                .width(12)
                .height(12)
                .margin({ left: 4 })
                .onClick(() => {
                  editDialogController.open()
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
  .borderRadius(13)
  .backgroundColor(Color.White)
  .justifyContent(FlexAlign.Start)
  .margin({ top: 20 })
  .padding({
    left: 12,
    right: 12,
    top: 16,
    bottom: 16
  })
}