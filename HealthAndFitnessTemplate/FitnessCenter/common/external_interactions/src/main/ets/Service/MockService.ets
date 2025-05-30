import { BusinessError } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';
import { CardInfo, CourseDetailModel, DateUtil, SportTypeEnum } from '../../../../Index';
import {
  Account,
  BookingRecordInfo,
  BookState,
  CoachCourseInfo,
  ConsumeType,
  CourseBookingInfo,
  OrderInfo,
  OrderState,
  OrderType,
  SportType,
  TeachType,
  UserCard
} from '../model/MockModel';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { preferences } from '@kit.ArkData';

export class MockService {
  static courseList: CourseDetailModel[] = [];
  static courseIdMap: Map<string, CourseDetailModel> = new Map();
  static homeSwiperImageList: string[] = ['app.media.material12', 'app.media.material10']
  static sportTypeList: SportType[] = []
  static cardList: CardInfo[] = []
  static cardIdMap: Map<string, CardInfo> = new Map();
  static userCardList: UserCard[] = []
  static userCardMap: Map<string, UserCard> = new Map();
  static courseBookingList: CourseBookingInfo[] = [];
  static courseBookingMap: Map<string, CourseBookingInfo> = new Map();
  static coachMap: Map<string, CoachCourseInfo> = new Map();
  static bookingList: BookingRecordInfo[] = [];
  static bookingMap: Map<string, BookingRecordInfo> = new Map();
  static orderList: OrderInfo[] = [];
  static orderMap: Map<string, OrderInfo> = new Map();
  static account: Account = {
    avatar: '',
    memberId: '300589954455677',
    nickname: '',
    phone: '12345678901',
    balance: 0,
    sex: '',
    birthday: ''
  };
  static dataPreferences: preferences.Preferences;

  static init() {
    MockService.dataPreferences = preferences.getPreferencesSync(getContext(), { name: 'myStore' })
    MockService.getRawFile<CourseDetailModel[]>('course.json').then((rsp: CourseDetailModel[]) => {
      MockService.courseList = rsp;
      rsp.forEach((item: CourseDetailModel) => {
        MockService.courseIdMap.set(item.id, item);
      })
    })
    MockService.getRawFile<SportType[]>('sportTypes.json').then((rsp: SportType[]) => {
      MockService.sportTypeList = rsp;
    })
    MockService.getRawFile<CardInfo[]>('card.json').then((rsp: CardInfo[]) => {
      MockService.cardList = rsp;
      rsp.forEach((item: CardInfo) => {
        MockService.cardIdMap.set(item.id, item);
      })
    })

    let courseBooking = MockService.getPreferences<CourseBookingInfo[]>('courseBooking')
    let date: Date = new Date();
    let weekdayDateMap: Map<number, string> = new Map();
    for (let i = 0; i < 7; i++) {
      // 获取一周对应的星期
      weekdayDateMap.set(date.getDay(), DateUtil.formatDate(date, '-'))
      date.setDate(date.getDate() + 1);
    }
    if (courseBooking) {
      MockService.courseBookingList = courseBooking
      MockService.courseBookingList.forEach((item: CourseBookingInfo) => {
        item.date = weekdayDateMap.get(item.weekday)!
        MockService.courseBookingMap.set(item.id, item);
      })
    } else {
      MockService.getRawFile<CourseBookingInfo[]>('course_booking.json').then((rsp: CourseBookingInfo[]) => {
        rsp.forEach((item: CourseBookingInfo) => {
          item.date = weekdayDateMap.get(item.weekday)!
          MockService.courseBookingList.push(item)
          MockService.courseBookingMap.set(item.id, item);
        })
      })
    }

    MockService.getRawFile<CoachCourseInfo[]>('coach.json').then((rsp: CoachCourseInfo[]) => {
      rsp.forEach((item: CoachCourseInfo) => {
        MockService.coachMap.set(item.id, item);
      })
    })

    let account = MockService.getPreferences<Account>('account')
    if (account) {
      MockService.account = account
    }

    let booking = MockService.getPreferences<BookingRecordInfo[]>('booking')
    if (booking) {
      MockService.bookingList = booking
    } else {
      MockService.getRawFile<BookingRecordInfo[]>('booking.json').then((rsp: BookingRecordInfo[]) => {
        MockService.bookingList = rsp;
      })
    }
    MockService.bookingList.forEach((item: BookingRecordInfo) => {
      MockService.bookingMap.set(item.id, item);
    })

    let order = MockService.getPreferences<OrderInfo[]>('order')
    if (order) {
      MockService.orderList = order
      MockService.orderList.forEach((item: OrderInfo) => {
        MockService.orderMap.set(item.id, item);
      })
    }

    let userCard = MockService.getPreferences<UserCard[]>('userCard')
    if (userCard) {
      MockService.userCardList = userCard
      MockService.userCardList.forEach((item: UserCard) => {
        MockService.userCardMap.set(item.id, item);
      })
    }

    AppStorage.setOrCreate('loginState', MockService.dataPreferences.getSync('loginState', false))
  }

