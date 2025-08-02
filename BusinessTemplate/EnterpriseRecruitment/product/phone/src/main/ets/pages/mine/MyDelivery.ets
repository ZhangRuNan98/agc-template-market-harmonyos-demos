import {
  AvoidArea,
  CommonConstants,
  DeliveryDatabase,
  DeliveryDetail,
  deliveryDetailData,
  DeliveryRecord,
  JobListItem,
  LeftReturnComponent,
  TitleBar,
} from '@ohos_agcit/common_component';
import { AppStorageV2, PersistenceV2, router } from '@kit.ArkUI';
import { UISteps, Direction, OptionsModel } from 'ui_steps';


@Entry
@ComponentV2
export struct MyDelivery {
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  @Local deliveryDatabase: DeliveryDatabase =
    PersistenceV2.connect(DeliveryDatabase, () => new DeliveryDatabase())!;
  @Local isSubscribe: boolean = this.deliveryDatabase.isSubscribe;

  aboutToAppear(): void {
    for (let i = 0; i < this.deliveryDatabase.deliveryList.length; i++) {
      let index = i % deliveryDetailData.length;
      this.deliveryDatabase.deliveryList[i].deliveryDetailId = index+'';
    }
  }

  build() {
    Column() {
      Scroll(){
        Column(){
          Row() {
            LeftReturnComponent()
              .onClick(() => {
                router.back();
              });
            TitleBar({ text: '投递记录' });
          }
          .height(56)
          .alignItems(VerticalAlign.Center)
          .width(CommonConstants.FULL_WIDTH)
          .alignItems(VerticalAlign.Center);

          List({ space: 12 }) {
            ForEach(this.deliveryDatabase.deliveryList, (item: DeliveryRecord) => {
              JobDeliveryCard({ deliveryInfo: item });
            }, (item: DeliveryRecord) => JSON.stringify(item));
          }
          .scrollBar(BarState.Off)
          .edgeEffect(EdgeEffect.Spring)
          .padding({ top: 10 })
          .height('83%')
          .width('100%');

          Flex({ direction: FlexDirection.Column,
            justifyContent: FlexAlign.SpaceEvenly, alignItems: ItemAlign.Center }) {
            if (!this.isSubscribe) {
              Text('订阅流程状态')
                .fontColor(Color.White)
                .fontSize($r('app.float.font_size_16'))
                .fontWeight(CommonConstants.FONT_WEIGHT_600);

              Text('授权后可收到面试邀约')
                .fontColor(Color.White)
                .fontSize($r('app.float.font_size_14'))
                .fontWeight(CommonConstants.FONT_WEIGHT_500);
            } else {
              Text('已订阅')
                .fontColor(Color.White)
                .fontSize($r('app.float.font_size_16'))
                .fontWeight(CommonConstants.FONT_WEIGHT_600);
            }
          }
          .backgroundColor($r('app.color.common_blue'))
          .borderRadius(24)
          .height(50)
          .width('100%')
          .onClick(() => {
            this.isSubscribe = true;
            this.deliveryDatabase.isSubscribe = true;
          })
          .margin({
            bottom: 10
          })
        }
      }
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
    }
    .height('100%')
    .backgroundColor($r('app.color.common_background'))
    .padding({
      top: px2vp(this.avoidArea.topRectHeight),
      left: '4%',
      right: '4%',
    });
  }
}

@ComponentV2
struct JobDeliveryCard {
  @Param @Require deliveryInfo: DeliveryRecord;
  @Local isShow: boolean = false;
  jobInfo: JobListItem | undefined = undefined;

  private deliveryDetail: DeliveryDetail = {id: '', active: -1, optionArray: []};

  aboutToAppear(): void {
    this.jobInfo = CommonConstants.JOB_LIST_MAP.get(this.deliveryInfo.jobId);
    this.deliveryDetail = this.findDeliveryDetail(this.deliveryInfo.deliveryDetailId);
  }

