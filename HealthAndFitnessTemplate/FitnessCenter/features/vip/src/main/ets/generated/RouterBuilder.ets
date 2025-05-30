import { MineInfoPage } from '../pages/MineInfoPage';
import { RechargePage } from '../pages/RechargePage';


@Builder
export function MineInfoBuilder() {
  MineInfoPage();
}

@Builder
export function VipRechargeBuilder() {
  RechargePage();
}

