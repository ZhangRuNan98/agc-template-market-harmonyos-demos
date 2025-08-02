import { AccountUtil } from 'common';
import { BaseResponse } from '../../types/BaseResponse';
import { GetUserInfoResp } from '../../types/responseTypes/GetUserInfoResp';

export const getUserInfoMock: BaseResponse<GetUserInfoResp> = {
  code: 0,
  data: {
    id:AccountUtil.getId(),
    avatar: '',
    nickname: '',
    cellphone: '',
  },
};