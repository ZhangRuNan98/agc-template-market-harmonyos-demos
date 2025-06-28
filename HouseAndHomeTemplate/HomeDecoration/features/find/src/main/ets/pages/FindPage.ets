import { emitter } from '@kit.BasicServicesKit';
import { RouterModule, RouterMap, BaseHeader } from 'commonlib';
import { FilterList, FilterOption, LayoutType } from 'module_filter_list';
import { DesignerDetail, CaseInfo } from 'network';
import { FindPageVM } from '../viewModels/FindPageVM';


@Builder
export function FindPageBuilder() {
  FindPage();
}


@ComponentV2
struct FindPage {
  vm: FindPageVM = FindPageVM.instance;
  callBackFn: () => void = () => {
    this.vm.designerList = [];
    this.vm.getDesignerList();
  };

  aboutToAppear(): void {
    this.vm.getDesignerList();
    emitter.on('CityChange', this.callBackFn);
  }

  aboutToDisappear(): void {
    emitter.off('CityChange', this.callBackFn);
  }

  build() {
    NavDestination() {
      BaseHeader('找设计师');
      FilterList({
        filterOptions: [new FilterOption('设计费', this.vm.feeIndex, this.vm.feeList.map(item => item.des)),
          new FilterOption('擅长空间', this.vm.spaceIndex, ['全部',
            '住宅家居',
            '别墅豪宅'])],
        layoutStyle: LayoutType.SPLIT,
        onchange: (res) => {
          this.vm.feeIndex = res[0].selectIndex;
          this.vm.spaceIndex = res[1].selectIndex;
        },
      }) {
        if (this.vm.designerList.length) {
          List() {
            ForEach(this.vm.designerList, (item: DesignerDetail, index) => {
              ListItem() {
                Column() {
                  Row() {
                    Row({ space: 4 }) {
                      Image($r(`app.media.${item.avatar}`)).width(44).height(44).borderRadius(22);
                      Column({ space: 4 }) {
                        Text(item.name)
                          .fontWeight(FontWeight.Regular)
                          .fontColor($r('sys.color.font_primary'))
                          .fontSize($r('sys.float.Body_M'))
                          .lineHeight(19);
                        Text(item.address).subTextExtend();

                      }.alignItems(HorizontalAlign.Start);
                    };

                    Column({ space: 4 }) {
                      Text(`${item.min}~${item.max}`)
                        .fontWeight(FontWeight.Medium)
                        .fontColor($r('sys.color.alert'))
                        .fontSize($r('sys.float.Body_M'))
                        .lineHeight(19);
                      Text('元/m³').subTextExtend();
                    };
                  }.width('100%').justifyContent(FlexAlign.SpaceBetween).margin({ bottom: 12 });

                  Grid() {
                    ForEach(item.ownerCases, (val: CaseInfo, i) => {
                      if (i <= 2) {
                        GridItem() {
                          Image($r(`app.media.${val.cover}`)).width('100%').height(104).borderRadius(16);
                        };
                      }
                    }, (val: CaseInfo) => val.caseId.toString() + item.address);
                  }.columnsTemplate('1fr 1fr 1fr').columnsGap(8).margin({ bottom: 11 });

                  if (this.vm.designerList.length !== index + 1) {
                    Divider().width('100%').height(1);
                  }

                };
              }.padding({ top: 12 }).onClick(() => {
                RouterModule.push(RouterMap.DESIGNER_PAGE, item);
              });
            }, (item: DesignerDetail) => item.id.toString());

          }.padding({ left: 16, right: 16 }).layoutWeight(1).scrollBar(BarState.Off);
        } else {
          Image($r('app.media.ic_empty')).width(120).margin({ top: 120 });
        }
      };
    }.hideTitleBar(true).backgroundColor($r('sys.color.background_secondary'));
  }
}


@Extend(Text)
function subTextExtend() {
  .fontSize($r('sys.float.Caption_M'))
  .fontWeight(FontWeight.Regular)
  .fontColor($r('sys.color.font_secondary'))
  .lineHeight(13);
}


