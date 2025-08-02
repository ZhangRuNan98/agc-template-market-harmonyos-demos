import {
  baseActionSheet,
  BikeConstants,
  BikeState,
  commonToast,
  MoreServicesModel,
  PermissionUtil,
  RouterPageEnum,
  UserInfoStorage
} from 'common';
import { map, mapCommon, MapComponent } from '@kit.MapKit';
import { AsyncCallback, BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { geoLocationManager } from '@kit.LocationKit';
import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';
import { call } from '@kit.TelephonyKit';

@ComponentV2
export struct HomePage {
  @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack()
  @Local myLocation_WGS84?: geoLocationManager.Location
  @Local myLocation_GCJ02?: mapCommon.LatLng
  @Local bikePosition: Array<mapCommon.LatLng> = []
  @Local isReady: boolean = false
  @Local changeSearchValue: string = ''
  @Local submitSearchValue: string = ''
  @Local userInfoStorage: UserInfoStorage = PersistenceV2.connect(UserInfoStorage, 'UserInfoStorage', () => new UserInfoStorage())!
  @Local bikeState: BikeState = AppStorageV2.connect(BikeState, () => new BikeState())!;
  private mapOption?: mapCommon.MapOptions
  private callback?: AsyncCallback<map.MapComponentController>;
  private mapController?: map.MapComponentController;
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  private phoneNumber: string = '123****456';
  private menuList: MoreServicesModel[] = [
    { img: $r('app.media.fault_reporting'), dsc: '故障申报', url: RouterPageEnum.FAULT_REPORTING_ROUTER },
    { img: $r('app.media.phone_customer_service'), dsc: '电话客服', url: 'dialog' },
    { img: $r('app.media.feedback'), dsc: '意见反馈', url: RouterPageEnum.FEEDBACK_ROUTER },
    { img: $r('app.media.user_guide'), dsc: '用户指南', url: RouterPageEnum.USER_GUIDE_ROUTER }
  ];

  aboutToAppear(): void {
    commonToast.show({ type: 'loading' })
    this.setMap().then(() => {
      commonToast.hideAll()
    })
  }

  mockBikePosition(): void {
    if (this.myLocation_GCJ02) {
      for (let i = 0; i < 10; i++) {
        let longitudeRand = (Math.random() - 0.5) * 0.005
        let latitudeRand = (Math.random() - 0.5) * 0.005
        let longitude: number = this.myLocation_GCJ02.longitude + longitudeRand
        let latitude: number = this.myLocation_GCJ02.latitude + latitudeRand
        this.bikePosition.push({ longitude, latitude })
      }
    }
  }

  @Builder
  PhoneSheetBuilder() {
    Column({ space: 12 }) {
      Text(this.phoneNumber)
        .fontSize(18)
        .fontWeight('medium')

      Row({ space: 8 }) {
        Image($r('app.media.phone'))
          .height(24)
          .width(24)

        Text('一键拨号')
          .fontSize(16)
          .fontWeight('medium')
          .fontColor($r('app.color.pure_white'))
      }
      .padding({ top: 10, bottom: 10 })
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .borderRadius(20)
      .backgroundColor($r('app.color.orange'))
      .onClick(() => {
        call.makeCall(this.phoneNumber,
          (err: BusinessError) => {
            if (err) {
              console.error(`makeCall fail, err->${JSON.stringify(err)}`);
            } else {
              console.log(`makeCall success`);
            }
          });
      })

      Row() {
        Text('取消')
          .fontSize(16)
          .fontWeight('medium')
          .fontColor($r('app.color.tab_font_color'))
      }
      .padding({ top: 10, bottom: 10 })
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .borderRadius(20)
      .backgroundColor($r('app.color.item_gray'))
      .onClick(() => {
        baseActionSheet.close('PhoneSheetBuilder')
      })
    }
    .width('90%')
    .padding({
      left: 12,
      right: 12,
      bottom: 16,
      top: 16
    })
    .margin({ bottom: 40, left: 16, right: 16 })
    .backgroundColor($r('app.color.pure_white'))
    .borderRadius(16)
  }

  @Builder
  MoreServiceSheetBuilder() {
    Row() {
      ForEach(this.menuList, (item: MoreServicesModel) => {
        Column({ space: 4 }) {
          Image(item.img)
            .width(40)
            .height(40)
          Text(item.dsc)
            .fontSize(10)
            .fontWeight('medium')
            .fontColor($r('app.color.tab_font_color'))
        }
        .onClick(() => {
          if (item.url === 'dialog') {
            // 电话客服 比较特殊，它是直接弹窗，而非拉起一个页面
            baseActionSheet.show({
              id: 'PhoneSheetBuilder',
              title: { title: '联系客服' },
              height: SheetSize.FIT_CONTENT,
              backgroundColor: ('#F1F3F5'),
              customContent: () => {
                this.PhoneSheetBuilder()
              },
            })
          } else {
            baseActionSheet.close('MoreServiceSheetBuilder')
            this.pageInfos.pushPathByName(item.url, null)
          }
        })

      })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .padding({
      left: 29,
      right: 29,
      bottom: 40,
      top: 22
    })
  }

  @Builder
  UnlockSheetBuilder() {
    Column({ space: 16 }) {
      Row({ space: 12 }) {
        LoadingProgress().width(24).height(24)

        Text() {
          Span('开锁中 ')
          Span(this.bikeState.unlockProgress.toString())
          Span('%')
        }
        .fontWeight('medium')
        .fontColor($r('app.color.contentColor'))
        .fontSize(20)
      }

      Text('结束用车请在停车点还车哦～')
        .fontSize(16)
        .fontWeight('medium')
        .fontColor($r('app.color.orange'))
    }
    .alignItems(HorizontalAlign.Center)
    .padding({
      left: 76,
      right: 76,
      bottom: 40,
      top: 20
    })
  }

  async setMap() {
    let userGrant: boolean = await PermissionUtil.checkPermissions(this.context,
      ['ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION']);
    if (!userGrant) {
      // 拉起系统位置权限页面
      this.startLocationSetting()
    } else {
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
        }
      }
    }
    this.isReady = true
  }

  startLocationSetting() {
    this.context.startAbility({
      bundleName: 'com.huawei.hmos.settings',
      abilityName: 'com.huawei.hmos.settings.MainAbility',
      uri: 'location_manager_settings',
      parameters: {
        pushParams: {
          // 应用包名
          bundleName: this.context.abilityInfo.bundleName,
        },
      },
    })
  }

  build() {
    NavDestination() {
      Column() {
        RelativeContainer() {
          Row() {
            Image($r('app.media.mine')).width(24).height(24)
              .onClick(() => {
                this.pageInfos.pushPathByName(RouterPageEnum.MINE_ROUTER, null)
              })
          }
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            left: { anchor: '__container__', align: HorizontalAlign.Start }
          })

          Row() {
            Text('单车出行')
              .fontSize(24)
              .fontWeight('medium')
          }
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
        }
        .padding({ left: 21, right: 21 })
        .width('100%')
        .height(50)

        Stack({ alignContent: Alignment.Top }) {
          if (this.isReady) {
            MapComponent({
              mapOptions: this.mapOption,
              mapCallback: this.callback
            })
              .width('100%')
              .height('100%')
          }

          Column({}) {
            if (!this.userInfoStorage.realName) {
              Row() {
                Row({ space: 8 }) {
                  Image($r('app.media.ic_attention'))
                    .width(24)
                    .height(24)
                    .objectFit(ImageFit.Contain)

                  Text('您还未进行身份认证。')
                    .fontColor($r('app.color.pure_white'))
                    .fontSize(14)
                }

                Image($r('app.media.right_arrow'))
                  .width(16)
                  .height(16)
                  .objectFit(ImageFit.Contain)
              }
              .backgroundColor($r('app.color.orange'))
              .width('100%')
              .height(40)
              .borderRadius(20)
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({
                left: 12,
                right: 12,
                top: 8,
                bottom: 8
              })
              .onClick(() => {
                this.pageInfos.pushPathByName(RouterPageEnum.REAL_NAME_AUTH_ROUTER, null)
              })
            }
          }
          .padding({ left: 16, right: 16, top: 12 })

          Row() {
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

            Row({ space: 8 }) {
              Image(this.bikeState.unlocked ? $r('app.media.cycling') : $r('app.media.scan'))
                .height(24)
                .width(24)
              Text(this.bikeState.unlocked ? '骑行中' : '扫码用车')
                .fontSize(16)
                .fontWeight('medium')
                .fontColor($r('app.color.pure_white'))
            }
            .backgroundColor($r('app.color.orange'))
            .padding({
              left: 12,
              right: 12,
              top: 8,
              bottom: 8
            })
            .borderRadius(20)
            .onClick(() => {
              if (!this.bikeState.unlocked) {
                this.pageInfos.pushPathByName(RouterPageEnum.CUSTOM_SCAN_ROUTER, null,
                  async (res: PopInfo) => {
                    this.bikeState.bikeId = res.result.toString()
                    await baseActionSheet.show({
                      id: 'UnlockSheetBuilder',
                      height: SheetSize.FIT_CONTENT,
                      showClose: false,
                      customContent: () => {
                        this.UnlockSheetBuilder()
                      },
                    })
                    // 模拟开锁过程
                    this.bikeState.unlockProgress = 0

                    let timer = setInterval(() => {
                      if (this.bikeState.unlockProgress > 98) {
                        this.bikeState.unlocked = true
                        baseActionSheet.close('UnlockSheetBuilder')
                        this.pageInfos.pushPathByName(RouterPageEnum.CYCLING_ROUTER, null)
                        clearInterval(timer)
                      }
                      this.bikeState.unlockProgress++
                    }, 10)
                  })
              } else {
                this.pageInfos.pushPathByName(RouterPageEnum.CYCLING_ROUTER, null)
              }
            })

            Image($r('app.media.more'))
              .height(40)
              .width(40)
              .onClick(() => {
                baseActionSheet.show({
                  id: 'MoreServiceSheetBuilder',
                  title: { title: '更多服务' },
                  height: SheetSize.FIT_CONTENT,
                  customContent: () => {
                    this.MoreServiceSheetBuilder()
                  },
                })
              })
          }
          .position({ bottom: 60 })
          .padding({ left: 16, right: 16 })
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .height('100%')
      }
      .height('100%')

    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}