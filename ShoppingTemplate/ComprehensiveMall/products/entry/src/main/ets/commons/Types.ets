import { IconTextTabModel } from './Models';

export interface TabSwiperDataItem {
  id: string;
  priority: number; // 首次加载时, 会显示优先级最高的页面 (优先级相同则显示索引最小的页面)
  tabModel: IconTextTabModel;
  contentWarpBuilder: WrappedBuilder<[]>;
}
