/**
 * 新增/编辑闹钟页面
 */
import { Alarm } from '../model/Alarm';
import { Utils } from '../common/Utils';
import { Constants } from '../common/Constants';
import { TaskSelectPage } from './TaskSelectPage';

@Component
export struct AddEditAlarmPage {
  @Prop alarm?: Alarm;
  onClose?: () => void;
  onSave?: (alarm: Alarm) => void;
  
  @State hour: number = 7;
  @State minute: number = 0;
  @State isEnabled: boolean = true;
  @State repeatDays: number[] = [];
  @State label: string = '';
  @State volume: number = Constants.DEFAULT_VOLUME;
  @State isVibrationEnabled: boolean = Constants.DEFAULT_VIBRATION;
  @State soundName: string = Constants.DEFAULT_SOUND;
  @State tasks: string[] = [];
  @State showTaskSelect: boolean = false;
  @State isDaily: boolean = false;
  
  // 小时和分钟范围
  private hourRange: string[] = [];
  private minuteRange: string[] = [];
  
  // 滚动控制器
  private hourScroller: Scroller = new Scroller();
  private minuteScroller: Scroller = new Scroller();
  
  private initRanges() {
    // 初始化小时范围 00-23
    for (let i = 0; i < 24; i++) {
      this.hourRange.push(i.toString().padStart(2, '0'));
    }
    // 初始化分钟范围 00-59
    for (let i = 0; i < 60; i++) {
      this.minuteRange.push(i.toString().padStart(2, '0'));
    }
  }
  
  aboutToAppear() {
    this.initRanges();
    if (this.alarm) {
      // 编辑模式：加载已有数据
      this.hour = this.alarm.hour;
      this.minute = this.alarm.minute;
      this.isEnabled = this.alarm.isEnabled;
      this.repeatDays = [...this.alarm.repeatDays];
      this.label = this.alarm.label;
      this.volume = this.alarm.volume;
      this.isVibrationEnabled = this.alarm.isVibrationEnabled;
      this.soundName = this.alarm.soundName;
      this.tasks = [...this.alarm.tasks];
      this.isDaily = this.repeatDays.length === 7;
    } else {
      // 新增模式：使用默认值
      const now = new Date();
      this.hour = now.getHours();
      this.minute = now.getMinutes();
    }
  }
  
  onSaveAlarm() {
    const alarmData: Alarm = {
      id: this.alarm?.id || Utils.generateId(),
      hour: this.hour,
      minute: this.minute,
      isEnabled: this.isEnabled,
      repeatDays: this.isDaily ? [0, 1, 2, 3, 4, 5, 6] : this.repeatDays,
      label: this.label || Utils.formatTime(this.hour, this.minute),
      volume: this.volume,
      isVibrationEnabled: this.isVibrationEnabled,
      soundName: this.soundName,
      tasks: this.tasks,
      createdAt: this.alarm?.createdAt || Date.now(),
      updatedAt: Date.now()
    };
    
    if (this.onSave) {
      this.onSave(alarmData);
    }
    if (this.onClose) {
      this.onClose();
    }
  }
  
  onToggleDay(day: number) {
    const index = this.repeatDays.indexOf(day);
    if (index >= 0) {
      this.repeatDays.splice(index, 1);
    } else {
      this.repeatDays.push(day);
      this.repeatDays.sort();
    }
  }
  
