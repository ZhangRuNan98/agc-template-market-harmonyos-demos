import { LengthMetrics } from '@kit.ArkUI';
import { Posting } from '../components/Posting';
import { WindowUtil } from '../common/WindowUtil';
import { UrlMap } from '../common/Constant';
import { BuildTitleBar } from '../components/BuildTitleBar';
import { FeedbackPageVM } from '../viewModels/FeedbackPageVM';
import { WantData, PostType } from '../http/Types';


@Builder
export function FeedbackPageBuilder() {
  FeedbackPage();
}


@ComponentV2
struct FeedbackPage {
  vm: FeedbackPageVM = FeedbackPageVM.instance;
  private controller: TabsController = new TabsController();

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          Posting(
            {
              onWantSubmit: (wantData: WantData) => {
                this.vm.uploadFeedback(wantData.title, PostType.want, wantData.painPoint, wantData.idea);
              },
              onSuggestionSubmit: (title) => {
                this.vm.uploadFeedback(title, PostType.suggestion);
              },
            },
          ) {
            Row() {
              Text('反馈历史')
                .fontSize($r('sys.float.Body_L'))
                .fontColor($r('sys.color.font_primary'))
                .fontWeight(FontWeight.Medium)
                .margin({ left: 6 });
              Image($r('app.media.ic_right')).width(16).height(16);

            }
            .width('100%')
            .padding(12)
            .justifyContent(FlexAlign.SpaceBetween)
            .borderRadius(16)
            .backgroundColor($r('sys.color.background_primary'))
            .height(61)
            .onClick(() => {
              this.vm.stack.pushPath({ name: UrlMap.FEEDBACK_HISTORY });
            });
          };

        }.padding({ left: 16, right: 16, top: 12 }).constraintSize({ minHeight: '100%' });
      }.scrollBar(BarState.Off).height('100%');
    }
    .title(BuildTitleBar('意见反馈'), { paddingStart: LengthMetrics.vp(16) })
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({ top: WindowUtil.avoidAreaSize.top, bottom: WindowUtil.avoidAreaSize.bottom })
    .onReady((context) => {
      this.vm.setStack(context.pathStack);
    });

  }
}



