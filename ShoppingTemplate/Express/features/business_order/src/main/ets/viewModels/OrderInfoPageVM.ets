import { map, mapCommon, navi } from '@kit.MapKit';
import { AsyncCallback } from '@kit.BasicServicesKit';
import { INodeItem } from '../components/CommonTimeLine';
import { nodeListData } from '../constants';
import { ExpressStatus, getOrderInfo, IOrderInfo, RouterModule } from 'lib_foundation';
import { RouterMap } from 'module_base';

const DEFAULT_LATITUDE = 31.97;
const DEFAULT_LONGITUDE = 118.75;

@ObservedV2
export class OrderInfoPageVM {
  private static _instance: OrderInfoPageVM;
  @Trace public mapOptions?: mapCommon.MapOptions
  @Trace public mapController?: map.MapComponentController;
  @Trace public mapEventManager?: map.MapEventManager;
  @Trace public callback?: AsyncCallback<map.MapComponentController>
  @Trace public orderInfo: IOrderInfo | undefined
  @Trace public nodeList: INodeItem[] = []
  @Trace public offsetX: number = 0;
  @Trace public offsetY: number = 240;
  @Trace public positionX: number = 0;
  @Trace public positionY: number = 0;

  public static get instance() {
    if (!OrderInfoPageVM._instance) {
      OrderInfoPageVM._instance = new OrderInfoPageVM();
    }
    return OrderInfoPageVM._instance;
  }

  public init() {
    const param = RouterModule.getNavParam<number>({
      url: RouterMap.ORDER_INFO_PAGE,
    });
    if (param) {
      this.getOrderInfo(param)
    }
  }

  clear() {
    this.orderInfo = undefined
  }

  public async getOrderInfo(id: number) {
    const res = await getOrderInfo({ id })
    this.orderInfo = res
    this.nodeList = nodeListData.slice(0, this.orderInfo.logisticsInfo.length)
    for (let i = 0; i < this.nodeList.length; i++) {
      this.nodeList[i].time = this.orderInfo.logisticsInfo[i].time
      this.nodeList[i].description = this.orderInfo.logisticsInfo[i].content
    }
    this.nodeList.reverse()
    this.testDrivingRoutes()
    this.addMarker()
  }

  public initMap() {
    this.mapOptions = {
      position: {
        target: {
          latitude: DEFAULT_LATITUDE,
          longitude: DEFAULT_LONGITUDE
        },
        zoom: 10
      },
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
    };

    this.callback = async (err, mapController) => {
      if (!err) {
        // 获取地图的控制器类，用来操作地图
        this.mapController = mapController;
        this.mapEventManager = this.mapController.getEventManager();
        let callback = () => {
          console.info('on-mapLoad');
        }
        this.mapEventManager.on('mapLoad', callback);
      }
    };
  }

  async testDrivingRoutes() {
    if (!this.orderInfo) {
      return
    }
    let params: navi.DrivingRouteParams = {
      // 起点的经纬度
      origins: [this.orderInfo.origins],
      // 终点的经纬度
      destination: this.orderInfo.destination,
      // 路径的途经点
      waypoints: this.orderInfo.waypoints,
      language: 'zh_CN'
    };
    const result = await navi.getDrivingRoutes(params);
    this.mapController?.addPolyline({
      points: result.routes[0].overviewPolyline,
      width: 10,
      color: 0xFFFF2737
    })
    console.info('Succeeded in getting driving routes.');
  }

  async addMarker() {
    const marker1 = await this.mapController?.addMarker({
      position: this.orderInfo?.origins,
      icon: $r('app.media.ic_send_map'),
    })
    if (!marker1) {
      return
    }
    // 设置信息窗的标题
    marker1.setTitle('始发地');
    // 设置信息窗的子标题
    marker1.setSnippet(this.orderInfo?.sendPosition);
    // 设置标记可点击
    marker1.setClickable(true);
    // 设置信息窗的锚点位置
    marker1.setInfoWindowAnchor(0, 5);
    // 设置信息窗可见
    marker1.setInfoWindowVisible(true);

    const marker2 = await this.mapController?.addMarker({
      position: this.orderInfo?.destination,
      icon: $r('app.media.ic_get_map'),
    })
    if (!marker2 || this.orderInfo?.expressStatus !== ExpressStatus.SIGNED_FOR) {
      return
    }
    // 设置信息窗的标题
    marker2.setTitle('已签收');
    // 设置信息窗的子标题
    marker2.setSnippet(this.orderInfo?.getPosition);
    // 设置标记可点击
    marker2.setClickable(true);
    // 设置信息窗的锚点位置
    marker2.setInfoWindowAnchor(0, 5);
    // 设置信息窗可见
    marker2.setInfoWindowVisible(true);
  }
}
