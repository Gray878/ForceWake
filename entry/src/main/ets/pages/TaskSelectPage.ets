/**
 * 任务选择页面
 */
import { Task, TaskType, TaskCategory } from '../model/Task';
import { Constants } from '../common/Constants';

@Component
export struct TaskSelectPage {
  @Prop selectedTasks: string[] = [];
  onClose?: () => void;
  onConfirm?: (taskIds: string[]) => void;
  
  @State selectedTaskIds: string[] = [];
  
  // 预设任务列表
  private brainTasks: Task[] = [
    {
      id: 'math-1',
      type: TaskType.MATH,
      category: TaskCategory.BRAIN,
      name: Constants.TASK_TYPES.MATH.name,
      icon: Constants.TASK_TYPES.MATH.icon,
      difficulty: 1,
      config: { mathCount: 3, mathLevel: 1 }
    },
    {
      id: 'memory-1',
      type: TaskType.MEMORY,
      category: TaskCategory.BRAIN,
      name: Constants.TASK_TYPES.MEMORY.name,
      icon: Constants.TASK_TYPES.MEMORY.icon,
      difficulty: 1,
      config: { memoryPairs: 3 }
    }
  ];
  
  private bodyTasks: Task[] = [
    {
      id: 'barcode-1',
      type: TaskType.BARCODE,
      category: TaskCategory.BODY,
      name: Constants.TASK_TYPES.BARCODE.name,
      icon: Constants.TASK_TYPES.BARCODE.icon,
      difficulty: 1,
      config: {}
    },
    {
      id: 'shake-1',
      type: TaskType.SHAKE,
      category: TaskCategory.BODY,
      name: Constants.TASK_TYPES.SHAKE.name,
      icon: Constants.TASK_TYPES.SHAKE.icon,
      difficulty: 1,
      config: { shakeCount: 10 }
    },
    {
      id: 'photo-1',
      type: TaskType.PHOTO,
      category: TaskCategory.BODY,
      name: Constants.TASK_TYPES.PHOTO.name,
      icon: Constants.TASK_TYPES.PHOTO.icon,
      difficulty: 1,
      config: {}
    }
  ];
  
  aboutToAppear() {
    this.selectedTaskIds = [...this.selectedTasks];
  }
  
  onToggleTask(taskId: string) {
    const index = this.selectedTaskIds.indexOf(taskId);
    if (index >= 0) {
      this.selectedTaskIds.splice(index, 1);
    } else {
      this.selectedTaskIds.push(taskId);
    }
  }
  
  onConfirmSelection() {
    if (this.onConfirm) {
      this.onConfirm(this.selectedTaskIds);
    }
    if (this.onClose) {
      this.onClose();
    }
  }
  
  build() {
    Column() {
      // 头部
      Row() {
        Text('×')
          .fontSize(28)
          .fontColor($r('app.color.text_primary'))
          .onClick(() => {
            if (this.onClose) {
              this.onClose();
            }
          })
        
        Blank()
        
        Text($r('app.string.alarm_task'))
          .fontSize(18)
          .fontColor($r('app.color.text_primary'))
          .fontWeight(FontWeight.Bold)
        
        Blank()
        Blank()
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor($r('app.color.card_background'))
      
      Scroll() {
        Column() {
          // 唤醒大脑
          Column() {
            Text($r('app.string.wake_up_brain'))
              .fontSize(16)
              .fontColor($r('app.color.text_primary'))
              .fontWeight(FontWeight.Bold)
              .alignSelf(ItemAlign.Start)
              .margin({ left: 16, top: 16, bottom: 12 })
            
            Row() {
              ForEach(this.brainTasks, (task: Task) => {
                this.TaskItem(task)
              }, (task: Task) => task.id)
            }
            .width('100%')
            .padding({ left: 16, right: 16 })
            .justifyContent(FlexAlign.SpaceAround)
          }
          .width('100%')
          .margin({ bottom: 24 })
          
          // 唤醒身体
          Column() {
            Text($r('app.string.wake_up_body'))
              .fontSize(16)
              .fontColor($r('app.color.text_primary'))
              .fontWeight(FontWeight.Bold)
              .alignSelf(ItemAlign.Start)
              .margin({ left: 16, top: 16, bottom: 12 })
            
            Row() {
              ForEach(this.bodyTasks, (task: Task) => {
                this.TaskItem(task)
              }, (task: Task) => task.id)
            }
            .width('100%')
            .padding({ left: 16, right: 16 })
            .justifyContent(FlexAlign.SpaceAround)
          }
          .width('100%')
          .margin({ bottom: 80 })
        }
        .width('100%')
      }
      .layoutWeight(1)
      .width('100%')
      
      // 底部确认按钮
      Button('确定')
        .type(ButtonType.Capsule)
        .width('90%')
        .height(50)
        .fontSize(18)
        .fontColor(Color.White)
        .backgroundColor(this.selectedTaskIds.length > 0 ? 
          $r('app.color.primary') : 
          $r('app.color.text_secondary'))
        .margin({ bottom: 24 })
        .enabled(this.selectedTaskIds.length > 0)
        .onClick(() => {
          this.onConfirmSelection();
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background'))
  }
  
  @Builder
  TaskItem(task: Task) {
    Column() {
      // 任务图标（使用背景色模拟）
      Column() {
        Text(this.getTaskIcon(task.type))
          .fontSize(32)
          .fontColor(Color.White)
      }
      .width(80)
      .height(80)
      .backgroundColor(this.getTaskColor(task.type))
      .borderRadius(12)
      .justifyContent(FlexAlign.Center)
      
      Text(task.name)
        .fontSize(12)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: 8 })
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      
      // 选中标记
      if (this.selectedTaskIds.includes(task.id)) {
        Image($r('app.media.startIcon'))
          .width(20)
          .height(20)
          .position({ x: '100%', y: 0 })
          .margin({ right: -10, top: -10 })
      }
    }
    .width(100)
    .padding({ bottom: 12 })
    .onClick(() => {
      this.onToggleTask(task.id);
    })
  }
  
  private getTaskIcon(type: TaskType): string {
    const icons: Record<TaskType, string> = {
      [TaskType.MATH]: '🔢',
      [TaskType.MEMORY]: '🧠',
      [TaskType.BARCODE]: '📷',
      [TaskType.SHAKE]: '📱',
      [TaskType.PHOTO]: '📸'
    };
    return icons[type] || '○';
  }
  
  private getTaskColor(type: TaskType): ResourceColor {
    const colors: Record<TaskType, ResourceColor> = {
      [TaskType.MATH]: Color.Blue,
      [TaskType.MEMORY]: Color.Green,
      [TaskType.BARCODE]: Color.Orange,
      [TaskType.SHAKE]: '#AF52DE', // Purple color
      [TaskType.PHOTO]: Color.Pink
    };
    return colors[type] || $r('app.color.card_background');
  }
}
