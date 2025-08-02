export type Any = ESObject;

export interface CheckinContext {
  studentId: string;
  courseId: string;
  courseName: string;
}

export interface Location {
  latitude: number;
  longitude: number;
}

export enum ViewModelState {
  UNINITIALIZED = 'UNINITIALIZED',
  READY = 'READY',
  INIT_FAILED = 'INIT_FAILED'
}

export enum PermissionStatus {
  GRANTED = 0,
  DENIED = -1,
  UNKNOWN = 2
}
