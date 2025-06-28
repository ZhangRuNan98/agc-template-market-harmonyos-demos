import { promptAction } from '@kit.ArkUI';
import { DesignerDetail, ReviewItem, ReviewInfo, queryReview, OrderDesignerBody, orderDesigner } from 'network';
import { RouterModule, RouterMap } from 'commonlib';
import { RangeItem } from '../types/Index';


@ObservedV2
export class DesignerPageVM {
  @Trace isOrderOpen: boolean = false;
  @Trace isPhoneOpen: boolean = false;
  @Trace isShow: boolean = false;
  @Trace reviewInfo: ReviewInfo | undefined = undefined;
  @Trace designerDetail: DesignerDetail | undefined = undefined;
  @Trace curAreaIndex: number = 0;
  @Trace curBudgetIndex: number = 0;
  @Trace firstName: string = '';
  @Trace areaList: RangeItem[] = [
    {
      label: '60㎡以下',
      min: 0,
      max: 60,
    },
    {
      label: '60㎡-80㎡',
      min: 60,
      max: 80,
    },
    {
      label: '81㎡-100㎡',
      min: 81,
      max: 100,
    },
    {
      label: '101㎡以上',
      min: 101,
      max: Infinity,
    },
  ];
  @Trace budgetList: RangeItem[] = [
    {
      label: '5-10万',
      min: 5,
      max: 10,
    },
    {
      label: '10-15万',
      min: 10,
      max: 15,
    },
    {
      label: '15-30万',
      min: 15,
      max: 30,
    },
    {
      label: '30万以上',
      min: 30,
      max: Infinity,
    },
  ];
  private static _instance: DesignerPageVM;

  public static get instance() {
    if (!DesignerPageVM._instance) {
      DesignerPageVM._instance = new DesignerPageVM();
    }
    return DesignerPageVM._instance;
  }

  public getDesignerDetail() {
    const params: DesignerDetail | undefined = RouterModule.getNavParam<DesignerDetail>(RouterMap.DESIGNER_PAGE);
    if (params) {
      this.designerDetail = params;
    }
  }

  public async getReviewList() {
    const res = await queryReview(this.designerDetail?.id || 1);
    if (res.status === 200) {
      this.reviewInfo = res.data;
    }
  }

  public async toOrder() {
    if (this.firstName) {
      const data: OrderDesignerBody = {
        id: this.designerDetail?.id || 0,
        firstName: this.firstName,
        budget: this.budgetList[this.curBudgetIndex].label,
        area: this.areaList[this.curAreaIndex].label,
      };
      const res = await orderDesigner(data);
      if (res.status === 200) {
        this.isOrderOpen = false;
        promptAction.showToast({ message: '预约成功，后续设计师将通过电话联系您！' });
      }
    } else {
      promptAction.showToast({ message: '请留下您的姓！' });
    }
  }
}
