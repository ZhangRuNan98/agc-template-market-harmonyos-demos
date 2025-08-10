import { CircleShape, PersistenceV2 } from '@kit.ArkUI'
import { CommonConstants, PopViewUtils, RouterMap, RouterUtils, UserInfoModel } from 'lib_common'
import { AuthorModel } from 'lib_news_api';
import { Constants } from '../common/Constants'
import { dialogLikeNumBuilder } from './DialogLikeNum';
import { WatchButton } from './WatchButton';

@ComponentV2
export struct UserIntro {
  @Require @Param userInfo: AuthorModel;
  @Param fontSizeRatio: number = 1;
  @Event refreshProfileHomePage: () => void = () => {
  };
  @Local mineInfo: UserInfoModel = PersistenceV2.connect(UserInfoModel, () => new UserInfoModel())!;

  build() {
    Column({ space: CommonConstants.SPACE_M }) {
      Row({ space: CommonConstants.SPACE_M }) {
        Image(this.userInfo.authorIcon || $r('app.media.ic_user_default'))
          .width(Constants.USER_ICON_W)
          .aspectRatio(1)
          .clipShape(new CircleShape({ width: Constants.USER_ICON_W, height: Constants.USER_ICON_W }))
        Column() {
          Row({ space: CommonConstants.SPACE_S }) {
            Text(this.userInfo.authorNickName)
              .fontSize(18 * this.fontSizeRatio)
              .fontColor($r('sys.color.font_primary'))
              .fontWeight(FontWeight.Medium)
            Image($r('app.media.ic_public_brush'))
              .width($r('app.float.normal_img_size'))
              .draggable(false)
              .fillColor($r('sys.color.font_primary'))
              .visibility(this.isMyself ? Visibility.Visible : Visibility.None)
              .onClick(() => {
                RouterUtils.pushPathByName(RouterMap.SETTING_PERSONAL, null, () => {
                  this.refreshProfileHomePage();
                });
              })
          }

          Row({ space: CommonConstants.SPACE_M }) {
            Row({ space: CommonConstants.SPACE_XXS }) {
              Text(`${this.userInfo.watchersCount}`)
                .fontSize(12 * this.fontSizeRatio)
                .fontColor($r('sys.color.font_primary'))
              Text('关注')
                .fontSize(12 * this.fontSizeRatio)
                .fontColor($r('sys.color.font_secondary'))
            }
            .onClick(() => {
              RouterUtils.pushPathByName(RouterMap.PROFILE_WATCH, this.userInfo.authorId, () => {
                this.refreshProfileHomePage();
              });
            })

            Row({ space: CommonConstants.SPACE_XXS }) {
              Text(`${this.userInfo.followersCount}`)
                .fontSize(12 * this.fontSizeRatio)
                .fontColor($r('sys.color.font_primary'))
              Text('粉丝')
                .fontSize(12 * this.fontSizeRatio)
                .fontColor($r('sys.color.font_secondary'))
            }
            .onClick(() => {
              RouterUtils.pushPathByName(RouterMap.PROFILE_FOLLOWER, this.userInfo.authorId, () => {
                this.refreshProfileHomePage();
              });
            })

            Row({ space: CommonConstants.SPACE_XXS }) {
              Text(`${this.userInfo.likeNum}`)
                .fontSize(12 * this.fontSizeRatio)
                .fontColor($r('sys.color.font_primary'))
              Text('获赞')
                .fontSize(12 * this.fontSizeRatio)
                .fontColor($r('sys.color.font_secondary'))
            }
            .onClick(() => {
              PopViewUtils.showPopView(wrapBuilder(dialogLikeNumBuilder), {}, this.userInfo);
            })
          }
        }
        .height(Constants.USER_ICON_W)
        .justifyContent(FlexAlign.SpaceBetween)
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .padding({
          top: CommonConstants.PADDING_XXS,
          bottom: CommonConstants.PADDING_XXS,
        })

        Column() {
          WatchButton({
            author: this.userInfo,
          })
        }
        .height(Constants.USER_ICON_W)
        .visibility(this.isMyself ? Visibility.None : Visibility.Visible)
      }

      Column() {
        Text('简介')
          .fontSize(12 * this.fontSizeRatio)
          .fontColor($r('sys.color.font_primary'))
        Text(this.userInfo.authorDesc || '这家伙很神秘，没有写个人简介。')
          .fontSize(12 * this.fontSizeRatio)
          .fontColor($r('sys.color.font_primary'))
      }
      .alignItems(HorizontalAlign.Start)
    }
    .alignItems(HorizontalAlign.Start)
    .padding({
      left: CommonConstants.PADDING_PAGE,
      right: CommonConstants.PADDING_PAGE,
      top: CommonConstants.PADDING_M,
      bottom: CommonConstants.PADDING_M,
    })
  }

  @Computed
  get isMyself() {
    return this.userInfo.authorId === this.mineInfo.authorId;
  }
}