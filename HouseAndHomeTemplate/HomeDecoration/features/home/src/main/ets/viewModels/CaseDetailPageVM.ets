import { promptAction } from '@kit.ArkUI';
import { RouterModule, RouterMap } from 'commonlib';
import { CaseInfo, orderDesigner, OrderDesignerBody, queryCollection, addCollection, cancelCollection } from 'network';
import { RangeItem } from '../types/Index';


@ObservedV2
export class CaseDetailPageVM {
  @Trace isCollection: boolean = false;
  @Trace collectionList: number[] = [];
  @Trace firstName: string = '';
  @Trace isOrderOpen: boolean = false;
  @Trace isPhoneOpen: boolean = false;
  @Trace curIndex: number = 0;
  @Trace curAreaIndex: number = 0;
  @Trace curBudgetIndex: number = 0;
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
  @Trace caseInfo: CaseInfo | undefined = undefined;
  private static _instance: CaseDetailPageVM;

  public static get instance() {
    if (!CaseDetailPageVM._instance) {
      CaseDetailPageVM._instance = new CaseDetailPageVM();
    }
    return CaseDetailPageVM._instance;
  }

  public getCaseInfo() {
    const params: CaseInfo | undefined = RouterModule.getNavParam<CaseInfo>(RouterMap.CASE_DETAIL_PAGE);
    if (params) {
      this.caseInfo = params;
    }
  }

  public async toOrder() {
    if (this.firstName) {
      const data: OrderDesignerBody = {
        id: this.caseInfo?.designer.id || 0,
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

  public async getCollectionList() {
    const res = await queryCollection();
    if (res.status === 200) {
      this.collectionList = res.data;
      this.isCollection = this.collectionList.includes(this.caseInfo?.caseId || -1);
    }
  }

  public async addCollection() {
    if (this.caseInfo) {
      const res = await addCollection(this.caseInfo.caseId);
      if (res.status === 200) {
        this.isCollection = true;
      }
    }
  }

  public async removeCollection() {
    if (this.caseInfo) {
      const res = await cancelCollection(this.caseInfo.caseId);
      if (res.status === 200) {
        this.isCollection = false;
      }
    }
  }
}
