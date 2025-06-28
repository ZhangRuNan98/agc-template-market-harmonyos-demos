import { LengthMetrics } from '@kit.ArkUI';
import { RouterModule, RouterMap, BuildTitleBar, WindowUtil } from 'commonlib';
import { CaseInfo } from 'network';
import { SearchKeys } from '../components/SearchKeys';
import { SearchPageVM } from '../viewModels/SearchPageVM';

@Builder
export function SearchPageBuilder() {
  SearchPage();
}


@ComponentV2
struct SearchPage {
  vm: SearchPageVM = SearchPageVM.instance;

  aboutToAppear(): void {
    this.vm.getHotkeys();
  }

  aboutToDisappear(): void {
    this.vm.isSearched = false;
  }

  build() {
    NavDestination() {
      Scroll() {
        Column({ space: 12 }) {
          Search({ placeholder: '请输入关键词', value: this.vm.keywords })
            .searchButton('搜索')
            .onChange((res) => {
              this.vm.keywords = res.trim();
            })
            .defaultFocus(true)
            .onSubmit(() => {
              this.vm.searchCase();
            })
            .onFocus(() => {
              this.vm.isFocus = true;
            })
            .onBlur(() => {
              this.vm.isFocus = false;
            });

          if (this.vm.isFocus || !this.vm.isSearched) {
            if (this.vm.historyInfo.length) {
              SearchKeys({
                title: '历史记录',
                keys: this.vm.historyInfo,
                onKeyClick: (key) => {
                  this.vm.keywords = key;
                  this.vm.searchCase();
                },
              }) {
                Image($r('app.media.ic_public_delete')).width(14).onClick(() => {
                  this.vm.historyInfo = [];
                });
              };
            }
            SearchKeys({
              title: '热门搜索',
              keys: this.vm.hotSearch,
              onKeyClick: (key) => {
                this.vm.keywords = key;
                this.vm.searchCase();
              },
            });
          }

          if (!this.vm.isFocus && this.vm.isSearched) {
            if (this.vm.caseList.length) {
              WaterFlow() {
                ForEach(this.vm.caseList, (item: CaseInfo, index) => {
                  this.flowItemBuilder(item);
                }, (item: CaseInfo) => item.caseId.toString());

              }
              .layoutWeight(1)
              .columnsGap(12)
              .rowsGap(12)
              .columnsTemplate('1fr 1fr')
              .nestedScroll({
                scrollForward: NestedScrollMode.SELF_FIRST,
                scrollBackward: NestedScrollMode.PARENT_FIRST,
              });
            } else {
              Image($r('app.media.ic_empty')).width(120);
            }

          }

        }.padding(16);

      }.width('100%').height('100%').scrollBar(BarState.Off).align(Alignment.Top);
    }
    .title(BuildTitleBar('搜索'), { paddingStart: LengthMetrics.vp(16) })
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({ top: WindowUtil.avoidAreaSize.top, bottom: WindowUtil.avoidAreaSize.bottom });
  }

  @Builder
  flowItemBuilder(item: CaseInfo) {
    FlowItem() {
      Column() {
        Image(item.homeCover ? $r(`app.media.${item.homeCover}`) : $r(`app.media.${item.cover}`))
          .width('100%')
          .borderRadius({
            topLeft: 16,
            topRight: 16,
          });
        Column() {
          if (item.caseType === '1') {
            Text(item.area + '㎡' + '·' + item.homeTypeLabel + '·' + item.price + '万')
              .fontSize($r('sys.float.Body_S'))
              .fontColor($r('sys.color.multi_color_08'))
              .fontWeight(FontWeight.Medium);
          }
          Text(item.title)
            .fontSize($r('sys.float.Body_S'))
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.font_primary'))
            .margin({ top: 8, bottom: 12 });
          Row() {
            Row({ space: 8 }) {
              Image($r(`app.media.${item.designer.avatar}`)).width(16).height(16).borderRadius(8);
              Text(item.designer.name)
                .width(70)
                .fontSize(8)
                .textOverflow({ overflow: TextOverflow.Clip })
                .maxLines(1)
                .fontWeight(FontWeight.Regular)
                .fontColor($r('sys.color.font_secondary'))
                .fontSize($r('sys.float.Caption_M'));
            };

          }.width('100%').justifyContent(FlexAlign.SpaceBetween);
        }.padding({ top: 12, left: 12, bottom: 12 }).alignItems(HorizontalAlign.Start);

      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .borderRadius(16)
      .backgroundColor($r('sys.color.background_primary'));
    }.onClick(() => {
      RouterModule.push(RouterMap.CASE_DETAIL_PAGE, item);
    });
  }
}

