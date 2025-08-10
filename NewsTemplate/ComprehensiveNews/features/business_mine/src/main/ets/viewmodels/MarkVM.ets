import { promptAction } from '@kit.ArkUI';
import { BaseViewModel, PopViewUtils } from 'lib_common';
import { MineServiceApi, NewsModel } from 'lib_news_api';
import { cancelDialogBuilder, CancelDialogParams } from '../components/CancelDialogBuilder';

@ObservedV2
export class MarkViewModel extends BaseViewModel {
  @Trace list: NewsModel[] = [];

  constructor() {
    super();
    this.queryList();
  }

  queryList() {
    this.list = MineServiceApi.queryMyMarks().map(v => new NewsModel(v));
  }

  cancelMark(v: NewsModel) {
    MineServiceApi.cancelMark(v.id);
    PopViewUtils.closePopView();
    promptAction.showToast({ message: '取消收藏成功' });
    this.queryList();
  }

  popDialog(v: NewsModel) {
    PopViewUtils.showPopView(wrapBuilder(cancelDialogBuilder), {}, {
      btnText: '取消收藏',
      onCancel: () => {
        this.cancelMark(v);
      },
    } as CancelDialogParams);
  }
}