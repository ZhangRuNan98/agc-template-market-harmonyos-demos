import { OrderSkuDto, PreOrderRequest, RouterMap, routerStack, Style, TitleBar } from 'lib_foundation';
import { ShippingOption } from '../commons/Enums';
import { OrderSubmitVM } from '../viewmodel/OrderSubmitVM';
import { ShippingInfoButton } from '../components/ShippingInfoButton';
import { AddressManage } from 'module_address_manage';
import { OrderItemCard } from '../components/OrderItemCard';
import { Coupons } from 'module_coupons';
import { PopupSheet } from 'module_shopping_cart';

@Builder
export function buildOrderSubmitPage() {
  OrderSubmitPage()
}

@ComponentV2
export struct OrderSubmitPage {
  vm: OrderSubmitVM = new OrderSubmitVM();
  @Local
  showPriceDetail: boolean = false;
  @Local
  popupMaskHeight: Length = '';
  @Local
  showRemarkSheet: boolean = false;

  build() {
    NavDestination() {
      TitleBar() {
        Text('确认订单')
          .fontColor(Style.FONT_COLOR_1_INVERT)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 11 });
      };

      Scroll() {
        Column() {
          if (this.vm.isLoading) {
            LoadingProgress().width(32).height(32);
          } else {
            this.shippingInfoBuilder();
            this.productInfoBuilder();
            this.paymentBuilder()
          }
        }
      }
      .align(Alignment.Top)
      .edgeEffect(EdgeEffect.Spring)
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .padding(16);

      PopupSheet({
        visible: this.showPriceDetail!!,
        cornerRadius: 12,
        maskHeight: this.popupMaskHeight,
        customContentBuilder: () => {
          this.priceDetailPopupBuilder();
        },
        title: '金额明细',
      })
        .backgroundColor(Color.White)
        .onAreaChange((_ov, nv) => {
          if (nv.globalPosition.y) {
            this.popupMaskHeight = nv.globalPosition.y;
          }
        });

