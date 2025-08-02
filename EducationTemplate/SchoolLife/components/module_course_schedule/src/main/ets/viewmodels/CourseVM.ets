import { ScheduleFlag } from '../common/CommonConst';

@ObservedV2
export class CourseVM {

  public courseName: string = '';

  public classroom: string = '';

  public teacher: string = '';

  public weekDay: number = 0;

  public weekSchedule: number[] = [];

  public daySchedule: number[] = [];

  public scheduleFlag: string = ScheduleFlag.NORMAL;

}
