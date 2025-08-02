import { map, mapCommon } from '@kit.MapKit';
import { AsyncCallback, emitter } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { BasicParkInfo, LocationStatus, LocationUtil, ServiceUtil } from 'module_parking_base';
import { AppStorageMap, EmitterConstants } from '../constants/Constants';

@ObservedV2
export class MapListVM {
  // 地图中心
  @Trace center: mapCommon.LatLng = { latitude: 39.9, longitude: 116.4 };
  // 查询地点
  @Trace query: string = '';
  // 附近停车场
  @Trace spots: BasicParkInfo[] = [];
  // 排序停车场
  @Trace sortedSpots: BasicParkInfo[] = [];
  // 选中停车场
  @Trace selectedSpot: BasicParkInfo | undefined = undefined;
  // 排序方式(0-距离近;1-空位多)
  @Trace sort: number = 0;
  // 当前列表索引
  @Trace curIndex: number = 0;
  // 标记点
  marks: map.Marker[] = [];
  // 选中标记点
  selectedMark: map.Marker | undefined = undefined;
  controller: Scroller = new Scroller();

  @Monitor('spots', 'sort')
  private _sortedSpotsChange() {
    const newSortedSpots = [...this.spots];
    newSortedSpots.sort((a, b) => this.sort ? b.leftSpots - a.leftSpots : a.distance - b.distance);
    this.sortedSpots = newSortedSpots;
  }

  // 地图初始回调
  public mapInitCallback: AsyncCallback<map.MapComponentController> = async (err, mapController) => {
    if (!err) {
      this.mapController = mapController;
      emitter.on(EmitterConstants.MOVE_CAMERA, this._emitterCallback);
      this.mapController.setMyLocationEnabled(true);
      this.mapController.setMyLocationControlsEnabled(true);
      this.mapEventManager = this.mapController.getEventManager();
      this.mapEventManager.on('markerClick', this._markClickCallback);
      this.mapEventManager.on('cameraChange', this._cameraChangeCallback);
      this.init();
    }
  };
  // 标记点击回调
  private _markClickCallback = (marker: map.Marker) => {
    const index = this.marks.findIndex(item => item === marker);
    if (index === -1) {
      return;
    }
    if (this.selectedMark && this.selectedSpot) {
      this.selectedMark.setIcon(this._getIcon(this.selectedSpot.leftSpots));
    }
    this.selectedMark = this.marks[index];
    this.selectedSpot = this.spots[index];
    this.selectedMark.setIcon(this._getIcon(this.selectedSpot.leftSpots, true));
    const sortedIndex = this.sortedSpots.findIndex(item => item.siteId === this.selectedSpot?.siteId);
    if (sortedIndex !== -1) {
      this.controller.scrollToIndex(sortedIndex, true);
    }
  };
  // 接收指令移动地图回调
  private _emitterCallback = () => {
    const location: mapCommon.LatLng | undefined = AppStorage.get(AppStorageMap.MAP_CENTER);
    AppStorage.set(AppStorageMap.MAP_CENTER, undefined);
    if (location) {
      this.moveCamera(location);
    }
  };
  // 相机移动回调
  private _cameraChangeCallback = (position: mapCommon.LatLng) => {
    this.center = position;
    this._searchParking();
  };
  mapOptions: mapCommon.MapOptions = { position: { target: this.center, zoom: 16 } };
  mapController?: map.MapComponentController;
  mapEventManager?: map.MapEventManager;
  private static _instance: MapListVM;

  public static get instance() {
    if (!MapListVM._instance) {
      MapListVM._instance = new MapListVM();
    }
    return MapListVM._instance;
  }

  /** 初始化-移动地图中心 **/
  public async init() {
    const location: mapCommon.LatLng | undefined = AppStorage.get(AppStorageMap.MAP_CENTER);
    AppStorage.set(AppStorageMap.MAP_CENTER, undefined);
    if (location) {
      this.moveCamera(location);
      return;
    }
    const ctx = getContext() as common.UIAbilityContext;
    const res = await LocationUtil.getCachedGCJ02Location(ctx);
    if (res.result === LocationStatus.SUCCESS) {
      this.moveCamera(res.gcj02LatLng!);
    }
  }

  /** 移动相机中心 **/
  public moveCamera(center: mapCommon.LatLng) {
    this.mapController?.moveCamera(map.newCameraPosition({ target: center, zoom: 16 }));
  }

  /** 搜索附近停车场 **/
  private async _searchParking() {
    this.spots.length = 0;
    this.selectedSpot = undefined;
    const newSpots = await ServiceUtil.searchParking(this.center);
    this.spots = newSpots;
    this.controller.scrollToIndex(0);
    this._setMarks();
  }

  /** 标记停车场 **/
  private async _setMarks() {
    if (!this.mapController) {
      return;
    }
    this.mapController.clear();
    this.marks.length = 0;
    for (let i = 0; i < this.spots.length; i++) {
      const item = this.spots[i];
      let markerOptions: mapCommon.MarkerOptions = {
        position: item.location,
        rotation: 0,
        icon: this._getIcon(item.leftSpots),
        clickable: true,
        visible: true,
        draggable: false,
        zIndex: 0,
      };
      const marker = await this.mapController!.addMarker(markerOptions);
      this.marks.push(marker);
    }
  }

  /** 获取停车车库图标 **/
  private _getIcon(left: number, max: boolean = false): ResourceStr {
    if (left > 20) {
      return max ? $r('app.media.ic_park_blue_max') : $r('app.media.ic_park_blue_min');
    } else if (left > 10) {
      return max ? $r('app.media.ic_park_yellow_max') : $r('app.media.ic_park_yellow_min');
    } else {
      return max ? $r('app.media.ic_park_red_max') : $r('app.media.ic_park_red_min');
    }
  }
}