import { TCRouter } from '../comp/TCRouter';
import { Constants } from '../constant/Constants';
import { BookInfo, GroupBook } from '../model/Book';
import { BookSubcategory } from '../model/BookSortInfo';
import { BookCover, BookGroupCover, BookLikeCover } from './CommonUI';


export interface CategoryInfo {
  category: string;
  isCategory: boolean
}

/**
 * 图书小卡，仅有图片+书名 换行：评分+类型
 */
@ComponentV2
export struct BookLittleCardHome {
  @Param info: BookInfo | undefined = undefined;

  build() {
    Column() {
      BookCover(this.info?.coverUrl, this.info?.isFree);
      Text(this.info?.name)
        .fontSize($r('sys.float.Body_M'))
        .fontColor($r('sys.color.font_primary'))
        .fontWeight(FontWeight.Medium)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width(104)
        .textAlign(TextAlign.Start)
        .padding({ top: 5 })
      Row() {
        Text(this.info?.rate)
          .fontSize(12)
          .fontColor($r('sys.color.mask_secondary'))
        Text(this.info?.category)
          .fontSize(12)
          .fontColor($r('sys.color.mask_secondary'))
      }
      .width(104)
      .align(Alignment.Start)
      .margin({ top: 4 })
    }
    .onClick(() => {
      if (this.info) {
        TCRouter.pushByLogin(Constants.READ_KIT_ROUTER, this.info);
      }
    })
  }
}

/**
 * 图书猜你喜欢小卡
 */
@ComponentV2
export struct BookLittleCard {
  @Param @Require info: BookInfo;
  @Event manageEvent: (book: BookInfo, isShowM: boolean) => void = (book: BookInfo, isShowM: boolean) => {
  };

  build() {
    Column() {
      BookCover(this.info?.coverUrl, this.info?.isFree);
      Text(this.info?.name)
        .fontSize($r('sys.float.Body_M'))
        .fontColor($r('sys.color.font_primary'))
        .fontWeight(FontWeight.Medium)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width(104)
        .textAlign(TextAlign.Start)
        .padding({ top: 5 })
      Row() {
        Row() {
          Text(this.info?.rate)
            .fontSize(12)
            .fontColor($r('sys.color.mask_secondary'))
          Text(this.info?.category)
            .fontSize(12)
            .fontColor($r('sys.color.mask_secondary'))
        }

        Row() {
          Image($r('app.media.ic_public_ellipsis'))
            .height(12)
            .width(12)
            .objectFit(ImageFit.Auto)
        }.width(30).justifyContent(FlexAlign.End)
        .onClick(() => {
          this.manageEvent(this.info as BookInfo, true);
        })
      }
      .width(104)
      .align(Alignment.Start)
      .margin({ top: 4 })
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .onClick(() => {
      if (this.info) {
        TCRouter.pushByLogin(Constants.READ_KIT_ROUTER, this.info);
      }
    })
  }
}


/**
 * 管理书籍-猜你喜欢
 */
@ComponentV2
export struct BookLikeCard {
  @Param @Require info: BookInfo;

  @Event showEvent:(isShow:boolean)=>void=(isShow:boolean)=>{

  }
  build() {
    Column() {
      BookLikeCover(this.info?.coverUrl, this.info?.isFree);
      Text(this.info?.name)
        .fontSize($r('sys.float.Body_S'))
        .fontColor($r('sys.color.font_primary'))
        .fontWeight(FontWeight.Medium)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width(104)
        .textAlign(TextAlign.Start)
        .padding({ top: 5 })


    }
    .width(104)
    .align(Alignment.Start)
    .margin({ top: 4 })
    .justifyContent(FlexAlign.SpaceBetween)

    .onClick(() => {
      if (this.info) {
        TCRouter.pushByLogin(Constants.READ_KIT_ROUTER, this.info);
        this.showEvent(false)

      }
    })
  }
}


/**
 *  宫格模式图书组合打卡
 */
@ComponentV2
export struct BookGroupCard {
  @Param info: GroupBook | undefined = undefined;
  @Local numbers1: number[] = [1, 2, 3, 4];
  @Local numbers2: BookInfo[] = [];

