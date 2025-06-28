import { CaseInfo, queryFilterCaseList, FilterListParams, Range } from 'network';
import { RangeItem } from '../types/Index';

@ObservedV2
export class HomeCasePageVM {
  @Trace filterList: string[] = ['全部风格', '全部户型', '全部面积', '全部造价'];
  @Trace styleIndex: number = 0;
  @Trace houseTypeIndex: number = 0;
  @Trace areaIndex: number = 0;
  @Trace priceIndex: number = 0;
  @Trace styleList: string[] =
    ['全部风格', '现代简约', '极简', '轻奢风', '奶油风', '北欧风', '原木风', '复古风', '日式', '新中式', '法式', '美式',
      '混搭风', '小清新', '大理石', '其他'];
  @Trace houseTypeList: string[] = ['全部户型', '一居室', '二居室', '三居室', '四居以上', '复式', '样板间', '别墅'];
  @Trace areaList: RangeItem[] = [
    {
      label: '全部面积',
      max: Infinity,
      min: 0,
    },
    {
      label: '60㎡以下',
      max: 60,
      min: 0,
    },
    {
      label: '60-80㎡',
      max: 80,
      min: 60,
    },
    {
      label: '81-100㎡',
      max: 100,
      min: 81,
    },
    {
      label: '101-120㎡',
      max: 120,
      min: 101,
    },
    {
      label: '121-150㎡',
      max: 150,
      min: 121,
    },
    {
      label: '151-200㎡',
      max: 200,
      min: 151,
    },
    {
      label: '200㎡以上',
      max: Infinity,
      min: 200,
    },
  ];
  @Trace priceList: RangeItem[] = [
    {
      label: '全部价格',
      min: 0,
      max: Infinity,
    },
    {
      label: '0-5万',
      min: 0,
      max: 5,
    },
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
      label: '15-20万',
      min: 15,
      max: 20,
    },
    {
      label: '20-25万',
      min: 20,
      max: 25,
    },
    {
      label: '25-30万',
      min: 25,
      max: 30,
    },
    {
      label: '30万以上',
      min: 30,
      max: Infinity,
    },
  ];
  @Trace caseList: CaseInfo[] = [];
  private static _instance: HomeCasePageVM;

  public static get instance() {
    if (!HomeCasePageVM._instance) {
      HomeCasePageVM._instance = new HomeCasePageVM();
    }
    return HomeCasePageVM._instance;
  }

  @Monitor('styleIndex', 'houseTypeIndex', 'priceIndex', 'areaIndex')
  onConditionChange() {
    this.getCaseList();
  }

  public initData() {
    this.styleIndex = -1;
    this.areaIndex = -1;
    this.houseTypeIndex = -1;
    this.priceIndex = -1;
  }

  public async getCaseList() {
    let homeTypeLabel: string | undefined = undefined;
    let style: string | undefined = undefined;
    let area: Range | undefined = undefined;
    let price: Range | undefined = undefined;
    if (this.houseTypeIndex > 0) {
      homeTypeLabel = this.houseTypeList[this.houseTypeIndex];
    }
    if (this.styleIndex > 0) {
      style = this.styleList[this.styleIndex];
    }
    if (this.areaIndex > 0) {
      let curArea: RangeItem = this.areaList[this.areaIndex];
      area = {
        max: curArea.max,
        min: curArea.min,
      };
    }
    if (this.priceIndex > 0) {
      let curPrice: RangeItem = this.priceList[this.priceIndex];
      price = {
        max: curPrice.max,
        min: curPrice.min,
      };

    }


    const queryParams: FilterListParams = {
      homeTypeLabel,
      style,
      area,
      price,
    };

    const res = await queryFilterCaseList(queryParams);
    if (res.status === 200) {
      this.caseList = res.data;
    }
  }
}