  static getHomeCourseList(): CourseDetailModel[] {
    let list: CourseDetailModel[] = []
    for (let i = 0; i < 4; i++) {
      list.push(MockService.courseList[i])
    }
    return list
  }

  static getCourseListBySportType(sportType: SportTypeEnum): CourseDetailModel[] {
    let list: CourseDetailModel[] = []
    MockService.courseList.forEach((item: CourseDetailModel) => {
      if (item.sportsType.includes(sportType)) {
        list.push(item)
      }
    })
    return list
  }

  static getCourseListBySearch(searchWord: string, searchSportType: SportType): CourseDetailModel[] {
    let list: CourseDetailModel[] = []
    MockService.courseList.forEach((item: CourseDetailModel) => {
      if (item.courseName.includes(searchWord) &&
        (searchSportType.typeEnum.valueOf() === 0 || item.sportsType.includes(searchSportType.typeEnum))) {
        list.push(item)
      }
    })
    return list
  }

  static getCourseById(courseId: string): CourseDetailModel {
    return MockService.courseIdMap.get(courseId)!
  }

  static getHomeCardList(): CardInfo[] {
    let list: CardInfo[] = []
    for (let i = 0; i < 4; i++) {
      list.push(MockService.cardList[i])
    }
    return list
  }

  static getCardListBySportType(sportType: SportTypeEnum): CardInfo[] {
    let list: CardInfo[] = []
    MockService.cardList.forEach((item: CardInfo) => {
      if (item.sportsType.includes(sportType)) {
        list.push(item)
      }
    })
    return list
  }

  static getCardListBySearch(searchWord: string, searchSportType: SportType): CardInfo[] {
    let list: CardInfo[] = []
    MockService.cardList.forEach((item: CardInfo) => {
      if (item.name.includes(searchWord) &&
        (searchSportType.typeEnum.valueOf() === 0 || item.sportsType.includes(searchSportType.typeEnum))) {
        list.push(item)
      }
    })
    return list
  }

  static getCardById(cardId: string): CardInfo {
    return MockService.cardIdMap.get(cardId)!
  }

  static getUserCardById(id: string): UserCard {
    return MockService.userCardMap.get(id)!
  }

  static getUserCardByCardId(cardId: string): UserCard {
    let sortList = MockService.userCardList
      .filter((value: UserCard) => value.cardId === cardId)
      .sort((a, b) => {
        return b.restQuota - a.restQuota;
      })
    return sortList[0]
  }

  static getQuotaDurationDesc(quota: number): string {
    return quota === 365 ? '年' : (quota === 90 ? '季' : '月')
  }

  static getCardExpireDate(userCard: UserCard): Date {
    let date: Date = DateUtil.parseDateString(userCard.buyTime);
    date.setDate(date.getDate() + userCard.restQuota);
    return date
  }

  static getCoachCourseInfoListBySearch(searchWord: string, searchSportType: SportType, date: Date): CoachCourseInfo[] {
    let list: CoachCourseInfo[] = []
    let now: Date = new Date();
    let coachBookingMap: Map<string, CourseBookingInfo[]> = new Map();
    MockService.courseBookingList.forEach((item: CourseBookingInfo) => {
      let courseDetail = MockService.getCourseById(item.courseId)
      if (courseDetail.teachType === TeachType.PERSONAL && courseDetail.courseName.includes(searchWord) &&
        (searchSportType.typeEnum.valueOf() === 0 || courseDetail.sportsType.includes(searchSportType.typeEnum)) &&
        DateUtil.formatDate(date, '-') === item.date &&
        DateUtil.parseDateString(item.date + ' ' + item.timeStart).getTime() > now.getTime()) {
        if (coachBookingMap.has(item.coachId)) {
          let courseBooKingInfoList: CourseBookingInfo[] = coachBookingMap.get(item.coachId)!
          courseBooKingInfoList.push(item)
        } else {
          let courseBooKingInfoList: CourseBookingInfo[] = []
          courseBooKingInfoList.push(item)
          coachBookingMap.set(item.coachId, courseBooKingInfoList)
        }
      }
    })
    coachBookingMap.forEach((value: CourseBookingInfo[], key) => {
      let coachCourseInfo: CoachCourseInfo = MockService.coachMap.get(key)!
      coachCourseInfo.courseInfos = value
      list.push(coachCourseInfo)
    })
    return list
  }

