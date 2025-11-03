/**
 * 条形码/二维码扫描任务组件
 * 
 * 使用HarmonyOS ScanKit实现扫码功能
 * 参考文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/scan-introduction
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
  @State errorMessage: string = '';
  
  private scanController: scan.ScanController | null = null;
  
  aboutToAppear() {
    // 从配置中获取目标条形码值
    this.targetValue = this.taskConfig.barcodeValue || '';
  }
  
  aboutToDisappear() {
    this.stopScan();
  }
  
  /**
   * 启动扫码
   * 使用ScanKit的自定义界面扫码方式
   */
  async onStartScan() {
    try {
      const context = getContext(this) as common.UIAbilityContext;
      if (!context) {
        this.errorMessage = '无法获取应用上下文';
        console.error('Context not available');
        return;
      }
      
      this.isScanning = true;
      this.errorMessage = '';
      this.scannedValue = '';
      
      // 配置扫码参数
      const scanConfig: scan.ScanConfig = {
        scanTypes: [scan.ScanType.ALL], // 支持所有码类型（QR Code、条形码等）
        resultType: scan.ScanResultType.STRING // 返回字符串结果
      };
      
      // 创建扫码控制器
      this.scanController = await scan.createScanController(context, scanConfig);
      
      if (!this.scanController) {
        throw new Error('创建扫码控制器失败');
      }
      
      // 注册扫码结果回调
      this.scanController.on('result', (err: BusinessError, result: scan.ScanResult) => {
        if (err) {
          console.error('Scan error:', JSON.stringify(err));
          this.errorMessage = `扫码错误: ${err.message || '未知错误'}`;
          this.isScanning = false;
          this.stopScan();
          return;
        }
        
        if (result && result.value) {
          this.scannedValue = result.value;
          this.isScanning = false;
          
          // 验证是否匹配目标值
          // 如果没有设置目标值，扫描任意码即可通过
          // 如果设置了目标值，必须匹配才能通过
          if (this.targetValue === '' || this.scannedValue === this.targetValue) {
            this.stopScan();
            if (this.onComplete) {
              this.onComplete();
            }
          } else {
            // 扫描结果不匹配
            this.errorMessage = '扫描的码与目标不匹配，请重试';
            this.scannedValue = '';
            // 不停止扫码，允许重新扫描
          }
        }
      });
      
      // 启动扫码
      // 如果不传入surfaceId，ScanKit会使用系统默认的扫码界面
      await this.scanController.startScan();
      
    } catch (error) {
      const errMsg = error instanceof Error ? error.message : String(error);
      console.error('Failed to start scan:', errMsg);
      this.errorMessage = `启动扫码失败: ${errMsg}`;
      this.isScanning = false;
      this.stopScan();
    }
  }
  
  /**
   * 停止扫码并释放资源
   */
  async stopScan() {
    try {
      if (this.scanController) {
        await this.scanController.stopScan();
        await this.scanController.destroy();
        this.scanController = null;
      }
    } catch (error) {
      console.error('Failed to stop scan:', error);
    } finally {
      this.isScanning = false;
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
          
          // 扫码界面提示
          // ScanKit会自动打开系统默认的扫码界面，用户在该界面完成扫码
          if (this.targetValue) {
            Text('系统扫码界面已打开')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ bottom: 8 })
            Text(`请在扫码界面扫描目标码值`)
              .fontSize(12)
              .fontColor($r('app.color.text_secondary'))
              .margin({ bottom: 8 })
            Text(`目标：${this.targetValue.substring(0, 30)}${this.targetValue.length > 30 ? '...' : ''}`)
              .fontSize(12)
              .fontColor($r('app.color.accent_blue'))
              .textAlign(TextAlign.Center)
          } else {
            Text('系统扫码界面已打开')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ bottom: 8 })
            Text('请在扫码界面扫描任意条形码/二维码')
              .fontSize(12)
              .fontColor($r('app.color.text_secondary'))
          }
          
          // 显示等待提示
          Text('等待扫码结果...')
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .margin({ top: 24 })
        }
      } else if (this.scannedValue && this.scannedValue === this.targetValue) {
        // 扫描成功
        Column() {
          Text('扫描成功！')
            .fontSize(24)
            .fontColor($r('app.color.primary'))
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 16 })
          
          Text('任务已完成')
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))
        }
      } else {
        // 初始状态或扫描失败
        Column() {
          if (this.targetValue) {
            Text('请扫描保存的条形码/二维码')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ bottom: 8 })
            Text(`目标码值：${this.targetValue.substring(0, 30)}${this.targetValue.length > 30 ? '...' : ''}`)
              .fontSize(12)
              .fontColor($r('app.color.text_secondary'))
              .textAlign(TextAlign.Center)
              .margin({ bottom: 24 })
          } else {
            Text('请先设置要扫描的条形码/二维码')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ bottom: 24 })
          }
          
          // 显示错误信息
          if (this.errorMessage) {
            Text(this.errorMessage)
              .fontSize(12)
              .fontColor('#FF3D3D')
              .margin({ bottom: 16 })
          }
          
          Button('开始扫描')
            .type(ButtonType.Capsule)
            .width(200)
            .height(50)
            .fontSize(16)
            .fontColor(Color.White)
            .backgroundColor($r('app.color.primary'))
            .enabled(!this.isScanning)
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

