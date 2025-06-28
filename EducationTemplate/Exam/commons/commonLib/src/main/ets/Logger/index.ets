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

import { hilog } from '@kit.PerformanceAnalysisKit';

export class Logger {
  private static _domain: number = 0xff00;
  private static _prefix: string = 'ParkTemplate';
  private static _format: string = '%{public}s, %{public}s';

  public static debug(...args: string[]): void {
    hilog.debug(Logger._domain, Logger._prefix, Logger._format, args);
  }

  public static info(...args: string[]): void {
    hilog.info(Logger._domain, Logger._prefix, Logger._format, args);
  }

  public static warn(...args: string[]): void {
    hilog.warn(Logger._domain, Logger._prefix, Logger._format, args);
  }

  public static error(...args: string[]): void {
    hilog.error(Logger._domain, Logger._prefix, Logger._format, args);
  }
}