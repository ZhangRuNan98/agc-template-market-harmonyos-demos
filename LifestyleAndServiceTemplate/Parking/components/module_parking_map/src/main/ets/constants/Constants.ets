import { emitter } from '@kit.BasicServicesKit';

export class EmitterConstants {
  // 移动地图
  public static readonly MOVE_CAMERA: emitter.InnerEvent = { eventId: 1001 };
}

export enum AppStorageMap {
  // 地图中心
  MAP_CENTER = 'MAP_CENTER',
}