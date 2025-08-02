import { ILayout } from 'foundation';
import { site } from '@kit.MapKit';

export interface Layout {
  bedroomCount: number;
  layouts: ILayout[];
}

export interface Facility {
  type: FacilityType,
  name: string,
  sites?: Array<site.Site>,
  keyword: string
}

export enum FacilityType {
  EDUCATION = '教育',
  TRANSPORT = '交通',
  LIFE = '生活'
}