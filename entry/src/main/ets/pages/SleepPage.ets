/**
 * 睡眠页面
 */
import { StorageManager } from '../database/StorageManager';
import { SleepReminder } from '../model/SleepData';
import { Utils } from '../common/Utils';

@Component
export struct SleepPage {
  @State sleepReminder: SleepReminder = { isEnabled: false, hour: 23, minute: 0 };
  @State showTimePicker: boolean = false;
  
  private storageManager = StorageManager.getInstance();
  
  aboutToAppear() {
    this.loadSleepReminder();
  }
  
  async loadSleepReminder() {
    this.sleepReminder = await this.storageManager.getSleepReminder();
  }
  
  async onReminderToggle(isEnabled: boolean) {
    this.sleepReminder.isEnabled = isEnabled;
    await this.storageManager.saveSleepReminder(this.sleepReminder);
  }
  
  async onTimeChange(hour: number, minute: number) {
    this.sleepReminder.hour = hour;
    this.sleepReminder.minute = minute;
    await this.storageManager.saveSleepReminder(this.sleepReminder);
  }
  
  build() {
    Column() {
      // 标题
      Text($r('app.string.sleep'))
        .fontSize(24)
        .fontColor($r('app.color.text_primary'))
        .fontWeight(FontWeight.Bold)
        .alignSelf(ItemAlign.Start)
        .margin({ left: 16, top: 16, bottom: 24 })
      
      Scroll() {
        Column() {
          // 睡眠提醒卡片
          Column() {
            Row() {
              Text($r('app.string.sleep_reminder'))
                .fontSize(16)
                .fontColor($r('app.color.text_primary'))
                .fontWeight(FontWeight.Medium)
              
              Blank()
              
              Toggle({ type: ToggleType.Switch, isOn: this.sleepReminder.isEnabled })
                .selectedColor($r('app.color.accent_blue'))
                .onChange((isOn: boolean) => {
                  this.onReminderToggle(isOn);
                })
            }
            .width('100%')
            
            if (this.sleepReminder.isEnabled) {
              Text(this.formatTime(this.sleepReminder.hour, this.sleepReminder.minute))
                .fontSize(20)
                .fontColor($r('app.color.text_primary'))
                .margin({ top: 12 })
                .alignSelf(ItemAlign.Start)
                .onClick(() => {
                  this.showTimePicker = true;
                })
            }
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 16 })
          .backgroundColor($r('app.color.card_background'))
          .borderRadius(12)
          .margin({ left: 16, right: 16, bottom: 24 })
          
          // 睡眠指标卡片
          Column() {
            Row() {
              this.SleepMetricItem('睡眠时间', '今天', Color.Blue)
              Divider()
                .vertical(true)
                .height(40)
                .margin({ left: 16, right: 16 })
              this.SleepMetricItem('睡眠效率', '', $r('app.color.text_secondary'))
              Divider()
                .vertical(true)
                .height(40)
                .margin({ left: 16, right: 16 })
              this.SleepMetricItem('打鼾', '', $r('app.color.text_secondary'))
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
          }
          .width('100%')
          .backgroundColor($r('app.color.card_background'))
          .borderRadius(12)
          .margin({ left: 16, right: 16, bottom: 24 })
          
          // 提示信息
          Column() {
            Text('您的睡眠时间')
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 8 })
            
            Text('没有您想象的那么多')
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 8 })
            
            Text('我的实际睡眠时间充足吗?')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ bottom: 24 })
            
            // 沙漏图标（使用Text模拟）
            Text('⏳')
              .fontSize(80)
              .margin({ bottom: 24 })
          }
          .width('100%')
          .padding({ top: 24, bottom: 24 })
          .alignItems(HorizontalAlign.Center)
          .margin({ bottom: 24 })
          
          // 跟踪睡眠按钮
          Button($r('app.string.track_sleep'))
            .type(ButtonType.Capsule)
            .width('90%')
            .height(50)
            .fontSize(16)
            .fontColor(Color.White)
            .backgroundColor($r('app.color.accent_blue'))
            .margin({ bottom: 16 })
          
          // 睡眠报告链接
          Row() {
            Text($r('app.string.sleep_report'))
              .fontSize(14)
              .fontColor($r('app.color.text_primary'))
            
            Blank()
            
            Text('>')
              .fontSize(16)
              .fontColor($r('app.color.text_secondary'))
          }
          .width('90%')
          .padding({ bottom: 24 })
        }
        .width('100%')
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background'))
  }
  
  @Builder
  SleepMetricItem(label: string, subtitle: string, iconColor: ResourceColor) {
    Column() {
      Column() {
        Text('🌙')
          .fontSize(24)
      }
      .width(40)
      .height(40)
      .backgroundColor(iconColor)
      .borderRadius(20)
      .justifyContent(FlexAlign.Center)
      .margin({ bottom: 8 })
      
      Text(label)
        .fontSize(12)
        .fontColor($r('app.color.text_primary'))
      
      if (subtitle) {
        Text(subtitle)
          .fontSize(10)
          .fontColor($r('app.color.text_secondary'))
          .margin({ top: 4 })
      }
    }
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Center)
  }
  
  private formatTime(hour: number, minute: number): string {
    const period = hour >= 12 ? '下午' : '上午';
    const displayHour = hour > 12 ? hour - 12 : (hour === 0 ? 12 : hour);
    return `${displayHour}:${minute.toString().padStart(2, '0')} ${period}`;
  }
}
