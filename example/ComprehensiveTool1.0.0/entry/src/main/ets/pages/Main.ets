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

import { TabBarType } from '../constant/Enum';
import { stack } from '../constant/Index';
import { Home } from './Home';
import { Mine } from './Mine';

@Entry
@ComponentV2
struct Main {
  @Local homeTabIndex: number = 0;

  @Builder
  mainTabBar(title: ResourceStr, targetIndex: number, selectedImg: ResourceStr, normalImg: ResourceStr) {
    Column({ space: 4 }) {
      Image(this.homeTabIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 24, height: 24 });
      Text(title)
        .fontSize(10)
        .fontColor(this.homeTabIndex === targetIndex ? $r('sys.color.font_emphasize') :
        $r('sys.color.font_secondary'))
        .opacity(this.homeTabIndex === targetIndex ? 1 : 0.6);
    }
    .onClick(() => {
      this.homeTabIndex = targetIndex;
    })
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('rgba(241, 243, 245, 0.8)');
  }

  build() {
    Navigation(stack) {
      Tabs({ index: this.homeTabIndex }) {
        TabContent() {
          Home();
        }
        .tabBar(this.mainTabBar('首页', TabBarType.HOME, $r('app.media.home_active'), $r('app.media.home_inactive')));

        TabContent() {
          Mine();
        }.expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .tabBar(this.mainTabBar('我的', TabBarType.MINE, $r('app.media.mine_active'), $r('app.media.mine_inactive')));
      }
      .clip(true)
      .barMode(BarMode.Fixed)
      .scrollable(false)
      .animationDuration(0)
      .barPosition(BarPosition.End)
      .barBackgroundColor($r('sys.color.background_secondary'))
      .height('100%').expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .onChange((value: number) => {
        this.homeTabIndex = value;
      })
    }.hideTitleBar(true).mode(NavigationMode.Stack);
  }
}