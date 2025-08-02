import { map, mapCommon, MapComponent } from '@kit.MapKit';
import { AsyncCallback } from '@kit.BasicServicesKit';
import { BikeConstants, commonToast, MapUtils, RouterPageEnum } from 'common';
import { CycleRecordData, getGeocode, CycleRecordDatas } from '../mockData/CycleRecordData';
import { CycleRecordCard } from '../components/CycleRecordCard';
import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';

@ComponentV2
export struct TripDetail {
  private mapOption?: mapCommon.MapOptions
  private callback?: AsyncCallback<map.MapComponentController>;
  private mapController?: map.MapComponentController;
  private mapPolyline?: map.MapPolyline;
  private startGeocode?: mapCommon.LatLng
  private endGeocode?: mapCommon.LatLng
  private startPointMarker?: map.Marker;
  private endPointMarker?: map.Marker;
  @Local isReady: boolean = false
  @Local tripId: number = 0
  @Local cycleRecord: CycleRecordData = new CycleRecordData();
  @Local cycleRecordDatas: CycleRecordDatas = AppStorageV2.connect(CycleRecordDatas, 'cycleRecordDatas', () => new CycleRecordDatas())!
  @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    commonToast.show({ type: 'loading' })
    this.setMap().then(() => {
      commonToast.hideAll()
    })
  }

  async setMap() {
    this.tripId = Number(this.pageInfos.getParamByName(RouterPageEnum.TRIP_DETAIL_ROUTER))
    this.cycleRecord = this.cycleRecordDatas.data[this.tripId]
    this.startGeocode = await getGeocode(this.cycleRecord.start)
    this.endGeocode = await getGeocode(this.cycleRecord.end)
    this.isReady = true

    this.mapOption = {
      position: {
        target: this.startGeocode,
        zoom: BikeConstants.ZOOM
      },
      mapType: mapCommon.MapType.STANDARD,
      compassControlsEnabled: false,
      zoomControlsEnabled: false
    }

    this.callback = async (err, mapController) => {
      if (!err) {
        this.mapController = mapController;
        if (this.startGeocode && this.endGeocode) {
          const cycleRoute = await MapUtils.cycleRoutes(this.startGeocode, this.endGeocode);
          let startPointMarkerOptions: mapCommon.MarkerOptions = {
            position: this.startGeocode,
            icon: $r('app.media.start_location'),
            anchorU: 0.5,
            anchorV: 1,
            draggable: false
          }
          this.startPointMarker = await this.mapController.addMarker(startPointMarkerOptions);

          let endPointMarkerOptions: mapCommon.MarkerOptions = {
            position: this.endGeocode,
            icon: $r('app.media.end_location'),
            anchorU: 0.5,
            anchorV: 1,
            draggable: false
          }
          this.endPointMarker = await this.mapController.addMarker(endPointMarkerOptions);
          await MapUtils.paintRoute(cycleRoute!, this.mapPolyline, this.mapController);
        }
      }
    }
  }

  build() {
    NavDestination() {
      Column() {
        if (this.isReady) {
          Stack({ alignContent: Alignment.Bottom }) {
            MapComponent({
              mapOptions: this.mapOption,
              mapCallback: this.callback
            })
              .width('100%')
              .height('100%')

            Column() {
              CycleRecordCard({ record: this.cycleRecord, hasLocation: true })
            }
            .width('100%')
            .height(131)
            .borderRadius({ topLeft: 16, topRight: 16 })
            .backgroundColor($r('app.color.pure_white'))
            .padding({ top: 16, left: 16, right: 16 })
          }
        }
      }
      .padding({ top: 8 })
    }
    .title('行程详情')
  }
}