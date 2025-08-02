@ObservedV2
export class CheckInDataModel {
  @Trace textDetail: string = '';
  @Trace pictureDetail: ResourceStr[] = [];
  @Trace audioDetail: ResourceStr[] = [];
  @Trace videoDetail: ResourceStr[] = [];
  @Trace createTime: string = '';
}