// 用户登录信息数据
@ObservedV2
export class BikeState {
  @Trace bikeId: string = '';
  @Trace unlockProgress: number = 0;
  @Trace unlocked: boolean = false;
}