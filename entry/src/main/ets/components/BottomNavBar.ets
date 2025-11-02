/**
 * 底部导航栏组件
 */
@Component
export struct BottomNavBar {
  @Prop currentIndex: number = 0;
  onTabChange?: (index: number) => void;
  
  build() {
    Row() {
      // 闹钟
      this.NavItem(0, $r('app.string.alarm'), this.currentIndex === 0)
      // 睡眠
      this.NavItem(1, $r('app.string.sleep'), this.currentIndex === 1)
      // 早上
      this.NavItem(2, $r('app.string.morning'), this.currentIndex === 2)
      // 报告
      this.NavItem(3, $r('app.string.report'), this.currentIndex === 3)
      // 设置
      this.NavItem(4, $r('app.string.settings'), this.currentIndex === 4)
    }
    .width('100%')
    .height(56)
    .backgroundColor($r('app.color.nav_bar_background'))
    .justifyContent(FlexAlign.SpaceAround)
    .alignItems(VerticalAlign.Center)
  }
  
  @Builder
  NavItem(index: number, label: ResourceStr, isActive: boolean) {
    Column() {
      // 图标使用Text模拟，实际应该使用Image加载图标资源
      Text(this.getIcon(index))
        .fontSize(24)
        .fontColor(isActive ? $r('app.color.text_primary') : $r('app.color.text_secondary'))
      
      Text(label)
        .fontSize(10)
        .fontColor(isActive ? $r('app.color.text_primary') : $r('app.color.text_secondary'))
        .margin({ top: 2 })
      
      // 选中状态下划线
      if (isActive) {
        Divider()
          .width(20)
          .height(2)
          .color($r('app.color.accent_blue'))
          .margin({ top: 2 })
      }
    }
    .width('20%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      if (this.onTabChange) {
        this.onTabChange(index);
      }
    })
  }
  
  private getIcon(index: number): string {
    const icons = ['⏰', '🌙', '☀️', '📄', '⚙️'];
    return icons[index] || '○';
  }
}

