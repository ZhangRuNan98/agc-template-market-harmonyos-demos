import { CommonSaveButton } from 'module_base';
import { EditNamePageVM } from '../viewModels/EditPageVM';


@Builder
export function EditPageBuilder() {
  EditPage();
}

@ComponentV2
export struct EditPage {
  vm: EditNamePageVM = EditNamePageVM.instance

  build() {
    NavDestination() {
      Column({ space: 16 }) {
        Row() {
          Text(this.vm.title)
            .fontSize(16)
            .layoutWeight(1)
            .lineHeight(22)
            .padding({ left: 12 });
          TextInput({
            text: this.vm.title === '昵称' ? this.vm.nickname : this.vm.cellphone,
          })
            .textAlign(TextAlign.End)
            .fontSize(14)
            .layoutWeight(1)
            .backgroundColor(Color.White)
            .selectionMenuHidden(true)
            .padding({ right: 6 })
            .cancelButton({
              style: CancelButtonStyle.CONSTANT,
              icon: {
                size: 16,
                src: $r('app.media.ic_clear'),
              }
            })
            .onChange((value) => {
              if (this.vm.userInfo) {
                if (this.vm.title === '昵称') {
                  this.vm.nickname = value
                } else {
                  this.vm.cellphone = value
                }
              }
            });
        }
        .backgroundColor($r('sys.color.white'))
        .height(56)
        .borderRadius(16);

        CommonSaveButton({
          value: this.vm.nickname, changeValue: () => {
            this.vm.modify()
          }
        })
      }
      .height('100%')
      .margin({
        left: 16,
        right: 16,
      });
    }
    .title(this.vm.title)
    .backgroundColor($r('sys.color.background_secondary'))
    .onShown(() => {
      this.vm.init()
    })
    .onHidden(() => {
      this.vm.clear()
    })
  }
}