import { FlexLayoutModel } from '../../params/response/LayoutResponse';

export class MockFlexLayout {
  static recommendList: FlexLayoutModel[] = [
    {
      navInfo: {
        setting: '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"HotNewsServiceCard","name":"热点新闻"}],"style":{"backgroundColor":"comp_background_tertiary","border-radius":16,"padding-top":"12","padding-bottom":"12","padding-left":"12","padding-right":"12","space":12}}]}]}',
      },
      articles: [
        'article_1', 'article_2', 'article_3', 'article_4', 'article_5',
      ],
      extraInfo: {},
    },
    {
      navInfo: {
        setting: '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"TopTextBottomImageCard","name":"上文下图"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","margin-top":"12"}}]}]}',
      },
      articles: [
        'article_6',
      ],
      extraInfo: {},
    },
    {
      navInfo: {
        setting: '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"LeftTextRightImageCard","name":"左文右图","style":{"padding-top":"12","padding-bottom":"12"}}],"style":{"backgroundColor":"#FFFFFF"}}]}]}',
      },
      articles: [
        'article_7', 'article_8',
      ],
      extraInfo: {},
    },
    {
      navInfo: {
        setting: '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"TopTextBottomBigImageCard","name":"上文下大图"}],"style":{"backgroundColor":"#FFFFFF","padding-top":"12","padding-bottom":"12"}}]}]}',
      },
      articles: [
        'video8',
      ],
      extraInfo: {},
    },
    {
      navInfo: {
        setting: '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"LeftTextRightImageCard","name":"左文右图"}],"style":{"backgroundColor":"#FFFFFF","margin-top":"12","margin-bottom":"24","space":"8"}}]}]}',
      },
      articles: [
        'article_10',
      ],
      extraInfo: {},
    },
    {
      navInfo: {
        setting: '{"type":"view","style":{"background-color":"#FFFFFF"},"children":[{"type":"view","style":{"background-color":"#F0F4F6"},"children":[{"type":"Scroll","style":{"background-color":null,"space":8},"children":[{"type":"native","showType":"VerticalBigImageCard","name":"竖图大图","style":{"border-radius":"8","width":"192","height":"256"}}]}]}]}',
      },
      articles: [
        'video6', 'video7',
      ],
      extraInfo: {},
    },
    {
      navInfo: {
        setting: '{"type":"view","children":[{"type":"native","showType":"AdvertisementCard","name":"横幅广告"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","margin-top":"12"}}',
      },
      articles: [],
      extraInfo: {},
    },
    {
      navInfo: {
        setting: '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"FeedDetailsCard","name":"帖子详情"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","margin-top":"12"}}]}]}',
      },
      articles: [
        'post_1',
      ],
      extraInfo: {},
    },
    {
      navInfo: {
        setting: '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"FeedDetailsCard","name":"帖子详情"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","margin-top":"12"}}]}]}',
      },
      articles: [
        'post_2',
      ],
      extraInfo: {},
    },
    {
      navInfo: {
        setting: '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"TopTextBottomVideoCard","name":"视频"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","margin-top":"12"}}]}]}',
      },
      articles: [
        'video1',
      ],
      extraInfo: {},
    },
    {
      navInfo: {
        setting: '{"type":"view","children":[{"type":"native","showType":"AdvertisementCard","name":"横幅广告"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","margin-top":"12"}}',
      },
      articles: [],
      extraInfo: {},
    },
    {
      navInfo: {
        setting: '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"TopTextBottomVideoCard","name":"视频"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","margin-top":"12"}}]}]}',
      },
      articles: [
        'video2',
      ],
      extraInfo: {},
    },
    {
      navInfo: {
        setting: '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"TopTextBottomVideoCard","name":"视频"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","margin-top":"12"}}]}]}',
      },
      articles: [
        'video3',
      ],
      extraInfo: {},
    },
    {
      navInfo: {
        setting: '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"TopTextBottomVideoCard","name":"视频"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","margin-top":"12"}}]}]}',
      },
      articles: [
        'video4',
      ],
      extraInfo: {},
    },
  ]
  static hotList: FlexLayoutModel[] = [{
    navInfo: {
      setting: '{"type":"view","children":[{"type":"view","children":[{"type":"native","showType":"HotListServiceSwitchCard","name":"热榜操作按钮"}]},{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"HotNewsServiceCard","name":"热榜新闻"}],"style":{"margin-top":"16","space":16}}]}],"style":{"backgroundColor":"comp_background_tertiary","border-radius":16,"padding-top":"12","padding-bottom":"12","padding-left":"12","padding-right":"12"}}',
    },
    extraInfo: {
      'hotList': [
        {
          'id': '1',
          'label': '我的热榜',
        },
        {
          'id': '2',
          'label': '今日热搜',
        },
        {
          'id': '3',
          'label': '实时资讯',
        },
      ],
    },
    articles: [
      'article_1', 'article_2', 'article_3', 'article_4', 'article_5', 'article_1', 'article_2', 'article_3',
      'article_4', 'article_5'
    ],
  }]
  static hotTopChart: FlexLayoutModel[] = [
    {
      navInfo: {
        setting: '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"HotNewsServiceCard","name":"热榜新闻"}],"style":{"margin-top":"16","space":16}}]}],"style":{"backgroundColor":"#ffffff","border-radius":16,"padding-bottom":"12","padding-left":"16","padding-right":"16"}}',
      },
      extraInfo: {},
      articles: [
        'article_1', 'article_2', 'article_3', 'article_4', 'article_5', 'article_1', 'article_2', 'article_3',
        'article_4', 'article_5'
      ],
    },
  ];
  static default: FlexLayoutModel = {
    navInfo: {
      setting: '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"FeedDetailsCard","name":"帖子详情"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","margin-top":"12"}}]}]}',
    },
    articles: [
      'article_13',
    ],
    extraInfo: {},
  };
}