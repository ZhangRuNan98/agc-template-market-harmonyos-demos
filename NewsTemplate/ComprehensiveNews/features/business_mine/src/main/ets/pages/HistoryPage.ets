import { CommonConstants } from 'lib_common';
import { NewsModel } from 'lib_news_api';
import { emptyBuilder, NavHeaderBar } from 'lib_widget';
import { UniformNewsCard } from '../components/UniformNewsCard';
import { HistoryViewModel } from '../viewmodels/HistoryVM';

@Builder
export function HistoryPageBuilder() {
  HistoryPage()
}

@ComponentV2
struct HistoryPage {
  @Local vm: HistoryViewModel = new HistoryViewModel();

  build() {
    NavDestination() {
      Column() {
        NavHeaderBar({
          title: '历史',
          rightPartBuilder: () => {
            this.rightPartBuilder()
          },
        })
        Column() {
          List({ space: CommonConstants.SPACE_M }) {
            ForEach(this.vm.list, (v: NewsModel) => {
              ListItem() {
                Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
                  Row() {
                    Checkbox()
                      .width($r('app.float.normal_img_size'))
                      .select(false)
                      .shape(CheckBoxShape.CIRCLE)
                      .selectedColor($r('sys.color.warning'))
                      .onChange((value: boolean) => {
                        this.vm.onChange(value, v);
                      })
                  }
                  .padding({
                    right: CommonConstants.PADDING_L,
                  })
                  .visibility(this.vm.isEditMode ? Visibility.Visible : Visibility.None)

                  this.contentItemBuilder(v)
                }
              }
            }, (v: NewsModel) => v.id)
          }
          .width(CommonConstants.FULL_PERCENT)
          .layoutWeight(1)
          .scrollBar(BarState.Off)
          .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
          .padding({
            left: CommonConstants.PADDING_PAGE,
            right: CommonConstants.PADDING_PAGE,
            top: CommonConstants.SPACE_M,
            bottom: CommonConstants.SPACE_M,
          })

          if (this.vm.isEditMode) {
            this.toolBarBuilder()
          }
        }
        .layoutWeight(1)
        .visibility(this.vm.list.length ? Visibility.Visible : Visibility.None)

        Column() {
          emptyBuilder({
            fontSizeRatio: this.vm.settingInfo.fontSizeRatio,
          })
        }
        .layoutWeight(1)
        .visibility(this.vm.list.length ? Visibility.None : Visibility.Visible)
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .padding({
        bottom: this.vm.windowModel.windowBottomPadding,
      })
    }
    .hideTitleBar(true)
    .onBackPressed(() => {
      return this.vm.onBackPressed();
    })
  }

  @Builder
  contentItemBuilder(v: NewsModel) {
    Row() {
      UniformNewsCard({
        newsInfo: v,
        showAuthorInfoTop: true,
        showAuthorInfoBottom: false,
        customStyle: {
          bodyFg: 16 * this.vm.settingInfo.fontSizeRatio,
        },
      })
    }
    .width(CommonConstants.FULL_PERCENT)
    .padding({
      top: CommonConstants.PADDING_M,
      bottom: CommonConstants.PADDING_M,
    })
  }

  @Builder
  rightPartBuilder() {
    Row() {
      Image(this.vm.isEditMode ? $r('app.media.ic_close') : $r('app.media.ic_public_trash'))
        .width($r('app.float.large_img_size'))
        .aspectRatio(1)
        .draggable(false)
        .enabled(this.vm.allowEnterEdit)
        .fillColor(this.vm.allowEnterEdit ? $r('sys.color.font_primary') : $r('sys.color.font_secondary'))
        .onClick(() => {
          if (this.vm.isEditMode) {
            this.vm.quitEdit();
          } else {
            this.vm.enterEdit();
          }
        })
    }
    .layoutWeight(1)
    .justifyContent(FlexAlign.End)
  }

  @Builder
  toolBarBuilder() {
    Row() {
      Column({ space: CommonConstants.SPACE_XS }) {
        Image($r('app.media.ic_public_eraser'))
          .width($r('app.float.normal_img_size'))
          .aspectRatio(1)
          .draggable(false)
          .fillColor($r('sys.color.font_primary'))
        Text('一键清空')
          .fontSize(10 * this.vm.settingInfo.fontSizeRatio)
          .fontColor($r('sys.color.font_primary'))
      }
      .width(CommonConstants.HALF_PERCENT)
      .padding(CommonConstants.PADDING_XS)
      .onClick(() => {
        this.vm.deleteAllConfirm();
      })

      Column({ space: CommonConstants.SPACE_XS }) {
        Image($r('app.media.ic_public_delete'))
          .width($r('app.float.normal_img_size'))
          .aspectRatio(1)
          .draggable(false)
          .fillColor(this.vm.allowDelete ? $r('sys.color.font_primary') : $r('sys.color.font_secondary'))
        Text('删除')
          .fontSize(10 * this.vm.settingInfo.fontSizeRatio)
          .fontColor(this.vm.allowDelete ? $r('sys.color.font_primary') : $r('sys.color.font_secondary'))
      }
      .width(CommonConstants.HALF_PERCENT)
      .padding(CommonConstants.PADDING_XS)
      .enabled(this.vm.allowDelete)
      .onClick(() => {
        this.vm.deleteConfirm();
      })
    }
    .width(CommonConstants.FULL_PERCENT)
  }
}