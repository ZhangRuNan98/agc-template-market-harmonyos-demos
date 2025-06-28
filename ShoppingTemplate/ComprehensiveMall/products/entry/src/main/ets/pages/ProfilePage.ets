import { promptAction } from '@kit.ArkUI';
import { iData, routerStack, CallButton, RouterMap, Style } from 'lib_foundation';
import { promptLogin } from 'module_login';
import { AddressManage } from 'module_address_manage';

@ComponentV2
export struct ProfilePage {
  build(): void {
    Scroll() {
      Stack({ alignContent: Alignment.TopStart }) {
        Column()
          .width('100%')
          .height('40%')
          .linearGradient({
            colors: [['#30E64566', 0], ['#00E64566', 1.0]],
          })
          .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.TOP])
        Column() {
          Column() {
            Text('我的')
              .fontSize(24)
              .fontColor('#E6000000')
              .fontWeight(600)
              .margin({ left: 12 })
          }
          .width('100%')
          .height(56)
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
          buildUserInfoArea();
          buildOrderInfoArea();
          buildMenuArea();
        }
        .width('100%')
        .padding({ left: 12, right: 12, bottom: Style.BOTTOM_NAV_HEIGHT })
      }
      .width('100%')
      .constraintSize({ minHeight: '100%' })
    }
    .height('100%')
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.None)
    .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.TOP])
  }
}

@Builder
export function buildProfilePage() {
  ProfilePage()
}

@Builder
function buildUserInfoArea() {
  Column() {
    Row() {
      Image(iData.global.userInfo.avatar ? iData.global.userInfo.avatar : $r('app.media.default_avatar_v2'))
        .width(48)
        .height(48)
        .borderRadius(48)
        .draggable(false)
        .margin({ right: 16 })
      Column() {
        Text(iData.global.isLogin ?
          iData.global.userInfo.nickname ? iData.global.userInfo.nickname : '华为用户' :
          '未登录'
        )
          .width('100%')
          .fontWeight(600)
          .fontSize(18)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .textAlign(TextAlign.Start)
          .fontColor('#E6000000')
        Row() {
          if (iData.global.isLogin) {
            Image($r('app.media.ic_mobile_phone'))
              .height(16)
              .objectFit(ImageFit.Contain)
              .draggable(false)
              .margin({ right: 8 })
            Text(iData.global.userInfo.anonymousPhone)
              .layoutWeight(1)
              .fontSize(12)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontColor($r('sys.color.mask_secondary'))
          } else {
            Text('登录后享受更多服务')
              .width('100%')
              .fontSize(12)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontColor('#E6000000')
          }
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
      }
      .layoutWeight(1)
      .height(48)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ top: 3, bottom: 3 })

      if (!iData.global.isLogin) {
        Image($r('app.media.ic_left_arrow'))
          .height(14)
          .objectFit(ImageFit.Contain)
          .rotate({ angle: 180 })
          .fillColor($r('sys.color.mask_tertiary'))
          .draggable(false)
      }
    }
    .width('100%')
    .height(72)
    .backgroundColor(Color.White)
    .borderRadius(16)
    .padding(12)
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      if (!iData.global.isLogin) {
        promptLogin();
      } else {
        routerStack.pushPath({ name: RouterMap.USER_PROFILE_EDIT });
      }
    })
  }
  .margin({ top: 12 })
  .padding({ left: 4, right: 4 })
}

