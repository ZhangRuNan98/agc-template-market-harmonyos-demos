import { CouponCardComp } from '../components/CouponCardComp';
import { TabComp } from '../components/TabComp';
import { CommonConstants, MY_TAB_BAR } from '../constants/Contants';
import { CouponItem } from '../network/types/responseTypes/GetCouponsResp';
import { ScenarioStatus } from '../types/Types';
import { getCouponList, getScenarioStatus } from '../utils/Service';
import { Coupons } from './SelectCouponsView';
import { window } from '@kit.ArkUI';
import { FullLoading } from '../utils/FullLoading';
import { WindowUtil } from '../utils/WindowUtil';

@ComponentV2
export struct MyCouponsView {
  @Local myCouponsAll: CouponItem[] = [];
  @Event useNow: (couponId: string) => void;
  private _tabBar: string[] = [];
  private _currentIndex: number = 0;

  @Computed
  get contentData() {
    const data: CouponItem[][] = [[], [], [], []];
    this.myCouponsAll.forEach(item => {
      const status = getScenarioStatus(item, 0);
      if (status === ScenarioStatus.EXPIRE) {
        data[3].push(item);
      } else if (status === ScenarioStatus.HAS_USED) {
        data[2].push(item);
      } else {
        data[1].push(item);
      }
    });
    data[0] = [...data[1], ...data[2], ...data[3]];
    return data;
  }

  async aboutToAppear() {
    this._tabBar = MY_TAB_BAR;
    if (!Coupons.uiContext) {
      let windowClass: window.Window = await window.getLastWindow(getContext());
      let uiContext = windowClass.getUIContext();
      Coupons.uiContext = uiContext;
      FullLoading.init(uiContext);
      WindowUtil.init(windowClass);
    }
    const res = await getCouponList();
    this.myCouponsAll = res;
  }

  build() {
    TabComp({
      tabBar: this._tabBar,
      space: 40,
      index: this._currentIndex,
      contentUi: (index: number) => {
        this.tabContentBuilder(index);
      },
    })
  }

  @Builder
  tabContentBuilder(index: number) {
    List({ space: 8 }) {
      ForEach(this.contentData[index], (item: CouponItem) => {
        ListItem() {
          CouponCardComp({ coupon: item, clickCoupon: coupon => this.useNow(coupon.couponID) })
        }
      }, (item: CouponItem, index) => JSON.stringify(item) + '_' + index)
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
    .scrollBar(BarState.Off)
    .align(Alignment.Top)
    .padding({ left: $r('app.string.padding_12'), right: $r('app.string.padding_12') })
  }
}