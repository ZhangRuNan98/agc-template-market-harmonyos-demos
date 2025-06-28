import { PersistenceV2 } from '@kit.ArkUI';
import { AppStorageMap } from 'commonlib';
import { RouterModule, CurrentCity } from 'commonlib';
import { emitter } from '@kit.BasicServicesKit';

@ObservedV2
export class AllCityPageVM {
  // 当前选定的城市信息
  @Trace currentCity: CurrentCity =
    PersistenceV2.connect(CurrentCity, AppStorageMap.CURRENT_CITY, () => new CurrentCity())!;
  private static _instance: AllCityPageVM;

  public static get instance() {
    if (!AllCityPageVM._instance) {
      AllCityPageVM._instance = new AllCityPageVM();
    }
    return AllCityPageVM._instance;
  }


  public handleCitySelect(city: string) {
    this.currentCity.cityName = city;
    this.currentCity.isSelect = true;
    emitter.emit('closeCitySelect');
    RouterModule.pop();
  }
}
