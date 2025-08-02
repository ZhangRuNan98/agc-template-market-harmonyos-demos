import { deviceInfo } from '@kit.BasicServicesKit';
import { CheckInActivity, CheckInRecord, CourseInfo, OrderInfo, StoreConfig, UserInfo } from 'commonlib';
import { CheckInActivityDB } from '../clouddb/CheckInActivityDB';
import { CourseInfoDB } from '../clouddb/CourseInfoDB';
import request from '../cloudfunc/CloudHttpModel';
import { CloudFuncMap, RequestUrl } from '../constants/NetworkEnums';
import { httpsMock } from '../mocks/HttpApisMock';
import {
  CheckInTaskOrderReq,
  CourseOrderReq,
  GetCheckInActivityReq,
  GetCourseDetailReq,
  GetOrderListReq,
  GetCourseListReq,
  GetUserCheckInRecordListReq,
  GetCourseListOrderedReq,
  GetOrderDetailReq,
} from '../types/RequestTypes';
import {
  BaseResp,
  BaseResponse,
  GetCheckInActivityListRsp,
  GetCourseListResp,
  GetOrderListResp,
  GetUserCheckInRecordListRsp,
} from '../types/ResponseTypes';

@ObservedV2
class HttpApi {
  private _openMock: boolean;

  constructor(openMock: boolean = false) {
    let productModelInfo: string = deviceInfo.productModel;
    this._openMock = productModelInfo ? openMock : true;
  }

  public bindPhone(authCode: string, createMock: boolean = false): Promise<BaseResp<UserInfo>> {
    return request.call({
      url: RequestUrl.BIND_PHONE,
      cloudFuncName: CloudFuncMap.ACCOUNT,
      data: {
        trigger: RequestUrl.BIND_PHONE,
        authCode,
        createMock,
      },
    });
  }

  public unBindPhone(): Promise<BaseResponse> {
    return request.call({
      url: RequestUrl.UNBIND_PHONE,
      cloudFuncName: CloudFuncMap.ACCOUNT,
      data: {
        trigger: RequestUrl.UNBIND_PHONE,
      },
    });
  }

  public getUserInfo(): Promise<BaseResp<UserInfo>> {
    return request.call({
      url: RequestUrl.USER_GET_INFO,
      cloudFuncName: CloudFuncMap.ACCOUNT,
      data: {
        trigger: RequestUrl.USER_GET_INFO,
      },
    });
  }

  public updateUserInfo(data: UserInfo): Promise<BaseResp<UserInfo>> {
    return request.call({
      url: RequestUrl.USER_UPDATE_INFO,
      cloudFuncName: CloudFuncMap.ACCOUNT,
      data: {
        trigger: RequestUrl.USER_UPDATE_INFO,
        avatar: data.avatar,
        nickname: data.nickname,
        wechat: data.wechat,
        birthday: data.birthday,
      },
    });
  }

  public createCourseOrder(data: CourseOrderReq): Promise<BaseResp<OrderInfo>> {
    return request.call({
      url: RequestUrl.CREATE_COURSE_ORDER,
      cloudFuncName: CloudFuncMap.ORDER,
      data: {
        trigger: RequestUrl.CREATE_COURSE_ORDER,
        courseId: data.courseId,
        paymentMethod: data.paymentMethod,
        student: data.student,
        phone: data.phone,
        price: data.price,
        remark: data.remark,
      },
    });
  }

  public cancelCourseOrder(data: GetOrderDetailReq): Promise<BaseResponse> {
    return request.call({
      url: RequestUrl.CANCEL_COURSE_ORDER,
      cloudFuncName: CloudFuncMap.ORDER,
      data: {
        trigger: RequestUrl.CANCEL_COURSE_ORDER,
        orderNo: data.orderNo,
      },
    });
  }

  public requestRefundCourseOrder(data: GetOrderDetailReq): Promise<BaseResponse> {
    return request.call({
      url: RequestUrl.REQUEST_REFUND_COURSE_ORDER,
      cloudFuncName: CloudFuncMap.ORDER,
      data: {
        trigger: RequestUrl.REQUEST_REFUND_COURSE_ORDER,
        orderNo: data.orderNo,
      },
    });
  }

  public cancelRefundCourseOrder(data: GetOrderDetailReq): Promise<BaseResponse> {
    return request.call({
      url: RequestUrl.CANCEL_REFUND_COURSE_ORDER,
      cloudFuncName: CloudFuncMap.ORDER,
      data: {
        trigger: RequestUrl.CANCEL_REFUND_COURSE_ORDER,
        orderNo: data.orderNo,
      },
    });
  }

