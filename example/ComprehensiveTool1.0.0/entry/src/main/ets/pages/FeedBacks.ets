/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { stack } from '../constant/Index';
import { FeedBack } from '../model/FeedBacks';
import { MineVM } from '../viewmodel/MineVM';

@Builder
export function FeedBacksBuilder() {
  FeedBacks();
}

@Preview
@ComponentV2
export struct FeedBacks {
  vm: MineVM = MineVM.instance;

  build() {
    NavDestination() {
      Column() {
        Row() {
          Row({ space: 8 }) {
            Image($r('app.media.icon_nav_left'))
              .size({ height: 40, width: 40 })
              .onClick(() => {
                stack.pop();
              });
            Text('意见与反馈')
              .fontSize(20)
              .width('50%')
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
              .fontColor($r('sys.color.black'))
              .fontWeight(FontWeight.Medium);
          };
        }
        .margin({ bottom: 8 })
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({
          left: 12,
          right: 12,
        });

        Column() {
          Column() {
            if (this.vm.feedbacks.contents.length) {
              List({ space: 12 }) {
                ForEach(this.vm.feedbacks.contents, (item: FeedBack) => {
                  ListItem() {
                    Column({ space: 12 }) {
                      Text(`${item.date}`).opacity(0.9)
                        .fontColor($r('sys.color.black'));
                      Text(`问题反馈：`).fontSize(14).opacity(0.6)
                        .fontColor($r('sys.color.black'));
                      Text(`${item.content}`)
                        .fontColor($r('sys.color.black'));
                    }
                    .padding(12)
                    .borderRadius(16)
                    .backgroundColor($r('sys.color.comp_background_primary'))
                    .width('100%')
                    .borderRadius(16)
                    .alignItems(HorizontalAlign.Start);
                  };
                }, (item: FeedBack) => item.content);
              };
            } else {
              Column({ space: 24 }) {
                Image($r('app.media.empty')).size({ height: 120, width: 120 });
                Text('暂无记录~~').opacity(0.6).fontColor($r('sys.color.font_secondary'));
              };
            }
          }
          .padding(16)
          .height('calc(100% - 108vp)')
          .justifyContent(this.vm.feedbacks.contents.length ? FlexAlign.Start : FlexAlign.Center);
        }
      }.height('100%').width('100%').backgroundColor($r('sys.color.background_secondary')).expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
    }.hideTitleBar(true).onReady(() => {
      this.vm.queryFeedbacks();
    });
  }
}