  static getCourseBookingInfoListBySearch(searchWord: string, searchSportType: SportType,
    date: Date): CourseBookingInfo[] {
    let list: CourseBookingInfo[] = []
    let now: Date = new Date();
    MockService.courseBookingList.forEach((item: CourseBookingInfo) => {
      let courseDetail = MockService.getCourseById(item.courseId)
      if (courseDetail.courseName.includes(searchWord) &&
        (searchSportType.typeEnum.valueOf() === 0 || courseDetail.sportsType.includes(searchSportType.typeEnum)) &&
        courseDetail.teachType === TeachType.GROUP && DateUtil.formatDate(date, '-') === item.date &&
        DateUtil.parseDateString(item.date + ' ' + item.timeStart).getTime() > now.getTime()) {
        list.push(item)
      }
    })
    return list
  }

  static searchCourseBooking(searchWord: string): CourseBookingInfo | undefined {
    let first: CourseBookingInfo | undefined = undefined
    let now: Date = new Date();
    let courseSortList = MockService.courseBookingList
      .sort((a, b) => {
        const timeA = DateUtil.parseDateString(a.date);
        const timeB = DateUtil.parseDateString(b.date);
        return timeA.getTime() - timeB.getTime();
      })
      .filter(item => DateUtil.parseDateString(item.date + ' ' + item.timeStart).getTime() > now.getTime());
    for (let i = 0; i < courseSortList.length; i++) {
      let item = courseSortList[i];
      let courseDetail = MockService.getCourseById(item.courseId)
      if (courseDetail.courseName.includes(searchWord)) {
        if (item.restQuota > 0) {
          return item;
        } else {
          if (first === undefined) {
            first = item
          }
        }
      }
    }
    return first;
  }

  static getCourseBookingById(id: string): CourseBookingInfo {
    return MockService.courseBookingMap.get(id)!
  }

  static getBookingListByState(bookingState: BookState): BookingRecordInfo[] {
    let list: BookingRecordInfo[] = [];
    let now: Date = new Date();
    MockService.bookingList.forEach((item: BookingRecordInfo) => {
      if (item.bookState === BookState.TO_BE_USE) {
        let bookingInfo = MockService.getCourseBookingById(item.courseBookingId)
        // 超时订单更新订单状态为已过期
        if (DateUtil.parseDateString(item.bookingDate + ' ' + bookingInfo.timeStart).getTime() <= now.getTime()) {
          item.bookState = BookState.EXPIRED
        }
      }
      if (item.bookState === bookingState || bookingState === BookState.ALL) {
        list.push(item)
      }
    })
    return list;
  }

  static getBookingRecordById(id: string): BookingRecordInfo {
    return MockService.bookingMap.get(id)!
  }

  static getOrderListByState(orderState: OrderState): OrderInfo[] {
    let list: OrderInfo[] = [];
    if (orderState === OrderState.ALL) {
      return MockService.orderList;
    } else {
      MockService.orderList.forEach((item: OrderInfo) => {
        if (item.orderState === orderState) {
          list.push(item)
        }
      })
      return list;
    }
  }

  static getOrderById(orderId: string): OrderInfo {
    return MockService.orderMap.get(orderId)!
  }

  static getBookStateString(state: number): string {
    switch (state) {
      case BookState.ALL:
        return '全部'
      case BookState.TO_BE_USE:
        return '待使用'
      case BookState.COMPLETED:
        return '已完成'
      case BookState.EXPIRED:
        return '已过期'
      case BookState.CANCELED:
        return '已取消'
      default:
        return ''
    }
  }

  static getOrderStateString(state: number): string {
    switch (state) {
      case OrderState.ALL:
        return '全部'
      case OrderState.COMPLETED:
        return '已完成'
      case OrderState.TO_BE_PAY:
        return '待支付'
      default:
        return ''
    }
  }

  static saveAccountInfo(nickname: string, phone: string, sex: string, birthday: string, avatar: ResourceStr) {
    MockService.account.nickname = nickname
    MockService.account.phone = phone
    MockService.account.sex = sex
    MockService.account.birthday = birthday
    MockService.account.avatar = avatar
    MockService.dataPreferences.putSync('account', JSON.stringify(MockService.account))
    MockService.dataPreferences.flush()
  }

