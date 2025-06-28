import { LengthMetrics } from '@kit.ArkUI';
import { BuildTitleBar } from '../components/BuildTitleBar';
import { FeedbackInfo } from '../http/Types';
import { WindowUtil } from '../common/WindowUtil';
import { UrlMap } from '../common/Constant';
import { FeedbackHistoryVM } from '../viewModels/FeedbackHistoryVM';


@Builder
export function FeedbackHistoryBuilder() {
  FeedbackHistory();
}

@ComponentV2
export struct FeedbackHistory {
  vm: FeedbackHistoryVM = FeedbackHistoryVM.instance;

  aboutToAppear(): void {
    this.vm.getFeedBack();
  }

  build() {
    NavDestination() {
      Scroll() {
        Column({ space: 12 }) {
          ForEach(this.vm.feedbackList, (item: FeedbackInfo) => {
            Column({ space: 12 }) {
              Text(item.title)
                .fontColor($r('sys.color.font_primary'))
                .fontWeight(FontWeight.Regular)
                .fontSize($r('sys.float.Body_M'));
              Text(item.postTime)
                .fontColor($r('sys.color.font_secondary'))
                .fontSize($r('sys.float.Body_S'))
                .fontWeight(FontWeight.Regular);
            }
            .alignItems(HorizontalAlign.Start)
            .width('100%')
            .padding(12)
            .borderRadius(16)
            .backgroundColor($r('sys.color.background_primary'))
            .onClick(() => {
              this.vm.stack.pushPath({
                name: UrlMap.FEEDBACK_DETAIL,
                param: item,
              });
            });

          }, (item: FeedbackInfo, index) => index.toString());


        }.alignItems(HorizontalAlign.Start).padding({ top: 12, right: 16, left: 16 });
      }.scrollBar(BarState.Off).height('100%').align(Alignment.Top).width('100%');
    }
    .title(BuildTitleBar('反馈历史'), { paddingStart: LengthMetrics.vp(16) })
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({ top: WindowUtil.avoidAreaSize.top, bottom: WindowUtil.avoidAreaSize.bottom })
    .onReady((context) => {
      this.vm.setStack(context.pathStack);
    });
  }
}