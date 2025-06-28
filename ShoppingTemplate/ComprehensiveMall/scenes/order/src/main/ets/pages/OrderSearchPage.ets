import { iResourceMgr, routerStack, Style, TitleBar } from 'lib_foundation';
import { OrderSearchPageVM } from '../viewModels/OrderSearchPageVM';
import { OrderCardVM, OrderSkuDto } from '../http/Type'
import { buildSkuCard } from '../common';

@ComponentV2
struct OrderSearchPage {
  vm: OrderSearchPageVM = OrderSearchPageVM.instance

  build() {
    NavDestination() {
      Column() {
        TitleBar({ barPadding: { right: Style.MENU_BAR_MARGIN_RIGHT } }) {
          this.buildSearch()
        }

        Stack() {
          Scroll() {
            if (this.vm.orderCards.length === 0) {
              Column() {
                Column() {
                  Image($r('app.media.empty_status_logo'))
                    .width(160)
                    .height(160)
                    .draggable(false)
                    .objectFit(ImageFit.Cover)
                    .margin({ bottom: 15 })
                  Text('无相关订单')
                    .fontSize(13)
                    .fontColor($r('sys.color.mask_secondary'))
                    .margin({ bottom: 15 })
                }
                .width('100%')
                .height('45%')
                .borderRadius(12)
                .alignItems(HorizontalAlign.Center)
                .justifyContent(FlexAlign.Center)
                .backgroundColor(Color.White)
              }
              .height('100%')
              .justifyContent(FlexAlign.Start)
              .padding(12)
            } else {
              Column() {
                ForEach(this.vm.orderCards, (card: OrderCardVM, index: number) => {
                  this.buildOrderCard(card, index)
                }, (item: OrderCardVM[]) => JSON.stringify(item))
              }
              .width('100%')
              .constraintSize({ minHeight: '100%' })
              .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.BOTTOM])
              .padding({ left: 12, right: 12 })
            }
          }
          .height('100%')
          .scrollBar(BarState.Off)
          .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.BOTTOM])

          if (this.vm.showLoading) {
            Column() {
              LoadingProgress()
                .width(37)
                .height(37)
                .offset({ y: -50 })
            }
            .width('100%')
            .height('100%')
            .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.BOTTOM])
            .justifyContent(FlexAlign.Center)
          }
        }
        .backgroundColor('#F1F3F5')
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
    }
    .hideTitleBar(true)
    .backgroundColor('#FFF1F3F5')
    .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.BOTTOM, SafeAreaEdge.TOP])
  }

  @Builder
  buildOrderCard(card: OrderCardVM, index: number) {
    Column() {
      Row() {
        Text(card.time)
          .fontSize(12)
          .fontColor($r('sys.color.mask_tertiary'))
        Text(card.statusDesc)
          .fontSize(13)
          .fontColor('#FFE64566')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Column() {
        ForEach(card.skuList, (sku: OrderSkuDto) => {
          buildSkuCard(sku)
        }, (item: OrderSkuDto[]) => JSON.stringify(item))
      }
      .onClick(() => {
        routerStack.pushPathByName('OrderInfoPage', card)
      })

      Row() {
        Text('总价¥' + card.totalPrice)
          .fontColor($r('sys.color.mask_tertiary'))
          .fontSize(12)
          .margin({ right: 8 })
        Text('实付')
          .fontColor($r('sys.color.mask_tertiary'))
          .fontSize(12)
        Text('¥' + card.totalPrice)
          .fontColor('#E6000000')
          .fontSize(14)
          .fontWeight(600)
      }
      .width('100%')
      .margin({ top: 13 })
      .justifyContent(FlexAlign.End)
    }
    .width('100%')
    .padding(12)
    .borderRadius(13)
    .backgroundColor(Color.White)
    .margin(this.vm.orderCards.length - 1 !== index ? { top: 12 } : { top: 12, bottom: 12 })
    .alignItems(HorizontalAlign.End)
  }

  @Builder
  buildSearch() {
    Search({
      value: this.vm.submit,
      controller: this.vm.controller,
      placeholder: this.vm.placeholder
    })
      .width('100%')
      .height(Style.MENU_BAR_HEIGHT)
      .borderWidth(Style.MENU_BAR_BORDER_WIDTH)
      .borderRadius(Style.MENU_BAR_BORDER_RADIUS)
      .backgroundColor(Color.White)
      .borderColor($r('sys.color.font_fourth'))
      .searchButton('搜索', {
        fontSize: 13,
        fontColor: '#FFE64566'
      })
      .defaultFocus(true)
      .searchIcon({ size: 0 })
      .textFont({
        size: 13
      })
      .placeholderFont({
        size: 13
      })
      .placeholderColor($r('sys.color.mask_secondary'))
      .caretStyle({ color: '#FFE64566' })
      .onSubmit((value) => {
        this.vm.onSubmit(value)
      })
  }
}

@Builder
export function buildOrderSearchPage() {
  OrderSearchPage()
}


