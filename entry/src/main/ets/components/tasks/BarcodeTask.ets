/**
 * 条形码/二维码扫描任务组件
 */
import { TaskConfig } from '../../model/Task';
import { scan } from '@kit.ScanKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { getContext } from '@kit.ArkUI';

@Component
export struct BarcodeTask {
  @Prop taskConfig: TaskConfig = {};
  onComplete?: () => void;
  
  @State scannedValue: string = '';
  @State isScanning: boolean = false;
  @State targetValue: string = '';
  
  private scanController: scan.ScanController | null = null;
  
  aboutToAppear() {
    // 从配置中获取目标条形码值
    this.targetValue = this.taskConfig.barcodeValue || '';
  }
  
  aboutToDisappear() {
    this.stopScan();
  }
  
  async onStartScan() {
    try {
      const context = getContext(this) as common.UIAbilityContext;
      if (!context) {
        console.error('Context not available');
        return;
      }
      
      this.isScanning = true;
      
      // 创建扫码控制器
      const scanConfig: scan.ScanConfig = {
        scanTypes: [scan.ScanType.ALL], // 支持所有类型
        resultType: scan.ScanResultType.STRING
      };
      
      this.scanController = await scan.createScanController(context, scanConfig);
      
      // 注册扫码结果回调
      this.scanController.on('result', (err: BusinessError, result: scan.ScanResult) => {
        if (err) {
          console.error('Scan error:', err);
          this.isScanning = false;
          return;
        }
        
        if (result && result.value) {
          this.scannedValue = result.value;
          this.isScanning = false;
          
          // 验证是否匹配
          if (this.targetValue === '' || this.scannedValue === this.targetValue) {
            if (this.onComplete) {
              this.onComplete();
            }
          }
        }
      });
      
      // 启动扫码
      await this.scanController.startScan();
      
    } catch (error) {
      console.error('Failed to start scan:', error);
      this.isScanning = false;
    }
  }
  
  async stopScan() {
    try {
      if (this.scanController) {
        await this.scanController.stopScan();
        await this.scanController.destroy();
        this.scanController = null;
      }
    } catch (error) {
      console.error('Failed to stop scan:', error);
    }
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

