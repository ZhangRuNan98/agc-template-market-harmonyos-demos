import { common } from '@kit.AbilityKit';
import { notificationManager } from '@kit.NotificationKit';
import {
  CommonConstants,
  LinearColumnModifier,
  NewsEnum,
  NewsScan,
  PushActionParams,
  PushUtils,
  RouterMap,
  RouterToNews,
  RouterUtils,
} from 'lib_common'
import { FlexLayout } from 'lib_flex_layout';
import { NavHeaderBar } from 'lib_widget';
import { BaseNewsServiceApi } from 'lib_news_api';
import { HomeViewModel } from '../viewmodels/HomeViewModel';

@Builder
export function HomePageBuilder() {
  HomePage()
}

@ComponentV2
struct HomePage {
  @Local homeViewModel: HomeViewModel = new HomeViewModel();
  @Local modifier: LinearColumnModifier = new LinearColumnModifier($r('app.color.home_linear'));

  aboutToAppear(): void {
   this.homeViewModel.sendPushNotice(getContext(this) as common.UIAbilityContext)
  }

  build() {
    NavDestination() {
      Column() {
        NavHeaderBar({
          title: '首页',
          isSubTitle: false,
          rightPartBuilder: () => {
            this.rightHeadPartBuilder()
          },
        })
        Column() {
          FlexLayout()
        }
        .layoutWeight(1)
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .backgroundColor($r('sys.color.background_primary'))
      .attributeModifier(this.modifier)
    }
    .hideTitleBar(true)
  }

  @Builder
  rightHeadPartBuilder() {
    Row({ space: CommonConstants.SPACE_S }) {
      Row() {
        Image($r('app.media.ic_search')).width($r('app.float.nav_icon_width')).fillColor($r('sys.color.font_primary'))
          .onClick(() => {
            RouterUtils.pushPathByName(RouterMap.NEWS_SEARCH)
          })
      }
      .padding(10)
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .borderRadius('50%')

      Row() {
        Image($r('app.media.ic_scan')).width($r('app.float.nav_icon_width')).fillColor($r('sys.color.font_primary'))
          .onClick(() => {
            new NewsScan().scan()
          })
      }
      .padding(10)
      .borderRadius('50%')
      .backgroundColor($r('sys.color.comp_background_tertiary'))
    }
    .layoutWeight(1)
    .justifyContent(FlexAlign.End)
  }
}