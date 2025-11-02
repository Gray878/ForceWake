/**
 * 摇晃任务组件
 */
import { TaskConfig } from '../../model/Task';

@Component
export struct ShakeTask {
  @Prop taskConfig: TaskConfig = {};
  onComplete?: () => void;
  
  @State shakeCount: number = 0;
  @State targetCount: number = 10;
  @State isShaking: boolean = false;
  
  // 传感器相关（需要导入传感器API）
  private sensorManager: any = null;
  
  aboutToAppear() {
    this.targetCount = this.taskConfig.shakeCount || 10;
    // TODO: 初始化加速度传感器
    this.initSensor();
  }
  
  initSensor() {
    // TODO: 实现加速度传感器初始化
    // 监听设备摇晃事件
    // 实际需要调用 @kit.SensorKit 的加速度传感器API
  }
  
  onShakeDetected() {
    if (this.isShaking) {
      this.shakeCount++;
      
      if (this.shakeCount >= this.targetCount) {
        this.isShaking = false;
        if (this.onComplete) {
          this.onComplete();
        }
      }
    }
  }
  
  onStartShake() {
    this.isShaking = true;
    this.shakeCount = 0;
    // TODO: 启动传感器监听
  }
  
  build() {
    Column() {
      Text('摇晃设备')
        .fontSize(20)
        .fontColor($r('app.color.text_primary'))
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 16 })
      
      if (this.isShaking) {
        Column() {
          // 进度
          Text(`${this.shakeCount} / ${this.targetCount}`)
            .fontSize(32)
            .fontColor($r('app.color.text_primary'))
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 16 })
          
          Text('继续摇晃设备')
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))
            .margin({ bottom: 24 })
          
          // 摇晃图标
          Text('📱')
            .fontSize(80)
            .opacity(0.8)
          
          Button('停止')
            .type(ButtonType.Capsule)
            .width(150)
            .height(40)
            .margin({ top: 24 })
            .onClick(() => {
              this.isShaking = false;
            })
        }
      } else if (this.shakeCount >= this.targetCount) {
        Column() {
          Text('✅ 完成！')
            .fontSize(24)
            .fontColor($r('app.color.text_primary'))
            .margin({ bottom: 16 })
        }
      } else {
        Column() {
          Text(`需要摇晃 ${this.targetCount} 次`)
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))
            .margin({ bottom: 24 })
          
          Button('开始摇晃')
            .type(ButtonType.Capsule)
            .width(200)
            .height(50)
            .fontSize(16)
            .fontColor(Color.White)
            .backgroundColor($r('app.color.primary'))
            .onClick(() => {
              this.onStartShake();
            })
        }
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 24, bottom: 24 })
    .justifyContent(FlexAlign.Center)
  }
}

