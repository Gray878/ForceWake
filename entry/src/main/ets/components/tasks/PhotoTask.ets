/**
 * 拍照任务组件
 */
import { TaskConfig } from '../../model/Task';
import { picker } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { getContext } from '@kit.ArkUI';

@Component
export struct PhotoTask {
  @Prop taskConfig: TaskConfig = {};
  onComplete?: () => void;
  
  @State photoPath: string = '';
  @State isCapturing: boolean = false;
  @State targetPath: string = '';
  @State photoUri: string = '';
  
  aboutToAppear() {
    // 从配置中获取目标照片路径
    this.targetPath = this.taskConfig.photoPath || '';
  }
  
  async onTakePhoto() {
    try {
      const context = getContext(this) as common.UIAbilityContext;
      if (!context) {
        console.error('Context not available');
        return;
      }
      
      this.isCapturing = true;
      
      // 使用相机拍照
      const photoPickerOptions: picker.PhotoSelectOptions = {
        MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE,
        maxSelectNumber: 1
      };
      
      const photoSelectResult = await picker.select(context, photoPickerOptions);
      
      if (photoSelectResult && photoSelectResult.photoUris.length > 0) {
        this.photoUri = photoSelectResult.photoUris[0];
        this.photoPath = photoSelectResult.photoUris[0];
        this.isCapturing = false;
        
        // 验证照片（简化处理：只要有照片就认为匹配）
        if (this.targetPath === '' || this.checkPhotoMatch()) {
          if (this.onComplete) {
            this.onComplete();
          }
        }
      } else {
        this.isCapturing = false;
      }
      
    } catch (error) {
      console.error('Failed to take photo:', error);
      this.isCapturing = false;
    }
  }
  
  checkPhotoMatch(): boolean {
    // TODO: 实现图像相似度匹配算法
    // 简化处理：只要有照片就认为匹配
    // 实际可以使用图像识别API进行相似度比较
    return this.photoPath.length > 0;
  }
  
  build() {
    Column() {
      Text('拍照任务')
        .fontSize(20)
        .fontColor($r('app.color.text_primary'))
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 16 })
      
      if (this.isCapturing) {
        Column() {
          Text('正在拍照...')
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))
            .margin({ bottom: 16 })
          
          // 相机预览框（模拟）
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
      } else if (this.photoPath && this.checkPhotoMatch()) {
        Column() {
          Text('✅ 拍照成功！')
            .fontSize(24)
            .fontColor($r('app.color.text_primary'))
            .margin({ bottom: 16 })
        }
      } else {
        Column() {
          if (this.targetPath) {
            Text('请拍摄与预设照片相似的场景')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ bottom: 24 })
          } else {
            Text('请先设置要匹配的照片')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ bottom: 24 })
          }
          
          Button('拍照')
            .type(ButtonType.Capsule)
            .width(200)
            .height(50)
            .fontSize(16)
            .fontColor(Color.White)
            .backgroundColor($r('app.color.primary'))
            .onClick(() => {
              this.onTakePhoto();
            })
        }
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 24, bottom: 24 })
    .justifyContent(FlexAlign.Center)
  }
}

