import { mapCommon } from '@kit.MapKit';
import { common } from '@kit.AbilityKit';
import { PersistenceV2 } from '@kit.ArkUI';
import { BasicParkInfo, CollectListModel, LocationStatus, LocationUtil, ServiceUtil } from 'module_parking_base';

@ObservedV2
export class SpotsTabVM {
  // 附件停车场
  @Trace nearbyList: BasicParkInfo[] = [];
  // 收藏停车场
  @Trace collectList: CollectListModel =
    PersistenceV2.connect(CollectListModel, 'collectList', () => new CollectListModel())!;
  @Trace refreshing: boolean = false;
  private _limit: number = 60000;
  private _count: number = -1;
  private _timer: number = -1;
  private static _instance: SpotsTabVM;

  public static get instance() {
    if (!SpotsTabVM._instance) {
      SpotsTabVM._instance = new SpotsTabVM();
    }
    return SpotsTabVM._instance;
  }

  /** 获取附近停车场 **/
  public getNearBySpots(callback?: () => void) {
    const ctx = getContext() as common.UIAbilityContext;
    LocationUtil.getGCJ02Location(ctx).then(res => {
      if (res.result === LocationStatus.SUCCESS && res.gcj02LatLng) {
        this._searchParking(res.gcj02LatLng).then(callback);
      }
    });
  }

  /** 刷新获取附近停车场 **/
  public refreshNewNearby() {
    if (this._timer > 0) {
      let timerTemp = setTimeout(() => {
        this.refreshing = false;
        clearTimeout(timerTemp);
      }, 1000);
      return;
    }
    this.getNearBySpots(() => {
      this.refreshing = false;
      this._count = this._limit;
      this._timer = setInterval(() => {
        this._count -= 1000;
        if (this._count === 0) {
          clearInterval(this._timer);
          this._timer = -1;
        }
      }, 1000);
    });
  }

  /** 搜索附近停车场 **/
  private async _searchParking(center: mapCommon.LatLng) {
    const newSpots = await ServiceUtil.searchParking(center);
    this.nearbyList = newSpots;
  }
}