import { LengthMetrics, promptAction } from '@kit.ArkUI';
import { RouterModule, BuildTitleBar, TelBar, RouterMap, WindowUtil, AccountUtil } from 'commonlib';
import { CaseInfo, ReviewItem } from 'network';
import { DesignerPageVM } from '../viewModels/DesignerPageVM';
import { RangeItem, RouterParams } from '../types/Index';


@Builder
export function DesignerPageBuilder() {
  DesignerPage();
}

@Preview
@ComponentV2
struct DesignerPage {
  vm: DesignerPageVM = DesignerPageVM.instance;

  aboutToAppear(): void {
    this.vm.getDesignerDetail();
    this.vm.getReviewList();
  }

  @Builder
  TelSheetBuilder() {
    Column() {
      TelBar({
        phone: this.vm.designerDetail?.phone || '',
        onCancel: () => {
          this.vm.isPhoneOpen = false;
        },
      });
    }.width('100%').padding(16);
  }

  @Builder
  OrderDesignerBuilder() {
    Column() {
      Column() {
        Text('选择房屋面积').baseTitle();
        Row() {
          ForEach(this.vm.areaList, (item: RangeItem, index) => {
            Text(item.label)
              .backgroundColor(this.vm.curAreaIndex === index ? $r('sys.color.alert') :
              $r('sys.color.comp_background_tertiary'))
              .fontColor(this.vm.curAreaIndex === index ? $r('sys.color.font_on_primary') :
              $r('sys.color.font_primary'))
              .baseBtnExtend()
              .onClick(() => {
                this.vm.curAreaIndex = index;
              });
          }, (item: RangeItem) => item.label);
        }.justifyContent(FlexAlign.SpaceBetween).margin({ bottom: 16 }).width('100%');

        Text('选择装修预算').baseTitle();
        Row() {
          ForEach(this.vm.budgetList, (item: RangeItem, index) => {
            Text(item.label)
              .backgroundColor(this.vm.curBudgetIndex === index ? $r('sys.color.alert') :
              $r('sys.color.comp_background_tertiary'))
              .fontColor(this.vm.curBudgetIndex === index ? $r('sys.color.font_on_primary') :
              $r('sys.color.font_primary'))
              .baseBtnExtend()
              .onClick(() => {
                this.vm.curBudgetIndex = index;
              });
          }, (item: RangeItem) => item.label);
        }.justifyContent(FlexAlign.SpaceBetween).margin({ bottom: 16 }).width('100%');
      }.padding({ left: 12, right: 12 }).width('100%').alignItems(HorizontalAlign.Start);

      TextInput({ placeholder: '请留下您的姓', text: this.vm.firstName })
        .width('100%')
        .height(40)
        .margin({ bottom: 16 })
        .placeholderColor($r('sys.color.font_secondary'))
        .placeholderFont({
          size: $r('sys.float.Body_M'),
          weight: FontWeight.Regular,
        })
        .onChange((res) => {
          this.vm.firstName = res;
        });

      Column() {
        Button('预约TA')
          .height(40)
          .backgroundColor($r('sys.color.alert'))
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.font_on_primary'))
          .width('100%')
          .onClick(() => {
            this.vm.toOrder();
          });


        Row({ space: 2 }) {
          Image($r('app.media.ic_warming')).width(10).height(10);
          Text('允许软件来电了解详细装修需求')
            .fontWeight(FontWeight.Regular)
            .fontSize($r('sys.float.Caption_L'))
            .fontColor($r('sys.color.font_tertiary'));
        }.margin({ top: 8 }).width('100%').justifyContent(FlexAlign.Center);
      }.padding({ left: 12, right: 12 });
    }
    .padding({
      top: 8,
      left: 16,
      right: 16,
      bottom: 23,
    })
    .alignItems(HorizontalAlign.Start);
  }

  @Builder
  headerBuilder() {
    Row() {
      Row({ space: 4 }) {
        Image($r(`app.media.${this.vm.designerDetail?.avatar}`)).width(44).height(44).borderRadius(22);
        Column({ space: 4 }) {
          Text(this.vm.designerDetail?.name)
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.font_primary'))
            .fontSize($r('sys.float.Body_M'))
            .lineHeight(19);
          Text(this.vm.designerDetail?.address).subTextExtend();

        }.alignItems(HorizontalAlign.Start);
      };

      Column({ space: 4 }) {
        Text(`${this.vm.designerDetail?.min}~${this.vm.designerDetail?.max}`)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.alert'))
          .fontSize($r('sys.float.Body_M'))
          .lineHeight(19);
        Text('元/m³').subTextExtend();
      };
    }.width('100%').justifyContent(FlexAlign.SpaceBetween).padding({ right: 16 });
  }

