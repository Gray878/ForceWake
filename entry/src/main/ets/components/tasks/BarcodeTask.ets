/**
 * 条形码/二维码扫描任务组件
 * 
 * 使用HarmonyOS ScanKit实现扫码功能
 * 参考文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/scan-introduction
 * 参考示例：example/scan-kit_-sample-code_-clientdemo_-arkts
 */
import { TaskConfig } from '../../model/Task';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { scanBarcode, scanCore } from '@kit.ScanKit';

@Component
export struct BarcodeTask {
  @Prop taskConfig: TaskConfig = {};
  onComplete?: () => void;
  
  @State scannedValue: string = '';
  @State isScanning: boolean = false;
  @State targetValue: string = '';
  @State errorMessage: string = '';
  
  aboutToAppear() {
    // 从配置中获取目标条形码值
    this.targetValue = this.taskConfig.barcodeValue || '';
  }
  
  aboutToDisappear() {
    // 默认界面扫码由系统自动管理资源，无需手动释放
  }
  
  /**
   * 启动扫码
   * 使用ScanKit默认界面扫码功能
   * 参考：example/scan-kit_-sample-code_-clientdemo_-arkts/entry/src/main/ets/pages/defaultScan/DefaultScan.ets
   */
  async onStartScan() {
    try {
      this.isScanning = true;
      this.errorMessage = '';
      this.scannedValue = '';
      
      // 获取页面上下文
      const context = getContext(this) as common.UIAbilityContext;
      if (!context) {
        throw new Error('无法获取页面上下文');
      }
      
      // 调用ScanKit默认界面扫码API
      // 参考官方示例：scanBarcode.startScanForResult()
      const result: scanBarcode.ScanResult = await scanBarcode.startScanForResult(context, {
        scanTypes: [scanCore.ScanType.ALL], // 支持所有码类型
        enableMultiMode: false, // 单码模式，只返回第一个扫码结果
        enableAlbum: false // 不启用相册入口
      });
      
      // 处理扫码结果
      if (result && result.originalValue) {
        this.scannedValue = result.originalValue;
        this.isScanning = false;
        
        // 验证是否匹配目标值
        if (this.targetValue === '' || this.scannedValue === this.targetValue) {
          // 匹配成功，完成任务
          if (this.onComplete) {
            this.onComplete();
          }
        } else {
          // 不匹配，提示用户重试
          this.errorMessage = '扫描的码与目标不匹配，请重试';
          this.scannedValue = '';
        }
      } else {
        // 扫码结果为空
        this.isScanning = false;
        this.errorMessage = '未获取到扫码结果，请重试';
      }
      
    } catch (error) {
      this.isScanning = false;
      
      // 处理错误
      // BusinessError是类型而非类，不能使用instanceof，需要类型断言
      const businessError = error as BusinessError;
      
      // 用户取消扫码
      if (businessError.code === scanCore.ScanErrorCode.SCAN_SERVICE_CANCELED) {
        console.info('用户取消了扫码');
        // 用户取消不显示错误信息
        return;
      } else {
        // 其他错误
        const errMsg: string = businessError.message || `错误代码: ${businessError.code}`;
        console.error('扫码失败:', errMsg);
        this.errorMessage = `启动扫码失败: ${errMsg}`;
      }
    }
  }
  
  /**
   * 停止扫码并释放资源
   * 注意：使用默认界面扫码时，系统会自动管理资源，无需手动释放
   */
  async stopScan() {
    // 默认界面扫码由系统自动管理资源，无需手动释放
    this.isScanning = false;
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

