import { PersistenceV2, promptAction } from '@kit.ArkUI';
import { LocationUtil, RouterModule, RouterMap, CurrentCity, AppStorageMap } from 'commonlib';
import { CustomParams, RangeDesc } from 'network';
import { SourceItem } from '../types/Index';

@ObservedV2
export class CustomPageVM {
  // 默认的城市信息
  @Trace defaultCity: CurrentCity =
    PersistenceV2.connect(CurrentCity, AppStorageMap.CURRENT_CITY, () => new CurrentCity())!;
  @Trace isSheetOpen: boolean = false;
  @Trace curCity: string = '';
  @Trace gpsCity: string = '';
  @Trace sourceList: SourceItem[] = [
    {
      label: '装修服务海量数据',
      img: $r('app.media.source1'),
    },
    {
      label: '合作案例数不胜数',
      img: $r('app.media.source2'),
    },
    {
      label: '普遍报价符合行情',
      img: $r('app.media.source3'),
    },
  ];
  @Trace curAreaIndex: number = 0;
  @Trace curBudgetIndex: number = 0;
  @Trace areaList: RangeDesc[] = [
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
  @Trace budgetList: RangeDesc[] = [
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
  private static _instance: CustomPageVM;

  public static get instance() {
    if (!CustomPageVM._instance) {
      CustomPageVM._instance = new CustomPageVM();
    }
    return CustomPageVM._instance;
  }

  public getCityByGPS() {
    if (!this.gpsCity){
      this.gpsCity = this.defaultCity.cityName;
    }
  }

  public async handleCustomData() {
    if (!this.curCity) {
      promptAction.showToast({ message: '请选择房屋所在城市！' });
    } else {
      const data: CustomParams = {
        city: this.curCity,
        area: this.areaList[this.curAreaIndex],
        price: this.budgetList[this.curBudgetIndex],
      };
      RouterModule.push(RouterMap.CUSTOM_RESULT, data);
    }
  }
}