/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import preferences from '@ohos.data.preferences';
import PreferConstant from './PreferConstant'
import { BusinessError } from '@kit.BasicServicesKit';

export class ExamPreferences {
  // 创建首选项
  pref: preferences.Preferences | undefined = undefined
  // 笔记
  static notesPreferences: preferences.Preferences | null = null;
  // 练习记录
  static practiceRecordsPreferences: preferences.Preferences | null = null;

  async creatPreference(context: Context) {
    try {
      let pref = await preferences.getPreferences(context, PreferConstant.EXAMPREFER);
      this.pref = pref;
      console.log('testTag', '获取Preferences实例成功');
    } catch (e) {
      console.log('testTag', '获取Preferences实例失败', JSON.stringify(e));
    }
  }

  static getPreferences(context: Context, name: string) {
    let promise = preferences.getPreferences(context, name);
    promise.then((prefer: preferences.Preferences) => {
      switch (name) {
        // 获取笔记Preferences实例
        case PreferConstant.TOPIC_NOTES:
          ExamPreferences.notesPreferences = prefer;
          break;
        // 获取练习记录Preferences实例
        case PreferConstant.PRACTICE_RECORDS:
          ExamPreferences.practiceRecordsPreferences = prefer;
          break;
      }
      console.info('Succeeded in getting preferences.');
    }).catch((err: BusinessError) => {
      console.error('Failed to get preferences. code =' + err.code + ', message =' + err.message);
    })
  }

  async putPreferenceValue(key: string, value: preferences.ValueType) {
    if (!this.pref) {
      console.log('testTag', '未初始化Preferences实例！');
      return;
    }
    try {
      // 写入
      await this.pref.put(key, value);
      // 刷新磁盘
      await this.pref.flush();
      console.log('testTag', `Preferences[${key} = ${value}]成功`);
    } catch (e) {
      console.log('testTag', `Preferences[${key} = ${value}]失败` + JSON.stringify(e));
    }
  }

  async getPreferenceValue(key: string, defautValue: preferences.ValueType) {
    if (!this.pref) {
      console.log('testTag', '未初始化Preferences实例！');
      return undefined;
    }
    try {
      // 读取
      let value = await this.pref.get(key, defautValue);
      console.log('testTag', `读取Preferences[${key} = ${defautValue}]成功`);
      return value;
    } catch (e) {
      console.log('testTag', `读取Preferences[${key} = ${defautValue}]失败` + JSON.stringify(e));
      return undefined;
    }
  }

  async deletePreferenceValue(key: string) {
    if (!this.pref) {
      console.log('testTag', '未初始化Preferences实例！');
      return;
    }
    try {
      // 删除
      await this.pref.delete(key);
      console.log('testTag', '删除Preferences[${key} = ${value}]成功');
    } catch (e) {
      console.log('testTag', '删除Preferences[${key} = ${value}]失败' + JSON.stringify(e));
    }
  }

  isClean(): boolean {
    let arr: [] = [];
    let arr1: [] = [];
    let arr2: [] = []
    if (this.pref) {
      let value = this.pref?.getAllSync()
      arr = Object.values(value) as [];
    }
    if (ExamPreferences.practiceRecordsPreferences) {
      let value = ExamPreferences.practiceRecordsPreferences?.getAllSync()
      arr1 = Object.values(value) as [];
    }
    if (ExamPreferences.notesPreferences) {
      let value = ExamPreferences.notesPreferences?.getAllSync()
      arr2 = Object.values(value) as [];
    }
    let isClean = arr.length === 0 && arr1.length === 0 && arr2.length === 0
    if (isClean) {
      return true
    }
    return false
  }

  async clear() {
    this.pref?.clearSync()
    ExamPreferences.notesPreferences?.clearSync()
    ExamPreferences.practiceRecordsPreferences?.clearSync()
  }
}

const examPrefer = new ExamPreferences();
export { PreferConstant, examPrefer }
