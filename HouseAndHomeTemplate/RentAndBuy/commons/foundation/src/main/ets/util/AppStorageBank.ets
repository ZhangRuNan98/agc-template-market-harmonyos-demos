import { UserInfo } from '../model/UserInfo';
import { AppStorageV2 } from '@kit.ArkUI';
import { CityList, CurrentAddressInfo } from '../model/Index';

export class AppStorageBank {
  private static _userInfo: UserInfo = AppStorageV2.connect(UserInfo, 'UserInfo', () => new UserInfo())!;
  private static _cityList: CityList = AppStorageV2.connect(CityList, 'CityList', () => new CityList())!;
  private static _currentAddressInfo: CurrentAddressInfo =
    AppStorageV2.connect(CurrentAddressInfo, 'CurrentAddressInfo', () => new CurrentAddressInfo())!;

  static getUserInfo() {
    return AppStorageBank._userInfo;
  }

  static getUserId() {
    return AppStorageBank._userInfo.uid;
  }

  static setAvatar(avatar: ResourceStr) {
    AppStorageBank._userInfo.avatar = avatar;
  }

  static setUserInfo(nickName: string, avatar: ResourceStr, phone: string, uid?: string) {
    AppStorageBank._userInfo.uid = uid ?? '';
    AppStorageBank._userInfo.nickName = nickName;
    AppStorageBank._userInfo.avatar = avatar;
    AppStorageBank._userInfo.phone = phone;
  }

  static getCityList() {
    return AppStorageBank._cityList;
  }

  static setCityList(city: string) {
    AppStorageBank._cityList.cityList.push(city);
  }

  static getCurrentCity() {
    return AppStorageBank._currentAddressInfo.city;
  }

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