import { CourseDetailModel } from 'external_interactions';

@Component
export struct Course {
  pathStack: NavPathStack = new NavPathStack();
  @Prop courseDetail: CourseDetailModel

  build() {
    Column() {
      Image($r(this.courseDetail.advImage))
        .width('100%')
        .height(76)
        .borderRadius({ topLeft: 8, topRight: 8 })
      Column() {
        Text(this.courseDetail.courseName)
          .fontSize(10)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 5 })
        Text('¥' + this.courseDetail.price)
          .fontSize(12)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 5 })
      }
      .borderRadius({ bottomLeft: 8, bottomRight: 8 })
      .justifyContent(FlexAlign.SpaceEvenly)
      .alignItems(HorizontalAlign.Start)
      .shadow({
        radius: 2,
        color:'#ECECEC',
        offsetY: 5,
      })
      .width('100%')
      .height(50)
    }
    .width('100%')
    .height(126)
    .onClick(() => {
      this.pathStack.pushPath({ name: 'course/CourseDetail', param: this.courseDetail })
    })
  }
}