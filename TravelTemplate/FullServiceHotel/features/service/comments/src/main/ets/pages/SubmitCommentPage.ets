import { CommonButton, CommonHeader } from 'componentlib';
import { CommentStarRating } from '../components/CommentStarRating';
import { RatingLayoutType } from '../constants';
import { SubmitCommentPageVM } from '../viewModels/SubmitCommentPageVM';

@Builder
export function submitCommentPageBuilder() {
  SubmitCommentPage();
}

@ComponentV2
export struct SubmitCommentPage {
  @Local
  showDialog: boolean = false;
  vm: SubmitCommentPageVM = SubmitCommentPageVM.instance;
  controller: TextAreaController = new TextAreaController();

  aboutToAppear(): void {
    this.vm.getHotelList();
    this.vm.resetData();
  }

  build() {
    NavDestination() {
      Column() {
        CommonHeader({
          title: '发表评论',
        });
        Column() {
          Row() {
            Text('*').fontColor($r('app.color.system_color_highlight'));
            Text('门店选择').commonTextStyle().layoutWeight(1);
            if (this.vm.hotelList.length === 1) {
              Row() {
                Text(this.vm.checkedHotel?.name ?? '').commonTextStyle();
              };
            } else {
              Row() {
                Text(this.vm.submitPageModel.location ? this.vm.checkedHotel?.name : '请选择').commonTextStyle();
                Image($r('app.media.ic_right_arrow')).height('24lpx');
              }
              .onClick(() => {
                this.showDialog = true;
              });
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({
            top: $r('app.string.padding_m'),
            left: $r('app.string.padding_m'),
            right: $r('app.string.padding_m'),
          });

          Divider()
            .strokeWidth('10lpx')
            .color('#f2f2f2')
            .margin({ top: $r('app.string.margin_m'), bottom: $r('app.string.margin_m') });

          CommentStarRating({
            rating: this.vm.submitPageModel.totalRate!!,
            layoutType: RatingLayoutType.VERTICAL,
            starSize: 24,
          })
            .margin({
              bottom: $r('app.string.margin_l'),
            });

          Column({
            space: 10,
          }) {
            CommentStarRating({
              label: '服务周到',
              starSize: 20,
              rating: this.vm.submitPageModel.detailRate.service!!,
            });
            CommentStarRating({
              label: '环境卫生',
              starSize: 20,
              rating: this.vm.submitPageModel.detailRate.environment!!,
            });
            CommentStarRating({
              label: '设施设备',
              starSize: 20,
              rating: this.vm.submitPageModel.detailRate.device!!,
            });
            CommentStarRating({
              label: '综合体验',
              starSize: 20,
              rating: this.vm.submitPageModel.detailRate.experience!!,
            });

            Divider().strokeWidth(1).color('#f2f2f2')
              .margin({
                top: $r('app.string.margin_s'),
                bottom: $r('app.string.margin_m'),
              });

            TextArea({
              text: this.vm.submitPageModel.desc,
              placeholder: '请留下您的宝贵意见吧~',
              controller: this.controller,
            })
              .placeholderFont({ size: $r('app.string.font_size_28') })
              .placeholderColor($r('app.color.font_color_level3'))
              .width('100%')
              .height(150)
              .fontSize($r('app.string.font_size_28'))
              .fontColor($r('app.color.font_color_level1'))
              .backgroundColor($r('app.color.system_color_background_white'))
              .borderWidth(1)
              .borderColor('#f2f2f2')
              .maxLength(200)
              .showCounter(true)
              .margin({
                bottom: $r('app.string.margin_s'),
              })
              .borderRadius($r('app.string.border_radius_8'))
              .onChange((value: string) => {
                this.vm.submitPageModel.desc = value;
              });

            // 匿名评论
            Row() {
              Text('匿名评论').margin({ right: $r('app.string.margin_s') }).fontSize($r('app.string.font_size_24'));
              Text('其他用户将无法看到您的头像与昵称')
                .fontSize($r('app.string.font_size_24'))
                .fontColor($r('app.color.font_color_level2'));
            }
            .width('100%');

          }
          .padding($r('app.string.padding_s'));
        }
        .width('100%');

        Blank();

        CommonButton({
          title: this.vm.submitPageModel.isAnonymous ? '匿名提交' : '提交',
          handleClick: () => {
            this.vm.submitComment();
          },
        });
      }
      .height('100%')
      .bindSheet($$this.showDialog, this.storeSelectionDialogBuilder(), {
        height: 300,
        showClose: false,
      });
    }
    .hideTitleBar(true);
  }

  @Builder
  storeSelectionDialogBuilder() {
    Column() {
      Row() {
        Image($r('app.media.ic_left_arrow'))
          .height('32lpx')
          .onClick(() => {
            this.showDialog = false;
          });

        Text('门店选择')
          .fontSize($r('app.string.font_size_32'));
        Text('保存')
          .fontSize($r('app.string.font_size_32'))
          .fontColor($r('app.color.font_color_link'))
          .onClick(() => {
            this.vm.getCheckedHotel(this.vm.hotelLabelList[this.vm.hotelIndex]);
            this.showDialog = false;
          });
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween);

      TextPicker({ range: this.vm.hotelLabelList, selected: this.vm.hotelIndex })
        .onChange((_value: string | string[], index: number | number[]) => {
          this.vm.hotelIndex = index as number;
        })
        .textStyle({
          color: $r('app.color.font_color_level1'),
          font: { size: $r('app.string.font_size_28'), weight: FontWeight.Normal },
        })
        .selectedTextStyle({
          color: $r('app.color.font_color_level1'),
          font: { size: $r('app.string.font_size_28'), weight: FontWeight.Bold },
        })
        .canLoop(false)
        .margin({
          top: $r('app.string.margin_m'),
        })
        .height(200)
        .width('100%');
    }
    .width('100%')
    .borderRadius({
      topLeft: $r('app.string.border_radius_32'),
      topRight: $r('app.string.border_radius_32'),
    })
    .padding($r('app.string.padding_m'))
    .justifyContent(FlexAlign.Start);
  }
}

@Extend(Text)
function commonTextStyle() {
  .fontSize($r('app.string.font_size_24'));
}