  public deleteCourseOrder(data: GetOrderDetailReq): Promise<BaseResponse> {
    return request.call({
      url: RequestUrl.DELETE_COURSE_ORDER,
      cloudFuncName: CloudFuncMap.ORDER,
      data: {
        trigger: RequestUrl.DELETE_COURSE_ORDER,
        orderNo: data.orderNo,
      },
    });
  }

  public getOrderList(data: GetOrderListReq): Promise<BaseResp<GetOrderListResp>> {
    return request.call({
      url: RequestUrl.GET_ORDER_LIST,
      cloudFuncName: CloudFuncMap.ORDER,
      data: {
        trigger: RequestUrl.GET_ORDER_LIST,
        orderStatus: data.orderStatus,
      },
    });
  }

  public getOrderDetail(data: GetOrderDetailReq): Promise<BaseResp<OrderInfo>> {
    return request.call({
      url: RequestUrl.GET_ORDER_DETAIL,
      cloudFuncName: CloudFuncMap.ORDER,
      data: {
        trigger: RequestUrl.GET_ORDER_DETAIL,
        orderNo: data.orderNo,
      },
    });
  }

  public getStoreConfig(): Promise<BaseResp<StoreConfig>> {
    if (this._openMock) {
      return httpsMock.getStoreConfig();
    }
    return CourseInfoDB.getStoreConfig();
  }

  public getCourseList(data?: GetCourseListReq): Promise<BaseResp<GetCourseListResp>> {
    if (this._openMock) {
      return httpsMock.getCourseList(data);
    }
    return CourseInfoDB.getCourseList(data);
  }

  public getCourseDetail(data: GetCourseDetailReq): Promise<BaseResp<CourseInfo>> {
    if (this._openMock) {
      return httpsMock.getCourseDetail(data);
    }
    return CourseInfoDB.getCourseInfoDetail(data) as Promise<BaseResp<CourseInfo>>;
  }

  public getCourseListOrdered(data: GetCourseListOrderedReq): Promise<BaseResp<GetCourseListResp>> {
    if (this._openMock) {
      return httpsMock.getCourseListOrdered(data);
    }
    return CourseInfoDB.getCourseListOrdered(data);
  }

  public getCheckInActivityList(): Promise<BaseResp<GetCheckInActivityListRsp>> {
    if (this._openMock) {
      return httpsMock.getCheckInActivityList();
    }
    return CheckInActivityDB.getCheckInActivityList();
  }

  public getCheckInActivityDetail(data: GetCheckInActivityReq): Promise<BaseResp<CheckInActivity>> {
    if (this._openMock) {
      return httpsMock.getCheckInActivityDetail(data);
    }
    return CheckInActivityDB.getCheckInActivityDetail(data) as Promise<BaseResp<CheckInActivity>>;
  }

  public createCheckInActivityOrder(data: CheckInTaskOrderReq): Promise<BaseResp<number>> {
    if (this._openMock) {
      return httpsMock.createCheckInActivityOrder(data);
    }
    return CheckInActivityDB.createCheckInActivityOrder(data);
  }

  public cancelCheckInActivityOrder(data: CheckInTaskOrderReq): Promise<BaseResponse> {
    if (this._openMock) {
      return httpsMock.cancelCheckInActivityOrder(data);
    }
    return CheckInActivityDB.cancelCheckInActivityOrder(data);
  }

  public getCheckInActivityListOrdered(): Promise<BaseResp<GetCheckInActivityListRsp>> {
    if (this._openMock) {
      return httpsMock.getCheckInActivityListOrdered();
    }
    return CheckInActivityDB.getCheckInActivityListOrdered();
  }

  public commitUserCheckIn(data: CheckInRecord): Promise<BaseResponse> {
    if (this._openMock) {
      return httpsMock.commitUserCheckIn(data);
    }
    return CheckInActivityDB.commitUserCheckIn(data);
  }

  public getUserCheckInRecordList(data: GetUserCheckInRecordListReq): Promise<BaseResp<GetUserCheckInRecordListRsp>> {
    if (this._openMock) {
      return httpsMock.getUserCheckInRecordList(data);
    }
    return CheckInActivityDB.getUserCheckInRecordList(data);
  }
}

const https = new HttpApi();

export { https };
