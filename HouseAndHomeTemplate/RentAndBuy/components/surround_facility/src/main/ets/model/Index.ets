import { site } from '@kit.MapKit';

export enum FacilityType {
  EDUCATION = '教育',
  TRANSPORT = '交通',
  LIFE = '生活',
  LEISURE = '休闲',
  MEDICAL = '医疗',
}

@ObservedV2
export class Facility {
  @Trace type: FacilityType = FacilityType.EDUCATION;
  @Trace name: string = '';
  @Trace sites?: Array<site.Site> = [];
  @Trace keyword: string = '';
}

