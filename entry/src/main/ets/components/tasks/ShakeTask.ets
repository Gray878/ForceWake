/**
 * 摇晃任务组件
 */
import { TaskConfig } from '../../model/Task';
// TODO: 接入sensor API时取消注释
// import sensor from '@ohos.sensor';

interface AccelerationData {
  x: number;
  y: number;
  z: number;
}

@Component
export struct ShakeTask {
  @Prop taskConfig: TaskConfig = {};
  onComplete?: () => void;
  
  @State shakeCount: number = 0;
  @State targetCount: number = 10;
  @State isShaking: boolean = false;
  
  private sensorId: number = -1;
  // TODO: 正确类型定义
  // private sensorManager: sensor.SensorManager | null = null;
  private lastAcceleration: AccelerationData | null = null;
  private shakeThreshold: number = 15.0; // 加速度阈值
  private lastShakeTime: number = 0;
  private shakeInterval: number = 300; // 摇晃间隔（毫秒）
  
  aboutToAppear() {
    this.targetCount = this.taskConfig.shakeCount || 10;
    this.shakeThreshold = this.taskConfig.shakeThreshold || 15.0;
    this.initSensor();
  }
  
  aboutToDisappear() {
    this.stopSensor();
  }
  
  async initSensor() {
    try {
      // TODO: 接入sensor API
      // 需要查阅HarmonyOS官方文档获取正确的API使用方式
      // 当前暂时使用模拟实现
      console.info('TODO: Initialize accelerometer sensor');
      
      // 模拟传感器初始化
      this.sensorId = 1; // 模拟传感器ID
      
    } catch (error) {
      console.error('Failed to init sensor:', error);
    }
  }
  
  stopSensor() {
    try {
      // TODO: 停止传感器监听
      if (this.sensorId !== -1) {
        this.sensorId = -1;
      }
    } catch (error) {
      console.error('Failed to stop sensor:', error);
    }
  }
  
  // TODO: 正确类型定义
  onAccelerationChanged(data: AccelerationData) {
    if (!this.isShaking) {
      return;
    }
    
    const currentTime = Date.now();
    const acceleration: AccelerationData = {
      x: data.x,
      y: data.y,
      z: data.z
    };
    
    if (this.lastAcceleration) {
      // 计算加速度变化
      const deltaX = Math.abs(acceleration.x - this.lastAcceleration.x);
      const deltaY = Math.abs(acceleration.y - this.lastAcceleration.y);
      const deltaZ = Math.abs(acceleration.z - this.lastAcceleration.z);
      
      const accelerationDelta = Math.sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ);
      
      // 检测摇晃：加速度变化超过阈值，且距离上次摇晃有足够间隔
      if (accelerationDelta > this.shakeThreshold && 
          (currentTime - this.lastShakeTime) > this.shakeInterval) {
        this.onShakeDetected();
        this.lastShakeTime = currentTime;
      }
    }
    
    this.lastAcceleration = acceleration;
  }
  
  onShakeDetected() {
    if (this.isShaking) {
      this.shakeCount++;
      
      if (this.shakeCount >= this.targetCount) {
        this.isShaking = false;
        this.stopSensor();
        if (this.onComplete) {
          this.onComplete();
        }
      }
    }
  }
  
  onStartShake() {
    this.isShaking = true;
    this.shakeCount = 0;
    this.lastAcceleration = null;
    this.lastShakeTime = 0;
    
    // 确保传感器已初始化
    if (this.sensorId === -1) {
      this.initSensor();
    }
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

