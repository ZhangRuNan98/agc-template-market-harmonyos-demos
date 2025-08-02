import { Article } from './clazz/Article';
import { webview } from '@kit.ArkWeb';
import { router } from '@kit.ArkUI';

@ComponentV2
export struct AboutUs {
  @Local isListReachEnd: boolean = false;
  @Local simpleList: Array<Resource> =
    [$r('app.string.information_title1_string'), $r('app.string.information_title2_string'),
      $r('app.string.information_title3_string')];
  @Local articleList: Array<Article> = [
    new Article('001', $r('app.string.information_title1_string'), $r('app.string.information_content1_string'),
      $r('app.media.swiperImage')),
    new Article('002', $r('app.string.information_title2_string'), $r('app.string.information_content2_string'),
      $r('app.media.swiperImage')),
    new Article('003', $r('app.string.information_title3_string'), $r('app.string.information_content3_string'),
      $r('app.media.swiperImage'))
  ]

  build() {
    Column() {
      ForEach(this.articleList, (item: Article) => {
        ArticleCard({ article: item })
          .margin({ bottom: 16 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/homepage/CompanyIntroduction',
              params: item.title
            }, router.RouterMode.Standard)
          })
      }, (item: Article) => item.id)
    }
    .width('100%')
  }
}

@Component
struct ArticleCard {
  @Prop article: Article;
  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Text(this.article.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('rgba(0,0,0,0.90)')
        .margin({ bottom: 8 })
      Text(this.article.content)
        .fontSize($r('app.float.font_size_14'))
        .fontColor(Color.Gray)
    }
    .alignItems(HorizontalAlign.Start)
    .padding('5%')
    .borderRadius(16)
    .backgroundColor('#FFFFFF')
    .justifyContent(FlexAlign.Start)
  }
}

