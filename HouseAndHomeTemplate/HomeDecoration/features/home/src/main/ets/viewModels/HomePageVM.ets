import { PersistenceV2 } from '@ohos.arkui.StateManagement';
import { emitter } from '@kit.BasicServicesKit';
import { AppStorageMap, LocationUtil, CommonConstants, Logger, CurrentCity, DataSource } from 'commonlib';
import { queryCaseList, CaseInfo, upDateCity } from 'network';
import { serverItem } from '../types/Index';


const TAG = '[HomePageVM]';

@ObservedV2
export class HomePageVM {
  // 自动定位的信息
  @Trace cityByGPS: string = '';
  // 当前选定的城市信息
  @Trace currentCity: CurrentCity =
    PersistenceV2.connect(CurrentCity, AppStorageMap.CURRENT_CITY, () => new CurrentCity())!;
  @Trace isOpen: boolean = false;
  @Trace serverList: serverItem[] =
    [{ label: '家装案例', icon: $r('app.media.tab_icon1') }, { label: '找设计师', icon: $r('app.media.tab_icon2') },
      { label: '装修报价', icon: $r('app.media.tab_icon3') }];
  @Trace curIndex: number = 0;
  @Trace tabList: string[] = ['热门', '设计师案例'];
  @Trace caseInfoList: DataSource<CaseInfo> = new DataSource<CaseInfo>();
  @Trace hotCaseInfo: DataSource<CaseInfo> = new DataSource<CaseInfo>();
  @Trace hotCity: string[] = [
    '全部',
    '北京',
    '上海',
    '广州',
    '深圳',
    '南京',
    '天津',
    '杭州',
    '武汉',
    '成都',
    '西安',
    '福州',
  ];
  private static _instance: HomePageVM;

  public static get instance() {
    if (!HomePageVM._instance) {
      HomePageVM._instance = new HomePageVM();
    }
    return HomePageVM._instance;
  }

  @Monitor('currentCity.cityName')
  async onCityChange() {
    const res = await upDateCity(this.currentCity.cityName);
    if (res.status === 200) {
      Logger.info('upDate city success');
      emitter.emit('CityChange');
    }
  }


  public async InitCity() {
    const res = await upDateCity(this.currentCity.cityName);
    if (res.status === 200) {
      Logger.info('upDate city success');
    }
  }


  public async getCurrentCityByGPS() {
    this.cityByGPS = await LocationUtil.getCityName() ?? '';
    if (!this.currentCity.isSelect) {
      this.currentCity.cityName = this.cityByGPS;
    }
  }

  public selectCurrentCity(city: string) {
    this.currentCity.cityName = city;
    this.currentCity.isSelect = true;
  }


  public async getCaseList() {
    const res = await queryCaseList({ caseType: '1' });
    if (res.status === 200) {
      this.caseInfoList.pushArrData(res.data);
    }
  }

  public async getHotCaseList() {
    const res = await queryCaseList();
    if (res.status === 200) {
      this.hotCaseInfo.pushArrData(res.data);
    }
  }
}
