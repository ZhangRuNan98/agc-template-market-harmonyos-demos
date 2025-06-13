import { IVip } from '../types';

export const vipList: IVip[] = [
  {
    id: 1,
    name: '连续包月',
    originalPrice: 12,
    discountPrice: 1,
    instructions: '次月起12元/月，到期自动续费可随时取消'
  },
  {
    id: 2,
    name: '连续包年',
    originalPrice: 225,
    discountPrice: 180,
    instructions: '次年起225元/年，到期自动续费可随时取消'
  }
]