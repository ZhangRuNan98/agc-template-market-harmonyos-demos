import {
  DesignerInfo,
  ReviewItem,
  CaseInfo,
  DesignerDetail,
  ReviewInfo,
  ProjectItem,
} from '../../types/Decoration';


// 当前城市
let currCity: string = '南京';
const phone: string = '123****0665';
const details: string[] = ['case_detail1', 'case_detail2', 'case_detail3', 'case_detail4'];

// 设计师列表
const designerList: DesignerInfo[] = [
  {
    id: 1,
    name: '悠米设计',
    avatar: 'mock_header1',
    min: 200,
    max: 600,
    address: currCity,
    phone,
    goodSpace: '住宅家居',
  },
  {
    id: 2,
    name: '大卫家装设计',
    avatar: 'mock_header2',
    min: 60,
    max: 600,
    address: currCity,
    phone,
    goodSpace: '别墅豪宅',
  },
  {
    id: 3,
    name: '胡涂设计',
    avatar: 'mock_header3',
    min: 100,
    max: 200,
    address: currCity,
    phone,
    goodSpace: '别墅豪宅',
  },
  {
    id: 4,
    name: '胡涂设计',
    avatar: 'mock_header4',
    min: 60,
    max: 200,
    address: currCity,
    phone,
    goodSpace: '住宅家居',
  },
  {
    id: 5,
    name: '美好设计',
    avatar: 'mock_header3',
    min: 60,
    max: 200,
    address: currCity,
    phone,
    goodSpace: '住宅家居',
  },
];