@Builder
function buildOrderInfoArea() {
  Column() {
    Row() {
      Text('我的订单')
        .fontSize(14)
        .fontWeight(600)
        .fontColor('#E6000000')
      Row() {
        Text('全部')
          .fontColor($r('sys.color.mask_tertiary'))
          .fontSize(12)
        Image($r('app.media.ic_left_arrow'))
          .height(12)
          .objectFit(ImageFit.Contain)
          .rotate({ angle: 180 })
          .fillColor($r('sys.color.mask_tertiary'))
          .draggable(false)
      }
      .onClick(() => {
        if (!iData.global.isLogin) {
          promptLogin();
          return;
        }
        routerStack.pushPathByName(RouterMap.ORDER_LIST, 0);
      })
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .padding({ left: 16, right: 16 })

    Row() {
      buildOrderTab($r('app.media.ic_order_pending_payment'), '待付款', 1);
      buildOrderTab($r('app.media.ic_order_pending_shipment'), '待发货', 2);
      buildOrderTab($r('app.media.ic_order_pending_receipt'), '待收货', 3);
      buildOrderTab($r('app.media.ic_order_pending_review'), '待评价', 4);
      buildOrderTab($r('app.media.ic_order_refund_after_sale'), '退款/售后', 6);
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      left: 18,
      right: 18,
      bottom: 20,
      top: 6,
    })
  }
  .width('100%')
  .borderRadius(8)
  .backgroundColor(Color.White)
  .margin({ top: 12 })
}

@Builder
function buildMenuArea() {
  Column() {
    AddressManage({
      navPathStack: routerStack,
      onBeforeNavigate: () => {
        if (!iData.global.isLogin) {
          promptLogin();
          return false;
        }
        return true;
      },
    }) {
      Row() {
        Image($r('app.media.ic_address_mgr'))
          .draggable(false)
          .height(18)
          .objectFit(ImageFit.Contain)
          .margin({ right: 10 })
        Row() {
          Text('地址管理')
            .fontSize(12)
            .fontColor($r('sys.color.mask_secondary'))
          Image($r('app.media.ic_left_arrow'))
            .height(18)
            .objectFit(ImageFit.Contain)
            .rotate({ angle: 180 })
            .fillColor($r('sys.color.mask_tertiary'))
            .draggable(false)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .height(50)
    }

    CallButton() {
      Row() {
        Image($r('app.media.ic_call_center'))
          .draggable(false)
          .height(18)
          .objectFit(ImageFit.Contain)
          .margin({ right: 10 })
        Row() {
          Text('联系客服')
            .fontSize(12)
            .fontColor($r('sys.color.mask_secondary'))
          Image($r('app.media.ic_left_arrow'))
            .height(18)
            .objectFit(ImageFit.Contain)
            .rotate({ angle: 180 })
            .fillColor($r('sys.color.mask_tertiary'))
            .draggable(false)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .height(50)
    }

    Row() {
      Image($r('app.media.ic_setting'))
        .draggable(false)
        .height(18)
        .objectFit(ImageFit.Contain)
        .margin({ right: 10 })
      Row() {
        Text('设置')
          .fontSize(12)
          .fontColor($r('sys.color.mask_secondary'))
        Image($r('app.media.ic_left_arrow'))
          .height(18)
          .objectFit(ImageFit.Contain)
          .rotate({ angle: 180 })
          .fillColor($r('sys.color.mask_tertiary'))
          .draggable(false)
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .height(50)
    .onClick(() => routerStack.pushPathByName(RouterMap.SETTING, null))
  }
  .width('100%')
  .borderRadius(8)
  .backgroundColor(Color.White)
  .margin({ top: 12 })
  .padding({ left: 12, right: 12 })
}

@Builder
function buildOrderTab(icon: ResourceStr, label: string, type: number) {
  Column() {
    Image(icon)
      .width(20)
      .height(20)
      .objectFit(ImageFit.Cover)
      .fillColor($r('sys.color.mask_secondary'))
      .margin({ bottom: 4 })
    Text(label)
      .fontSize(10)
      .fontWeight(FontWeight.Medium)
      .fontColor($r('sys.color.mask_secondary'))
  }
  .alignItems(HorizontalAlign.Center)
  .justifyContent(FlexAlign.Start)
  .onClick(() => {
    if (type === -1) {
      promptAction.showToast({ message: '您可以按照自身业务逻辑接入评论中心' });
    } else if (!iData.global.isLogin) {
      promptLogin();
    } else {
      routerStack.pushPathByName(RouterMap.ORDER_LIST, type);
    }
  })
}