  static createOrder(orderType: OrderType, orderState: OrderState, number: number, price: number, cardId?: string,
    bookingId?: string): OrderInfo {
    let order: OrderInfo = {
      id: MockService.generateDigitString(11),
      orderType: orderType,
      orderState: orderState,
      number: number,
      price: price,
      createTime: DateUtil.formatDate(new Date(), '-', undefined, 'medium')
    }
    if (orderType === OrderType.CARD) {
      order.cardId = cardId
    } else {
      order.bookingId = bookingId
    }
    if (orderState === OrderState.COMPLETED) {
      order.payTime = DateUtil.formatDate(new Date(), '-', undefined, 'medium')
    }

    MockService.orderList.splice(0, 0, order);
    MockService.orderMap.set(order.id, order);
    MockService.dataPreferences.putSync('order', JSON.stringify(MockService.orderList))
    MockService.dataPreferences.flush()
    return order;
  }

  static createBookingRecord(courseBookingId: string, bookState: BookState, phone: string, name: string,
    personNum: number, remark: string, bookingDate: string, userCardId?: string): BookingRecordInfo {
    let bookingRecord: BookingRecordInfo = {
      id: MockService.generateDigitString(11),
      createTime: DateUtil.formatDate(new Date(), '-', undefined, 'medium'),
      courseBookingId: courseBookingId,
      bookState: bookState,
      phone: phone,
      name: name,
      personNum: personNum,
      remark: remark,
      userCardId: userCardId,
      bookingDate: bookingDate
    }

    MockService.bookingList.splice(0, 0, bookingRecord);
    MockService.bookingMap.set(bookingRecord.id, bookingRecord);
    MockService.dataPreferences.putSync('booking', JSON.stringify(MockService.bookingList))
    MockService.dataPreferences.flush()
    return bookingRecord;
  }

  static addUserCard(cardId: string, restQuota: number): UserCard {
    let userCard: UserCard = {
      id: MockService.generateDigitString(11),
      cardId: cardId,
      restQuota: restQuota,
      buyTime: DateUtil.formatDate(new Date(), '-', undefined, 'medium'),
    }
    MockService.userCardList.push(userCard);
    MockService.userCardMap.set(userCard.id, userCard);
    MockService.dataPreferences.putSync('userCard', JSON.stringify(MockService.userCardList))
    MockService.dataPreferences.flush()
    return userCard;
  }

  static userCardCanUse(userCard: UserCard): boolean {
    let cardInfo: CardInfo = MockService.getCardById(userCard.cardId)
    if (cardInfo.consumeType === ConsumeType.TIMES) {
      return userCard.restQuota > 0
    } else {
      let now = new Date()
      return MockService.getCardExpireDate(userCard) > now
    }
  }

  static generateDigitString(count: number): string {
    // 获取13位时间戳并转为字符串
    const timestamp = new Date().getTime().toString();
    // 截取时间戳后6位（包含毫秒级变化）
    const timePart = timestamp.substring(7);

    // 剩余位置生成随机数（补零确保长度）
    const randomPart = MockService.doRandBySync(2)
      .toString()
      .padStart(count - 6, '0'); // 补零

    // 4. 拼接并返回结果
    return timePart + randomPart;
  }

  static doRandBySync(len: number): number {
    let rand = cryptoFramework.createRandom();
    let randData = rand.generateRandomSync(len);
    if (randData != null) {
      return randData.data.reduce((acc, byte) => acc * 256 + byte, 0); // 将字节转换为整数
    } else {
      console.error('[Sync]: get rand result fail!');
    }
    return 0
  }

  static getRawFile<T>(filePath: string): Promise<T> {
    return getContext().resourceManager.getRawFileContent(filePath)
      .then((value: Uint8Array) => {
        let res: string = MockService.bufferToString(value);
        return JSON.parse(res) as T;
      }).catch((e: BusinessError) => {
        console.error(`MockService.getRawFileContent failed, error code: ${e.code}, message: ${e.message}.`);
        return Promise.reject(e);
      });
  }

  static getPreferences<T>(key: string): T | undefined {
    let value = MockService.dataPreferences.getSync(key, '');
    if (value.toString().length > 0) {
      return JSON.parse(value.toString()) as T;
    }
    return undefined;
  }

  static bufferToString(buffer: Uint8Array): string {
    let textDecoder = util.TextDecoder.create('utf-8', {
      ignoreBOM: true
    });
    let resultPut = textDecoder.decodeToString(buffer);
    return resultPut;
  }
}