  build() {
    Column() {

      Column() {
        Grid() {
          ForEach(this.info?.groupBooks, (item: BookInfo) => {
            GridItem() {
              BookGroupCover(item.coverUrl);
            }
            .width(40)
            .height(56)


          }, (item: string) => JSON.stringify(item))

        }
        .columnsTemplate('1fr 1fr')
        .rowsTemplate('1fr 1fr')
      }
      .height(144)
      .width(104)
      .borderRadius(10)
      .backgroundColor(Color.White)


      Text(this.info?.groupName)
        .fontSize($r('sys.float.Body_M'))
        .fontColor($r('sys.color.font_primary'))
        .fontWeight(FontWeight.Medium)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width(104)
        .textAlign(TextAlign.Start)
        .padding({ top: 5 })
      Row() {
        if (this.info?.groupBooks?.length){
          Text('共' + this.info?.groupBooks?.length.toString() + '本')
            .fontSize(12)
            .fontColor($r('sys.color.mask_secondary'))
        } else {
          Text('共' + 0 + '本')
            .fontSize(12)
            .fontColor($r('sys.color.mask_secondary'))
        }
      }
      .width(104)
      .align(Alignment.Start)
      .margin({ top: 4 })
    }
  }
}

/**
 * 图书大卡，书名、介绍、评分
 */
@ComponentV2
export struct BookBigCard {
  @Param info: BookInfo | undefined = undefined;

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
      BookCover(this.info?.coverUrl, this.info?.isFree);

      Blank()
        .width(20)
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
        Column() {
          Row() {
            Text(this.info?.name)
              .fontSize($r('sys.float.Body_L'))
              .fontColor($r('sys.color.font_primary'))
            Row() {
              Image($r('app.media.ic_public_star'))
                .height(15)
                .width(20)
                .padding({ right: 4 })
              Text(`${this.info?.rate}`)
                .fontSize($r('sys.float.Body_M'))
                .fontColor($r('sys.color.font_secondary'))
            }
          }
          .width(Constants.FULL_SIZE)
          .justifyContent(FlexAlign.SpaceBetween)

          Text(this.info?.description)
            .maxLines(3)
            .fontSize($r('sys.float.Body_M'))
            .fontColor($r('sys.color.font_secondary'))
            .padding({ top: 10, bottom: 20 })
        }

        Column() {
          Text('作者：' + this.info?.author)
            .fontSize(12)
            .textAlign(TextAlign.Start)
            .width('100%')
        }
        .margin({ top: 20 })

      }
      .width('75%')
    }
    .padding({ left: 12, right: 12 })
    .height(150)
    .width(Constants.FULL_SIZE)
    .onClick(() => {
      if (this.info) {
        TCRouter.pushByLogin(Constants.READ_KIT_ROUTER, this.info);
      }
    })
  }
}

/**
 * 图书类别，图片、类别名
 */
@ComponentV2
export struct BookCategoryItem {
  @Param categoryInfo: BookSubcategory | undefined = undefined;
  @Local pushParam?: CategoryInfo

  build() {
    Column() {
      if (this.categoryInfo?.imgUrl) {
        Column() {
          Image($r(this.categoryInfo?.imgUrl?.toString()))
            .height(76)
            .width(76)
            .borderRadius(8)
          Text(this.categoryInfo?.subcategoryName)
            .fontSize(14)
            .width(76)
            .textAlign(TextAlign.Center)
        }
        .onClick(() => {
          this.pushParam = { category: this.categoryInfo?.subcategoryName!, isCategory: true }
          TCRouter.push(Constants.SEARCH_ROUTE, this.pushParam)
        })
      } else {
        Row() {
          Text(this.categoryInfo?.subcategoryName)
            .fontSize(14)
        }
        .height(28)
        .width(76)
        .borderRadius(14)
        .backgroundColor('#0d000000')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.pushParam = { category: this.categoryInfo?.subcategoryName!, isCategory: true }
          TCRouter.push(Constants.SEARCH_ROUTE, this.pushParam)
        })
      }
    }
  }
}

/**
 * 列表模式分组
 */
@ComponentV2
export struct GroupListCard {
  @Param info: GroupBook | undefined = undefined;

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
      Grid() {
        ForEach(this.info?.groupBooks, (item: BookInfo) => {
          GridItem() {
            BookGroupCover(item.coverUrl);
          }
          .width(40)
          .height(56)


        }, (item: string) => JSON.stringify(item))

      }
      .columnsTemplate('1fr 1fr')
      .rowsTemplate('1fr 1fr')
      .height(144)
      .width(104)
      .borderRadius(10)
      .backgroundColor(Color.White)
      Blank()
        .width(16)
      Column() {

        Text(this.info?.groupName)
          .fontSize(16)
          .fontColor($r('sys.color.font_primary'))
          .fontWeight(FontWeight.Medium)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width(104)
          .textAlign(TextAlign.Start)
          .padding({ top: 5 })

        Text('共' + this.info?.groupBooks?.length.toString() + '本')
          .fontSize(12)
          .fontColor($r('sys.color.mask_secondary'))

      }
      .height(150)
      .padding({
        bottom:5
      })
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Start)
    }
    .height(150)
    .width(Constants.FULL_SIZE)
  }
}


/**
 * 组合card
 */
@ComponentV2
export struct GroupBookCheckCard {
  @Param info: BookInfo | undefined = undefined;
  @Local isSelect: boolean = false;
  @Event manageGroupEvent: (book: BookInfo,isShowM:boolean) => void = (book: BookInfo,isShowM:boolean) => {
  };
  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
      BookCover(this.info?.coverUrl);

