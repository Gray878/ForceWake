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

import { SETTING_TYPE_MODULES } from '../constant/Index';
import { SettingModule } from '../model/Index';

@Builder
export function MineBuilder() {
  Mine();
}

@ComponentV2
export struct Mine {
  build() {
    NavDestination() {
      Column() {
        Text('我的')
          .fontSize(26)
          .width('100%')
          .textAlign(TextAlign.Start)
          .fontColor($r('sys.color.black'))
          .fontWeight(FontWeight.Bold)

        Row() {
          Text('综合工具模板')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('sys.color.font_primary'))
            .padding({ left: 6, top: 6 });
          Image($r('app.media.logo')).size({ width: 64, height: 64 });
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Top)
        .padding(12)
        .backgroundColor($r('sys.color.white'))
        .borderRadius(16)
        .margin({ top: 34 }).expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP]);

        Text('常用服务')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Start)
          .padding({ left: 12, top: 12, bottom: 12 })

        Column() {
          ForEach(SETTING_TYPE_MODULES, (item: SettingModule) => {
            Row() {
              Row({ space: 12 }) {
                Image(item.icon).size({ width: 24, height: 24 });
                Text(item.title).fontWeight(FontWeight.Medium);
              };

              Image($r('app.media.chevron_right')).size({ width: 12, height: 24 });
            }.height(56).width('100%').justifyContent(FlexAlign.SpaceBetween).onClick(item.click);
          }, (item: SettingModule) => JSON.stringify(item));
        }.backgroundColor($r('sys.color.white')).borderRadius(8).padding(12)
      }
      .width('100%')
      .height('100%')
      .padding(16)
      .backgroundColor($r('sys.color.background_secondary'))
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP]);
    }.expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP]);
  }
}