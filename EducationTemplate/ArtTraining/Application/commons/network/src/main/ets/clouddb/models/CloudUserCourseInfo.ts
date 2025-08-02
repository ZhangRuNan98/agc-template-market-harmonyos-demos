import { CloudCourseInfo } from './CloudCourseInfo';

class CloudUserCourseInfo extends CloudCourseInfo {
  public id: string;
  public userId: string;

  public naturalbase_ClassName(): string {
    return 'CloudUserCourseInfo';
  }
}

export { CloudUserCourseInfo };
