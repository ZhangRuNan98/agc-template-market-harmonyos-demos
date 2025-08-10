import { CommonConstants } from 'lib_common';
import { FlexLayoutPage } from 'lib_flex_layout';
import { NewsEnum, RequestListData } from 'lib_news_api';
import { emptyBuilder, NavHeaderBar } from 'lib_widget';
import { LayoutNewsDataSource } from '../common/NewsDataSource';
import { TabBar } from '../components/TabBar';
import { UserIntro } from '../components/UserIntro';
import { UniformNews } from '../components/UniformNews';
import { PersonalPageViewModel } from '../viewmodels/PersonalHomeVM';

@Builder
export function PersonalHomePageBuilder() {
  PersonalHomePage()
}

@ComponentV2
struct PersonalHomePage {
  @Local vm: PersonalPageViewModel = new PersonalPageViewModel();

  aboutToAppear(): void {
    this.vm.init();
  }

  build() {
    NavDestination() {
      Column() {
        NavHeaderBar({
          title: this.vm.titleText,
          rightPartBuilder: () => {
            this.rightPartBuilder()
          },
        })
        Refresh({ refreshing: $$this.vm.loading }) {
          Scroll() {
            Column({ space: CommonConstants.SPACE_M }) {
              UserIntro({
                userInfo: this.vm.userInfo!,
                fontSizeRatio: this.vm.settingInfo.fontSizeRatio,
                refreshProfileHomePage: () => {
                  this.vm.queryAuthorInfo()
                },
              })
              this.contentBuilder()
            }
          }
          .width(CommonConstants.FULL_PERCENT)
          .height(CommonConstants.FULL_PERCENT)
          .scrollBar(BarState.Off)
          .align(Alignment.Top)
          .edgeEffect(EdgeEffect.None)
          .onReachEnd(() => {
            this.vm.titleText = this.vm.userInfo?.authorNickName || '';
          })
          .onReachStart(() => {
            this.vm.titleText = '';
          })
        }
        .layoutWeight(1)
        .onRefreshing(() => {
          this.vm.onRefreshing();
        })
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
    }
    .hideTitleBar(true)
    .linearGradient({
      direction: GradientDirection.Bottom,
      repeating: false,
      colors: [[$r('app.color.profile_bg1'), 0.0], [$r('app.color.profile_bg2'), 1]],
    })
  }

  @Builder
  contentBuilder() {
    Column() {
      TabBar({
        selectedId: this.vm.targetIndex,
        fontSizeRatio: this.vm.settingInfo.fontSizeRatio,
        onClickBar: (id: number) => {
          this.vm.curIndex = id;
          this.vm.targetIndex = id;
        },
      })
      Tabs({ index: this.vm.curIndex }) {
        ForEach(this.vm.dataSource, (v: LayoutNewsDataSource, index: number) => {
          TabContent() {
            if (v.totalCount() > 0) {
              this.listBuilder(v, index)
            } else {
              Column() {
                emptyBuilder({
                  fontSizeRatio: this.vm.settingInfo.fontSizeRatio,
                })
              }
              .layoutWeight(1)
              .padding({
                bottom: 150,
              })
            }
          }
        }, (v: LayoutNewsDataSource, index: number) => index.toString())
      }
      .width(CommonConstants.FULL_PERCENT)
      .layoutWeight(1)
      .align(Alignment.Top)
      .barHeight(0)
      .onAnimationStart((index: number, targetIndex: number) => {
        this.vm.targetIndex = targetIndex;
      })
      .onChange((index: number) => {
        this.vm.curIndex = index;
      })
    }
    .alignItems(HorizontalAlign.Start)
    .backgroundColor($r('sys.color.comp_background_primary'))
    .borderRadius({ topLeft: $r('app.float.xxl_radius'), topRight: $r('app.float.xxl_radius') })
    .padding({
      left: CommonConstants.PADDING_PAGE,
      right: CommonConstants.PADDING_PAGE,
      bottom: this.vm.windowModel.windowBottomPadding,
    })
  }

  @Builder
  listBuilder(v: LayoutNewsDataSource, index: number) {
    List() {
      LazyForEach(v, (item: RequestListData) => {
        ListItem() {
          if ([NewsEnum.Article, NewsEnum.Video].includes(index)) {
            UniformNews({
              newsInfo: item.articles[0],
              fontSizeRatio: this.vm.settingInfo.fontSizeRatio,
            })
          } else {
            FlexLayoutPage({
              setting: JSON.parse(item.navInfo.setting),
              articles: item.articles,
              extraInfo: item.extraInfo,
            })
          }
        }
      }, (item: RequestListData) => JSON.stringify(item))
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .cachedCount(1)
    .align(Alignment.Top)
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.None)
    .nestedScroll({
      scrollForward: NestedScrollMode.PARENT_FIRST,
      scrollBackward: NestedScrollMode.SELF_FIRST,
    })
  }

  @Builder
  rightPartBuilder() {
    Row() {
      Image($r('app.media.ic_email'))
        .width($r('app.float.large_img_size'))
        .aspectRatio(1)
        .draggable(false)
        .visibility(this.vm.isMyself ? Visibility.None : Visibility.Visible)
        .onClick(() => {
          this.vm.jumpChatPage();
        })
    }
    .layoutWeight(1)
    .justifyContent(FlexAlign.End)
  }
}