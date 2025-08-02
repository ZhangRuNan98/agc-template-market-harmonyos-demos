import { Location } from '../common/CustomTypes';

export interface CheckinStatusDTO {
  isCheckedIn: boolean;
  checkinInfo?: CheckinInfoDTO;
}

export interface CheckinInfoDTO {
  studentId: string;
  courseId: string;
  checkinCode: string;
  location: Location;
  courseName?: string;
  checkinTime?: number;
}
