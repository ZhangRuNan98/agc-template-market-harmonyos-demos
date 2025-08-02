import { AccountUtil } from 'common';
import { BaseResponse } from '../../types/BaseResponse';
import { AllLicenseInfoResp } from '../../types/responseTypes/AllLicenseNumbersResp';

export const allLicenseInfoMock: BaseResponse<AllLicenseInfoResp> = {
  code: 0,
  data: {
    id: AccountUtil.getId(),
    licenses: ['京A12345', '苏A654321'],
  },
};