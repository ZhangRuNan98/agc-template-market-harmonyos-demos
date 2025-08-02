

@ObservedV2
export class ScheduleInfo {

  @Trace
  public daySchedule: number[] = []; // 日程时间段，长度为2

  public weekDay: number = 0;        // 日程所在日期

  public scheduleName: string = '';  // 日程名称

  constructor(daySchedule: number[], weekDay: number, scheduleName: string) {
    this.daySchedule = daySchedule;
    this.weekDay = weekDay;
    this.scheduleName = scheduleName;
  }
}
