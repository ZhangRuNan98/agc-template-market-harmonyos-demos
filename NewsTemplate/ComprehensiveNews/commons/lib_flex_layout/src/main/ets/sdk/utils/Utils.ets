import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';

export function pxToVp(layout: Record<string, string>) {
  let result: Record<string, string> = {}
  Object.keys(layout).forEach((item: string) => {
    if (layout[item].includes('px')) {
      result[item] = layout[item].split('px')[0]
    } else {
      result[item] = layout[item]
    }
  })
  return result
}
