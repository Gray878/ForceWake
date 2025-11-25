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

import { Feedback } from '../components/Feedback';
import { stack } from '../constant/Index';
import { FeedbackItemType } from '../model/FeedbackRecordModel';
import { MineVM } from '../viewmodel/MineVM';

@Builder
export function SubmitFeedBackBuilder() {
  SubmitFeedBack();
}

@ComponentV2
export struct SubmitFeedBack {
  vm: MineVM = MineVM.instance;
  @Local isSelected: boolean = false;
  @Local localImgUri: string = '';
  @Local phoneNo: string = '';
  controller: TextInputController = new TextInputController();

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

          Image($r('app.media.feedbacks')).size({ width: 40, height: 40 }).onClick(() => {
            stack.pushPathByName('FeedBacks', null);
          });
        }
        .margin({ bottom: 8 })
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({
          left: 12,
          right: 12,
        });

        Feedback({
          des: 100,
          num: 3,
          butOnClick: (val: FeedbackItemType) => {
            this.vm.submit(val);
          },
        });
      }.height('100%').backgroundColor($r('sys.color.background_secondary')).expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
    }.hideTitleBar(true);
  }
}
