/**
 * 条形码/二维码扫描任务组件
 */
import { TaskConfig } from '../../model/Task';

@Component
export struct BarcodeTask {
  @Prop taskConfig: TaskConfig = {};
  onComplete?: () => void;
  
  @State scannedValue: string = '';
  @State isScanning: boolean = false;
  @State targetValue: string = '';
  
  aboutToAppear() {
    // 从配置中获取目标条形码值
    this.targetValue = this.taskConfig.barcodeValue || '';
  }
  
  onStartScan() {
    // TODO: 实现扫码功能
    // 这里需要调用鸿蒙的扫码API
    this.isScanning = true;
    
    // 模拟扫码结果（实际应该从扫码API获取）
    setTimeout(() => {
      // 假设扫描成功
      const mockScannedValue = this.targetValue || '1234567890';
      this.scannedValue = mockScannedValue;
      this.isScanning = false;
      
      // 验证是否匹配
      if (this.scannedValue === this.targetValue || this.targetValue === '') {
        if (this.onComplete) {
          this.onComplete();
        }
      }
    }, 2000);
  }
  
  build() {
    Column() {
      Text('扫描条形码/二维码')
        .fontSize(20)
        .fontColor($r('app.color.text_primary'))
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 16 })
      
      if (this.isScanning) {
        Column() {
          Text('正在扫描...')
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))
            .margin({ bottom: 16 })
          
          // 扫码框（模拟）
          Column() {
            Text('📷')
              .fontSize(60)
          }
          .width(200)
          .height(200)
          .border({ width: 2, color: $r('app.color.accent_blue') })
          .borderRadius(8)
          .backgroundColor($r('app.color.card_background'))
          .justifyContent(FlexAlign.Center)
        }
      } else if (this.scannedValue && this.scannedValue === this.targetValue) {
        Column() {
          Text('✅ 扫描成功！')
            .fontSize(24)
            .fontColor($r('app.color.text_primary'))
            .margin({ bottom: 16 })
        }
      } else {
        Column() {
          if (this.targetValue) {
            Text('请扫描保存的条形码/二维码')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ bottom: 24 })
          } else {
            Text('请先设置要扫描的条形码/二维码')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ bottom: 24 })
          }
          
          Button('开始扫描')
            .type(ButtonType.Capsule)
            .width(200)
            .height(50)
            .fontSize(16)
            .fontColor(Color.White)
            .backgroundColor($r('app.color.primary'))
            .onClick(() => {
              this.onStartScan();
            })
        }
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 24, bottom: 24 })
    .justifyContent(FlexAlign.Center)
  }
}

