import { https, INoticeItem } from 'lib_foundation';

@ObservedV2
export class FinancialInformationVM {
  private static _instance: FinancialInformationVM;
  @Trace public noticeList: INoticeItem[] = []

  public static get instance() {
    if (!FinancialInformationVM._instance) {
      FinancialInformationVM._instance = new FinancialInformationVM();
    }
    return FinancialInformationVM._instance;
  }

  async init() {
    this.getNoticeList()
  }


  public async getNoticeList() {
    const res = await https.getNoticeList();
    if (res.code === 0) {
      this.noticeList = res.data;
    }
  }
}
