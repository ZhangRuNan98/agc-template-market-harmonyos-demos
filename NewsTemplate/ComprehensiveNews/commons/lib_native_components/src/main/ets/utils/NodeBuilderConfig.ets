import { Logger } from 'lib_common'
import { LayoutParams } from 'lib_news_api'
const TAG = 'NodeBuilderConfig'
export class NodeBuilderConfig {
  buildNodeMap: Map<string, WrappedBuilder<[LayoutParams]>> = new Map()
  private static _instance: NodeBuilderConfig

  public static get instance() {
    if (!NodeBuilderConfig._instance) {
      NodeBuilderConfig._instance = new NodeBuilderConfig()
    }
    return NodeBuilderConfig._instance
  }

  public registerBuilderCard(key: string, value:WrappedBuilder<[LayoutParams]>) {
    if (!this.buildNodeMap.has(key)) {
      this.buildNodeMap.set(key, value)
    }
  }

  public getBuilderNode(key: string):WrappedBuilder<[LayoutParams]> | undefined {
    if (!this.buildNodeMap.has(key)) {
      Logger.error(TAG, `can not find ${key} register`)
    }
    return this.buildNodeMap.get(key)
  }
}

