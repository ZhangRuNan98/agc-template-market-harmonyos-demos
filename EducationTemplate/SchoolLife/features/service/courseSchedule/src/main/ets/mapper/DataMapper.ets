import { ScheduleInfo } from 'module_course_schedule';
import { CourseDetail } from 'commonlib';


export function mappedCourseDetailList(courseDetailList: CourseDetail[]): ScheduleInfo[] {
  const scheduleInfoList: ScheduleInfo[] = [];
  courseDetailList.forEach((courseDetail: CourseDetail) => {
    scheduleInfoList.push(new ScheduleInfo(
      courseDetail.daySchedule,
      courseDetail.weekDay,
      `${courseDetail.courseName}@${courseDetail.classroom}`));
  });
  return scheduleInfoList;
}