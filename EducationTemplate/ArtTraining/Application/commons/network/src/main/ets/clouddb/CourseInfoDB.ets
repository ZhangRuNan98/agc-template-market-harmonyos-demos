import { cloudDatabase } from '@kit.CloudFoundationKit';
import { AccountUtil, CourseInfo, Logger, StoreConfig, StoreInfo } from 'commonlib';
import { GetCourseDetailReq, GetCourseListOrderedReq, GetCourseListReq } from '../types/RequestTypes';
import { BaseResp, GetCourseListResp } from '../types/ResponseTypes';
import { BaseDB } from './BaseDB';
import { CloudCourseInfo } from './models/CloudCourseInfo';
import { CloudUserCourseInfo } from './models/CloudUserCourseInfo';
import { promptAction } from '@kit.ArkUI';

const TAG = '[CourseInfoDB]';

const CLOUD_STORAGE_URL: string =
  'https://agc-storage-drcn.platform.dbankcloud.cn/v0/default-bucket-ta7go/';

const BANNERS: string[] = [
  CLOUD_STORAGE_URL + 'art-training/img_course_cover1.png',
  CLOUD_STORAGE_URL + 'art-training/img_course_cover2.png',
];

const STORE_INFO_IMAGES: string[] = [
  CLOUD_STORAGE_URL + 'art-training/img_log_activity1.png',
  CLOUD_STORAGE_URL + 'art-training/img_store_info.png',
  CLOUD_STORAGE_URL + 'art-training/img_course_cover1.png',
];

class CourseInfoDB extends BaseDB {
  private _uid: string = AccountUtil.getAccountInfo().uid;

  public async getStoreConfig() {
    const condition = new cloudDatabase.DatabaseQuery(CloudCourseInfo);
    let dataList: CloudCourseInfo[] = [];
    try {
      dataList = await this.databaseZone.query(condition);
    } catch (err) {
      Logger.error(TAG, `get course list failed. error:${JSON.stringify(err)}`);
    }
    const respList = this._createListResp(dataList);
    const storeInfo = await this._getStoreInfo();
    const resp: StoreConfig = {
      banners: BANNERS,
      storeInfo,
      courseList: respList.courseList ?? [],
    };
    return this.getFormattedResp<StoreConfig>(resp);
  }

  public async getCourseList(param?: GetCourseListReq): Promise<BaseResp<GetCourseListResp>> {
    const condition = new cloudDatabase.DatabaseQuery(CloudUserCourseInfo);
    if (param?.type) {
      condition.equalTo('type', param.type);
    }
    if (param?.keyword) {
      condition.contains('keyword', param.keyword);
    }
    let dataList: CloudUserCourseInfo[] = [];
    try {
      dataList = await this.databaseZone.query(condition);
    } catch (err) {
      Logger.error(TAG, `get course list failed. error:${JSON.stringify(err)}`);
    }
    const resp = this._createListResp(dataList);
    return this.getFormattedResp<GetCourseListResp>(resp);
  }

  public async getCourseInfoDetail(data: GetCourseDetailReq): Promise<BaseResp<CourseInfo | undefined>> {
    const condition = new cloudDatabase.DatabaseQuery(CloudUserCourseInfo)
      .equalTo('courseId', data.courseId)
      .equalTo('userId', this._uid);
    try {
      const dataList = await this.databaseZone.query(condition);
      if (dataList.length === 1) {
        const courseItem = this._createCourseInfoItem(dataList[0]);
        return this.getFormattedResp<CourseInfo>(courseItem);
      }
    } catch (err) {
      Logger.error(TAG, `get course detail failed. error:${JSON.stringify(err)}`);
    }
    return this.getFormattedResp<undefined>(undefined);
  }