      this.bottomButtonBuilder();
    }
    .onReady(() => {
      const params = routerStack.getParamByName(RouterMap.ORDER_SUBMIT) as PreOrderRequest[] | undefined;
      if (params?.length) {
        this.vm.initData(params[0]);
      }
    })
    .hideTitleBar(true)
    .linearGradient({
      colors: [[0xFFE64566, 0.1], [0x00f1f3f5, 0.5]],
    });
  }

  @Builder
  shippingInfoBuilder() {
    Column() {
      ShippingInfoButton({
        onShippingIndexChange: (index) => {
          this.vm.shippingIndex = index;
        },
      })
        .margin({ bottom: 16 });
      if (this.vm.shippingIndex === ShippingOption.EXPRESS) {
        AddressManage({
          navPathStack: routerStack,
          isSelectMode: true,
          onSelect: (data) => {
            this.vm.customerAddress = data.province + data.city + data.district + data.street + data.detail;
            this.vm.customerName = data.name;
            this.vm.customerPhone = data.phone;
          },
        }) {
          Row() {
            Image($r('app.media.ic_address'))
              .width(24)
              .margin({ right: 16 });
            Row() {
              Column() {
                Text(this.vm.customerAddress).addressInfoStyle();
                Text(this.vm.customerName + ' ' + this.vm.customerPhone).customerLabelStyle();
              }
              .layoutWeight(1)
              .margin({ right: 16 })
              .alignItems(HorizontalAlign.Start);

              Image($r('sys.media.ohos_ic_public_arrow_right')).arrowStyle();
            }
            .layoutWeight(1)
            .justifyContent(FlexAlign.SpaceBetween);
          };
        };
      } else if (this.vm.shippingIndex === ShippingOption.SELF_PICK_UP) {
        Row() {
          Image($r('app.media.shop'))
            .width(24)
            .margin({ right: 16 });
          Column() {
            Text(this.vm.SHOP_ADDRESS).addressInfoStyle();
            Text() {
              Span('预留电话');
              Span(' ').letterSpacing(2);
              Span(this.vm.SHOP_PHONE).fontColor(Style.THEME_COLOR);
            }.customerLabelStyle();
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start);
        };
      }
    }.containerStyle();
  }

  @Builder
  productInfoBuilder() {
    Column() {
      List() {
        ForEach(this.vm.skuList, (item: OrderSkuDto) => {
          ListItem() {
            OrderItemCard({
              sku: item,
            });
          };
        }, (item: OrderSkuDto, index: number) => index + '__' + item.skuCode);
      };

      this.infoItemBuilder({
        label: '配送服务',
        content: this.vm.ShippingLabel,
      });
      this.infoItemBuilder({
        label: '优惠券',
        content: '-¥' + this.vm.discountPrice,
        contentColor: Style.THEME_COLOR,
        callback: () => {
          Coupons.select({
            totalMoney: this.vm.totalPrice,
            selectId: this.vm.discountId,
            confirm: (data) => {
              this.vm.discountPrice = data.reduce;
            },
          });
        },
      });
      this.infoItemBuilder({
        label: '订单总金额',
        content: '¥' + this.vm.finalPrice,
      });
      this.infoItemBuilder({
        label: '备注',
        content: this.vm.remark,
        callback: () => {
          this.showRemarkSheet = true;
        },
      });
    }
    .containerStyle()
    .bindSheet($$this.showRemarkSheet, this.remarkEditSheet(), {
      detents: [SheetSize.MEDIUM],
      title: { title: '订单备注' },
      backgroundColor: Style.BACKGROUND_COLOR,
      onWillDismiss: (action) => {
        this.vm.remarkCache = '';
        action.dismiss();
      },
    });
  }

  @Builder
  paymentBuilder() {
    Row() {
      Image($r('app.media.ic_huawei_pay'))
        .height(24)
        .borderRadius(8)
        .margin({ right: 12 })

      Text('华为支付').formContentStyle().fontSize(16)
      Blank()
      Radio({ value: '华为支付', group: 'payment' })
        .checked(true)
        .radioStyle({ checkedBackgroundColor: Style.THEME_COLOR })
    }
    .containerStyle();
  }

  @Builder
  bottomButtonBuilder() {
    Row() {
      Column() {
        Text() {
          Span(`共${this.vm.totalProductCount}件, `).fontColor(Style.FONT_COLOR_LEVEL3);
          Span('合计: ');
          Span('¥ ').fontWeight(FontWeight.Medium).fontColor(Style.THEME_COLOR);
          Span(this.vm.finalPrice.toString())
            .fontWeight(FontWeight.Medium)
            .fontColor(Style.THEME_COLOR)
            .fontSize(Style.FONT_SIZE_16);
        }
        .fontSize(Style.FONT_SIZE_12)
        .fontColor(Style.FONT_COLOR_LEVEL1)
        .margin({ bottom: 4 });

        Row() {
          Text('查看明细')
            .fontColor(Style.THEME_COLOR)
            .fontSize(Style.FONT_SIZE_12);
          Image($r('sys.media.ohos_ic_public_arrow_up'))
            .width(16)
            .height(16)
            .fillColor(Style.THEME_COLOR);
        }
        .onClick(() => {
          this.showPriceDetail = !this.showPriceDetail;
        });
      }
      .margin({ right: 16 })
      .alignItems(HorizontalAlign.End);

      Button('提交订单')
        .backgroundColor(Style.THEME_COLOR)
        .onClick(() => {
          this.vm.onSubmit();
        });
    }
    .width('100%')
    .justifyContent(FlexAlign.End)
    .backgroundColor(Style.BACKGROUND_COLOR)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .padding({
      top: 8,
      bottom: 8,
      left: 16,
      right: 16,
    });
  }

  @Builder
  infoItemBuilder($$: InfoBuilderParam) {
    Row() {
      Text($$.label)
        .fontColor(Style.FONT_COLOR_LEVEL2)
        .fontSize(Style.FONT_SIZE_14);
      Blank();
      Text($$.content).formContentStyle($$.contentColor)
      if ($$.callback) {
        Image($r('sys.media.ohos_ic_public_arrow_right'))
          .arrowStyle()
          .onClick(() => {
            $$.callback?.();
          });
      }
    }
    .width('100%')
    .margin({ top: 16 });
  }

  @Builder
  priceDetailPopupBuilder() {
    Column({ space: 14 }) {
      this.PopupContentItem('商品金额', this.vm.totalDashPrice);
      if (this.vm.totalPrice < this.vm.totalDashPrice) {
        this.PopupContentItem('活动优惠', this.vm.totalDashPrice - this.vm.totalPrice, true);
      }
      if (this.vm.discountPrice) {
        this.PopupContentItem('优惠券', this.vm.discountPrice, true);
      }
      Row() {
        Text('合计')
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontWeight(FontWeight.Medium);

        Text() {
          Span('¥').fontSize(12);
          Span(this.vm.finalPrice.toString());
        }
        .fontColor(Style.THEME_COLOR)
        .fontWeight(FontWeight.Medium);
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween);
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .backgroundColor($r('sys.color.white'));
  }

  @Builder
  PopupContentItem(label: string, value: number, isDiscount: boolean = false) {
    Row() {
      Text(label)
        .fontSize(14)
        .fontColor($r('sys.color.ohos_id_color_text_tertiary'))
        .fontWeight(FontWeight.Regular);

      Text() {
        if (isDiscount) {
          Span('-')
        }
        Span(`¥${value}`)
      }
      .fontSize(14)
      .fontColor($r('sys.color.ohos_id_color_text_primary'))
      .fontWeight(FontWeight.Medium);
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween);
  }

  @Builder
  remarkEditSheet() {
    Column() {
      TextArea({ text: this.vm.remark, placeholder: '选填，建议先与商家沟通后再填写' })
        .width('100%')
        .height(160)
        .caretColor(Style.THEME_COLOR)
        .fontColor(Style.FONT_COLOR_LEVEL1)
        .fontSize(Style.FONT_SIZE_14)
        .placeholderFont({ size: Style.FONT_SIZE_14 })
        .maxLength(100)
        .showCounter(true)
        .barState(BarState.Off)
        .onChange((value: string) => {
          this.vm.remarkCache = value;
        })
        .borderRadius(12)
        .backgroundColor(Style.BACKGROUND_COLOR_GREY_2);
      Blank();
      Button('确定')
        .width('100%')
        .height(40)
        .borderRadius(Style.BORDER_RADIUS_CAPSULE)
        .type(ButtonType.Normal)
        .backgroundColor(Style.THEME_COLOR)
        .onClick(() => {
          this.vm.remark = this.vm.remarkCache;
          this.showRemarkSheet = false;
        });
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor(Style.BACKGROUND_COLOR);
  }
}

@Extend(Image)
function arrowStyle() {
  .height(24)
  .width(24)
  .fillColor(Style.ICON_COLOR_GREY);
}

@Styles
function containerStyle() {
  .backgroundColor(Style.BACKGROUND_COLOR)
  .padding(12)
  .borderRadius(Style.BORDER_RADIUS_16)
  .width('100%')
  .margin({ bottom: 16 });
}

@Extend(Text)
function addressInfoStyle() {
  .fontColor(Style.FONT_COLOR_LEVEL1)
  .fontWeight(FontWeight.Medium)
  .maxLines(1)
  .textOverflow({ overflow: TextOverflow.Ellipsis })
  .margin({ bottom: 2 });
}

@Extend(Text)
function customerLabelStyle() {
  .fontColor(Style.FONT_COLOR_LEVEL3)
  .fontSize(Style.FONT_SIZE_14)
  .maxLines(1)
  .textOverflow({ overflow: TextOverflow.Ellipsis });
}

@Extend(Text)
function formContentStyle(color?: ResourceColor) {
  .fontColor(color ? color : Style.FONT_COLOR_LEVEL1)
  .fontSize(Style.FONT_SIZE_14)
  .fontWeight(FontWeight.Medium);
}

class InfoBuilderParam {
  label: string = '';
  content: string = '';
  contentColor?: ResourceColor;
  callback?: () => void;
}