  build() {
    if (this.jobInfo !== undefined) {
      Column() {
        // title
        Row() {
          Text(this.jobInfo?.name)
            .fontSize($r('app.float.font_size_18'))
            .fontWeight(FontWeight.Medium)
            .fontColor('rgba(0,0,0,0.90)')
          Blank();
          Text(this.getDeliveryTitle(this.deliveryDetail.optionArray))
            .fontSize(10)
            .fontColor(this.getDeliveryTitle(this.deliveryDetail.optionArray) ===
              '流程结束' ? 'rgba(0,0,0,0.90)' : '#376BFC')
            .backgroundColor(this.getDeliveryTitle(this.deliveryDetail.optionArray) ===
              '流程结束' ? 'rgba(0,0,0,0.05)' : 'rgba(55,107,252,0.10)')
            .borderRadius(4)
            .padding({
              left: 4,
              right: 4,
              top: 2,
              bottom: 2
            })
        }
        .width('100%');

        Row() {
          // desc
          Column() {
            this.SimpleText('职位类型：' + this.jobInfo.jobType);
            this.SimpleText('工作地点：' + CommonConstants.ADDRESS_MAP.get(this.jobInfo.address));
            this.SimpleText('投递时间：' + this.deliveryInfo.submitTime);
          }
          .margin({ top: 8 })
          .width('90%')
          .alignItems(HorizontalAlign.Start);

          Row() {
            SymbolGlyph($r('sys.symbol.chevron_right'))
              .fontSize(24);
          }
          .width('10%')
          .justifyContent(FlexAlign.End);
        }
        .width('100%');
      }
      .borderRadius(20)
      .backgroundColor(Color.White)
      .padding({
        left: 12,
        right: 12,
        top: 16,
        bottom: 16,
      })
      .height(138)
      .width('100%')
      .onClick(() => {
        this.isShow = !this.isShow;
      })
      .bindSheet($$this.isShow, this.showDeliverySheet(), {
        title: { title: '投递详情' },
        height: 650,
        width: '100%',
      });
    }
  }

  getDeliveryTitle(optionArray : Array<OptionsModel>): string{
    let option = optionArray.find(item => item.isPassed === false);
    if (option !== undefined) {
      return option.title;
    }
    option = optionArray.find(item => item.isPassed === undefined);
    if (option !== undefined) {
      return option.title;
    }

    return optionArray[optionArray.length - 1].title;
  }

  @Builder
  showDeliverySheet() {
    Column() {
      Column({ space: 8 }) {
        Text(this.jobInfo?.name)
          .fontSize(16)
          .fontColor('rgba(0,0,0,0.90)')
          .fontWeight(FontWeight.Medium);
        Text(`项       目：` + CommonConstants.RECRUITMENT_COLLECTION
          .find(item => item.index === this.jobInfo?.recruitmentType)?.title)
          .fontSize(12)
          .fontColor('rgba(0,0,0,0.90)');
        Text(`职位类型：${this.jobInfo?.jobType}`)
          .fontSize(12)
          .fontColor('rgba(0,0,0,0.90)');
        Text('工作地点：' + CommonConstants.ADDRESS_MAP.get(this.jobInfo?.address))
          .fontSize(12)
          .fontColor('rgba(0,0,0,0.90)');
        Text(`投递时间：${this.deliveryInfo.submitTime}`)
          .fontSize(12)
          .fontColor('rgba(0,0,0,0.90)');
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .padding({
        left: '5%',
        top: 16,
        bottom: 16,
      });

      Divider()
        .width('90%');

      Column() {
        UISteps({
          active: this.deliveryDetail.active,
          options: this.deliveryDetail.optionArray,
          directionSteps: Direction.COLOUM,
          textWidth: '80%',
        });
      }
      .width('100%')
      .padding({
        top: 20,
      });
    }
    .height('95%')
    .width('92%')
    .backgroundColor(Color.White)
    .borderRadius(16)
    .padding({
      bottom: 20,
    });
  }

  @Builder
  SimpleText(text: string | undefined) {
    Text(text)
      .fontSize($r('app.float.font_size_14'))
      .fontColor('rgba(0,0,0,0.90)')
      .margin({ bottom: '2.5%' })
  }

  findDeliveryDetail(index: string): DeliveryDetail{
    let deliveryDetail = deliveryDetailData.find(item => item.id === index);
    return deliveryDetail === undefined ?
      {id: '', active: -1, optionArray: []} : deliveryDetail;
  }
}