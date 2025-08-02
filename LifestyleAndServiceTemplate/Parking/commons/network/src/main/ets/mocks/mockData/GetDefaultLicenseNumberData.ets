import { AccountUtil } from 'common';
import { BaseResponse } from '../../types/BaseResponse';
import { GetDefaultLicenseNumberResp } from '../../types/responseTypes/GetDefaultLicenseNumberResp';

export const getDefaultLicenseNumberMock: BaseResponse<GetDefaultLicenseNumberResp> = {
  code: 0,
  data: {
    id: AccountUtil.getId(),
    default: '苏A654321',
  },
};