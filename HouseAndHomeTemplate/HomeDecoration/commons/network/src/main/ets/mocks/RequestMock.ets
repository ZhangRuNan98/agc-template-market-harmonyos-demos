import { AxiosRequestConfig, HttpStatusCode } from '@ohos/axios';
import { axiosInstance } from '../apis/HttpRequest';
import { AxiosMock } from './AxiosMock';
import {
  getHotKeys,
  getCaseList,
  getDesignerList,
  getReviewList,
  addCollection,
  removeCollection,
  getCollection,
  upDateCity,
  getProjects,
} from '../mocks/MockData/CaseList';
import {
  Range,
  RangeDesc,
  PriceInfo,
  PriceListItem,
  ProjectItem,
  AccountPriceBody,
} from '../types/Decoration';


const mock: AxiosMock = new AxiosMock(axiosInstance, {
  delayResponse: 100,
});


mock.onGet('/decoration/hot-keys').reply(async () => {
  return {
    status: HttpStatusCode.Ok,
    data: getHotKeys(),
  };
});


mock.onGet('/decoration/list').reply(async (config: AxiosRequestConfig) => {
  let list = getCaseList();
  const style: string = config.params?.style;
  const title: string = config.params?.title;
  const caseType: string = config.params?.caseType;
  if (style) {
    list = list.filter((item => item.style.includes(style)));
  }
  if (title) {
    list = list.filter((item => item.title.includes(title) || item.style.includes(title)));
  }
  if (caseType) {
    list = list.filter((item => item.caseType === caseType));
  }
  return {
    status: HttpStatusCode.Ok,
    data: list,
  };
});


mock.onGet('/decoration/custom/list').reply(async (config: AxiosRequestConfig) => {
  let list = getCaseList().filter((item => item.caseType === '1')).slice(0, 3);
  let area: RangeDesc = config.params.area;
  const price: RangeDesc = config.params.price;

  if (area.max === Infinity) {
    area.max = 120;
  }

  if (price.max === Infinity) {
    price.max = 40;
  }

  list = list.map((item) => {
    item.price = (price.max + price.min) / 2;
    item.area = (area.max + area.min) / 2;
    return item;
  });

  return {
    status: HttpStatusCode.Ok,
    data: list,
  };
});


mock.onGet('/decoration/filter/list').reply(async (config: AxiosRequestConfig) => {
  let list = getCaseList().filter((item => item.caseType === '1'));
  const style: string = config.params?.style;
  const homeTypeLabel: string = config.params?.homeTypeLabel;
  const area: Range = config.params?.area;
  const price: Range = config.params?.price;
  if (style) {
    list = list.filter((item => item.style.includes(style)));
  }
  if (homeTypeLabel) {
    list = list.filter((item => item.homeTypeLabel.includes(homeTypeLabel)));
  }
  if (area) {
    list = list.filter((item => item.area >= area.min && item.area <= area.max));
  }
  if (price) {
    list = list.filter((item => item.price >= price.min && item.price <= price.max));
  }

  return {
    status: HttpStatusCode.Ok,
    data: list,
  };
});


mock.onGet('/decoration/designerList').reply(async (config: AxiosRequestConfig) => {
  let list = getDesignerList();
  const min: number = config.params.min;
  const max: number = config.params.max;
  const goodSpace: string = config.params.goodSpace;

  list = list.filter((item => min <= item.max && max >= item.min));
  if (goodSpace) {
    list = list.filter((item => item.goodSpace.includes(goodSpace)));
  }
  return {
    status: HttpStatusCode.Ok,
    data: list,
  };
});


mock.onGet('/decoration/reviewList').reply(async () => {
  return {
    status: HttpStatusCode.Ok,
    data: getReviewList(),
  };
});

// 预约设计师
mock.onPost('/decoration/order/designer').reply(async (config: AxiosRequestConfig) => {
  return {
    status: HttpStatusCode.Ok,
  };
});


mock.onPost('/decoration/Collection/add').reply(async (config: AxiosRequestConfig) => {
  const caseId = Number(JSON.parse(config.data).caseId);
  addCollection(caseId);
  return {
    status: HttpStatusCode.Ok,
  };
});


mock.onDelete('/decoration/Collection').reply(async (config: AxiosRequestConfig) => {
  const caseId = Number(JSON.parse(config.data).caseId);
  console.log('id', caseId);
  removeCollection(caseId);
  return {
    status: HttpStatusCode.Ok,
  };
});


mock.onGet('/decoration/collection/list').reply(async () => {
  return {
    status: HttpStatusCode.Ok,
    data: getCollection(),
  };
});

// 更新城市
mock.onPost('/decoration/city').reply(async (config: AxiosRequestConfig) => {
  const city = String(JSON.parse(config.data).city);
  upDateCity(city);
  return {
    status: HttpStatusCode.Ok,
  };
});

// 计算价格
mock.onPost('/decoration/account/price').reply(async (config: AxiosRequestConfig) => {
  const data = JSON.parse(config.data) as AccountPriceBody;
  const details: ProjectItem[] = getProjects();
  const list: PriceListItem[] = [];
  if (data.room && Number(data.room) > 0) {
    list.push({
      label: Number(data.room) > 1 ? `卧室·${data.room}` : '卧室',
      details,
    });
  }

  if (data.hall && Number(data.hall) > 0) {
    list.push({
      label: Number(data.hall) > 1 ? `客厅·${data.hall}` : '客厅',
      details,
    });
  }

  if (data.kitchen && Number(data.kitchen) > 0) {
    list.push({
      label: Number(data.kitchen) > 1 ? `厨房·${data.kitchen}` : '厨房',
      details,
    });
  }

  if (data.washroom && Number(data.washroom) > 0) {
    list.push({
      label: Number(data.washroom) > 1 ? `卫生间·${data.washroom}` : '卫生间',
      details,
    });
  }

  if (data.balcony && Number(data.balcony) > 0) {
    list.push({
      label: Number(data.balcony) > 1 ? `阳台·${data.balcony}` : '阳台',
      details,
    });
  }

  const res: PriceInfo = {
    mainMember: '3.23万',
    assistant: '0.79万',
    manpower: '2.75万',
    priceList: list,
  };


  return {
    status: HttpStatusCode.Ok,
    data: res,
  };
});

