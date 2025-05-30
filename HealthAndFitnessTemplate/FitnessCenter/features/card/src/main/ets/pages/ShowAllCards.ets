import { CardInfo, MockService, SportType } from 'external_interactions';
import { TitleBar } from 'uicomponents';
import { Card } from '../components/Card';
import { SymbolGlyphModifier } from '@kit.ArkUI';
import { JSON } from '@kit.ArkTS';

@Component
export struct ShowAllCards {
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @Prop pathStack: NavPathStack;
  @State showCardList: CardInfo[] = MockService.cardList;
  sportTypeList: SportType[] = [{
    name: '全部',
    typeEnum: 0,
    icon: '',
    advImage: []
  }];
  @State sportSelectIndex: number = 0;
  @State searchWord: string = ''

  build() {
    NavDestination() {
      TitleBar({ title: '本店卡项', pathStack: this.pathStack })
        .margin({ left: 16, right: 16 })
      Scroll() {
        Column() {
          Search({ placeholder: '请输入卡项名称', value: $$this.searchWord })
            .width('100%')
            .backgroundColor('#E5E7E8')
            .placeholderColor($r('sys.color.font_tertiary'))
            .placeholderFont({ size: $r('sys.float.Body_M'), weight: FontWeight.Regular })
            .cancelButton({
              style: CancelButtonStyle.CONSTANT,
              icon: new SymbolGlyphModifier($r('sys.symbol.xmark_circle')).fontColor([Color.Gray])
                .outlineColor(Color.Gray)
            })
            .margin({ bottom: 15 })
            .borderRadius(20)
            .onChange(() => {
              this.showCardList =
                MockService.getCardListBySearch(this.searchWord, this.sportTypeList[this.sportSelectIndex]);
            })

          List({ space: 16 }) {
            ForEach(this.sportTypeList, (item: SportType, index: number) => {
              ListItem() {
                Row() {
                  Text(item.name)
                    .fontSize(14)
                    .fontWeight(this.sportSelectIndex === index ? FontWeight.Bold : FontWeight.Regular)
                }
                .justifyContent(FlexAlign.Center)
                .borderRadius(16)
                .backgroundColor('#E5E7E8')
                .width(60)
                .height(40)
                .onClick(() => {
                  this.sportSelectIndex = index;
                  this.showCardList =
                    MockService.getCardListBySearch(this.searchWord, this.sportTypeList[this.sportSelectIndex]);
                })
              }
            }, (item: SportType) => JSON.stringify(item))
          }
          .listDirection(Axis.Horizontal)
          .scrollBar(BarState.Off)
          .width('100%')
          .height(40)
          .margin({ bottom: 15 })

          Column() {
            Image($r('app.media.no_result'))
              .width(144)
              .height(144)
              .margin({ bottom: 12 })
            Text('未查询到卡项信息')
              .fontSize(14)
              .fontWeight(FontWeight.Regular)
              .fontColor('#999999')
          }
          .height('50%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .visibility(this.showCardList.length > 0 ? Visibility.None : Visibility.Visible)

          Grid() {
            ForEach(this.showCardList, (item: CardInfo) => {
              GridItem() {
                Card({ pathStack: this.pathStack, cardInfo: item })
              }
            }, (item: CardInfo) => JSON.stringify(item))
          }
          .width('100%')
          .columnsTemplate('1fr 1fr')
          .columnsGap(15)
          .rowsGap(15)
          .backgroundColor(Color.White)
          .borderRadius(16)
          .margin({ bottom: 15 })
          .padding(15)
          .visibility(this.showCardList.length > 0 ? Visibility.Visible : Visibility.None)
        }
      }
      .margin({ left: 16, right: 16 })
      .scrollBar(BarState.Off)
    }
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx.pathStack
      this.sportTypeList = this.sportTypeList.concat(MockService.sportTypeList)
    })
    .hideTitleBar(true)
    .padding({ top: px2vp(this.topRectHeight), bottom: px2vp(this.bottomRectHeight)})
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.main_background_color'))
  }
}
