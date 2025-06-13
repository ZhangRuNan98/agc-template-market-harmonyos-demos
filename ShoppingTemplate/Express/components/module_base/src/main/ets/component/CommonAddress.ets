import { OrderType, RouterMap, TypeAddressPage } from '../common/Constant';
import { IAddrInfo, IAddrInfoDetail, ParamAddressPage } from '../types';


@ComponentV2
export struct CommonAddress {
  @Param stack: NavPathStack = new NavPathStack();
  @Param isEdit: boolean = true
  @Param sendAddress: IAddrInfo = {
    id: 0,
    name: '',
    cellphone: '',
    province: '',
    city: '',
    area: '',
    detailAddress: '',
    isDefault: false,
  }
  @Param getAddress: IAddrInfo = {
    id: 0,
    name: '',
    cellphone: '',
    province: '',
    city: '',
    area: '',
    detailAddress: '',
    isDefault: false,
  }
  @Event select: (value: OrderType) => void = (value: OrderType) => {
  }
  @Event change: () => void = () => {
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Image($r('app.media.ic_send_address'))
          .width(24)
          .height(28)
          .flexShrink(0)
        this.addressContentBuilder({
          id: this.sendAddress.id,
          name: this.sendAddress.name,
          cellphone: this.sendAddress.cellphone,
          province: this.sendAddress.province,
          city: this.sendAddress.city,
          area: this.sendAddress.area,
          detailAddress: this.sendAddress.detailAddress,
          isDefault: this.sendAddress.isDefault,
          orderType: OrderType.SEND
        })
        this.addressBookBuilder(OrderType.SEND)
      }

      Row() {
        Image($r('app.media.ic_change'))
          .width(24)
          .height(24)
          .onClick(() => {
            this.change()
          })

        Divider().strokeWidth(1).color('rgba(0,0,0,0.20)')
          .margin({ left: 12, right: 12 })
      }
      .margin({ top: 5, bottom: 12, right: 12 })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Image($r('app.media.ic_get_address'))
          .width(24)
          .height(28)
          .flexShrink(0)
        this.addressContentBuilder({
          id: this.getAddress.id,
          name: this.getAddress.name,
          cellphone: this.getAddress.cellphone,
          province: this.getAddress.province,
          city: this.getAddress.city,
          area: this.getAddress.area,
          detailAddress: this.getAddress.detailAddress,
          isDefault: this.getAddress.isDefault,
          orderType: OrderType.RECEIVE
        })

        this.addressBookBuilder(OrderType.RECEIVE)
      }
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      top: 14,
      bottom: 12,
      left: 12,
      right: 12
    })
    .borderRadius(16)
    .backgroundColor(Color.White)
    .margin({ bottom: 16 })
  }

  @Builder
  addressBookBuilder(type: OrderType) {
    Row() {
      Text('地址簿')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_primary'))
    }
    .height(24)
    .padding({ left: 12 })
    .borderWidth({ left: 1 })
    .borderColor('rgba(0,0,0,0.40)')
    .flexShrink(0)
    .onClick(() => {
      if (this.isEdit) {
        this.select(type)
        this.stack.pushPath({ name: RouterMap.ADDRESS_PAGE, param: true })
      }
    })
  }

  @Builder
  addressContentBuilder($$: IAddrInfoDetail) {
    Column() {
      Row() {
        Text($$.name)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
          .margin({ right: 10 })
        Text($$.cellphone)
          .fontSize(14)
          .fontWeight(FontWeight.Regular)
          .fontColor($r('sys.color.font_tertiary'))
      }
      .width('100%')
      .margin({ bottom: 12 })

      Row() {
        Text($$.province + $$.city + $$.area + $$.detailAddress)
          .fontSize(11)
          .fontWeight(FontWeight.Regular)
          .fontColor($r('sys.color.font_secondary'))
      }
      .width('100%')
    }
    .margin({ left: 12, right: 12 })
    .flexGrow(1)
    .onClick(() => {
      if (this.isEdit) {
        this.select($$.orderType)
        const address: IAddrInfo = {
          id: $$.id,
          name: $$.name,
          cellphone: $$.cellphone,
          province: $$.province,
          city: $$.city,
          area: $$.area,
          detailAddress: $$.detailAddress,
          isDefault: $$.isDefault
        }
        if ($$.id === 0) {
          address.name = ''
          address.province = ''
        }
        const param: ParamAddressPage = {
          type: TypeAddressPage.EDIT,
          param: address,
        };
        this.stack.pushPath({ name: RouterMap.EDIT_ADDRESS_PAGE, param: param })
      }
    })
  }
}