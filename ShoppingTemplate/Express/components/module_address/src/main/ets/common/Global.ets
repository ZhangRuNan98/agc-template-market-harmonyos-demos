/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { AppStorageV2 } from '@kit.ArkUI';
import { AddrMgtApi } from '../http/Api';
import { IAddrInfo } from '../http/Type';

@ObservedV2
export class AddressInfo {
  @Trace id: number = 0
  @Trace name: string = ''
  @Trace cellphone: string = ''
  @Trace province: string = ''
  @Trace city: string = ''
  @Trace area: string = ''
  @Trace detailAddress: string = ''
  @Trace isDefault: boolean = true
}

export class CurrentAppStorage {
  static addressInfo: AddressInfo = AppStorageV2.connect(AddressInfo, () => new AddressInfo())!;

  static reset() {
    CurrentAppStorage.addressInfo = new AddressInfo()
  }
}

@ObservedV2
export class AddrList {
  @Trace list: IAddrInfo[] = AddrMgtApi.ADDRESS_LIST
}

/**
 * AppStorageV2应用全局缓存库
 */
export class AppStorageBank {
  static addrList: AddrList = AppStorageV2.connect(AddrList, () => new AddrList())!;

  static updateAddrList(list: IAddrInfo[]) {
    AppStorageBank.addrList.list = list;
  }
}


