import { ProductWaterFlow } from 'module_product_waterflow';
import {
  iData,
  PreOrderItem,
  PreOrderRequest,
  routerStack,
  RouterMap,
  BreakpointSystem,
  BreakpointStorage,
  BreakpointTypeEnum,
  Style,
} from 'lib_foundation';

import { CartPageLogic } from '../logic/CartPageLogic';
import { ShoppingCart } from 'module_shopping_cart';
import { promptAction } from '@kit.ArkUI';
import { Product } from 'module_shopping_cart/src/main/ets/commons/Model';

@ComponentV2
struct CartPage {
  @Param
  public pageName?: string = undefined;
  private logic: CartPageLogic = new CartPageLogic();
  @Local isChildRoute: boolean = false;
  @Local curBreakpoint: BreakpointStorage = BreakpointSystem.currentBreakpoint

  @Computed
  get waterFlowTemplate() {
    if (this.curBreakpoint.value === BreakpointTypeEnum.SM) {
      return '1fr 1fr'
    }
    return '1fr 1fr 1fr'
  }

  aboutToAppear(): void {
    this.isChildRoute = Boolean(this.pageName);
    this.logic.isSubPage = this.isChildRoute;
  }

  private handleCheckout(list: Product[]): void {
    if (!list.length) {
      promptAction.showToast({ message: '您还没有选择商品' });
      return;
    }
    const orders: PreOrderItem[] = [];
    for (let product of list) {
      const preOrderItem: PreOrderItem = {
        skuCode: product.skuCode,
        quantity: product.count,
      };
      orders.push(preOrderItem);
    }
    const preOrderRequest: PreOrderRequest = {
      items: orders,
      removeFromCart: true,
    };
    routerStack.pushPathByName('OrderSubmitPage', preOrderRequest);
  }

  build(): void {
    NavDestination() {
      // 购物车页面
      ShoppingCart({
        isChildRoute: this.isChildRoute,
        isLogin: this.logic.global.isLogin,
        customContentBuilder: () => {
          // 自定义组件  推荐商品
          this.recommendedProductSection();
        },
        onLogin: () => {
          // 登录逻辑
          routerStack.pushPathByName('HuaweiQuickLoginPage', () => {
            this.logic.global.isLogin = iData.global.isLogin;
          });
        },
        onCardClick: (id: string) => {
          // 点击购物车卡片
          routerStack.pushPath({
            name: RouterMap.PRODUCT_INFO_NEW,
            param: id,
          });
        },
        onBack: () => {
          routerStack.pop();
        },
        onCheckout: (selectedGoodList: Product[]) => {
          // 结算逻辑
          this.handleCheckout(selectedGoodList);
        },
      })
    }
    .hideTitleBar(true)
    .onShown(() => {
      this.isChildRoute = true;
      if (this.logic.isSubPage) {
        this.logic.refresh(false);
      }
    })
    .onHidden(() => {
      this.isChildRoute = false;
    })
  }

  @Builder
  recommendedProductSection() {
    buildSpecialDivider();
    Column() {
      ProductWaterFlow({
        customColumnTemplate: this.waterFlowTemplate,
        bgColor:Style.BACKGROUND_COLOR,
        handleProductClick: (id) => {
          routerStack.pushPath({
            name: RouterMap.PRODUCT_INFO_NEW,
            param: id,
          });
        },
      })
    }
    .padding({ left: 12, right: 12, top: 12 })
    .backgroundColor(Color.White)
  }
}


@Builder
export function buildCartPage(pageName?: string) {
  CartPage({ pageName: pageName })
}

@Builder
function buildSpecialDivider() {
  Row() {
    Column()
      .width(5.5)
      .height(5.5)
      .borderRadius(10)
      .linearGradient({
        angle: -130.6,
        colors: [['#FFE64566', 0.3], ['#00E64566', 1.0]],
      })
      .margin({ right: 10 })
    Column()
      .width(7)
      .height(7)
      .borderRadius(10)
      .linearGradient({
        angle: -130.6,
        colors: [['#FFE64566', 0.3], ['#00E64566', 1.0]],
      })
    Text('推荐商品')
      .fontSize(15)
      .fontColor('#E6000000')
      .margin({ left: 15, right: 15 })
    Column()
      .width(7)
      .height(7)
      .borderRadius(10)
      .linearGradient({
        angle: 130.6,
        colors: [['#FFE64566', 0.3], ['#00E64566', 1.0]],
      })
    Column()
      .width(5.5)
      .height(5.5)
      .borderRadius(10)
      .linearGradient({
        angle: 130.6,
        colors: [['#FFE64566', 0.3], ['#00E64566', 1.0]],
      })
      .margin({ left: 10 })
  }
  .width('100%')
  .height(47)
  .alignItems(VerticalAlign.Center)
  .justifyContent(FlexAlign.Center)
}
