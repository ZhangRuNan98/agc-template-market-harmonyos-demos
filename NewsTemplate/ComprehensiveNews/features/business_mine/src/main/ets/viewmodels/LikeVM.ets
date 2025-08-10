import { promptAction } from '@kit.ArkUI';
import { BaseViewModel, PopViewUtils } from 'lib_common';
import { MineServiceApi, NewsModel } from 'lib_news_api';
import { cancelDialogBuilder, CancelDialogParams } from '../components/CancelDialogBuilder';

@ObservedV2
export class LikeViewModel extends BaseViewModel {
  @Trace list: NewsModel[] = [];

  constructor() {
    super();
    this.queryList();
  }

  queryList() {
    this.list = MineServiceApi.queryMyLikes().map(v => new NewsModel(v));
  }

  cancelLike(v: NewsModel) {
    MineServiceApi.cancelLike(v.id);
    PopViewUtils.closePopView();
    promptAction.showToast({ message: '取消点赞成功' });
    this.queryList();
  }

  popDialog(v: NewsModel) {
    PopViewUtils.showPopView(wrapBuilder(cancelDialogBuilder), {}, {
      btnText: '取消点赞',
      onCancel: () => {
        this.cancelLike(v);
      },
    } as CancelDialogParams);
  }
}