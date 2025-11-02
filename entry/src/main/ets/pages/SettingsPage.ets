/**
 * 设置页面
 */
@Component
export struct SettingsPage {
  @State preventShutdown: boolean = false;
  
  build() {
    Column() {
      // 标题
      Text($r('app.string.settings'))
        .fontSize(24)
        .fontColor($r('app.color.text_primary'))
        .fontWeight(FontWeight.Bold)
        .alignSelf(ItemAlign.Start)
        .margin({ left: 16, top: 16, bottom: 24 })
      
      Scroll() {
        Column() {
          // 必要的权限
          this.SettingsItem(
            $r('app.string.required_permissions'),
            '🚀',
            () => {
              // 跳转到权限设置
            }
          )
          
          // 阻止关机
          Row() {
            Row() {
              Text('🛡️')
                .fontSize(20)
                .margin({ right: 12 })
              
              Text($r('app.string.prevent_shutdown'))
                .fontSize(16)
                .fontColor($r('app.color.text_primary'))
            }
            .layoutWeight(1)
            
            Row() {
              Text(this.preventShutdown ? '开' : '关')
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
                .margin({ right: 8 })
              
              Toggle({ type: ToggleType.Switch, isOn: this.preventShutdown })
                .selectedColor($r('app.color.accent_blue'))
                .onChange((isOn: boolean) => {
                  this.preventShutdown = isOn;
                })
              
              Text('>')
                .fontSize(16)
                .fontColor($r('app.color.text_secondary'))
                .margin({ left: 8 })
            }
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 16 })
          .backgroundColor($r('app.color.card_background'))
          .borderRadius(12)
          .margin({ left: 16, right: 16, bottom: 12 })
          .onClick(() => {
            // 打开阻止关机设置
          })
          
          // 闹钟设置
          this.SettingsItem(
            $r('app.string.alarm'),
            '',
            () => {
              // 跳转到闹钟设置
            }
          )
          
          // 任务设置
          this.SettingsItem(
            $r('app.string.task'),
            '',
            () => {
              // 跳转到任务设置
            }
          )
          
          // 常规设置
          this.SettingsItem(
            $r('app.string.general'),
            '',
            () => {
              // 跳转到常规设置
            }
          )
          
          // 问题反馈
          this.SettingsItem(
            $r('app.string.feedback'),
            '',
            () => {
              // 跳转到问题反馈
            }
          )
          
          // 关于我们
          this.SettingsItem(
            $r('app.string.about_us'),
            '',
            () => {
              // 跳转到关于我们
            }
          )
        }
        .width('100%')
        .padding({ bottom: 24 })
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background'))
  }
  
  @Builder
  SettingsItem(label: ResourceStr, icon: string, onClick: () => void) {
    Row() {
      if (icon) {
        Text(icon)
          .fontSize(20)
          .margin({ right: 12 })
      }
      
      Text(label)
        .fontSize(16)
        .fontColor($r('app.color.text_primary'))
      
      Blank()
      
      Text('>')
        .fontSize(16)
        .fontColor($r('app.color.text_secondary'))
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(12)
    .margin({ left: 16, right: 16, bottom: 12 })
    .onClick(() => {
      onClick();
    })
  }
}
