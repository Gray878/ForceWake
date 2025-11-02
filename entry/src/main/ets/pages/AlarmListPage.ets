/**
 * 闹钟列表页面
 */
import { Alarm } from '../model/Alarm';
import { StorageManager } from '../database/StorageManager';
import { Utils, NextAlarmTime } from '../common/Utils';
import { AddEditAlarmPage } from './AddEditAlarmPage';

@Entry
@Component
export struct AlarmListPage {
  @State alarms: Alarm[] = [];
  @State nextAlarmTime: NextAlarmTime | null = null;
  @State nextAlarmText: string = '暂无闹钟';
  @State showAddEditPage: boolean = false;
  @State editingAlarm: Alarm | null = null;
  
  private storageManager = StorageManager.getInstance();
  
  aboutToAppear() {
    // 初始化存储管理器
    this.initStorage().then(() => {
      this.loadAlarms().then(() => {
        this.updateNextAlarmTime();
      });
    });
  }
  
  onPageShow() {
    // 页面显示时刷新数据
    this.loadAlarms().then(() => {
      this.updateNextAlarmTime();
    });
  }
  
  async initStorage() {
    // 尝试从全局获取context
    try {
      const context = getContext(this);
      if (context) {
        await this.storageManager.init(context);
      }
    } catch (error) {
      console.error('Failed to init storage:', error);
    }
  }
  
  async loadAlarms() {
    this.alarms = await this.storageManager.getAlarms();
  }
  
  updateNextAlarmTime() {
    this.nextAlarmTime = Utils.calculateNextAlarmTime(this.alarms);
    this.nextAlarmText = Utils.formatNextAlarmTime(this.nextAlarmTime);
  }
  
  async onAlarmToggle(alarm: Alarm) {
    alarm.isEnabled = !alarm.isEnabled;
    alarm.updatedAt = Date.now();
    await this.storageManager.updateAlarm(alarm);
    await this.loadAlarms();
    this.updateNextAlarmTime();
  }
  
  async onDeleteAlarm(alarmId: string) {
    await this.storageManager.deleteAlarm(alarmId);
    await this.loadAlarms();
    this.updateNextAlarmTime();
  }
  
  onAddAlarm() {
    this.editingAlarm = null;
    this.showAddEditPage = true;
  }
  
  onEditAlarm(alarm: Alarm) {
    this.editingAlarm = alarm;
    this.showAddEditPage = true;
  }
  
  onCloseAddEditPage() {
    this.showAddEditPage = false;
    this.editingAlarm = null;
  }
  
  async onSaveAlarm(alarm: Alarm) {
    if (this.editingAlarm) {
      // 更新现有闹钟
      await this.storageManager.updateAlarm(alarm);
    } else {
      // 添加新闹钟
      await this.storageManager.addAlarm(alarm);
    }
    await this.loadAlarms();
    this.updateNextAlarmTime();
    this.showAddEditPage = false;
    this.editingAlarm = null;
  }
  
  build() {
    Stack() {
      if (this.showAddEditPage) {
        // 显示新增/编辑页面
        AddEditAlarmPage({
          alarm: this.editingAlarm ?? undefined,
          onClose: () => {
            this.onCloseAddEditPage();
          },
          onSave: (alarm: Alarm) => {
            this.onSaveAlarm(alarm);
          }
        })
      } else {
        // 显示闹钟列表
        this.AlarmListView()
      }
    }
    .width('100%')
    .height('100%')
  }
  
  @Builder
  AlarmListView() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Column() {
        // 顶部：下次闹钟信息
        Column() {
          Button() {
            Row() {
              Text($r('app.string.next_alarm'))
                .fontSize(14)
                .fontColor($r('app.color.text_primary'))
              Text(' >')
                .fontSize(14)
                .fontColor($r('app.color.text_primary'))
            }
          }
          .type(ButtonType.Normal)
          .backgroundColor(Color.Transparent)
          .border({ width: 1, color: $r('app.color.text_secondary') })
          .borderRadius(8)
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .alignSelf(ItemAlign.Start)
          .margin({ left: 16, top: 16 })
          .onClick(() => {
            // 可以添加跳转逻辑
          })
          
          Text(this.nextAlarmText)
            .fontSize(16)
            .fontColor($r('app.color.text_primary'))
            .margin({ top: 12 })
            .alignSelf(ItemAlign.Center)
        }
        .width('100%')
        .padding({ bottom: 16 })
        
        // 闹钟列表
        if (this.alarms.length === 0) {
          Column() {
            Text('暂无闹钟')
              .fontSize(16)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 40 })
          }
          .layoutWeight(1)
          .width('100%')
          .justifyContent(FlexAlign.Center)
        } else {
          List() {
            ForEach(this.alarms, (alarm: Alarm) => {
              ListItem() {
                this.AlarmCard(alarm)
              }
            }, (alarm: Alarm) => alarm.id)
          }
          .layoutWeight(1)
          .width('100%')
          .padding({ left: 16, right: 16 })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.background'))
      
      // 浮动添加按钮
      Button() {
        Text('+')
          .fontSize(32)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Normal)
      }
      .type(ButtonType.Circle)
      .width(56)
      .height(56)
      .backgroundColor($r('app.color.primary'))
      .margin({ right: 16, bottom: 80 })
      .onClick(() => {
        this.onAddAlarm();
      })
    }
    .width('100%')
    .height('100%')
  }
  
  @Builder
  AlarmCard(alarm: Alarm) {
    Row() {
      Column() {
        // 重复周期标签
        Text(Utils.formatRepeatDays(alarm.repeatDays))
          .fontSize(12)
          .fontColor(alarm.repeatDays.length === 0 ? 
            $r('app.color.accent_blue') : 
            $r('app.color.text_secondary'))
          .alignSelf(ItemAlign.Start)
          .margin({ bottom: 4 })
        
        // 时间
        Text(Utils.formatTime(alarm.hour, alarm.minute))
          .fontSize(32)
          .fontColor($r('app.color.text_primary'))
          .fontWeight(FontWeight.Bold)
        
        // 任务信息
        Row() {
          Text($r('app.string.alarm_task'))
            .fontSize(12)
            .fontColor($r('app.color.text_secondary'))
          
          if (alarm.tasks && alarm.tasks.length > 0) {
            Text(' × ' + alarm.tasks.length + ' 个任务')
              .fontSize(12)
              .fontColor($r('app.color.text_secondary'))
          } else {
            Text(' 立即醒来!')
              .fontSize(12)
              .fontColor($r('app.color.text_secondary'))
          }
        }
        .margin({ top: 4 })
        .alignSelf(ItemAlign.Start)
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .onClick(() => {
        this.onEditAlarm(alarm);
      })
      
      // 右侧操作区域
      Row() {
        Toggle({ type: ToggleType.Switch, isOn: alarm.isEnabled })
          .selectedColor($r('app.color.accent_blue'))
          .onChange((isOn: boolean) => {
            this.onAlarmToggle(alarm);
          })
        
        Text('⋮')
          .fontSize(24)
          .fontColor($r('app.color.text_primary'))
          .margin({ left: 16 })
          .onClick(() => {
            this.onEditAlarm(alarm);
          })
      }
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(12)
    .margin({ bottom: 12 })
  }
}
