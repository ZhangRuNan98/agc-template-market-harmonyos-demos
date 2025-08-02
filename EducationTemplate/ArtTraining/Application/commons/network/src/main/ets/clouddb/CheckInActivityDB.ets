import { cloudDatabase } from '@kit.CloudFoundationKit';
import { AccountUtil, CheckInActivity, CheckInRecord, CheckInTaskItem, Logger } from 'commonlib';
import { CheckInTaskOrderReq, GetCheckInActivityReq, GetUserCheckInRecordListReq } from '../types/RequestTypes';
import { GetCheckInActivityListRsp, GetUserCheckInRecordListRsp } from '../types/ResponseTypes';
import { BaseDB } from './BaseDB';
import { CloudCheckInActivity } from './models/CloudCheckInActivity';
import { CloudCheckInRecord } from './models/CloudCheckInRecord';
import { CloudUserCheckInActivity } from './models/CloudUserCheckInActivity';
import { promptAction } from '@kit.ArkUI';

const TAG = '[CheckInActivityDB]';

class CheckInActivityDB extends BaseDB {
  private _uid: string = AccountUtil.getAccountInfo().uid;

  public async getCheckInActivityList() {
    const condition = new cloudDatabase.DatabaseQuery(CloudUserCheckInActivity);
    let dataList: CloudUserCheckInActivity[] = [];
    try {
      dataList = await this.databaseZone.query(condition);
    } catch (err) {
      Logger.error(TAG, `get activity list failed. error:${JSON.stringify(err)}`);
    }
    const resp = this._createListResp(dataList);
    return this.getFormattedResp<GetCheckInActivityListRsp>(resp);
  }

  public async getCheckInActivityDetail(params: GetCheckInActivityReq) {
    const condition = new cloudDatabase.DatabaseQuery(CloudUserCheckInActivity).equalTo(
      'activityId',
      params.activityId,
    );
    try {
      const dataList = await this.databaseZone.query(condition);
      if (dataList.length === 1) {
        const activityItem = this._createActivityItem(dataList[0]);
        return this.getFormattedResp<CheckInActivity>(activityItem);
      }
    } catch (err) {
      Logger.error(TAG, `get activity detail failed. error:${JSON.stringify(err)}`);
    }
    return this.getFormattedResp<undefined>(undefined);
  }

  public async createCheckInActivityOrder(data: CheckInTaskOrderReq) {
    const id = data.activityId + this._uid;
    const condition = new cloudDatabase.DatabaseQuery(CloudUserCheckInActivity).equalTo('id', id);
    let res: number = 0;
    try {
      const dataList = await this.databaseZone.query(condition);
      if (dataList.length === 1) {
        const activityItem = dataList[0];
        activityItem.status = 1;
        activityItem.orderTime = new Date().getTime().toString();
        res = await this.upsert(activityItem);
      }
    } catch (err) {
      Logger.error(TAG, `create activity order failed. error:${JSON.stringify(err)}}`);
    }
    return this.getFormattedResp<number>(res);
  }

  public async commitUserCheckIn(data: CheckInRecord) {
    const record = new CloudCheckInRecord();
    record.userId = this._uid;
    record.taskId = data.taskId;
    record.activityId = data.activityId;
    record.textDetail = data.textDetail ?? '';
    record.pictureDetail = JSON.stringify(data.pictureDetail ?? []);
    record.audioDetail = JSON.stringify(data.audioDetail ?? []);
    record.videoDetail = JSON.stringify(data.videoDetail ?? []);
    record.createTime = new Date();
    record.recordId = `${this._uid}_${data.activityId}_${data.taskId}`;
    let res: number = 0;
    try {
      res = await this.upsert(record);
      if (res) {
        await this._updateTaskStatus(data.activityId, data.taskId);
      }
    } catch (err) {
      Logger.error(TAG, `commit user check-in record failed. error:${JSON.stringify(err)}}`);
    }
    return this.getFormattedResp<number>(res);
  }

  public async cancelCheckInActivityOrder(data: CheckInTaskOrderReq) {
    const id = data.activityId + this._uid;
    const condition = new cloudDatabase.DatabaseQuery(CloudUserCheckInActivity).equalTo('id', id);
    let res: number = 0;
    try {
      const dataList = await this.databaseZone.query(condition);
      if (dataList.length === 1) {
        const activityItem = dataList[0];
        activityItem.status = 0;
        activityItem.orderTime = '';
        res = await this.upsert(activityItem);
      }
    } catch (err) {
      Logger.error(TAG, `cancel activity order failed. error:${JSON.stringify(err)}}`);
    }
    return this.getFormattedResp<number>(res);
  }

  public async getCheckInActivityListOrdered() {
    const condition = new cloudDatabase.DatabaseQuery(CloudUserCheckInActivity)
      .notEqualTo('orderTime', '')
      .equalTo('userId', this._uid);

    let dataList: CloudUserCheckInActivity[] = [];
    try {
      dataList = await this.databaseZone.query(condition);
    } catch (err) {
      Logger.error(TAG, `get activity list failed. error:${JSON.stringify(err)}`);
    }
    const resp = this._createListResp(dataList);
    return this.getFormattedResp<GetCheckInActivityListRsp>(resp);
  }

