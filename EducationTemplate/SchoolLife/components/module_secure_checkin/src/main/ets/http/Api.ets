import { CheckinStatusDTO, CheckinInfoDTO } from '../models/ApiModels';

import HashMap from '@ohos.util.HashMap';

export const MOCK_CHECKIN_CODE: string = '1111';

export class Api {

  // key: 学号_课程号, value: 签到信息
  private static checkinRecordMock: HashMap<string, CheckinInfoDTO> = new HashMap();

  private static withDelay<T>(callback: () => T | Promise<T>, delay = 300): Promise<T> {
    return new Promise((resolve, reject) => {
      setTimeout(async () => {
        try {
          const result: T = await callback();
          resolve(result);
        } catch (error) {
          reject(error);
        }
      }, delay);
    });
  }

  public static async requestCheckinStatus(studentId: string, courseId: string): Promise<CheckinStatusDTO> {
    return Api.withDelay(() => {
      const key: string = studentId + '_' + courseId;
      const status: CheckinStatusDTO = {
        isCheckedIn: Api.checkinRecordMock.hasKey(key),
        checkinInfo: Api.checkinRecordMock.get(key)
      };
      return status;
    });
  }

  public static async submitCheckin(checkinInfo: CheckinInfoDTO): Promise<boolean> {
    return Api.withDelay(() => {
      if (checkinInfo.checkinCode !== MOCK_CHECKIN_CODE) {
        return false;
      }
      // 当前 Mock 逻辑使用 Name 代表 Id
      const key: string = checkinInfo.studentId + '_' + checkinInfo.courseName;
      checkinInfo.checkinTime = new Date().getTime();
      Api.checkinRecordMock.set(key, checkinInfo);
      return true;
    });
  }
}
