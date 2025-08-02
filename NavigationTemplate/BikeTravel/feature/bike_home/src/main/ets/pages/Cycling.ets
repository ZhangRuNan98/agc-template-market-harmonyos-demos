import { BikeConstants, BikeState, commonToast } from 'common';
import { geoLocationManager } from '@kit.LocationKit';
import { AsyncCallback } from '@kit.BasicServicesKit';
import { map, mapCommon, MapComponent } from '@kit.MapKit';
import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';
import { CycleRecordData, CycleRecordDatas } from 'bike_mine';

@ComponentV2
export struct Cycling {
  @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack()
  @Local bikeState: BikeState = AppStorageV2.connect(BikeState, () => new BikeState())!;
  @Local myLocation_WGS84?: geoLocationManager.Location
  @Local myLocation_GCJ02?: mapCommon.LatLng
  @Local bikePosition: Array<mapCommon.LatLng> = []
  @Local isReady: boolean = false
  @Local duration: string = '00:01'
  @Local cost: number = 0
  @Local cycleRecordDatas: CycleRecordDatas = AppStorageV2.connect(CycleRecordDatas, 'cycleRecordDatas', () => new CycleRecordDatas())!
  private mapOption?: mapCommon.MapOptions
  private callback?: AsyncCallback<map.MapComponentController>;
  private mapController?: map.MapComponentController;

  aboutToAppear(): void {
    commonToast.show({ type: 'loading' })
    this.setMap().then(() => {
      commonToast.hideAll()
    })
  }

  mockBikePosition(): void {
    if (this.myLocation_GCJ02) {
      for (let i = 0; i < 5; i++) {
        let longitudeRand = (Math.random() - 0.5) * 0.005
        let latitudeRand = (Math.random() - 0.5) * 0.005
        let longitude: number = this.myLocation_GCJ02.longitude + longitudeRand
        let latitude: number = this.myLocation_GCJ02.latitude + latitudeRand
        this.bikePosition.push({ longitude, latitude })
      }
    }
  }

