@ComponentV2
export struct PrivacyCard {
  @Require @Param title: string
  @Require @Param displayDate: boolean
  @Require @Param ifPrivacyPolicy: boolean

  build() {
    Column() {
      Column({space: 16}) {
        Image($r('app.media.security'))
          .width(32)
          .height(32)
          .objectFit(ImageFit.Contain)

        Column({space:4}){
          Text(this.title)
            .fontColor('E6000000')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          if(this.displayDate){
            Text('更新时间：2024-08-13 12:00:00')
              .fontSize(14)
          }
          Column(){
            if(this.ifPrivacyPolicy){
            Text('XX是（功能介绍）。华为非常重视您的个人信息和隐私保护，我们将会按照法律要求和业界成熟的安全标准，为您的个人信息提供相应的保护措施。\n' +
              '\n' +
              '1、我们如何收集和使用您的个人信息\n' +
              '......\n' +
              '\n' +
              '4、对儿童的保护\n' +
              '\n' +
              '5、与第三方共享（共享）\n' +
              '\n' +
              '6、管理您的数据\n' +
              '\n' +
              '7、数据存储地点及期限\n' +
              '\n' +
              '8、如何联系我们\n' +
              '\n' +
              '华为将始终遵照我们的隐私政策来收集和使用您的信息。有关我们的隐私政策，可参阅华为消费者业务隐私声明。')
              .fontWeight(FontWeight.Medium)
              .margin({top:27})
            } else {
              Text(' 1、关于我们\n' +
                '“xx”及相关技术与功能（以下合称为本服务）由XXX运营。本协议中的“您”与“用户”指任何使用和/或访问本服务的个人。\n' +
                '......\n' +
                '\n' +
                '2、协议目的\n' +
                '\n' +
                '3、使用资格\n' +
                '\n' +
                '4、访问本服务\n' +
                '\n' +
                '5、本服务\n' +
                '\n' +
                '6、第三方服务\n' +
                '\n' +
                '7、购买\n' +
                '\n' +
                '......\n' +
                '\n' +
                '20、联系我们\n' +
                '如您对本协议有任何疑问，请通过如下信息联系我们：XXXX。')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .margin({top:27})
            }
          }

        }
        .width('100%')


      }
      .height('100%')
      .width('100%')
      .padding({ top: 16, left: 16, right: 16})
    }
    .align(Alignment.TopStart)
    .backgroundColor($r('app.color.common_background'))
    .height('100%')
    .width('100%')
  }
}