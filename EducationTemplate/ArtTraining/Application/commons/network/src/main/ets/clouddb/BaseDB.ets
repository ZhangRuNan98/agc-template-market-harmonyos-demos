import { cloudDatabase } from '@kit.CloudFoundationKit';
import { Logger } from 'commonlib';
import { BaseResp } from '../types/ResponseTypes';

const TAG = '[BaseDB]';

export abstract class BaseDB {
  protected databaseZone = cloudDatabase.zone('ArtTraining');

  protected async query<K extends cloudDatabase.DatabaseObject>(
    condition: cloudDatabase.DatabaseQuery<K>,
  ): Promise<K[]> {
    try {
      const dataList = await this.databaseZone.query(condition);
      Logger.info(TAG, `Succeeded to query data, result: ${JSON.stringify(dataList)}`);
      return dataList;
    } catch (err) {
      Logger.error(TAG, `Failed to query data, code: ${err.code}, message: ${err.message}`);
      return [];
    }
  }

  protected async upsert<K extends cloudDatabase.DatabaseObject>(data: K) {
    try {
      const upsertNum = await this.databaseZone.upsert(data);
      Logger.info(TAG, `Succeeded to upsert data, result: ${JSON.stringify(upsertNum)}`);
      return upsertNum;
    } catch (err) {
      Logger.error(TAG, `Failed to upsert data, code: ${err.code}, message: ${err.message}`);
      return 0;
    }
  }

  protected async delete<K extends cloudDatabase.DatabaseObject>(data: K) {
    try {
      const deleteNum = await this.databaseZone.delete(data);
      Logger.info(TAG, `Succeeded to delete data, result: ${JSON.stringify(deleteNum)}`);
      return deleteNum;
    } catch (err) {
      Logger.error(TAG, `Failed to delete data, code: ${err.code}, message: ${err.message}`);
      return 0;
    }
  }

  protected getFormattedResp<T>(data: T): BaseResp<T> {
    let code = -1;
    let msg = 'request database failed';
    if (typeof data !== 'undefined' && data !== 0) {
      code = 0;
      msg = '';
    }
    const resp: BaseResp<T> = {
      ret: {
        code,
        msg,
      },
      result: data,
    };
    return resp;
  }
}
