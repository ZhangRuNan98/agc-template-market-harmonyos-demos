import { Constant, TitleBar } from 'foundation';

@Builder
export function TermsOfServicePageBuilder() {
  TermsOfServicePage();
}

@ComponentV2
export struct TermsOfServicePage {
  build() {
    NavDestination() {
      Column() {
        TitleBar({title: '用户协议'})
        Text('协议定义与订立主体：明确该协议是用户与租房找房app管理者之间订立的具有合同法律效力的契约，如同APP用户协议（精编版）中表明协议为用户与 app 管理者之间的契约。\n' +
          '协议生效与变更：用户同意所有协议条款并完成注册程序后，协议生效对双方产生约束力。app有权根据需要不定期制订、修改协议及各类规则，并在app平台公示，变更后的协议一经公布立即生效。若用户不同意变更，应停止使用平台服务；继续使用则表明接受修订后的协议。')
          .lineHeight(24).padding(16);
      }.width(Constant.FULL_PERCENT);
    }.hideTitleBar(true);
  }
}