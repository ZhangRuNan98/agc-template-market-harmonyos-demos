import { AccountUtil } from 'common';
import { BaseResponse } from '../../types/BaseResponse';
import { GetDefaultLicenseNumberResp } from '../../types/responseTypes/GetDefaultLicenseNumberResp';

export const setDefaultLicenseNumberMock: BaseResponse<GetDefaultLicenseNumberResp> = {
  code: 0,
  data: {
    id: AccountUtil.getId(),
    default: '',
  },
};