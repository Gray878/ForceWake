/**
 * 拍照任务组件
 * 
 * 使用HarmonyOS MediaLibraryKit实现拍照功能
 * 参考示例：example/ComprehensiveTool1.0.0/entry/src/main/ets/utils/FileSelect.ets
 */
import { TaskConfig } from '../../model/Task';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

@Component
export struct PhotoTask {
  @Prop taskConfig: TaskConfig = {};
  onComplete?: () => void;
  
  @State photoPath: string = '';
  @State isCapturing: boolean = false;
  @State targetPath: string = '';
  @State photoUri: string = '';
  @State errorMessage: string = '';
  
  aboutToAppear() {
    // 从配置中获取目标照片路径
    this.targetPath = this.taskConfig.photoPath || '';
  }
  
  /**
   * 拍照或选择图片
   * 参考：example/ComprehensiveTool1.0.0/entry/src/main/ets/utils/FileSelect.ets
   */
  async onTakePhoto() {
    try {
      this.isCapturing = true;
      this.errorMessage = '';
      this.photoPath = '';
      this.photoUri = '';
      
      // 设置图片选择选项
      let photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE; // 类型：图片
      photoSelectOptions.maxSelectNumber = 1; // 最多选择1张图片
      photoSelectOptions.preselectedUris = []; // 预先选中的URI（空数组）
      
      // 创建图片选择器
      let photoPicker = new photoAccessHelper.PhotoViewPicker();
      
      // 拉起图片选择框（用户可以选择拍照或从相册选择）
      let photoSelectResult = await photoPicker.select(photoSelectOptions);
      
      // 处理选择结果
      if (photoSelectResult && photoSelectResult.photoUris && photoSelectResult.photoUris.length > 0) {
        const selectedUri = photoSelectResult.photoUris[0];
        
        // 验证URI格式
        if (selectedUri.indexOf('media/Photo') < 0 && selectedUri.indexOf('file://') < 0) {
          this.errorMessage = '请选择有效的图片';
          this.isCapturing = false;
          return;
        }
        
        // 保存照片路径和URI
        this.photoPath = selectedUri;
        this.photoUri = selectedUri;
        this.isCapturing = false;
        
        // 验证照片（简化处理：只要有照片就认为匹配）
        if (this.targetPath === '' || this.checkPhotoMatch()) {
          // 匹配成功，完成任务
          if (this.onComplete) {
            this.onComplete();
          }
        } else {
          // 不匹配，提示用户重试
          this.errorMessage = '拍摄的照片与目标不匹配，请重试';
          this.photoPath = '';
          this.photoUri = '';
        }
      } else {
        // 用户取消选择
        this.isCapturing = false;
        console.info('用户取消了图片选择');
      }
      
    } catch (error) {
      this.isCapturing = false;
      const errMsg = error instanceof Error ? error.message : String(error);
      console.error('拍照失败:', errMsg);
      this.errorMessage = `拍照失败: ${errMsg}`;
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
          Text('正在选择图片...')
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))
            .margin({ bottom: 16 })
          
          Text('图片选择器已打开')
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .margin({ bottom: 8 })
          Text('请选择拍照或从相册选择图片')
            .fontSize(12)
            .fontColor($r('app.color.text_secondary'))
        }
      } else if (this.photoPath && this.checkPhotoMatch()) {
        // 拍照成功
        Column() {
          Text('✅ 拍照成功！')
            .fontSize(24)
            .fontColor($r('app.color.primary'))
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 16 })
          
          Text('任务已完成')
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))
          
          // 显示拍摄的照片（如果有URI）
          if (this.photoUri) {
            Image(this.photoUri)
              .width(200)
              .height(200)
              .objectFit(ImageFit.Cover)
              .borderRadius(8)
              .margin({ top: 16 })
          }
        }
      } else {
        // 初始状态或拍照失败
        Column() {
          if (this.targetPath) {
            Text('请拍摄与预设照片相似的场景')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ bottom: 8 })
            Text('或从相册选择相似的照片')
              .fontSize(12)
              .fontColor($r('app.color.text_secondary'))
              .margin({ bottom: 24 })
          } else {
            Text('请先设置要匹配的照片')
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
          
          Button('拍照/选择图片')
            .type(ButtonType.Capsule)
            .width(200)
            .height(50)
            .fontSize(16)
            .fontColor(Color.White)
            .backgroundColor($r('app.color.primary'))
            .enabled(!this.isCapturing)
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

