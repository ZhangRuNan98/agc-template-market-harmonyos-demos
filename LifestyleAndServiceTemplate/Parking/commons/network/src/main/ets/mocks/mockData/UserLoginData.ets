import { AccountUtil } from 'common';
import { BaseResponse } from '../../types/BaseResponse';
import { UserLoginResp } from '../../types/responseTypes/UserLoginResp';

export const userLoginMock: BaseResponse<UserLoginResp> = {
  code: 0,
  data: {
    loginToken: 'xxx',
    id: AccountUtil.getId(),
    avatar: '',
    nickname: '',
    cellphone: '',
    bonusPoint: 0,
    coupons: 0,
  },
};