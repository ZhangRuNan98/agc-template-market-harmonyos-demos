import { PersistenceV2, promptAction } from '@kit.ArkUI';
import { TitleBar, iData, CartDto, PreOrderRequest, routerStack, RouterMap } from 'lib_foundation';
import { client } from 'lib_network';
import { MockCart } from 'lib_network/src/main/ets/mock/MockDataMgr';
import { ProductDetail } from 'module_product_detail';

@ComponentV2
export struct ProductInfoNewPage {
  @Local
  productId: string = '';
  @Local
  isLogin: boolean = iData.global.isLogin;
  @Local
  cartNum: number = iData.global.cartTotal;

  build() {
    NavDestination() {
      TitleBar();

      if (this.productId) {
        ProductDetail({
          isLogin: this.isLogin,
          productId: this.productId,
          cartProdNum: this.cartNum,
          clickCart: () => {
            routerStack.pushPath({ name: RouterMap.PRODUCT_CART });
          },
          handleAddCart: (skuCode, count) => {
            client.cart.addSkuToCart(skuCode, count).then((cartDto: CartDto) => {
              iData.global.cartVersion = cartDto.version;
              iData.global.cartTotal = cartDto.total;
              promptAction.showToast({ message: '成功加入购物车' });
              this.getCartNum();
            });
          },
          handlePayNow: (skuCode, count) => {
            const preOrderRequest: PreOrderRequest = {
              items: [{
                skuCode,
                quantity: count,
              }],
              removeFromCart: false,
            };
            routerStack.pushPathByName(RouterMap.ORDER_SUBMIT, preOrderRequest);
          },
          handleNotLogin: () => {
            routerStack.pushPathByName(RouterMap.USER_LOGIN, () => {
              this.isLogin = iData.global.isLogin;
            });
          },
        })
          .layoutWeight(1);
      }
    }
    .hideTitleBar(true)
    .backgroundColor(Color.White)
    .onReady(() => {
      const params = routerStack.getParamByName(RouterMap.PRODUCT_INFO_NEW) as string[];
      if (params?.length) {
        this.productId = params[0];
      }
    })
    .onShown(() => {
      this.getCartNum();
    });
  }

  async getCartNum() {
    const cartData = await client.cart.getCartData();
    this.cartNum = cartData.total;
  }
}

@Builder
export function buildProductInfoNewPage() {
  ProductInfoNewPage();
}

