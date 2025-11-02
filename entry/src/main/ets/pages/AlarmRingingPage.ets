/**
 * 闹钟响铃页面
 */
import { Alarm } from '../model/Alarm';
import { TaskType, TaskConfig } from '../model/Task';
import { Utils } from '../common/Utils';
import { AlarmService } from '../common/AlarmService';
import { MathTask } from '../components/tasks/MathTask';
import { MemoryTask } from '../components/tasks/MemoryTask';
import { BarcodeTask } from '../components/tasks/BarcodeTask';
import { PhotoTask } from '../components/tasks/PhotoTask';
import { ShakeTask } from '../components/tasks/ShakeTask';
import { getContext } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

@Component
export struct AlarmRingingPage {
  @Prop alarm?: Alarm;
  onDismiss?: () => void;
  
  @State currentTaskIndex: number = 0;
  @State completedTasks: Set<string> = new Set();
  @State allTasksCompleted: boolean = false;
  @State allowDismiss: boolean = false;
  
  // 任务配置映射（从闹钟的任务ID获取配置）
  private taskConfigs: Map<string, TaskConfig> = new Map();
  private alarmService: AlarmService = AlarmService.getInstance();
  
  aboutToAppear() {
    // 初始化任务配置
    if (this.alarm && this.alarm.tasks) {
      this.alarm.tasks.forEach(taskId => {
        // 根据任务ID获取配置（这里简化处理）
        this.taskConfigs.set(taskId, this.getDefaultTaskConfig(taskId));
      });
    }
    
    // 初始化闹铃服务上下文
    const context = getContext(this) as common.UIAbilityContext;
    if (context) {
      this.alarmService.setContext(context);
    }
    
    // 开始播放闹铃
    if (this.alarm) {
      this.alarmService.playAlarmSound(this.alarm);
    }
    
    // 阻止返回和关闭
    this.preventBack();
  }
  
  aboutToDisappear() {
    // 停止闹铃
    this.alarmService.stopAlarmSound();
  }
  
  /**
   * 阻止返回键和防作弊机制
   */
  onBackPress(): boolean | number {
    // 如果任务未完成，阻止返回
    if (!this.allTasksCompleted) {
      return true; // 返回true表示阻止返回
    }
    return false; // 允许返回
  }
  
  preventBack() {
    // 防作弊机制已通过onBackPress实现
    // 注意：阻止应用切换到后台和阻止关机/重启需要系统级权限
    // 这些功能在实际部署时可能需要特殊权限申请
  }
  
  getDefaultTaskConfig(taskId: string): TaskConfig {
    // 根据任务ID返回默认配置
    if (taskId.includes('math')) {
      return { mathCount: 3, mathLevel: 1 };
    } else if (taskId.includes('memory')) {
      return { memoryPairs: 3 };
    } else if (taskId.includes('barcode')) {
      return { barcodeValue: '' };
    } else if (taskId.includes('photo')) {
      return { photoPath: '' };
    } else if (taskId.includes('shake')) {
      return { shakeCount: 10 };
    }
    return {};
  }
  
  onTaskComplete() {
    if (!this.alarm || !this.alarm.tasks) return;
    
    const currentTaskId = this.alarm.tasks[this.currentTaskIndex];
    this.completedTasks.add(currentTaskId);
    
    // 检查是否所有任务都完成了
    if (this.completedTasks.size >= this.alarm.tasks.length) {
      this.allTasksCompleted = true;
      this.allowDismiss = true;
      
      // 停止闹铃声音
      this.alarmService.stopAlarmSound();
    } else {
      // 下一个任务
      this.currentTaskIndex++;
    }
  }
  
  getCurrentTaskType(): TaskType | null {
    if (!this.alarm || !this.alarm.tasks || this.currentTaskIndex >= this.alarm.tasks.length) {
      return null;
    }
    
    const taskId = this.alarm.tasks[this.currentTaskIndex];
    if (taskId.includes('math')) return TaskType.MATH;
    if (taskId.includes('memory')) return TaskType.MEMORY;
    if (taskId.includes('barcode')) return TaskType.BARCODE;
    if (taskId.includes('photo')) return TaskType.PHOTO;
    if (taskId.includes('shake')) return TaskType.SHAKE;
    return null;
  }
  
  @Builder
  TaskContent() {
    const taskType = this.getCurrentTaskType();
    const taskConfig = this.alarm && this.alarm.tasks ? 
      (this.taskConfigs.get(this.alarm.tasks[this.currentTaskIndex]) || {}) : {};
    
    if (taskType === TaskType.MATH) {
      MathTask({ taskConfig: taskConfig })
        .onComplete(() => {
          this.onTaskComplete();
        })
    } else if (taskType === TaskType.MEMORY) {
      MemoryTask({ taskConfig: taskConfig })
        .onComplete(() => {
          this.onTaskComplete();
        })
    } else if (taskType === TaskType.BARCODE) {
      BarcodeTask({ taskConfig: taskConfig })
        .onComplete(() => {
          this.onTaskComplete();
        })
    } else if (taskType === TaskType.PHOTO) {
      PhotoTask({ taskConfig: taskConfig })
        .onComplete(() => {
          this.onTaskComplete();
        })
    } else if (taskType === TaskType.SHAKE) {
      ShakeTask({ taskConfig: taskConfig })
        .onComplete(() => {
          this.onTaskComplete();
        })
    } else {
      Text('未知任务类型')
        .fontSize(16)
        .fontColor($r('app.color.text_secondary'))
    }
  }
  
  build() {
    Column() {
      // 头部：闹钟信息
      Column() {
        Text(Utils.formatTime(this.alarm?.hour || 0, this.alarm?.minute || 0))
          .fontSize(48)
          .fontColor($r('app.color.text_primary'))
          .fontWeight(FontWeight.Bold)
          .margin({ top: 40, bottom: 16 })
        
        if (!this.allTasksCompleted) {
          Text('完成所有任务才能关闭闹铃')
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .margin({ bottom: 8 })
          
          // 任务进度
          if (this.alarm && this.alarm.tasks) {
            Text(`任务 ${this.currentTaskIndex + 1} / ${this.alarm.tasks.length}`)
              .fontSize(16)
              .fontColor($r('app.color.accent_blue'))
          }
        } else {
          Text('✅ 所有任务已完成！')
            .fontSize(18)
            .fontColor($r('app.color.text_primary'))
            .margin({ bottom: 16 })
          
          Button('关闭闹铃')
            .type(ButtonType.Capsule)
            .width(200)
            .height(50)
            .fontSize(16)
            .fontColor(Color.White)
            .backgroundColor($r('app.color.primary'))
            .onClick(() => {
              if (this.onDismiss) {
                this.onDismiss();
              }
            })
        }
      }
      .width('100%')
      .padding({ bottom: 24 })
      
      // 任务内容区域
      if (!this.allTasksCompleted && this.alarm && this.alarm.tasks && this.alarm.tasks.length > 0) {
        Column() {
          this.TaskContent()
        }
        .layoutWeight(1)
        .width('100%')
      } else if (this.allTasksCompleted) {
        // 已完成
        Blank()
      } else {
        // 没有任务
        Column() {
          Text('此闹钟没有绑定任务')
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))
        }
        .layoutWeight(1)
        .width('100%')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background'))
  }
}
