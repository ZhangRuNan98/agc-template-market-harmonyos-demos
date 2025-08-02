import { HouseType, OrientationType, PaymentType, PropertyType, StatusType, UsageType } from '../constants/Enum';
import {
  IBasic,
  ILayout,
  INewHouse,
  INewHouseDetail,
  ISecondHouseDetail,
  IRentHouseDetail,
  IRentHouse,
  ISecondHouse,
} from './IResponse';

@ObservedV2
export class NewHouseInfo implements INewHouseDetail {
  @Trace layout: ILayout[] = [];
  @Trace basic: IBasic = {
    transport: '',
    plan: '',
    rate: '',
  };
  @Trace house: INewHouse = {
    inspect: [],
    onsite: [],
    houseId: '',
    type: HouseType.REC,
    title: '',
    district: '',
    area: '',
    longitude: 0,
    latitude: 0,
    unit: 0,
    cell: '',
    space: [],
    total: [],
    labels: [],
    thumbnail: '',
    bedroom: 0,
    lounge: 0,
    bathroom: 0,
    open: new Date(),
    usage: UsageType.RESIDENCE,
    property: PropertyType.RESIDENCE,
    address: '',
    orientation: OrientationType.SOUTH_NORTH,
    status: StatusType.SOLD,
    floor: 0,
    phone: '',
    favorite: 0,
  };
}

@ObservedV2
export class SecondHouseInfo implements ISecondHouseDetail {
  @Trace house: ISecondHouse = {
    video: [{
      uri: '',
      preview: '',
    }],
    value: '',
    houseId: '',
    type: HouseType.REC,
    title: '',
    district: '',
    area: '',
    longitude: 0,
    latitude: 0,
    unit: 0,
    cell: '',
    space: [],
    total: [],
    labels: [],
    thumbnail: '',
    bedroom: 0,
    lounge: 0,
    bathroom: 0,
    open: new Date(),
    usage: UsageType.RESIDENCE,
    property: 0,
    address: '',
    orientation: OrientationType.SOUTH_NORTH,
    status: StatusType.SOLD,
    floor: 0,
    around: '',
    phone: '',
    pic: [],
    zone: [],
    favorite: 0,
  };
  @Trace basic: IBasic = {
    transport: '',
    plan: '',
    rate: '',
  };
}

@ObservedV2
export class RentHouseInfo implements IRentHouseDetail {
  @Trace house: IRentHouse = {
    viewTime: '',
    requirement: '',
    payMethod: PaymentType.DEPOSIT_ONE_PAY_ONE,
    supplement: [],
    houseId: '',
    type: HouseType.REC,
    title: '',
    district: '',
    area: '',
    longitude: 0,
    latitude: 0,
    unit: 0,
    cell: '',
    space: [],
    total: [],
    labels: [],
    thumbnail: '',
    bedroom: 0,
    lounge: 0,
    bathroom: 0,
    open: new Date(),
    usage: UsageType.RESIDENCE,
    property: 0,
    address: '',
    orientation: OrientationType.SOUTH_NORTH,
    status: StatusType.SOLD,
    floor: 0,
    phone: '',
    pic: [],
    favorite: 0,
  };
}