  @Builder
  reviewBuilder() {
    Column() {

      List({ space: 12 }) {
        ForEach(this.vm.reviewInfo?.reviewList, (item: ReviewItem) => {
          ListItem() {
            this.reviewItemBuilder(item);
          };
        }, (item: ReviewItem) => item.reviewId.toString());
      }.padding({ bottom: 20 });

    }.padding(16);
  }

  @Builder
  reviewItemBuilder(item: ReviewItem) {
    Column({ space: 12 }) {
      Row() {
        Image($r(`app.media.${item.authorAvatar}`)).width(32).margin({ right: 8 }).borderRadius(16);
        Text(item.author).layoutWeight(1).secondTextExtend();
        Text(item.postTime).secondTextExtend();
      }.width('100%');

      Text(item.review)
        .width('100%')
        .fontSize($r('sys.float.Body_M'))
        .fontWeight(FontWeight.Regular)
        .fontColor($r('sys.color.font_primary'));
    }.width('100%').padding(12).borderRadius(16).border({ width: 1, color: $r('sys.color.comp_divider') });

  }

  build() {
    NavDestination() {
      Stack() {
        Scroll() {
          Column({ space: 16 }) {
            this.headerBuilder();

            Column({ space: 8 }) {
              this.titleBuilder('案例', `${this.vm.designerDetail?.ownerCases.length}篇`);

              List({ space: 12 }) {
                ForEach(this.vm.designerDetail?.ownerCases, (item: CaseInfo, index) => {
                  ListItem() {
                    Column() {
                      Image($r(`app.media.${item.cover}`)).width(250).height(140).borderRadius(16);
                      Text(item.title)
                        .width(220)
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .margin({ top: 8, bottom: 4 })
                        .height(19)
                        .fontWeight(FontWeight.Regular)
                        .fontSize($r('sys.float.Body_M'))
                        .fontColor($r('sys.color.font_primary'));
                      Text(`${item.area}㎡ / ${item.style} / ${item.homeTypeLabel} / ${item.detail.length}张图`)
                        .height(14)
                        .fontWeight(FontWeight.Regular)
                        .fontSize($r('sys.float.Caption_M'))
                        .fontColor($r('sys.color.font_tertiary'));
                    }.alignItems(HorizontalAlign.Start);
                  }.onClick(() => {
                    RouterModule.push(RouterMap.CASE_DETAIL_PAGE, item);
                  });

                }, (item: CaseInfo, index) => item.caseId.toString());
              }.listDirection(Axis.Horizontal).scrollBar(BarState.Off);
            };

            Column({ space: 8 }) {
              this.titleBuilder('文章', `${this.vm.designerDetail?.ownerArticle.length}篇`);
              List({ space: 12 }) {
                ForEach(this.vm.designerDetail?.ownerArticle, (item: CaseInfo) => {
                  ListItem() {
                    Column() {
                      Image($r(`app.media.${item.cover}`)).width(250).height(140).borderRadius(16);
                      Text(item.title)
                        .width(220)
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .margin({ top: 8, bottom: 4 })
                        .height(19)
                        .fontWeight(FontWeight.Regular)
                        .fontSize($r('sys.float.Body_M'))
                        .fontColor($r('sys.color.font_primary'));
                      Text(`${item.area}㎡ / ${item.style} / ${item.homeTypeLabel} / ${item.detail.length}张图`)
                        .height(14)
                        .fontWeight(FontWeight.Regular)
                        .fontSize($r('sys.float.Caption_M'))
                        .fontColor($r('sys.color.font_tertiary'));
                    }.alignItems(HorizontalAlign.Start);
                  }.onClick(() => {
                    RouterModule.push(RouterMap.CASE_DETAIL_PAGE, item);
                  });

                }, (item: CaseInfo) => item.caseId.toString());
              }.listDirection(Axis.Horizontal).scrollBar(BarState.Off);
            };

            Column({ space: 8 }) {
              Row() {
                Text('评论')
                  .layoutWeight(1)
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('sys.color.font_primary'))
                  .fontSize($r('sys.float.Body_M'));
                Text('好评率100%')
                  .fontWeight(FontWeight.Regular)
                  .fontColor($r('sys.color.font_secondary'))
                  .fontSize($r('sys.float.Body_S'));
                Image($r('app.media.ic_designer_right')).width(16).margin({ left: 4 });
              }.padding({ right: 16 })
              .bindSheet($$this.vm.isShow, this.reviewBuilder(), {
                title: {
                  title: '全部评论',
                },
                height: SheetSize.FIT_CONTENT,
              })
              .onClick(() => {

                this.vm.isShow = true;

              });

              Column() {
                if (this.vm.reviewInfo) {
                  Column({ space: 12 }) {
                    Row() {
                      Image($r(`app.media.${this.vm.reviewInfo.reviewList[0].authorAvatar}`))
                        .width(32)
                        .margin({ right: 8 })
                        .borderRadius(16);
                      Text(this.vm.reviewInfo.reviewList[0].author).layoutWeight(1).secondTextExtend();
                      Text(this.vm.reviewInfo.reviewList[0].postTime).secondTextExtend();
                    }.width('100%');

                    Text(this.vm.reviewInfo.reviewList[0].review)
                      .width('100%')
                      .fontSize($r('sys.float.Body_M'))
                      .fontWeight(FontWeight.Regular)
                      .fontColor($r('sys.color.font_primary'));
                  }
                  .width('100%')
                  .padding(12)
                  .borderRadius(16)
                  .border({ width: 1, color: $r('sys.color.comp_divider') });
                }

              }.width('100%').padding({ right: 16 });
            };

          }.padding({ top: 12, left: 16 });
        }
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)
        .align(Alignment.Top)
        .padding({ bottom: 140 })
        .edgeEffect(EdgeEffect.Spring)

        Row({ space: 16 }) {
          Button() {
            Row({ space: 8 }) {
              Image($r('app.media.ic_designer_phone')).width(16);
              Text('联系TA').fontSize($r('sys.float.Body_L'))
                .fontWeight(FontWeight.Medium).fontColor($r('sys.color.alert'));
            };
          }
          .shadow(1)
          .backgroundColor($r('sys.color.background_primary'))
          .height(40)
          .layoutWeight(1)
          .bindSheet($$this.vm.isPhoneOpen, this.TelSheetBuilder, {
            title: {
              title: '联系设计师',
            },
            height: 280,
            radius: LengthMetrics.vp(16),
          })
          .onClick(() => {
            this.vm.isPhoneOpen = true;
          });


          Button('在线预约')
            .shadow(1)
            .backgroundColor($r('sys.color.alert'))
            .height(40)
            .fontSize($r('sys.float.Body_L'))
            .fontWeight(FontWeight.Medium)
            .layoutWeight(1)
            .fontColor($r('sys.color.font_on_primary'))
            .bindSheet($$this.vm.isOrderOpen, this.OrderDesignerBuilder, {
              height: 342,
              title: {
                title: '预约',
              },
              radius: LengthMetrics.vp(16),
            })
            .onClick(() => {
              if (AccountUtil.getUserInfo().isLogin) {
                this.vm.isOrderOpen = true;
              } else {
                promptAction.showToast({ message: '请先登录，享受更多精彩！' });
                RouterModule.push(RouterMap.QUICK_LOGIN_PAGE);
              }

            });
        }.width('100%').padding(16);
      }.height('100%').align(Alignment.Bottom);

    }
    .title(BuildTitleBar('设计师'), { paddingStart: LengthMetrics.vp(16) })
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({ top: WindowUtil.avoidAreaSize.top, bottom: WindowUtil.avoidAreaSize.bottom });
  }

  @Builder
  titleBuilder(title: string, des: string) {
    Row() {
      Text(title)
        .layoutWeight(1)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_primary'))
        .fontSize($r('sys.float.Body_M'));
      Text(des)
        .fontWeight(FontWeight.Regular)
        .fontColor($r('sys.color.font_secondary'))
        .fontSize($r('sys.float.Body_S'));
      Image($r('app.media.ic_designer_right')).width(16).margin({ left: 4 });
    }.padding({ right: 16 }).onClick(() => {
      if (title === '案例') {
        RouterModule.push(RouterMap.OWN_CASE_PAGE,
          { caseList: this.vm.designerDetail?.ownerCases, title: '设计师案例' } as RouterParams);
      }
      if (title === '文章') {
        RouterModule.push(RouterMap.OWN_CASE_PAGE,
          { caseList: this.vm.designerDetail?.ownerArticle, title: '设计师文章' } as RouterParams);
      }
    });
  }
}

@Extend(Text)
function secondTextExtend() {
  .fontColor($r('sys.color.font_secondary'))
  .fontSize($r('sys.float.Body_S'))
  .fontWeight(FontWeight.Regular);
}

@Extend(Text)
function subTextExtend() {
  .fontSize($r('sys.float.Caption_M'))
  .fontWeight(FontWeight.Regular)
  .fontColor($r('sys.color.font_secondary'))
  .lineHeight(13);
}


@Extend(Text)
function baseBtnExtend() {
  .width(70)
  .height(28)
  .fontSize($r('sys.float.Caption_M'))
  .fontWeight(FontWeight.Regular)
  .padding(0)
  .borderRadius(8)
  .textAlign(TextAlign.Center);
}


@Extend(Text)
function baseTitle() {
  .fontSize($r('sys.float.Body_S'))
  .fontWeight(FontWeight.Regular)
  .fontColor($r('sys.color.font_primary'))
  .margin({ bottom: 8 });
}
