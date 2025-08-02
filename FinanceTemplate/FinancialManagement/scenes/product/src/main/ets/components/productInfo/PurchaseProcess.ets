import { ProductInfoVM } from '../../viewModels/ProductInfoVM'
import { CommonCheckCard } from '../CommonCheckCard'

@ComponentV2
export struct PurchaseProcess {
  vm: ProductInfoVM = ProductInfoVM.instance

  build() {
    CommonCheckCard({
      redemptionDate: this.vm.purchaseProcess?.redemptionDate,
      confirmationDate: this.vm.purchaseProcess?.confirmationDate
    })
  }
}