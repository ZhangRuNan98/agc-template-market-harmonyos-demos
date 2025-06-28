import { LengthMetrics } from '@kit.ArkUI';
import { BuildTitleBar } from '../components/BuildTitleBar';
import { FeedbackDetailVM } from '../viewModels/FeedbackDetailVM';
import { WindowUtil } from '../common/WindowUtil';
import { FeedbackInfo } from '../http/Types';

@Builder
export function FeedbackDetailBuilder() {
  FeedbackDetail();
}

@ComponentV2
export struct FeedbackDetail {
  vm: FeedbackDetailVM = FeedbackDetailVM.instance;

  build() {
    NavDestination() {
      Scroll() {
        Column({ space: 12 }) {
          Column({ space: 12 }) {
            Text(this.vm.feedbackDetail?.title || '')
              .baseTxtExtend();
            Text(this.vm.feedbackDetail?.postTime || '')
              .secondTextExtend();
            Divider().width('100%');
          }.alignItems(HorizontalAlign.Start);

          if (this.vm.feedbackDetail?.answer) {
            Row() {
              Text('答：').width(32).baseTxtExtend();
              Text(this.vm.feedbackDetail?.answer).layoutWeight(1).baseTxtExtend();
            }.alignItems(VerticalAlign.Top);
          } else {
            Text('~暂无答复~').secondTextExtend().width('100%').textAlign(TextAlign.Center);
          }


        }
        .alignItems(HorizontalAlign.Start)
        .borderRadius(16)
        .backgroundColor($r('sys.color.background_primary'))
        .padding(12);
      }
      .scrollBar(BarState.Off)
      .height('100%')
      .align(Alignment.Top)
      .width('100%')
      .padding({ left: 16, right: 16, top: 12 });
    }
    .title(BuildTitleBar('反馈历史'), { paddingStart: LengthMetrics.vp(16) })
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({ top: WindowUtil.avoidAreaSize.top, bottom: WindowUtil.avoidAreaSize.bottom })
    .onReady((context) => {
      this.vm.setStack(context.pathStack);
      this.vm.getFeedbackDetail();
    });
  }
}

@Extend(Text)
function secondTextExtend() {
  .fontColor($r('sys.color.font_secondary'))
  .fontSize($r('sys.float.Body_S'))
  .fontWeight(FontWeight.Regular);
}

@Extend(Text)
function baseTxtExtend() {
  .fontColor($r('sys.color.font_primary'))
  .fontWeight(FontWeight.Regular)
  .fontSize($r('sys.float.Body_M'));
}
