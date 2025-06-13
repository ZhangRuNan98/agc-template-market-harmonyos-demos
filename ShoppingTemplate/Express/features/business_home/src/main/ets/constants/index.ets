import { ISetting } from 'module_base'
import { ITime } from '../types'

export const methodList: ISetting[] = [
  {
    text: '上门取件',
    value: 1,
  },
  {
    text: '服务点自寄',
    value: 2,
  }
]

export const payMethodList: ISetting[] = [
  {
    text: '寄付现结',
    value: 1
  },
  {
    text: '到付',
    value: 2
  }
]

export const shippingMethodList: ISetting[] = [
  {
    text: '网点自寄',
    value: 1
  },
  {
    text: '自行联系快递员',
    value: 2
  },
  {
    text: '每天固定时间',
    value: 3
  }
]

export const gridList: ISetting[] = [
  {
    text: '小格口',
    value: 1
  },
  {
    text: '中格口',
    value: 2
  },
  {
    text: '大格口',
    value: 3
  }
]

export const timeList: string[] =
  ['8:00 - 9:00', '9:00 - 10:00', '10:00 - 11:00', '11:00 - 12:00', '12:00 - 13:00', '13:00 - 14:00', '14:00 - 15:00',
    '15:00 - 16:00', '16:00 - 17:00',
    '17:00 - 18:00']

export const dayList: ITime[] = [
  {
    text: '今天',
    value: 1,
    timeList: timeList
  },
  {
    text: '明天',
    value: 2,
    timeList: timeList
  },
  {
    text: '后天',
    value: 3,
    timeList: timeList
  }
]

export function getTimeList(dayList: ITime[]): ITime[] {
  const data: ITime[] = []
  dayList.forEach((item) => {
    const temp: ITime = {
      text: item.text,
      value: item.value,
      timeList: item.timeList
    }
    data.push(temp)
  })
  const time = new Date().getHours()
  if (time < 8) {
    return data
  }

  if (time > 18) {
    return data.slice(1, 2)
  }

  const count = time - 8
  if (count < 10) {
    data[0].timeList = data[0].timeList.slice(count)
  } else {
    data.shift()
  }
  return data
}