// 案例列表
const caseList: CaseInfo[] = [
  {
    caseId: 1,
    caseType: '0',
    title: '新家装修有经验这样做',
    cover: 'article_cover1',
    homeCover: 'home_cover1',
    designer: designerList[0],
    detail: details,
    isCollected: false,
    collection: 200,
    style: '现代简约',
    homeTypeLabel: '一居室',
    room: 1,
    area: 50,
    price: 15,
  },
  {
    caseId: 2,
    caseType: '0',
    title: '超实用的装修小细节',
    cover: 'article_cover2',
    homeCover: 'home_cover2',
    designer: designerList[1],
    detail: details,
    isCollected: false,
    collection: 200,
    style: '原木风',
    homeTypeLabel: '二居室',
    room: 2,
    area: 80,
    price: 20,
  },
  {
    caseId: 3,
    caseType: '1',
    title: '三室一厅的户型，如何做出奶油风大平层？',
    cover: 'mock_cover1',
    designer: designerList[2],
    detail: details,
    isCollected: false,
    collection: 200,
    style: '奶油风',
    homeTypeLabel: '二居室',
    room: 2,
    area: 80,
    price: 20,
  },
  {
    caseId: 4,
    caseType: '1',
    title: '岛台应当如何安置？',
    cover: 'mock_cover2',
    designer: designerList[3],
    detail: details,
    isCollected: false,
    collection: 200,
    style: '原木风',
    homeTypeLabel: '二居室',
    room: 2,
    area: 80,
    price: 15,
  },
  {
    caseId: 5,
    caseType: '1',
    title: '无色就是枯燥，奶油风与绚丽多彩的完美结合',
    cover: 'mock_cover3',
    designer: designerList[4],
    detail: details,
    isCollected: false,
    collection: 200,
    style: '奶油风',
    homeTypeLabel: '三居室',
    room: 3,
    area: 90,
    price: 20,
  },
  {
    caseId: 6,
    caseType: '0',
    title: '新家装修有经验这样做',
    cover: 'article_cover1',
    homeCover: 'home_cover1',
    designer: designerList[1],
    detail: details,
    isCollected: false,
    collection: 200,
    style: '现代简约',
    homeTypeLabel: '一居室',
    room: 1,
    area: 50,
    price: 15,
  },
  {
    caseId: 7,
    caseType: '0',
    title: '超实用的装修小细节',
    cover: 'article_cover2',
    homeCover: 'home_cover2',
    designer: designerList[0],
    detail: details,
    isCollected: false,
    collection: 200,
    style: '原木风',
    homeTypeLabel: '二居室',
    room: 2,
    area: 80,
    price: 20,
  },
  {
    caseId: 21,
    caseType: '1',
    title: '60平米单室套，如何破局，成为他人羡慕的居所',
    cover: 'mock_cover1',
    designer: designerList[0],
    detail: details,
    isCollected: false,
    collection: 200,
    style: '新中式',
    homeTypeLabel: '二居室',
    room: 2,
    area: 50,
    price: 10,
  },
  {
    caseId: 22,
    caseType: '1',
    title: '素境简局·富贵荣华',
    cover: 'mock_cover2',
    designer: designerList[1],
    detail: details,
    isCollected: false,
    collection: 700,
    style: '复古风',
    homeTypeLabel: '别墅',
    room: 3,
    area: 100,
    price: 20,
  },
  {
    caseId: 23,
    caseType: '1',
    title: '宝藏之家，松弛中自带时尚张力',
    cover: 'mock_cover3',
    designer: designerList[2],
    detail: details,
    isCollected: false,
    collection: 900,
    style: '北欧风',
    homeTypeLabel: '四居以上',
    room: 4,
    area: 57,
    price: 30,
  },
  {
    caseId: 24,
    caseType: '1',
    title: '岛台应当如何安置？',
    cover: 'mock_cover4',
    designer: designerList[3],
    detail: details,
    isCollected: false,
    collection: 200,
    style: '新中式',
    homeTypeLabel: '复式',
    room: 4,
    area: 100,
    price: 35,
  },
  {
    caseId: 8,
    caseType: '0',
    title: '新家装修有经验这样做',
    cover: 'article_cover1',
    homeCover: 'home_cover1',
    designer: designerList[2],
    detail: details,
    isCollected: false,
    collection: 100,
    style: '现代简约',
    homeTypeLabel: '一居室',
    room: 1,
    area: 50,
    price: 15,
  },
  {
    caseId: 9,
    caseType: '0',
    title: '超实用的装修小细节',
    cover: 'article_cover2',
    homeCover: 'home_cover2',
    designer: designerList[2],
    detail: details,
    isCollected: false,
    collection: 100,
    style: '原木风',
    homeTypeLabel: '四居以上',
    room: 4,
    area: 180,
    price: 20,
  },
  {
    caseId: 10,
    caseType: '0',
    title: '新家装修有经验这样做',
    cover: 'article_cover1',
    homeCover: 'home_cover1',
    designer: designerList[3],
    detail: details,
    isCollected: false,
    collection: 100,
    style: '现代简约',
    homeTypeLabel: '一居室',
    room: 1,
    area: 50,
    price: 15,
  },
  {
    caseId: 11,
    caseType: '0',
    title: '超实用的装修小细节',
    cover: 'article_cover2',
    homeCover: 'home_cover2',
    designer: designerList[3],
    detail: details,
    isCollected: false,
    collection: 100,
    style: '原木风',
    homeTypeLabel: '二居室',
    room: 2,
    area: 80,
    price: 20,
  },
  {
    caseId: 12,
    caseType: '0',
    title: '新家装修有经验这样做',
    cover: 'article_cover1',
    homeCover: 'home_cover1',
    designer: designerList[4],
    detail: details,
    isCollected: false,
    collection: 100,
    style: '现代简约',
    homeTypeLabel: '一居室',
    room: 1,
    area: 50,
    price: 15,
  },
  {
    caseId: 13,
    caseType: '0',
    title: '超实用的装修小细节',
    cover: 'article_cover2',
    homeCover: 'home_cover2',
    designer: designerList[4],
    detail: details,
    isCollected: false,
    collection: 100,
    style: '原木风',
    homeTypeLabel: '二居室',
    room: 2,
    area: 80,
    price: 20,
  },

  {
    caseId: 14,
    caseType: '1',
    title: '宝藏之家，松弛中自带时尚张力',
    cover: 'mock_cover4',
    designer: designerList[4],
    detail: details,
    isCollected: false,
    collection: 200,
    style: '北欧风',
    homeTypeLabel: '四居以上',
    room: 4,
    area: 57,
    price: 30,
  },
  {
    caseId: 15,
    caseType: '1',
    title: '岛台应当如何安置？',
    cover: 'mock_cover2',
    designer: designerList[3],
    detail: details,
    isCollected: false,
    collection: 200,
    style: '新中式',
    homeTypeLabel: '四居以上',
    room: 4,
    area: 100,
    price: 35,
  },
  {
    caseId: 16,
    caseType: '1',
    title: '90后南京女生爆改老城区老破小',
    cover: 'mock_cover3',
    designer: designerList[2],
    detail: details,
    isCollected: false,
    collection: 200,
    style: '奶油风',
    homeTypeLabel: '三居室',
    room: 3,
    area: 90,
    price: 20,
  },
  {
    caseId: 17,
    caseType: '1',
    title: '宝藏之家，松弛中自带时尚张力',
    cover: 'mock_cover4',
    designer: designerList[0],
    detail: details,
    isCollected: false,
    collection: 200,
    style: '北欧风',
    homeTypeLabel: '四居以上',
    room: 4,
    area: 57,
    price: 30,
  },
  {
    caseId: 18,
    caseType: '1',
    title: '岛台应当如何安置？',
    cover: 'mock_cover2',
    designer: designerList[1],
    detail: details,
    isCollected: false,
    collection: 200,
    style: '新中式',
    homeTypeLabel: '四居以上',
    room: 4,
    area: 100,
    price: 35,
  },
  {
    caseId: 19,
    caseType: '1',
    title: '90后南京女生爆改老城区老破小',
    cover: 'mock_cover3',
    designer: designerList[0],
    detail: details,
    isCollected: false,
    collection: 200,
    style: '样板间',
    homeTypeLabel: '三居室',
    room: 3,
    area: 90,
    price: 20,
  },
  {
    caseId: 20,
    caseType: '1',
    title: '三室一厅的户型，如何做出奶油风大平层？',
    cover: 'mock_cover1',
    designer: designerList[1],
    detail: details,
    isCollected: false,
    collection: 200,
    style: '奶油风',
    homeTypeLabel: '二居室',
    room: 2,
    area: 80,
    price: 20,
  },
  {
    caseId: 25,
    caseType: '1',
    title: '90后南京女生爆改老城区老破小',
    cover: 'mock_cover5',
    designer: designerList[4],
    detail: details,
    isCollected: false,
    collection: 200,
    style: '轻奢风',
    homeTypeLabel: '三居室',
    room: 3,
    area: 90,
    price: 20,
  },
];

