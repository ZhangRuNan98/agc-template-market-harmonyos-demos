/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import NavRouterInfo from './models/NavRouterInfo';
import { RouterMap } from './models/RouterMap';

const TAG: string = '[RouterModule]';

class RouterModule {
  public static stack: NavPathStack = new NavPathStack();

  // 页面跳转(指定页面)
  public static push(info: NavRouterInfo, animated?: boolean) {
    try {
      RouterModule.stack.pushPathByName(info.url, info.param, info.onPop, animated);
    } catch (err) {
      console.error(TAG, 'navigation stack push failed::' + JSON.stringify(err));
    }
  }

  // 页面替换(指定页面)
  public static replace(info: NavRouterInfo) {
    try {
      RouterModule.stack.replacePathByName(info.url, info.param);
    } catch (err) {
      console.error(TAG, 'navigation stack replace failed::' + JSON.stringify(err));
    }
  }

  // 页面回退(上个页面)
  public static pop<T = boolean>(result?: T, animated?: boolean) {
    try {
      RouterModule.stack.pop(result, animated);
    } catch (err) {
      console.error(TAG, 'navigation stack pop failed::' + JSON.stringify(err));
    }
  }

  // 页面回退(携带参数)
  public static popWithRes(res: ESObject, animated?: boolean) {
    try {
      RouterModule.stack.pop(res, animated);
    } catch (err) {
      console.error(TAG, 'navigation stack pop failed::' + JSON.stringify(err));
    }
  }

  // 页面回退(至对应页面名)
  public static popToName(name: string, animated?: boolean) {
    try {
      RouterModule.stack.popToName(name, animated);
    } catch (err) {
      console.error(TAG, 'navigation stack pop to name failed::' + JSON.stringify(err));
    }
  }

  // 页面栈清空(回Navigation)
  public static clear(animated?: boolean) {
    try {
      RouterModule.stack.clear(animated);
    } catch (err) {
      console.error(TAG, 'navigation stack clear failed::' + JSON.stringify(err));
    }
  }

  // 获取页面栈大小
  public static size(): number {
    return RouterModule.stack.size();
  }

  // 获取参数(指定页面)
  public static getNavParam<T = Object>(info: NavRouterInfo): T | undefined {
    try {
      const paramsArr = RouterModule.stack.getParamByName(info.url) as T[] | undefined[];
      return paramsArr.pop();
    } catch (err) {
      console.error(TAG, 'navigation stack get params failed::' + JSON.stringify(err));
    }
    return undefined;
  }

  // 获取页面名(页面栈前一个)
  public static getSourcePage(): string | undefined {
    const pathNames = RouterModule.stack.getAllPathName();
    pathNames.pop();
    return pathNames.pop();
  }
}

export { RouterModule, RouterMap };