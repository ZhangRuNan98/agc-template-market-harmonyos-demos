import { BuilderNode, FrameNode, NodeController, typeNode } from '@kit.ArkUI';
import { LayoutSetting, NewsResponse } from 'lib_news_api';
import { transformLayout } from 'lib_native_components';
import { IButtonItem } from 'lib_widget';
import { FrameNodeParams } from '../model/Model';
import { ScrollNodeBuilder } from '../builder/scrollNodeBuild/ScrollNodeBuilder';
import { ListNodeBuilder } from '../builder/listNodeBuilder/ListNodeBuilder';

import { getNativeNodeController } from './NativeNodeFactory';

export const nodeMap: Map<string, FrameController | undefined> = new Map();

export function FrameNodeFactory(vm: LayoutSetting, articles: NewsResponse[],
  extraInfo: Record<string, string | boolean | Record<string, string | boolean>[]>,
  context: UIContext): FrameNode | null {
  if (vm.type === 'view') {
    let node = typeNode.createNode(context, 'Column');
    setColumnNodeAttr(node, vm.style);
    vm.children?.forEach(kid => {
      let child = FrameNodeFactory(kid, articles, extraInfo, context);
      node.appendChild(child);
    });
    return node;
  }
  if (vm.type === 'Swiper') {
    let node = typeNode.createNode(context, 'Swiper');
    vm.children?.forEach(kid => {
      let child = FrameNodeFactory(kid, articles, extraInfo, context);
      node.appendChild(child);
    });
    return node;
  }
  if (vm.type === 'Scroll') {
    let node = typeNode.createNode(context, 'Column');
    setColumnNodeAttr(node, vm.style);
    let nativeNode: BuilderNode<[FrameNodeParams]> = new BuilderNode(context);
    nativeNode.build(wrapBuilder<[FrameNodeParams]>(ScrollNodeBuilder),
      new FrameNodeParams(vm, articles, vm.style, extraInfo));
    return nativeNode.getFrameNode()
  }
  if (vm.type === 'List') {
    let node = typeNode.createNode(context, 'Column');
    setColumnNodeAttr(node, vm.style);
    let nativeNode: BuilderNode<[FrameNodeParams]> = new BuilderNode(context);
    nativeNode.build(wrapBuilder<[FrameNodeParams]>(ListNodeBuilder),
      new FrameNodeParams(vm, articles, vm.style, extraInfo));
    node.appendChild(nativeNode.getFrameNode())
    return node
  }
  if (vm.type === 'native') {
    let node = typeNode.createNode(context, 'Column');
    setColumnNodeAttr(node, vm.style);
    node.appendChild(getNativeNodeController(context, {
      type: vm.showType,
      extraInfo: extraInfo,
      layout: vm,
    })?.makeNode());
    return node;
  }
  return null;
}


function setColumnNodeAttr(node: typeNode.Column, style: Record<string, string | number>) {
  node.attribute.borderRadius(transformLayout(style)?.borderRadius)
  node.attribute.backgroundColor($r(`app.sys.${style?.backgroundColor}`))
  node.attribute.padding({
    left: transformLayout(style)?.paddingLeft,
    top: transformLayout(style)?.paddingTop,
    bottom: transformLayout(style)?.paddingBottom,
    right: transformLayout(style)?.paddingRight,
  })
  node.attribute.margin({
    top: transformLayout(style)?.marginTop,
  })
  if (style?.width) {
    node.attribute.width(style.width)
  }
  if (style?.height) {
    node.attribute.height(style.height)
  }
}

export class FrameController extends NodeController {
  setting: LayoutSetting
  articles: NewsResponse[]
  extraInfo: Record<string, string | boolean | Record<string, string | boolean>[]>

  constructor(setting: LayoutSetting, articles: NewsResponse[],
    extraInfo: Record<string, string | boolean | Record<string, string | boolean>[]>) {
    super()
    this.setting = setting
    this.articles = articles
    this.extraInfo = extraInfo
  }

  makeNode(uiContext: UIContext): FrameNode | null {
    return FrameNodeFactory(this.setting, this.articles, this.extraInfo, uiContext);
  }
}