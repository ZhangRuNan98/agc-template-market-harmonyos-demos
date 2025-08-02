import { Facility, FacilityType } from '../model/Index';

export const ADDITIONAL_FACILITY_TYPES: Facility[] = [
  {
    type: FacilityType.LEISURE,
    name: '休闲场所',
    sites: [],
    keyword: '公园,体育场',
  },
  {
    type: FacilityType.MEDICAL,
    name: '医疗诊所',
    sites: [],
    keyword: '医院,诊所',
  },
];