import { FeedbackBody, FeedbackInfo } from './Types';


export class FeedbackApi {
  static FEEDBACK_HISTORY: FeedbackInfo[] = [
    {
      title: '装修时打柜子好还是买现成的组装好？',
      type: '0',
      postTime: '2025-06-05',
      answer: '‌个性化定制‌：打柜子可以根据房屋的实际尺寸、空间布局以及个人的使用习惯和需求进行量身定制，确保每一寸空间都能得到充分利用，满足个性化需求‌\n' +
        '‌质量可控‌：选择优质的材料和经验丰富的木工师傅，可以确保柜子的质量和耐用性‌。\n' +
        '‌环保可控‌：自己购买材料并监督制作过程，可以更好地控制材料的环保性，确保家居环境的健康和安全‌。\n' +
        '‌成本可控‌：相对于全屋定制，打柜子的成本通常更低，尤其是对于预算有限的家庭来说更为经济实惠‌。\n' +
        '\n' +
        '‌缺点‌：\n' +
        '价格可能较高‌：如果要求设计复杂、材质高档，打柜子的价格可能会比买现成柜子更高‌。\n' +
        '‌制作周期长‌：从设计、制作到安装，整个过程需要耗费一定的时间和精力，不适合急需使用的家庭‌。\n' +
        '‌工艺粗糙‌：木工现场制作的柜子在工艺上可能略显粗糙，尤其是封边、收口等细节处理上可能不够精细‌。',
    },
    {
      title: '电视柜是否有存在的必要？',
      type: '1',
      postTime: '2025-06-04',
      answer: '',
    },
  ];

  static queryFeedback(): Promise<FeedbackInfo[]> {
    return Promise.resolve(FeedbackApi.FEEDBACK_HISTORY);
  }


  static uploadFeedback(data: FeedbackBody): Promise<boolean> {
    FeedbackApi.FEEDBACK_HISTORY.push({
      title: data.title,
      type: data.title,
      postTime: data.postTime,
      answer: '',
    });
    return Promise.resolve(true);
  }
}