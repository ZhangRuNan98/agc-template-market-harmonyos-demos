import { CommonConstants } from 'lib_common';
import { AuthorModel } from 'lib_news_api';
import { emptyBuilder } from 'lib_widget';
import { FollowerPageViewModel } from '../viewmodels/FollowerPageVM';
import { WatchPageViewModel } from '../viewmodels/WatchPageVM';
import { AuthorItem } from './AuthorItem';

@ComponentV2
export struct BaseFollowWatchPage {
  @Require @Param vm: FollowerPageViewModel | WatchPageViewModel;

  build() {
    Column() {
      if (this.vm.dataSource.totalCount() > 0) {
        List({ space: CommonConstants.SPACE_M }) {
          LazyForEach(this.vm.dataSource, (v: AuthorModel) => {
            ListItem() {
              AuthorItem({
                author: v,
                fontSizeRatio: this.vm.settingInfo.fontSizeRatio,
              })
            }
            .padding({
              top: CommonConstants.PADDING_M,
              bottom: CommonConstants.PADDING_M,
            })
          }, (v: AuthorModel) => v.authorId)
          ListItem() {
            Text('--到底啦--')
              .fontSize($r('sys.float.Body_S'))
              .fontColor($r('sys.color.font_secondary'))
              .width(CommonConstants.FULL_PERCENT)
              .textAlign(TextAlign.Center)
          }
        }
        .width(CommonConstants.FULL_PERCENT)
        .height(CommonConstants.FULL_PERCENT)
        .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
        .cachedCount(1)
        .padding({
          left: CommonConstants.PADDING_PAGE,
          right: CommonConstants.PADDING_PAGE,
          top: CommonConstants.SPACE_M,
          bottom: this.vm.windowModel.windowBottomPadding,
        })
        .onReachEnd(() => {
          this.vm.loadMore();
        })
      } else {
        Column() {
          emptyBuilder({
            text: this.vm.emptyTip,
            fontSizeRatio: this.vm.settingInfo.fontSizeRatio,
          })
        }
        .layoutWeight(1)
        .padding({
          bottom: 100,
        })
      }
    }
    .layoutWeight(1)
  }
}