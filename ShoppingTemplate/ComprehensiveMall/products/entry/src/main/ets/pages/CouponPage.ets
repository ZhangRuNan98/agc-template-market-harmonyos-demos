import { RouterMap, routerStack, Style, TitleBar } from 'lib_foundation';
import { MyCouponsView } from 'module_coupons';

@Builder
export function buildCouponPage() {
  CouponPage();
}

@ComponentV2
export struct CouponPage {
  build() {
    NavDestination() {
      TitleBar() {
        Text('我的优惠券')
          .fontSize(Style.FONT_SIZE_20)
          .fontColor(Style.FONT_COLOR_LEVEL1)
          .fontWeight(FontWeight.Bold);
      };

      MyCouponsView({
        useNow: () => {
          routerStack.pushPath({ name: RouterMap.PRODUCT_CATEGORY });
        },
      }).layoutWeight(1);
    }
    .hideTitleBar(true);
  }
}