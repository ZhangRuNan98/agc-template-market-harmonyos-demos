import { AvoidArea, CommonConstants, LeftReturnComponent, TitleBar } from '@ohos_agcit/common_component';
import { AppStorageV2, router } from '@kit.ArkUI';
import { MessageItem, MessageDetail } from 'message_manager';


@Entry
@ComponentV2
export struct MessageDetailView {
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  @Local message:MessageItem | undefined = undefined;

  aboutToAppear(): void {
   const message:MessageItem = router.getParams() as MessageItem ;
   this.message = message;
  }
  build() {
    Column() {
      Row() {
        LeftReturnComponent()
          .onClick(() => {
            router.back();
          });
        TitleBar({ text: '我的收藏' });
      }
      .height(56)
      .alignItems(VerticalAlign.Center)
      .width(CommonConstants.FULL_WIDTH)
      .alignItems(VerticalAlign.Center);

       MessageDetail({
         message: this.message
       })
    }
    .width(CommonConstants.FULL_WIDTH)
    .padding({
      top: px2vp(this.avoidArea.topRectHeight),
      left:16,
      right:16,
      bottom:28
    })
  }
}