      Blank()
        .width(16)
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
        Column() {
          Row() {
            Text(this.info?.name)
              .fontSize($r('sys.float.Subtitle_M'))
              .fontColor($r('sys.color.font_primary')).fontWeight(FontWeight.Medium);
            Row() {
              Text(`${this.info?.rate}` + '分')
                .fontSize($r('sys.float.Subtitle_M'))
                .fontColor($r('sys.color.font_primary')).fontWeight(FontWeight.Medium);
            }.padding({right:30})
          }
          .width(Constants.FULL_SIZE)
          .justifyContent(FlexAlign.SpaceBetween)
          Row() {
            Row() {
              Text(this.info?.description)
                .maxLines(8).fontSize($r('sys.float.Body_S'))
                .fontColor($r('sys.color.font_secondary'))
                .fontWeight(FontWeight.Regular)
            } .justifyContent(FlexAlign.Start).width(200)

            Row(){
              Image(this.isSelect ? $r('app.media.selected_yes') : $r('app.media.selected_no'))

                .height(20)
                .width(20)

            }.width(30).height(30).margin({right:5})

          } .justifyContent(FlexAlign.SpaceBetween).onClick(() => {
            if (this.isSelect) {
              this.isSelect= false
            }else  {
              this.isSelect= true
            }
            this.manageGroupEvent(this.info as BookInfo,this.isSelect);
          })
          .margin({top:10,right:0})

        }

        Column() {
          Row() {
            Text(this.info?.category)
              .fontSize($r('sys.float.Body_S'))
              .fontColor($r('sys.color.font_secondary'))
              .fontWeight(FontWeight.Regular).textAlign(TextAlign.Start)

            Text(this.info?.count)
              .fontSize(12)
              .textAlign(TextAlign.Start)
              .padding({ left: 10 })
              .fontSize($r('sys.float.Body_S'))
              .fontColor($r('sys.color.font_secondary'))
              .fontWeight(FontWeight.Regular)
          }.width('100%').justifyContent(FlexAlign.Start)

        }
        .margin({ top: 20 })
      }
      .width('65%')
    }
    .height(150)
    .width(Constants.FULL_SIZE)
    .onClick(() => {
      if (this.info) {
        TCRouter.pushByLogin(Constants.READ_KIT_ROUTER, this.info);
      }
    })
  }
}
/*
 * 列表组合card
 * */
@ComponentV2
export struct bookShelfCard {
  @Param @Require info: BookInfo;
  @Event manageEvent: (book: BookInfo, isShowM: boolean) => void = (book: BookInfo, isShowM: boolean) => {
  };
  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
      BookCover(this.info?.coverUrl);

      Blank()
        .width(16)
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
        Column() {
          Row() {
            Text(this.info?.name)
              .fontSize($r('sys.float.Subtitle_M'))
              .fontColor($r('sys.color.font_primary')).fontWeight(FontWeight.Medium);
            Row() {
              Text(`${this.info?.rate}` + '分')
                .fontSize($r('sys.float.Subtitle_M'))
                .fontColor($r('sys.color.font_primary')).fontWeight(FontWeight.Medium);
            }
          }
          .width(Constants.FULL_SIZE)
          .justifyContent(FlexAlign.SpaceBetween)

          Text(this.info?.description)
            .maxLines(3)
            .fontSize($r('sys.float.Body_S'))
            .fontColor($r('sys.color.font_secondary'))
            .fontWeight(FontWeight.Regular)
            .padding({ top: 10, bottom: 20 })
        }

        Row() {
          Row() {
            Text(this.info?.category)
              .fontSize($r('sys.float.Body_S'))
              .fontColor($r('sys.color.font_secondary'))
              .fontWeight(FontWeight.Regular).textAlign(TextAlign.Start)

            Text(this.info?.count)
              .fontSize(12)
              .textAlign(TextAlign.Start)
              .padding({ left: 10 })
              .fontSize($r('sys.float.Body_S'))
              .fontColor($r('sys.color.font_secondary'))
              .fontWeight(FontWeight.Regular)
          }
          Row() {
            Image($r('app.media.ic_public_ellipsis'))
              .height(12)
              .width(12)
              .objectFit(ImageFit.Auto)
          }.width(30).justifyContent(FlexAlign.End)
          .onClick(() => {
            this.manageEvent(this.info as BookInfo, true);
          })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .margin({ top: 20 })
      }
      .width('65%')
    }
    .height(150)
    .width(Constants.FULL_SIZE)
    .onClick(() => {
      if (this.info) {
        TCRouter.pushByLogin(Constants.READ_KIT_ROUTER, this.info);
      }
    })
  }
}