@ObservedV2
export class UserInfoVM {
  @Trace
  public nickname: string = '';

  @Trace
  public anonymousPhone: string = '';

  @Trace
  public phone: string = '';

  @Trace
  public avatar: ResourceStr = '';

  public reset(): void {
    this.nickname = '';
    this.anonymousPhone = '';
    this.phone = '';
    this.avatar = '';
  }
}