  public async getUserCheckInRecordList(data: GetUserCheckInRecordListReq) {
    const condition = new cloudDatabase.DatabaseQuery(CloudCheckInRecord)
      .equalTo('userId', this._uid)
      .equalTo('activityId', data.activityId);

    let dataList: CloudCheckInRecord[] = [];
    try {
      dataList = await this.databaseZone.query(condition);
    } catch (err) {
      Logger.error(TAG, `get activity list failed. error:${JSON.stringify(err)}`);
    }
    const resp = this._createRecordListResp(dataList);
    return this.getFormattedResp<GetUserCheckInRecordListRsp>(resp);
  }

  public async initList() {
    try {
      const baseCondition = new cloudDatabase.DatabaseQuery(CloudCheckInActivity);
      const baseList = await this.databaseZone.query(baseCondition);
      const condition = new cloudDatabase.DatabaseQuery(CloudUserCheckInActivity);
      const list = await this.databaseZone.query(condition);
      if (list?.length) {
        return;
      }
      await this._initUserActivityList(baseList);
    } catch (err) {
      promptAction.showToast({ message: '云数据库初始化失败' });
      Logger.error(TAG, `init user check-in activity list failed. error:${JSON.stringify(err)}`);
    }
  }

  private async _initUserActivityList(baseList: CloudCheckInActivity[]) {
    try {
      const upsertArr: CloudUserCheckInActivity[] = [];
      baseList.forEach(async (item) => {
        const userItem = new CloudUserCheckInActivity();
        userItem.id = item.activityId + this._uid;
        userItem.activityId = item.activityId;
        userItem.userId = this._uid;
        userItem.name = item.name;
        userItem.summary = item.summary;
        userItem.detail = item.detail;
        userItem.mainDiagram = item.mainDiagram;
        userItem.price = item.price;
        userItem.requirement = item.requirement;
        userItem.status = 1;
        userItem.orderTime = '';
        userItem.taskDirectory = item.taskDirectory;
        userItem.participationCount = item.participationCount;
        userItem.historyCount = item.historyCount;
        upsertArr.push(userItem);
      });
      await this.databaseZone.upsert(upsertArr);
    } catch (err) {
      Logger.error(TAG, `init user course list failed. error: ${err}`);
    }
  }

  private _createRecordListResp(list: CloudCheckInRecord[]) {
    const resp: GetUserCheckInRecordListRsp = {
      totalCount: list.length,
      returnCount: list.length,
      list: [],
    };
    list.forEach((item) => {
      const respItem: CheckInRecord = this._createRecordItem(item);
      resp.list.push(respItem);
    });
    return resp;
  }

  private _createListResp(list: CloudUserCheckInActivity[]) {
    const resp: GetCheckInActivityListRsp = {
      totalCount: list.length,
      returnCount: list.length,
      list: [],
    };
    list.forEach((item) => {
      const respItem: CheckInActivity = this._createActivityItem(item);
      resp.list.push(respItem);
    });
    return resp;
  }

  private _createActivityItem(item: CloudUserCheckInActivity): CheckInActivity {
    const res: CheckInActivity = {
      activityId: item.activityId,
      name: item.name,
      summary: item.summary,
      detail: item.detail,
      mainDiagram: item.mainDiagram,
      price: item.price,
      orderTime: item.orderTime,
      requirement: JSON.parse(item.requirement ?? '{}'),
      participationCount: item.participationCount,
      historyCount: item.historyCount,
      taskDirectory: JSON.parse(item.taskDirectory ?? '{}'),
    };
    return res;
  }

  private _createRecordItem(item: CloudCheckInRecord): CheckInRecord {
    const record: CheckInRecord = {
      taskId: item.taskId,
      activityId: item.activityId,
      textDetail: item.textDetail,
      pictureDetail: JSON.parse(item.pictureDetail),
      audioDetail: JSON.parse(item.audioDetail),
      videoDetail: JSON.parse(item.videoDetail),
      createTime: item.createTime.getTime().toString(),
    };
    return record;
  }

  private async _updateTaskStatus(activityId: number, taskId: number) {
    const condition = new cloudDatabase.DatabaseQuery(CloudUserCheckInActivity)
      .equalTo('userId', this._uid)
      .equalTo('activityId', activityId);

    let dataList: CloudUserCheckInActivity[] = [];
    try {
      dataList = await this.databaseZone.query(condition);
      if (dataList.length === 1) {
        const activity = dataList[0];
        const taskDirectory: CheckInTaskItem[] = JSON.parse(activity.taskDirectory);
        if (taskDirectory.length) {
          const taskItem = taskDirectory.find((it) => it.taskId === taskId)!;
          taskItem.taskStatus = 2;
          activity.taskDirectory = JSON.stringify(taskDirectory);
          this.upsert(activity);
        }
      }
    } catch (err) {
      Logger.error(TAG, `update task status failed. error:${JSON.stringify(err)}`);
    }
  }
}

const checkInActivityDB = new CheckInActivityDB();

export { checkInActivityDB as CheckInActivityDB };
