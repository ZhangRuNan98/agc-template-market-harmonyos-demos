import { OrderSkuDto } from '../http/Type';
import { iResourceMgr } from 'lib_foundation';

export enum OrderType {
  ALL = 0,
  PENDING_PAY = 1,
  PENDING_SEND = 2,
  PENDING_GET = 3,
  SUCCESS = 4,
  CANCEL = 5,
  REFUND = 6,
}

@Builder
export function buildSkuCard(sku: OrderSkuDto) {
  Row() {
    Image(iResourceMgr.resolveUri(sku.banner))
      .width(65)
      .height(65)
      .draggable(false)
      .objectFit(ImageFit.Cover)
      .borderRadius(7)
      .margin({ right: 10 })
      .backgroundColor('#90E5E7E9')
    Column() {
      Row() {
        Text(sku.title)
          .layoutWeight(1)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontSize(14)
          .fontColor($r('sys.color.mask_secondary'))
        Text() {
          Span('¥')
            .fontSize(13)
          Span(sku.price.toString())
            .fontSize(13)
        }
        .fontColor($r('sys.color.mask_secondary'))
        .margin({ left: 8 })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      if (sku.oldPrices) {
        Row() {
          Text('￥' + sku.oldPrices.toString())
            .fontSize(12)
            .fontColor($r('sys.color.font_tertiary'))
            .decoration({ type: TextDecorationType.LineThrough })
        }
        .width('100%')
        .justifyContent(FlexAlign.End)
      }

      Row() {
        Text(sku.skuDesc)
          .layoutWeight(1)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontColor($r('sys.color.mask_tertiary'))
          .fontSize(12)
        Text('x' + sku.count)
          .fontColor($r('sys.color.mask_tertiary'))
          .fontSize(12)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .height(65)
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.SpaceBetween)
  }
  .width('100%')
  .margin({ top: 13 })
}