  public async getCourseListOrdered(data: GetCourseListOrderedReq): Promise<BaseResp<GetCourseListResp>> {
    const condition = new cloudDatabase.DatabaseQuery(CloudUserCourseInfo)
      .notEqualTo('orderTime', '')
      .equalTo('userId', this._uid);
    if (typeof data.courseStatus === 'number' && data.courseStatus !== 0) {
      condition.equalTo('status', data.courseStatus);
    }
    let dataList: CloudUserCourseInfo[] = [];
    try {
      dataList = await this.databaseZone.query(condition);
    } catch (err) {
      Logger.error(TAG, `get course list ordered failed. error:${JSON.stringify(err)}`);
    }
    const resp = this._createListResp(dataList);
    return this.getFormattedResp<GetCourseListResp>(resp);
  }

  public  async initList() {
    try {
      const baseCondition = new cloudDatabase.DatabaseQuery(CloudCourseInfo);
      const baseList = await this.databaseZone.query(baseCondition);
      const condition = new cloudDatabase.DatabaseQuery(CloudUserCourseInfo);
      const list = await this.databaseZone.query(condition);
      if (list?.length) {
        return;
      }
      await this._initUserCourseInfoList(baseList);
    } catch (err) {
      promptAction.showToast({ message: '云数据库初始化失败' });
      Logger.error(TAG, `init user course list failed. error:${JSON.stringify(err)}`);
    }
  }

  private _createListResp(list: CloudUserCourseInfo[] | CloudCourseInfo[]) {
    const resp: GetCourseListResp = {
      totalCount: list.length,
      returnCount: list.length,
      courseList: [],
    };
    list.forEach((item) => {
      const respItem: CourseInfo = this._createCourseInfoItem(item);
      resp.courseList.push(respItem);
    });
    return resp;
  }

  private async _initUserCourseInfoList(baseList: CloudCourseInfo[]) {
    try {
      const upsertArr: CloudUserCourseInfo[] = [];
      baseList.forEach(async (item) => {
        const userItem = new CloudUserCourseInfo();
        userItem.id = item.courseId + this._uid;
        userItem.courseId = item.courseId;
        userItem.userId = this._uid;
        userItem.type = item.type;
        userItem.name = item.name;
        userItem.summary = item.summary;
        userItem.detail = item.detail;
        userItem.mainDiagram = item.mainDiagram;
        userItem.price = item.price;
        userItem.expireType = item.expireType;
        userItem.startTime = item.startTime;
        userItem.endTime = item.endTime;
        userItem.orderTime = item.orderTime;
        userItem.classHour = item.classHour;
        userItem.status = item.status;
        userItem.currentHour = item.currentHour;
        userItem.timetable = item.timetable;
        upsertArr.push(userItem);
      });
      await this.databaseZone.upsert(upsertArr);
    } catch (err) {
      Logger.error(TAG, `init user course list failed. error: ${err}`);
    }
  }

  private _createCourseInfoItem(item: CloudUserCourseInfo | CloudCourseInfo): CourseInfo {
    const res: CourseInfo = {
      courseId: item.courseId,
      type: item.type,
      name: item.name,
      summary: item.summary,
      detail: item.detail,
      mainDiagram: item.mainDiagram,
      price: item.price,
      expireType: item.expireType,
      startTime: item.startTime,
      endTime: item.endTime,
      orderTime: item.orderTime,
      classHour: item.classHour,
      status: item.status,
      currentHour: item.currentHour,
      timetable: JSON.parse(item.timetable ?? '{}'),
    };
    return res;
  }

  private async _getStoreInfo() {
    const storeInfo: StoreInfo = {
      shopName: '琴之美 (鼓楼店)',
      latitude: 32.0603,
      longitude: 118.7969,
      address: '江苏省南京市鼓楼区音乐之路123号',
      phoneNumber: '+86 25 1234 5678',
      email: 'qinzhimei@test.com',
      logoUrl: STORE_INFO_IMAGES[0],
      desc: STORE_INFO_IMAGES[1],
      bannerImg: STORE_INFO_IMAGES[2],
      businessTime: '9:00 - 20:00',
    };
    return storeInfo;
  }
}

const courseInfoDB = new CourseInfoDB();

export { courseInfoDB as CourseInfoDB };
