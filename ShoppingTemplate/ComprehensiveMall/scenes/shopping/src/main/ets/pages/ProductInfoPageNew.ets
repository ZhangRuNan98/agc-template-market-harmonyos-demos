import { promptAction } from '@kit.ArkUI';
import { TitleBar, iData, CartDto, PreOrderRequest, routerStack, RouterMap, Style } from 'lib_foundation';
import { client } from 'lib_network';
import { ProductDetail } from 'module_product_detail';
import { ProductResource, ProductShare } from 'module_product_share';

@ComponentV2
export struct ProductInfoNewPage {
  @Local
  productId: string = '';
  @Local
  isLogin: boolean = iData.global.isLogin;
  @Local
  cartNum: number = iData.global.cartTotal;
  @Local
  productResource: ProductResource | undefined = undefined;

  build() {
    NavDestination() {
      TitleBar() {
        Row() {
          Text('商品详情')
            .fontSize(Style.FONT_SIZE_20)
            .fontWeight(FontWeight.Bold)
            .fontColor(Style.FONT_COLOR_LEVEL1);

          if (this.productResource) {
            ProductShare({
              customUI: this.shareIconBuilder,
              productResource: this.productResource,
            });
          }
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .padding({ right: 16 });
      };

      if (this.productId) {
        ProductDetail({
          isLogin: this.isLogin,
          productId: this.productId,
          cartProdNum: this.cartNum,
          getProductInfo: (data) => {
            this.productResource = {
              image: data.banners[0],
              title: data.title,
              price: Number(data.price),
              url: `http://test/${data.id}/${data.title}`,
            };
          },
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

  @Builder
  shareIconBuilder() {
    Image($r('app.media.ic_share'))
      .width(40)
      .height(40);
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