// 热门搜索词
const hotKeys: string[] = ['原木风', '奶油风', '新中式', '北欧风'];

const reviewList: ReviewItem[] = [
  {
    reviewId: 1,
    authorAvatar: 'mock_header1',
    author: '张三',
    reviewType: '好评',
    postTime: '2025/05/20',
    review: '房子不大不小一家三口居住，喜欢空间通透，吧台式休闲用餐开放厨房，风格比较偏好现代黑白灰和一些亮色点缀，设计师方案还有效果上都把控的比较好很专业，也能get到我们很多喜欢的点，给了许多实质性的建议，软装细致的和我们一件件对，整体效果非常满意，服务也可以的，现在施工已经进行了一半，期待最后的正品~',
  },
  {
    reviewId: 2,
    authorAvatar: 'mock_header1',
    author: '李四',
    reviewType: '好评',
    postTime: '2025/05/20',
    review: '一开始有点纠结，毕竞我们属于非同城设计，怕只是网路上沟通会不顺，影响我们最终的效果，通过几次网络会议沟通，设计师给了我们比较大的信心，不管是专业度还是耐心程度上都很不错，施工过程中，我们有个微信群，群里设计师也是及时跟进解决问题，不管是选择材料还是现场干活的师傅的问题，都能及时回应，这点我们很满意！已经软装入场了，效果如期而至，啦啦啦',
  },
  {
    reviewId: 3,
    authorAvatar: 'mock_header1',
    author: '王五',
    reviewType: '好评',
    postTime: '2025/05/20',
    review: '简约大方',
  },
];

let collectionList: Array<number> = [];

// 报价
const projects: ProjectItem[] = [
  {
    name: '顶面墙固',
    quantity: 18,
    price: 10,
    total: 180,
  },
  {
    name: '侧面墙固',
    quantity: 18,
    price: 10,
    total: 180,
  },
  {
    name: '顶面防水',
    quantity: 18,
    price: 10,
    total: 180,
  },
  {
    name: '旧墙拆除',
    quantity: 18,
    price: 10,
    total: 180,
  },
];



const reviewInfo: ReviewInfo = {
  applauseRate: 100,
  reviewList: reviewList,
};


export const getCaseList = (): Array<CaseInfo> => {
  return caseList;
};

export const getHotKeys = (): Array<string> => {

  return hotKeys;
};

// 获取设计师详情
export const getDesignerList = (): Array<DesignerDetail> => {
  const designerDetailList = designerList.map((item: DesignerInfo) => {
    const ownerCases = caseList.filter((val) => val.designer.id === item.id && val.caseType === '1');
    const ownerArticle = caseList.filter((val) => val.designer.id === item.id && val.caseType === '0');
    const data: DesignerDetail = {
      id: item.id,
      name: item.name,
      min: item.min,
      max: item.max,
      avatar: item.avatar,
      address: currCity,
      ownerCases: ownerCases,
      goodSpace: item.goodSpace,
      phone: item.phone,
      ownerArticle: ownerArticle,
    };
    return data;
  });
  return designerDetailList;
};


// 获取评论
export const getReviewList = (): ReviewInfo => {
  return reviewInfo;
};

export const getCollection = () => {
  return collectionList;
};


export const addCollection = (caseId: number) => {
  collectionList = collectionList.filter(item => item !== caseId);
  collectionList.unshift(caseId);
};

export const removeCollection = (caseId: number) => {
  collectionList = collectionList.filter(item => item !== caseId);
};

export const upDateCity = (city: string) => {
  if (city) {
    currCity = city;
    designerList.forEach((item: DesignerInfo) => {
      item.address = currCity;
    });
  }
};


export const getProjects = () => {
  return projects;
};



