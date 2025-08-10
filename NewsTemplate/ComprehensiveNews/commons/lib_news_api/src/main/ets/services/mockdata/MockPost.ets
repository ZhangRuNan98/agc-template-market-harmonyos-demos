import { NewsEnum } from '../../constants/Constants';
import { BaseNews } from '../../database/NewsType';
import { RequestListData } from '../../params/response/LayoutResponse';

export class MockPost {
  static mineList: BaseNews[] = [
    {
      id: 'post_mine_1',
      type: NewsEnum.Post,
      likeCount: 12,
      commentCount: 15,
      isLiked: false,
      isMarked: false,
      recommends: [{
        newsId: 'article_11',
        newsType: 1,
      }, {
        newsId: 'article_12',
        newsType: 1,
      }],
      shareCount: 120,
      markCount: 45,
      articleFrom: '',
      title: '假期的旅行碎片已加载完毕～。旅行哪里是逃离呀，分明是让你在人山人海里，重新找到自己的位置，原来旅行的意义，真的藏在那些不期而遇里，走在陌生的街道，看当地人慢悠悠地喝茶，突然懂了 “慢下来” 不是浪费时，原来自己比想象中更有韧性呀。',
      richContent: '',
      authorId: '001',
      createTime: 1751076002000,
      postImgList: [
        {
          picVideoUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_2.jpg',
          surfaceUrl: '',
        },
        {
          picVideoUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_3.jpg',
          surfaceUrl: '',
        },
        {
          picVideoUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_4.jpg',
          surfaceUrl: '',
        },
        {
          picVideoUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_5.jpg',
          surfaceUrl: '',
        },
        {
          picVideoUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_6.jpg',
          surfaceUrl: '',
        },
        {
          picVideoUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_7.jpg',
          surfaceUrl: '',
        },
        {
          picVideoUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_8.jpg',
          surfaceUrl: '',
        },
        {
          picVideoUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_9.jpg',
          surfaceUrl: '',
        },
        {
          picVideoUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_10.jpg',
          surfaceUrl: '',
        },
      ],
      navInfo: {
        setting: '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"FeedDetailsCard","name":"帖子详情"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","padding-top":"12"}}]}]}',
      },
    },
    {
      id: 'post_mine_2',
      type: NewsEnum.Post,
      likeCount: 36,
      commentCount: 175,
      isMarked: false,
      isLiked: false,
      markCount: 4500,
      articleFrom: '',
      shareCount: 12000,
      title: '#旅行的意义 #在路上',
      recommends: [{
        newsId: 'article_8',
        newsType: 1,
      }, {
        newsId: 'article_13',
        newsType: 1,
      }],
      richContent: '',
      authorId: '001',
      createTime: 1750557602000,
      postImgList: [
        {
          picVideoUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_11.jpg',
          surfaceUrl: '',
        },
      ],
      navInfo: {
        setting: '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"FeedDetailsCard","name":"帖子详情"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","padding-top":"12"}}]}]}',
      },
    },
  ];
  static list: BaseNews[] = [
    ...MockPost.mineList,
    {
      id: 'post_1',
      type: NewsEnum.Post,
      likeCount: 36,
      commentCount: 175,
      shareCount: 12000,
      isLiked: false,
      isMarked: false,
      markCount: 4500,
      articleFrom: '',
      recommends: [{
        newsId: 'article_11',
        newsType: 1,
      }, {
        newsId: 'article_12',
        newsType: 1,
      }],
      title: '假期的旅行碎片已加载完毕～。旅行哪里是逃离呀，分明是让你在人山人海里，重新找到自己的位置，原来旅行的意义，真的藏在那些不期而遇里，走在陌生的街道，看当地人慢悠悠地喝茶，突然懂了 “慢下来” 不是浪费时，原来自己比想象中更有韧性呀。',
      richContent: '',
      authorId: 'author_6',
      createTime: 1751089800000,
      postImgList: [
        {
          picVideoUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_2.jpg',
          surfaceUrl: '',
        },
        {
          picVideoUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_8.jpg',
          surfaceUrl: '',
        },
        {
          picVideoUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_3.jpg',
          surfaceUrl: '',
        },
        {
          picVideoUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_5.jpg',
          surfaceUrl: '',
        },
        {
          picVideoUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_4.jpg',
          surfaceUrl: '',
        },
        {
          picVideoUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_6.jpg',
          surfaceUrl: '',
        },
        {
          picVideoUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_10.jpg',
          surfaceUrl: '',
        },
        {
          picVideoUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_7.jpg',
          surfaceUrl: '',
        },
        {
          picVideoUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_9.jpg',
          surfaceUrl: '',
        },

      ],
      navInfo: {
        setting: '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"FeedDetailsCard","name":"帖子详情"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","padding-top":"12"}}]}]}',
      },
    },
    {
      id: 'post_2',
      type: NewsEnum.Post,
      likeCount: 36,
      commentCount: 175,
      shareCount: 12000,
      isLiked: false,
      isMarked: false,
      markCount: 4500,
      articleFrom: '',
      recommends: [{
        newsId: 'article_8',
        newsType: 1,
      }, {
        newsId: 'article_13',
        newsType: 1,
      }],
      title: '#旅行的意义 #在路上',
      richContent: '',
      authorId: 'author_6',
      createTime: 1751089800000,
      postImgList: [
        {
          picVideoUrl: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_11.jpg',
          surfaceUrl: '',
        },
      ],
      navInfo: {
        setting: '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"FeedDetailsCard","name":"帖子详情"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","padding-top":"12"}}]}]}',
      },
    },
    {
      id: 'post_3',
      type: NewsEnum.Post,
      likeCount: 36,
      commentCount: 175,
      shareCount: 12000,
      isLiked: false,
      isMarked: false,
      markCount: 4500,
      articleFrom: '',
      recommends: [{
        newsId: 'article_8',
        newsType: 1,
      }, {
        newsId: 'article_13',
        newsType: 1,
      }],
      title: '#好好学习、天天向上# 学而时习之',
      richContent: '',
      authorId: 'author_6',
      createTime: 1751089800000,
      postImgList: [
        {
          picVideoUrl: 'https://e-file.huawei.com/mediares/Video_MCD/EBG/PUBLIC/zh/2025/04/3c04b872-197d-4551-a353-0eb99def6ca2.png',
          surfaceUrl: '',
        },
        {
          picVideoUrl: 'https://e-file.huawei.com/mediares/Video_MCD/EBG/PUBLIC/zh/2025/05/43f01339-48e0-4e5d-a433-ccb8c423cdfe.png',
          surfaceUrl: '',
        },
        {
          picVideoUrl: 'https://www-file.huawei.com/admin/asset/v1/pro/view/2644ff4ada00431f91c7d31209cf5f9b.jpg',
          surfaceUrl: '',
        },
        {
          picVideoUrl: 'https://www-file.huawei.com/admin/asset/v1/pro/view/ca03b4509af94cadbdde656fd9cd23ef.jpg',
          surfaceUrl: '',
        },
      ],
      navInfo: {
        setting: '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"FeedDetailsCard","name":"帖子详情"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","padding-top":"12"}}]}]}',
      },
    },
    {
      id: 'post_4',
      type: NewsEnum.Post,
      likeCount: 36,
      commentCount: 175,
      shareCount: 12000,
      isLiked: false,
      isMarked: false,
      markCount: 4500,
      articleFrom: '',
      recommends: [{
        newsId: 'article_8',
        newsType: 1,
      }, {
        newsId: 'article_13',
        newsType: 1,
      }],
      title: '清晨的阳光总是带着点懒意，悄悄爬上窗帘缝隙时，先别急着掀开被子。听会儿窗外的鸟鸣，是麻雀在树枝上跳来跳去的碎语，还是鸽子带着哨音从楼顶掠过？',
      richContent: '',
      authorId: 'author_5',
      createTime: 1751089800000,
      postImgList: [
        {
          picVideoUrl: 'https://www-file.huawei.com/admin/asset/v1/pro/view/ca03b4509af94cadbdde656fd9cd23ef.jpg',
          surfaceUrl: '',
        },
      ],
      navInfo: {
        setting: '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"FeedDetailsCard","name":"帖子详情"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","padding-top":"12"}}]}]}',
      },
    },
  ];
  static default: RequestListData = {
    navInfo: {
      setting: '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"FeedDetailsCard","name":"帖子详情"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","margin-top":"12"}}]}]}',
    },
    articles: [
      {
        id: 'article_13',
        type: NewsEnum.Post,
        likeCount: 0,
        commentCount: 0,
        comments: [],
        shareCount: 0,
        isLiked: false,
        isMarked: false,
        markCount: 0,
        articleFrom: '',
        title: '',
        author: {
          authorId: '7',
          authorNickName: '7号选手',
          authorIcon: 'app.media.ic_user_default',
          authorDesc: '',
          authorIp: '北京',
          watchersCount: 12724,
          followersCount: 11712,
          likeNum: 12172,
        },
        createTime: new Date().getTime(),
        postImgList: [
          {
            picVideoUrl: '',
            surfaceUrl: '',
          },
        ],
      },
    ],
    extraInfo: {},
  };
}