  async setMap() {
    this.myLocation_WGS84 = await geoLocationManager.getCurrentLocation()
    this.myLocation_GCJ02 = map.convertCoordinateSync(
      mapCommon.CoordinateType.WGS84,
      mapCommon.CoordinateType.GCJ02,
      this.myLocation_WGS84
    );
    this.mapOption = {
      position: {
        target: this.myLocation_GCJ02,
        zoom: BikeConstants.ZOOM
      },
      mapType: mapCommon.MapType.STANDARD,
      compassControlsEnabled: false,
      zoomControlsEnabled: false
    }

    this.mockBikePosition()

    this.callback = async (err, mapController) => {
      if (!err) {
        this.mapController = mapController
        this.mapController.setMyLocationEnabled(true);
        this.mapController.setMyLocation(this.myLocation_WGS84);
        this.mapController.setMyLocationControlsEnabled(false);
        for (let i = 0; i < this.bikePosition.length; ++i) {
          let bikeMarkerOptions: mapCommon.MarkerOptions = {
            position: this.bikePosition[i],
            icon: $r('app.media.ic_bike'),
            anchorU: 0.5,
            anchorV: 1,
            draggable: false
          }
          await this.mapController.addMarker(bikeMarkerOptions);
        }

        let noParkAnnotationOptions: mapCommon.PointAnnotationParams = {
          // 定义点注释图标锚点
          position: this.myLocation_GCJ02!,
          // 定义点注释名称与地图POI名称相同时，是否支持去重
          repeatable: true,
          // 定义点注释的碰撞规则
          collisionRule: mapCommon.CollisionRule.NAME,
          // 定义点注释的标题，数组长度最小为1，最大为3
          titles: [
            {
              // 定义标题内容
              content: '此位置非还车点不可还车',
              // 定义标题字体颜色
              color: 0xFF000000,
              // 定义标题字体大小
              fontSize: 15,
              // 定义标题字体样式
              fontStyle: mapCommon.FontStyle.MEDIUM,
            }
          ],
          // 定义点注释的图标，图标存放在resources/rawfile
          icon: '',
          // 定义点注释是否展示图标
          showIcon: true,
          // 定义点注释的锚点在水平方向上的位置
          anchorU: 0.5,
          // 定义点注释的锚点在垂直方向上的位置
          anchorV: 1,
          // 定义点注释的显示属性，为true时，在被碰撞后仍能显示
          forceVisible: false,
          // 定义碰撞优先级，数值越大，优先级越低
          priority: 3,
          // 定义点注释展示的最小层级
          minZoom: 2,
          // 定义点注释展示的最大层级
          maxZoom: 20,
          // 定义点注释是否可见
          visible: true,
          // 定义点注释叠加层级属性
          zIndex: 10
        }
        await this.mapController.addPointAnnotation(noParkAnnotationOptions);

        let parkAnnotationOptions: mapCommon.PointAnnotationParams = {
          // 定义点注释图标锚点
          position: this.bikePosition[0],
          // 定义点注释名称与地图POI名称相同时，是否支持去重
          repeatable: true,
          // 定义点注释的碰撞规则
          collisionRule: mapCommon.CollisionRule.NAME,
          // 定义点注释的标题，数组长度最小为1，最大为3
          titles: [
            {
              // 定义标题内容
              content: '可在此位置还车',
              // 定义标题字体颜色
              color: 0xFF000000,
              // 定义标题字体大小
              fontSize: 15,
              // 定义标题字体样式
              fontStyle: mapCommon.FontStyle.MEDIUM,
            }
          ],
          // 定义点注释的图标，图标存放在resources/rawfile
          icon: '',
          // 定义点注释是否展示图标
          showIcon: true,
          // 定义点注释的锚点在水平方向上的位置
          anchorU: 0.5,
          // 定义点注释的锚点在垂直方向上的位置
          anchorV: 1,
          // 定义点注释的显示属性，为true时，在被碰撞后仍能显示
          forceVisible: false,
          // 定义碰撞优先级，数值越大，优先级越低
          priority: 3,
          // 定义点注释展示的最小层级
          minZoom: 2,
          // 定义点注释展示的最大层级
          maxZoom: 20,
          // 定义点注释是否可见
          visible: true,
          // 定义点注释叠加层级属性
          zIndex: 10
        }
        await this.mapController.addPointAnnotation(parkAnnotationOptions);

      }
    }
    this.isReady = true
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom }) {
        if (this.isReady) {
          MapComponent({
            mapOptions: this.mapOption,
            mapCallback: this.callback
          })
            .width('100%')
            .height('100%')
        }

        Column() {
          Image($r('app.media.location'))
            .height(40)
            .width(40)
            .onClick(async () => {
              this.myLocation_WGS84 = await geoLocationManager.getCurrentLocation()
              this.mapController?.setMyLocation(this.myLocation_WGS84);
              this.myLocation_GCJ02 = map.convertCoordinateSync(
                mapCommon.CoordinateType.WGS84,
                mapCommon.CoordinateType.GCJ02,
                this.myLocation_WGS84
              );
              let cameraPosition: mapCommon.CameraPosition = {
                target: this.myLocation_GCJ02,
                zoom: BikeConstants.ZOOM,
                tilt: 0,
                bearing: 0
              };
              let cameraUpdate = map.newCameraPosition(cameraPosition);
              // 以动画方式移动地图相机
              this.mapController?.animateCamera(cameraUpdate, 10);
            })
            .margin({ left: 16, bottom: 12 })

          Column({ space: 8 }) {
            Row({ space: 49 }) {
              Text() {
                Span('骑行时长')
                  .fontSize(12)
                  .fontColor($r('app.color.tab_font_color'))
                Span(this.duration)
                  .fontSize(16)
                  .fontColor('#e6000000')
                  .fontWeight('bold')
              }

              Column({ space: 7 }) {
                Text() {
                  Span('骑行费用')
                    .fontSize(12)
                    .fontColor($r('app.color.tab_font_color'))
                  Span(this.cost.toString())
                    .fontSize(16)
                    .fontWeight('bold')
                    .fontColor('#e6000000')
                  Span('元')
                    .fontSize(12)
                    .fontColor($r('app.color.tab_font_color'))
                }

                Text() {
                  Span('遇故障')
                    .fontColor($r('app.color.tab_font_color'))
                  Span('1分钟内')
                    .fontColor($r('app.color.orange'))
                  Span('免费')
                    .fontColor($r('app.color.tab_font_color'))
                }
                .fontSize(12)
              }
            }
            .padding({ top: 28 })
            .alignItems(VerticalAlign.Top)

            Button('还车')
              .backgroundColor($r('app.color.orange'))
              .fontColor($r('app.color.pure_white'))
              .fontSize(16)
              .fontWeight('medium')
              .width('100%')
              .onClick(() => {
                this.bikeState.unlocked = false
                this.pageInfos.pop()
                let cycleRecordData: CycleRecordData = new CycleRecordData()
                cycleRecordData.bike = this.bikeState.bikeId;
                this.cycleRecordDatas.data.push(cycleRecordData)
              })
          }
          .padding({ left: 16, right: 16 })
          .backgroundColor($r('app.color.pure_white'))
          .borderRadius({ topLeft: 16, topRight: 16 })
        }
        .alignItems(HorizontalAlign.Start)

      }
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .title('骑行中')
  }
}