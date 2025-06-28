import { queryDesignerList, DesignerDetail } from 'network';
import { FeeInfo } from '../types/Index';


@ObservedV2
export class FindPageVM {
  @Trace isDrawOpen: boolean = false;
  @Trace curIndex: number = -1;
  @Trace feeIndex: number = -1;
  @Trace spaceIndex: number = -1;
  @Trace tabList: string[] = ['设计费', '擅长空间'];
  @Trace feeList: FeeInfo[] = [
    {
      des: '全部',
      min: 0,
      max: Infinity,
    },
    {
      des: '60元/m²',
      min: 60,
      max: 60,
    },
    {
      des: '80元/m²',
      min: 80,
      max: 80,
    },
    {
      des: '100元/m²',
      min: 100,
      max: 100,
    },
    {
      des: '120元/m²',
      min: 120,
      max: 120,
    },
    {
      des: '140元/m²',
      min: 140,
      max: 140,
    },
    {
      des: '160元/m²',
      min: 160,
      max: 160,
    },
    {
      des: '160元以上',
      min: 160,
      max: Infinity,
    },
  ];
  @Trace goodSpace: string[] = [
    '全部',
    '住宅家居',
    '别墅豪宅',
  ];
  @Trace designerList: DesignerDetail[] = [];
  private static _instance: FindPageVM;

  public static get instance() {
    if (!FindPageVM._instance) {
      FindPageVM._instance = new FindPageVM();
    }
    return FindPageVM._instance;
  }

  @Monitor('feeIndex', 'spaceIndex')
  onIndexChange(monitor: IMonitor) {
    this.getDesignerList();
  }

  public async getDesignerList() {
    const res =
      await queryDesignerList({
        min: this.feeIndex <= 0 ? 0 : this.feeList[this.feeIndex].min,
        goodSpace: this.spaceIndex <= 0 ? '' : this.goodSpace[this.spaceIndex],
        max: this.feeIndex <= 0 ? Infinity : this.feeList[this.feeIndex].max,
      });
    if (res.status === 200) {
      this.designerList = res.data;
    }
  }
}
