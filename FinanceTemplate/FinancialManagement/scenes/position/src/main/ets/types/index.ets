import {
  IInvestmentRecordItem,
  IRegularInvestmentInfo } from 'lib_foundation';

export interface IRedemptionButton {
  index: number,
  text: string,
}

export interface IInvestmentParam {
  investmentInfo: IRegularInvestmentInfo,
  record: IInvestmentRecordItem,
}