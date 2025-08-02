import { IBasicHouse } from 'foundation';

@ObservedV2
export class HouseHistory {
  @Trace date: string = ''
  @Trace houses: IBasicHouse[] = []
}
