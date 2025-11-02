/**
 * 主界面 - 包含底部导航栏和页面切换
 */
import { AlarmListPage } from './AlarmListPage';
import { SleepPage } from './SleepPage';
import { MorningPage } from './MorningPage';
import { SettingsPage } from './SettingsPage';
import { BottomNavBar } from '../components/BottomNavBar';

@Entry
@Component
struct Index {
  @State currentTabIndex: number = 0;
  
  build() {
    Column() {
      // 主内容区域
      if (this.currentTabIndex === 0) {
        AlarmListPage()
          .layoutWeight(1)
      } else if (this.currentTabIndex === 1) {
        SleepPage()
          .layoutWeight(1)
      } else if (this.currentTabIndex === 2) {
        MorningPage()
          .layoutWeight(1)
      } else if (this.currentTabIndex === 3) {
        // 报告页面（暂时使用占位）
        Column() {
          Text('报告')
            .fontSize(24)
            .fontColor($r('app.color.text_primary'))
        }
        .layoutWeight(1)
        .width('100%')
        .justifyContent(FlexAlign.Center)
      } else if (this.currentTabIndex === 4) {
        SettingsPage()
          .layoutWeight(1)
      }
      
      // 底部导航栏
      BottomNavBar({ 
        currentIndex: this.currentTabIndex,
        onTabChange: (index: number) => {
          this.currentTabIndex = index;
        }
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background'))
  }
}
