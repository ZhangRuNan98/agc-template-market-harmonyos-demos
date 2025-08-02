import { RouteEntryVM } from 'common'
import { BusLinePlan } from '../page/BusLinePlan'

@Builder
export function RouteDesignBuilder() {
  RouteDesign()
}

@Component
export struct RouteDesign {
  vm: RouteEntryVM = RouteEntryVM.instance

  build() {
    BusLinePlan()
  }
}