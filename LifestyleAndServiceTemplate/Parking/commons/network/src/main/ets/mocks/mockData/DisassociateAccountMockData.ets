import { BaseResponse } from '../../types/BaseResponse';
import { DisassociateAccountResp } from '../../types/responseTypes/DiassociateAccountResp';

export const associateAccountMock: BaseResponse<DisassociateAccountResp> = {
  code: 0,
  data: {
    cellphone: '',
  },
};