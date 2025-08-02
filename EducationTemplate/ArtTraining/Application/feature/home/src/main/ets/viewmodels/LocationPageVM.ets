import { RouterMap, RouterModule, StoreInfo } from 'commonlib';
import { MapUtil } from 'module_store_map';

@ObservedV2
export class LocationVM {
  @Trace storeInfo: StoreInfo | null = null;
  @Trace isLoading: boolean = false;
  private static _instance: LocationVM;

  public static get instance() {
    if (!LocationVM._instance) {
      LocationVM._instance = new LocationVM();
    }
    return LocationVM._instance;
  }

  public initStoreInfo() {
    const param = RouterModule.getNavParam<StoreInfo>({
      url: RouterMap.HOME_LOCATION,
    });
    if (param) {
      this.storeInfo = param;
    }
  }

  public jumpToGuide() {
    if (this.storeInfo) {
      MapUtil.handleClickGuide({
        latitude: this.storeInfo.latitude,
        longitude: this.storeInfo.longitude,
      });
    }
  }
}