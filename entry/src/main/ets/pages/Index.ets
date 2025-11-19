/**
 * 主界面 - 包含底部导航栏和页面切换
 */
import { AlarmListPage } from './AlarmListPage';
import { SleepPage } from './SleepPage';
import { MorningPage } from './MorningPage';
import { SettingsPage } from './SettingsPage';
import { AlarmRingingPage } from './AlarmRingingPage';
import { BottomNavBar } from '../components/BottomNavBar';
import { StorageManager } from '../database/StorageManager';
import { Alarm } from '../model/Alarm';
import { getCurrentRingingAlarmId, clearCurrentRingingAlarmId } from '../entryability/EntryAbility';

@Entry
@Component
struct Index {
  @State currentTabIndex: number = 0;
  @State showAlarmRinging: boolean = false;
  @State ringingAlarm: Alarm | null = null;
  
  private storageManager = StorageManager.getInstance();
  
  aboutToAppear() {
    // 检查是否有待响铃的闹钟
    this.checkAndShowAlarmRinging();
  }
  
  async checkAndShowAlarmRinging() {
    const alarmId = getCurrentRingingAlarmId();
    if (alarmId) {
      const alarms = await this.storageManager.getAlarms();
      const alarm = alarms.find(a => a.id === alarmId);
      if (alarm) {
        this.ringingAlarm = alarm;
        this.showAlarmRinging = true;
        // 清除标记，避免下次进入时重复触发
        clearCurrentRingingAlarmId();
      }
    }
  }
  
  onDismissAlarm() {
    this.showAlarmRinging = false;
    this.ringingAlarm = null;
  }
  
  build() {
    Column() {
      if (this.showAlarmRinging && this.ringingAlarm) {
        // 显示响铃页面
        AlarmRingingPage({
          alarm: this.ringingAlarm,
          onDismiss: () => {
            this.onDismissAlarm();
          }
        })
          .layoutWeight(1)
      } else {
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
        
        // 底部导航栏（响铃时不显示）
        BottomNavBar({ 
          currentIndex: this.currentTabIndex,
          onTabChange: (index: number) => {
            this.currentTabIndex = index;
          }
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background'))
  }
}
