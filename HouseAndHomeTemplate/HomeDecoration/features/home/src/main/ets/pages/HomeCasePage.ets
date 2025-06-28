import { LengthMetrics } from '@kit.ArkUI';
import { BuildTitleBar, RouterMap, RouterModule, WindowUtil } from 'commonlib';
import { FilterList, LayoutType } from 'module_filter_list';
import { CaseInfo } from 'network';
import { HomeCasePageVM } from '../viewModels/HomeCasePageVM';


@Builder
export function HomeCasePageBuilder() {
  HomeCasePage();
}


@ComponentV2
struct HomeCasePage {
  vm: HomeCasePageVM = HomeCasePageVM.instance;

  aboutToAppear(): void {
    this.vm.initData();
    this.vm.getCaseList();
  }

  build() {
    NavDestination() {
      FilterList({
        onchange: (res) => {
          this.vm.styleIndex = res[0].selectIndex;
          this.vm.houseTypeIndex = res[1].selectIndex;
          this.vm.areaIndex = res[2].selectIndex;
          this.vm.priceIndex = res[3].selectIndex;
        },
      }) {
        if (this.vm.caseList.length) {
          List({ space: 16 }) {
            ForEach(this.vm.caseList, (item: CaseInfo) => {
              ListItem() {
                Column() {
                  Image($r(`app.media.${item.cover}`)).width('100%').height(140).borderRadius(16);
                  Row() {
                    Column({ space: 4 }) {
                      Text(item.title)
                        .fontSize($r('sys.float.Body_M'))
                        .fontWeight(FontWeight.Regular)
                        .fontColor($r('sys.color.font_primary'))
                        .lineHeight(19);
                      Text(`${item.area}㎡ / ${item.style} / ${item.homeTypeLabel} / ${item.detail.length}张图`)
                        .fontSize($r('sys.float.Caption_M'))
                        .fontWeight(FontWeight.Regular)
                        .fontColor($r('sys.color.font_tertiary'))
                        .lineHeight(13);
                    }.layoutWeight(1).padding({ right: 15, top: 4 }).alignItems(HorizontalAlign.Start);

                    Image($r(`app.media.${item.designer.avatar}`)).width(44).height(44).margin({ top: 8 });

                  }.width('100%').alignItems(VerticalAlign.Top);
                };
              }.onClick(() => {
                RouterModule.push(RouterMap.CASE_DETAIL_PAGE, item);
              });
            }, (item: CaseInfo) => item.caseId.toString());

          }.scrollBar(BarState.Off).layoutWeight(1).padding({ left: 16, right: 16 });
        } else {
          Image($r('app.media.ic_empty')).width(120);
        }
      };
    }
    .title(BuildTitleBar('家装案例'), { paddingStart: LengthMetrics.vp(16) })
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({ top: WindowUtil.avoidAreaSize.top, bottom: WindowUtil.avoidAreaSize.bottom });
  }
}

