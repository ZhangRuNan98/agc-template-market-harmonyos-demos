import { mapCommon } from '@kit.MapKit';
import { emitter } from '@kit.BasicServicesKit';
import { AppStorageMap, EmitterConstants } from './src/main/ets/constants/Constants';

export class MapController {
  public static move(center: mapCommon.LatLng) {
    AppStorage.setOrCreate(AppStorageMap.MAP_CENTER, center);
    emitter.emit(EmitterConstants.MOVE_CAMERA, { data: center });
  }
}

export { ParkingMapList } from './src/main/ets/views/ParkingMapList';