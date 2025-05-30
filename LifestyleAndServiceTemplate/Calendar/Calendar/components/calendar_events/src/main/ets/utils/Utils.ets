/**
 * 生成随机id
 */
export function generateId() {
  return Math.random().toString(36).substring(2, 9)
}

/**
 * 计算下一次生日日期
 */
export function getNextBirthday(birthday: Date): Date {
  const today = new Date();
  const thisYearBirthday = new Date(
    today.getFullYear(),
    birthday.getMonth(),
    birthday.getDate(),
    birthday.getHours(),
    birthday.getMinutes(),
    birthday.getSeconds()
  );
  return thisYearBirthday < today
    ? new Date(thisYearBirthday.getFullYear() + 1, thisYearBirthday.getMonth(), thisYearBirthday.getDate())
    : thisYearBirthday;
}

export function compareDates(start:Date,end:Date) {
  const timestamp1 = start.getTime()
  const timestamp2 = end.getTime()

  if(timestamp1 > timestamp2) {
    return false
  }
  return true
}