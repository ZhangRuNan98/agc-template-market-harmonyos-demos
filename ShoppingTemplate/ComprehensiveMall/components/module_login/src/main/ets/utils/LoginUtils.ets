import { routerStack } from 'lib_foundation';

export async function promptLogin(): Promise<void> {
  return new Promise((resolve) => {
    routerStack.pushPathByName('HuaweiQuickLoginPage', () => resolve());
  });
}