  build() {
    Column() {
      // 头部导航栏
      Row() {
        Text('取消')
          .fontSize(16)
          .fontColor($r('app.color.text_primary'))
          .onClick(() => {
            if (this.onClose) {
              this.onClose();
            }
          })
        
        Blank()
        
        Text(this.alarm ? '保存' : '保存')
          .fontSize(16)
          .fontColor($r('app.color.text_primary'))
          .onClick(() => {
            this.onSaveAlarm();
          })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor($r('app.color.card_background'))
      
      Scroll() {
        Column() {
          // 下次响铃时间提示
          Text(`闹钟会在${this.calculateNextRingTime()}后响铃`)
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .margin({ top: 16, bottom: 24 })
          
          // 时间选择器 - 使用滚动列表
          Row() {
            // 小时选择
            Column() {
              List({ scroller: this.hourScroller }) {
                ForEach(this.hourRange, (item: string, index: number) => {
                  ListItem() {
                    Text(item)
                      .fontSize(24)
                      .fontColor(this.hour === index ? $r('app.color.text_primary') : $r('app.color.text_secondary'))
                      .fontWeight(this.hour === index ? FontWeight.Bold : FontWeight.Normal)
                      .width('100%')
                      .textAlign(TextAlign.Center)
                      .padding({ top: 8, bottom: 8 })
                      .onClick(() => {
                        this.hour = index;
                      })
                  }
                }, (item: string, index: number) => `${index}`)
              }
              .width(80)
              .height(200)
              .scrollBar(BarState.Auto)
            }
            
            Text(':')
              .fontSize(28)
              .fontColor($r('app.color.text_primary'))
              .fontWeight(FontWeight.Bold)
              .margin({ left: 8, right: 8 })
            
            // 分钟选择
            Column() {
              List({ scroller: this.minuteScroller }) {
                ForEach(this.minuteRange, (item: string, index: number) => {
                  ListItem() {
                    Text(item)
                      .fontSize(24)
                      .fontColor(this.minute === index ? $r('app.color.text_primary') : $r('app.color.text_secondary'))
                      .fontWeight(this.minute === index ? FontWeight.Bold : FontWeight.Normal)
                      .width('100%')
                      .textAlign(TextAlign.Center)
                      .padding({ top: 8, bottom: 8 })
                      .onClick(() => {
                        this.minute = index;
                      })
                  }
                }, (item: string, index: number) => `${index}`)
              }
              .width(80)
              .height(200)
              .scrollBar(BarState.Auto)
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 24 })
          
          // 重复设置
          Column() {
            Row() {
              Text($r('app.string.repeat'))
                .fontSize(16)
                .fontColor($r('app.color.text_primary'))
                .fontWeight(FontWeight.Medium)
              
              Blank()
              
              Checkbox()
                .select(this.isDaily)
                .onChange((checked: boolean) => {
                  this.isDaily = checked;
                  if (checked) {
                    this.repeatDays = [0, 1, 2, 3, 4, 5, 6];
                  } else {
                    this.repeatDays = [];
                  }
                })
              
              Text($r('app.string.daily'))
                .fontSize(16)
                .fontColor($r('app.color.text_primary'))
                .margin({ left: 8 })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 12, bottom: 12 })
            
            // 星期选择
            if (!this.isDaily) {
              Row() {
                ForEach([0, 1, 2, 3, 4, 5, 6], (day: number) => {
                  Button(Constants.WEEK_DAYS[day])
                    .type(ButtonType.Circle)
                    .width(40)
                    .height(40)
                    .fontSize(14)
                    .fontColor(this.repeatDays.includes(day) ? 
                      $r('app.color.text_primary') : 
                      $r('app.color.text_secondary'))
                    .backgroundColor(this.repeatDays.includes(day) ? 
                      $r('app.color.accent_blue') : 
                      $r('app.color.card_background'))
                    .onClick(() => {
                      this.onToggleDay(day);
                    })
                })
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceAround)
              .padding({ left: 16, right: 16, bottom: 16 })
            }
          }
          .width('100%')
          .backgroundColor($r('app.color.card_background'))
          .borderRadius(12)
          .margin({ left: 16, right: 16, bottom: 16 })
          
          // 闹钟任务
          Row() {
            Text($r('app.string.alarm_task'))
              .fontSize(16)
              .fontColor($r('app.color.text_primary'))
              .fontWeight(FontWeight.Medium)
            
            Blank()
            
            Text(this.tasks.length > 0 ? `${this.tasks.length}个任务` : '添加任务')
              .fontSize(14)
              .fontColor($r('app.color.accent_blue'))
            
            Text('>')
              .fontSize(16)
              .fontColor($r('app.color.text_secondary'))
              .margin({ left: 8 })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 16 })
          .backgroundColor($r('app.color.card_background'))
          .borderRadius(12)
          .margin({ left: 16, right: 16, bottom: 16 })
          .onClick(() => {
            this.showTaskSelect = true;
          })
          
          // 音量和震动
          Column() {
            // 音量
            Column() {
              Row() {
                Text($r('app.string.volume'))
                  .fontSize(16)
                  .fontColor($r('app.color.text_primary'))
                  .fontWeight(FontWeight.Medium)
                
                Blank()
                
                Text(`${this.volume}%`)
                  .fontSize(14)
                  .fontColor($r('app.color.text_secondary'))
              }
              .width('100%')
              .margin({ bottom: 8 })
              
              Slider({
                value: this.volume,
                min: 0,
                max: 100,
                step: 1,
                style: SliderStyle.OutSet
              })
                .blockColor($r('app.color.accent_blue'))
                .selectedColor($r('app.color.accent_blue'))
                .trackColor($r('app.color.card_background'))
                .onChange((value: number) => {
                  this.volume = value;
                })
            }
            .width('100%')
            .padding({ bottom: 16 })
            
            Divider()
            
            // 震动
            Row() {
              Text($r('app.string.vibration'))
                .fontSize(16)
                .fontColor($r('app.color.text_primary'))
                .fontWeight(FontWeight.Medium)
              
              Blank()
              
              Toggle({ type: ToggleType.Switch, isOn: this.isVibrationEnabled })
                .selectedColor($r('app.color.accent_blue'))
                .onChange((isOn: boolean) => {
                  this.isVibrationEnabled = isOn;
                })
            }
            .width('100%')
            .padding({ top: 16 })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 16 })
          .backgroundColor($r('app.color.card_background'))
          .borderRadius(12)
          .margin({ left: 16, right: 16, bottom: 16 })
          
          // 声音选择
          Row() {
            Text($r('app.string.sound'))
              .fontSize(16)
              .fontColor($r('app.color.text_primary'))
              .fontWeight(FontWeight.Medium)
            
            Blank()
            
            Text(this.soundName)
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
            
            Text('>')
              .fontSize(16)
              .fontColor($r('app.color.text_secondary'))
              .margin({ left: 8 })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 16 })
          .backgroundColor($r('app.color.card_background'))
          .borderRadius(12)
          .margin({ left: 16, right: 16, bottom: 80 })
        }
        .width('100%')
      }
      .layoutWeight(1)
      .width('100%')
      
      // 任务选择页面遮罩
      if (this.showTaskSelect) {
        TaskSelectPage({
          selectedTasks: this.tasks,
          onClose: () => {
            this.showTaskSelect = false;
          },
          onConfirm: (taskIds: string[]) => {
            this.tasks = taskIds;
            this.showTaskSelect = false;
          }
        })
      }
      
      // 保存按钮
      Button($r('app.string.save'))
        .type(ButtonType.Capsule)
        .width('90%')
        .height(50)
        .fontSize(18)
        .fontColor(Color.White)
        .backgroundColor($r('app.color.primary'))
        .margin({ bottom: 24 })
        .onClick(() => {
          this.onSaveAlarm();
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background'))
  }
  
  private calculateNextRingTime(): string {
    const now = new Date();
    const currentMinutes = now.getHours() * 60 + now.getMinutes();
    const alarmMinutes = this.hour * 60 + this.minute;
    let diff = alarmMinutes - currentMinutes;
    
    if (diff < 0) {
      diff += 24 * 60;
    }
    
    const hours = Math.floor(diff / 60);
    const minutes = diff % 60;
    return `${hours}小时${minutes}分钟`;
  }
}
