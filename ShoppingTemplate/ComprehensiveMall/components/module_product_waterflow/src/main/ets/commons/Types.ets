import { LabelPresetType } from './Enums';

export interface LabelItem {
  preset: LabelPresetType;
  data: string;
}

export interface ProductCardItem {
  productId: string;
  price: number;
  dashPrice?: number;
  title: string;
  banner: ResourceStr;
  promotion: string[];
  label: LabelItem[];
}

export interface ProductListResp {
  list: ProductCardItem[];
  isFinal: boolean;
}
