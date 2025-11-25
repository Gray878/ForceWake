/**
 * 任务选择页面
 */
import { Task, TaskType, TaskCategory, TaskConfig } from '../model/Task';
import { Constants } from '../common/Constants';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { scanBarcode, scanCore } from '@kit.ScanKit';

@Component
export struct TaskSelectPage {
  @Prop selectedTasks: string[] = [];
  @Prop selectedTaskConfigs?: Record<string, TaskConfig>; // 已选择的任务配置
  onClose?: () => void;
  onConfirm?: (taskIds: string[], taskConfigs: Record<string, TaskConfig>) => void;
  
  @State selectedTaskIds: string[] = [];
  @State taskConfigs: Record<string, TaskConfig> = {}; // 任务配置映射
  @State isScanning: boolean = false; // 是否正在扫码
  @State scanningTaskId: string = ''; // 正在扫码的任务ID
  
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
    // 复制选中的任务ID列表
    this.selectedTaskIds = [];
    for (let i = 0; i < this.selectedTasks.length; i++) {
      this.selectedTaskIds.push(this.selectedTasks[i]);
    }
    // 加载已有的任务配置
    if (this.selectedTaskConfigs) {
      // 手动复制对象，遍历已知的任务ID列表
      this.taskConfigs = {};
      for (let i = 0; i < this.selectedTaskIds.length; i++) {
        const taskId = this.selectedTaskIds[i];
        if (this.selectedTaskConfigs[taskId]) {
          this.taskConfigs[taskId] = this.selectedTaskConfigs[taskId];
        }
      }
    }
  }
  
  /**
   * 切换任务选择状态
   * 如果是扫码任务且未选择，需要先扫码保存配置
   */
  async onToggleTask(taskId: string) {
    const index = this.selectedTaskIds.indexOf(taskId);
    if (index >= 0) {
      // 取消选择
      this.selectedTaskIds.splice(index, 1);
      // 删除对应的配置（创建新对象，不包含该任务ID）
      const newConfigs: Record<string, TaskConfig> = {};
      // 遍历当前选中的任务ID列表来重建配置对象
      for (let i = 0; i < this.selectedTaskIds.length; i++) {
        const key = this.selectedTaskIds[i];
        if (this.taskConfigs[key]) {
          newConfigs[key] = this.taskConfigs[key];
        }
      }
      this.taskConfigs = newConfigs;
    } else {
      // 选择任务
      const task = this.getAllTasks().find(t => t.id === taskId);
      if (task && task.type === TaskType.BARCODE) {
        // 扫码任务需要先扫码保存配置
        await this.scanBarcodeForTask(taskId);
      } else {
        // 其他任务直接添加
        this.selectedTaskIds.push(taskId);
        // 使用任务的默认配置（手动复制）
        if (task) {
          const config: TaskConfig = {};
          if (task.config.mathCount !== undefined) {
            config.mathCount = task.config.mathCount;
          }
          if (task.config.mathLevel !== undefined) {
            config.mathLevel = task.config.mathLevel;
          }
          if (task.config.memoryPairs !== undefined) {
            config.memoryPairs = task.config.memoryPairs;
          }
          if (task.config.barcodeValue !== undefined) {
            config.barcodeValue = task.config.barcodeValue;
          }
          if (task.config.photoPath !== undefined) {
            config.photoPath = task.config.photoPath;
          }
          if (task.config.shakeCount !== undefined) {
            config.shakeCount = task.config.shakeCount;
          }
          if (task.config.shakeThreshold !== undefined) {
            config.shakeThreshold = task.config.shakeThreshold;
          }
          this.taskConfigs[taskId] = config;
        }
      }
    }
  }
  
  /**
   * 为扫码任务扫描二维码并保存配置
   */
  async scanBarcodeForTask(taskId: string) {
    try {
      this.isScanning = true;
      this.scanningTaskId = taskId;
      
      console.info('开始扫码，taskId:', taskId);
      
      // 获取页面上下文
      // 参考BarcodeTask的实现，直接转换为UIAbilityContext
      const context = getContext(this) as common.UIAbilityContext;
      if (!context) {
        throw new Error('无法获取页面上下文');
      }
      
      if (!context) {
        throw new Error('上下文为空');
      }
      
      console.info('上下文获取成功，开始调用扫码API');
      
      // 调用扫码API
      const result: scanBarcode.ScanResult = await scanBarcode.startScanForResult(context, {
        scanTypes: [scanCore.ScanType.ALL],
        enableMultiMode: false,
        enableAlbum: false
      });
      
      console.info('扫码API调用完成，结果:', result);
      
      // 处理扫码结果
      if (result && result.originalValue) {
        // 保存扫码结果到任务配置
        this.taskConfigs[taskId] = {
          barcodeValue: result.originalValue
        };
        // 添加到选中列表
        this.selectedTaskIds.push(taskId);
        
        // 提示用户扫码成功
        console.info(`扫码成功，已保存二维码信息: ${result.originalValue.substring(0, 20)}...`);
      } else {
        console.error('未获取到扫码结果，result:', result);
      }
      
    } catch (error) {
      console.error('扫码过程发生错误:', error);
      
      const businessError = error as BusinessError;
      
      // 用户取消扫码
      if (businessError.code === scanCore.ScanErrorCode.SCAN_SERVICE_CANCELED) {
        console.info('用户取消了扫码');
      } else {
        const errMsg: string = businessError.message || `错误代码: ${businessError.code}`;
        console.error('扫码失败:', errMsg);
        // 显示错误提示给用户
        console.error('详细错误信息:', JSON.stringify(businessError));
      }
    } finally {
      this.isScanning = false;
      this.scanningTaskId = '';
    }
  }
  
  /**
   * 获取所有任务列表
   */
  private getAllTasks(): Task[] {
    return [...this.brainTasks, ...this.bodyTasks];
  }
  
  onConfirmSelection() {
    if (this.onConfirm) {
      this.onConfirm(this.selectedTaskIds, this.taskConfigs);
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
        .enabled(this.selectedTaskIds.length > 0 && !this.isScanning)
        .onClick(() => {
          this.onConfirmSelection();
        })
      
      // 扫码中遮罩提示
      if (this.isScanning) {
        Column() {
          Text('正在扫码，请扫描二维码...')
            .fontSize(16)
            .fontColor(Color.White)
            .margin({ bottom: 8 })
          Text('扫码成功后会自动保存')
            .fontSize(14)
            .fontColor(Color.White)
        }
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0, 0, 0, 0.7)')
        .justifyContent(FlexAlign.Center)
        .position({ x: 0, y: 0 })
      }
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
