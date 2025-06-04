import dayjs from 'dayjs';
import { ListEndSwiperAction } from '../common/ListEndSwiperAction';
import { TodoDataGroup, UserEventItem } from '../../model/UserEventModel';
import CalendarEventVM from '../../viewModel/ViewModel';

@ComponentV2
export struct TodoList {
  @Local calendarEventVM: CalendarEventVM = CalendarEventVM.instance;
  @Param todoList: UserEventItem[] = []
  @Local todoListGroup: TodoDataGroup[] = []

  aboutToAppear(): void {
    this.getTodoGroupList()
  }

  getTodoGroupList() {
    this.todoListGroup = []
    let todo = this.todoList.filter(item => !item.isDone)
    let done = this.todoList.filter(item => item.isDone)
    let params1: TodoDataGroup = new TodoDataGroup('待处理', todo)
    let params2: TodoDataGroup = new TodoDataGroup('已完成', done)
    this.todoListGroup.push(params1)
    this.todoListGroup.push(params2)
  }

  @Builder
  todoHeader(text: string) {
    Column() {
      Text(text)
        .fontSize(14)
        .fontColor($r('sys.color.font_secondary'))
        .margin({ bottom: 12 })
    }
  }

  @Builder
  itemEnd(item: UserEventItem) {
    ListEndSwiperAction({
      userEventInfo:item
    })
  }

  @Builder
  todoListBuilder() {
    List() {
      ListItem() {
        Column() {
          Image($r('app.media.no_data')).width(120).height(120)
          Text('暂无重要提醒')
            .fontSize(14)
            .fontColor($r('sys.color.font_secondary'))
        }
        .width('100%')
        .margin({ top: '40%' })
      }
      .visibility(this.todoList.length ? Visibility.None : Visibility.Visible)

      ForEach(this.todoListGroup, (value: TodoDataGroup) => {
        ListItemGroup({ header: this.todoHeader(value.title), space: 12 }) {
          ForEach(value.todoList, (item: UserEventItem) => {
            ListItem() {
              Row({ space: 18 }) {
                Checkbox({ name: 'checkbox2', group: 'checkboxGroup' })
                  .select(item.isDone)
                  .selectedColor('#D9B3B3')
                  .shape(CheckBoxShape.ROUNDED_SQUARE)
                  .onChange((value: boolean) => {
                    item.isDone = !item.isDone
                    this.getTodoGroupList()
                  })
                Column({ space: 5 }) {
                  Text(item.content)
                    .fontWeight(FontWeight.Medium)
                    .fontSize(14)
                    .fontColor(item.isDone ? '#969696' : $r('sys.color.font_primary'))
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Text(dayjs(item.date[0].date).format('YYYY年MM月DD日') + '  ' + item.date[0].time)
                    .fontSize(12)
                    .fontColor(item.isDone ? '#969696' : $r('sys.color.font_secondary'))
                }
                .width('80%')
                .alignItems(HorizontalAlign.Start)
              }
              .onClick(() => {
                this.calendarEventVM.getPageInfo()?.pushPathByName('TodoDetails', item)
              })
              .width('100%')
              .padding(14)
              .borderRadius(16)
              .backgroundColor('#FAFAFA')
            }
            .swipeAction({
              end: {
                builder: () => {
                  this.itemEnd(item)
                },
              },
            })
          }, (item: UserEventItem) => JSON.stringify(item))
        }
        .margin({ bottom: 32 })
        .visibility(this.todoList.length ? Visibility.Visible : Visibility.None)
      }, (value: TodoDataGroup) => JSON.stringify(value))
    }
    .scrollBar(BarState.Off)
    .backgroundColor($r('sys.color.background_primary'))
  }

  build() {
    Column() {
      List() {
        ListItem() {
          this.todoListBuilder()
        }
      }
      .scrollBar(BarState.Off)
    }
    .margin({ top: 12 })
    .height('100%')
    .justifyContent(FlexAlign.Start)
  }
}