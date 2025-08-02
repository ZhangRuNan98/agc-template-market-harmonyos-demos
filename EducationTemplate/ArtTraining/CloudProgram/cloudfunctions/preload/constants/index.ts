import { StoreInfo } from '../types/ResponseTypes';

const CLOUD_STORAGE_DOMAIN = 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/default-bucket-ta7go/art-training%2F';

export const BANNERS: string[] = [
  CLOUD_STORAGE_DOMAIN + 'img_course_cover1.png',
  CLOUD_STORAGE_DOMAIN + 'img_course_cover2.png',
  CLOUD_STORAGE_DOMAIN + 'img_course_cover3.png',
];

export const STORE_INFO: StoreInfo = {
  shopName: '琴之美 (鼓楼店)',
  latitude: 32.0603,
  longitude: 118.7969,
  address: '江苏省南京市鼓楼区音乐之路123号',
  phoneNumber: '+86 25 1234 5678',
  email: 'qinzhimei@test.com',
  logoUrl: CLOUD_STORAGE_DOMAIN + 'img_log_activity1.png',
  desc: CLOUD_STORAGE_DOMAIN + 'img_store_info.png',
  bannerImg: CLOUD_STORAGE_DOMAIN + 'img_course_cover1.png',
  businessTime: '9:00 - 20:00',
};
