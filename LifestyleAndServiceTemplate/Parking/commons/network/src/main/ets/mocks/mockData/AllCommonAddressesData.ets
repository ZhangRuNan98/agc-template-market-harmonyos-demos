import { AccountUtil } from 'common';
import { BaseResponse } from '../../types/BaseResponse';
import { AllCommonAddressesResp } from '../../types/responseTypes/AllCommonAddressesResp';

export const allCommonAddressesMock: BaseResponse<AllCommonAddressesResp> = {
  code: 0,
  data: {
    id: AccountUtil.getId(),
    addresses: [
      {
        name: '',
        location: { latitude: 39.9, longitude: 116.4 },
        siteId: '',
        addr: '',
        type: 1,
      },
      {
        name: '',
        location: { latitude: 39.9, longitude: 116.4 },
        siteId: '',
        addr: '',
        type: 2,
      },
      {
        name: '',
        location: { latitude: 39.9, longitude: 116.4 },
        siteId: '',
        addr: '',
        type: 3,
      },
    ],
  },
};