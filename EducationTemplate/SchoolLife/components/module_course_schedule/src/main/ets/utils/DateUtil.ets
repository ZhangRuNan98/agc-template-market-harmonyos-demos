

export class DateUtil {

  // 标准化Date时分秒
  public static normalizeDate(dateTime: Date): Date {
    const normalizedDate = new Date(dateTime);
    normalizedDate.setHours(0);
    normalizedDate.setMinutes(0);
    normalizedDate.setSeconds(0);
    return normalizedDate;
  }

  // 查看两个日期是否在同一天
  public static isSameDate(dateTime1: Date, date2Time: Date): boolean {
    return dateTime1.toLocaleDateString() === date2Time.toLocaleDateString();
  }
}
