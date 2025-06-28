import { LengthMetrics } from '@kit.ArkUI';
import { BuildTitleBar, WindowUtil } from 'commonlib';
import { ProjectItem, PriceInfo, PriceListItem } from 'network';
import { ListPageVM } from '../viewModels/ListPageVM';


@Builder
export function ListPageBuilder() {
  ListPage();
}


@ComponentV2
struct ListPage {
  vm: ListPageVM = ListPageVM.instance;

  aboutToAppear(): void {
    this.vm.getDecorationInfo();
    this.vm.getPriceInfo();
  }

  build() {
    NavDestination() {
      Scroll() {
        Column({ space: 12 }) {
          Row({ space: 8 }) {
            Text(this.vm.decorationInfo?.address).titleExtend();
            Divider().vertical(true);
            Text(this.vm.decorationInfo?.area + '㎡').titleExtend();
            Divider().vertical(true);
            Text(this.vm.decorationInfo?.homeType === '0' ? '高层' : '混砖').titleExtend();
          }.height(19).width('100%');

          Column({ space: 8 }) {
            Row({ space: 4 }) {
              Image($r('app.media.form_home_type')).width(16);
              Text(`${this.vm.decorationInfo?.room}室` +
                ` ${this.vm.decorationInfo?.hall}厅` +
                ` ${this.vm.decorationInfo?.kitchen}厨` +
                ` ${this.vm.decorationInfo?.washroom}卫` +
                ` ${this.vm.decorationInfo?.balcony}阳台`)
                .titleExtend();
            };

            Row() {
              Text('主材：' + this.vm.priceInfo?.mainMember).mainTextExtend();
              Text('辅材：' + this.vm.priceInfo?.assistant).mainTextExtend();
              Text('人工：' + this.vm.priceInfo?.mainMember).mainTextExtend();
            }.width('100%').justifyContent(FlexAlign.SpaceBetween);

            Row({ space: 4 }) {
              Image($r('app.media.ic_warming')).width(10);
              Text('报价来自系统估算，实际价格以量房为准')
                .fontWeight(FontWeight.Regular)
                .fontSize($r('sys.float.Caption_M'))
                .fontColor($r('sys.color.font_tertiary'));
            };
          }.wrapExtend();

          Column() {
            List({space:12}) {
              ForEach(this.vm.priceInfo?.priceList, (val: PriceListItem) => {
                ListItem() {
                  Column({ space: 8 }) {
                    Text(val.label).titleExtend();
                    Column({ space: 12 }) {
                      Row() {
                        ForEach(this.vm.priceLabels, (item: string) => {
                          Text(item)
                            .width(53)
                            .fontSize($r('sys.float.Body_S'))
                            .fontWeight(FontWeight.Regular)
                            .fontColor($r('sys.color.font_secondary'));
                        }, (item: string) => item);
                      }.width('100%').justifyContent(FlexAlign.SpaceBetween);

                      ForEach(val.details, (item: ProjectItem) => {
                        Row() {
                          Text(item.name).width(53).contentTextExtend();
                          Text(item.quantity + '㎡').width(53).contentTextExtend();
                          Text(item.price + '元/㎡').width(53).contentTextExtend();
                          Text(item.total + '元').width(53).contentTextExtend();
                        }.width('100%').justifyContent(FlexAlign.SpaceBetween);

                      }, (item: ProjectItem) => item.name);

                    }.backgroundColor($r('sys.color.background_secondary')).padding(12).borderRadius(16);

                  }.width('100%').alignItems(HorizontalAlign.Start);
                };

              }, (val: PriceListItem, i) => val.label);

            };

          }.wrapExtend();

        };

      }.align(Alignment.Top).scrollBar(BarState.Off).height('100%').padding({ left: 16, right: 16, top: 12 });
    }
    .title(BuildTitleBar('报价清单'), { paddingStart: LengthMetrics.vp(16) })
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({top:WindowUtil.avoidAreaSize.top,bottom:WindowUtil.avoidAreaSize.bottom})
  }
}

@Extend(Text)
function contentTextExtend() {
  .width(53).fontSize($r('sys.float.Body_S')).fontWeight(FontWeight.Regular).fontColor($r('sys.color.font_primary'));
}

@Extend(Column)
function wrapExtend() {
  .padding(12).alignItems(HorizontalAlign.Start).backgroundColor($r('sys.color.background_primary')).borderRadius(16);
}

@Extend(Text)
function titleExtend() {
  .fontColor($r('sys.color.font_primary')).fontWeight(FontWeight.Medium).fontSize($r('sys.float.Body_M'));
}


@Extend(Text)
function mainTextExtend() {
  .fontColor($r('sys.color.font_primary')).fontWeight(FontWeight.Regular).fontSize($r('sys.float.Body_M'));
}