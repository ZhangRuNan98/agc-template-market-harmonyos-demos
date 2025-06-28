import { CaseInfo } from 'network';


export interface FeeInfo {
  des: string,
  min: number,
  max: number
}


export interface RangeItem {
  label: string,
  min: number,
  max: number
}

export interface RouterParams {
  caseList: CaseInfo[],
  title: string
}