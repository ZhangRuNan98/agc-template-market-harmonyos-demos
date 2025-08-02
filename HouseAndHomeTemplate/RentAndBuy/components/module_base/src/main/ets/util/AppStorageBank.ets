import { AppStorageV2 } from '@kit.ArkUI';

export class CurrentAddressInfo {
  city: string = '';
  latitude: number = 0;
  longitude: number = 0;
}

export class CityList {
  cityList: string[] = [];
}

export class AppStorageBank {
  private static _currentAddressInfo: CurrentAddressInfo =
    AppStorageV2.connect(CurrentAddressInfo, 'CurrentAddressInfo', () => new CurrentAddressInfo())!;

  static setCurrentCity(city: string) {
    AppStorageBank._currentAddressInfo.city = city;
  }

  static setCurrentLocation(latitude: number, longitude: number) {
    AppStorageBank._currentAddressInfo.latitude = latitude;
    AppStorageBank._currentAddressInfo.longitude = longitude;
  }

  static getCurrentLocation() {
    return [AppStorageBank._currentAddressInfo.latitude, AppStorageBank._currentAddressInfo.longitude];
  }
}