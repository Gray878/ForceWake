/**
 * 记忆游戏任务组件
 */
import { TaskConfig } from '../../model/Task';

interface Card {
  id: number;
  value: number;
  isFlipped: boolean;
  isMatched: boolean;
}

@Component
export struct MemoryTask {
  @Prop taskConfig: TaskConfig = {};
  onComplete?: () => void;
  
  @State cards: Card[] = [];
  @State flippedCards: number[] = [];
  @State matchedCount: number = 0;
  @State pairs: number = 3;
  @State isCompleted: boolean = false;
  
  aboutToAppear() {
    this.pairs = this.taskConfig.memoryPairs || 3;
    this.initCards();
  }
  
  initCards() {
    this.cards = [];
    const values: number[] = [];
    
    // 生成配对值
    for (let i = 0; i < this.pairs; i++) {
      values.push(i);
      values.push(i);
    }
    
    // 打乱顺序
    for (let i = values.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [values[i], values[j]] = [values[j], values[i]];
    }
    
    // 创建卡片
    for (let i = 0; i < values.length; i++) {
      this.cards.push({
        id: i,
        value: values[i],
        isFlipped: false,
        isMatched: false
      });
    }
  }
  
  onCardClick(cardIndex: number) {
    const card = this.cards[cardIndex];
    
    // 已匹配或已翻转的卡片不能点击
    if (card.isMatched || card.isFlipped) {
      return;
    }
    
    // 已经翻转了两张卡片，检查是否匹配
    if (this.flippedCards.length === 2) {
      // 重置之前翻转的卡片
      this.cards[this.flippedCards[0]].isFlipped = false;
      this.cards[this.flippedCards[1]].isFlipped = false;
      this.flippedCards = [];
    }
    
    // 翻转当前卡片
    card.isFlipped = true;
    this.flippedCards.push(cardIndex);
    
    // 检查是否匹配
    if (this.flippedCards.length === 2) {
      const card1 = this.cards[this.flippedCards[0]];
      const card2 = this.cards[this.flippedCards[1]];
      
      if (card1.value === card2.value) {
        // 匹配成功
        card1.isMatched = true;
        card2.isMatched = true;
        this.matchedCount++;
        this.flippedCards = [];
        
        // 检查是否完成
        if (this.matchedCount >= this.pairs) {
          this.isCompleted = true;
          if (this.onComplete) {
            this.onComplete();
          }
        }
      } else {
        // 不匹配，延迟后自动翻转回去
        setTimeout(() => {
          if (!card1.isMatched && !card2.isMatched) {
            card1.isFlipped = false;
            card2.isFlipped = false;
            this.flippedCards = [];
          }
        }, 1000);
      }
    }
  }
  
  build() {
    Column() {
      if (this.isCompleted) {
        Text('✅ 完成！')
          .fontSize(24)
          .fontColor($r('app.color.text_primary'))
          .margin({ top: 20 })
      } else {
        // 进度
        Text(`已匹配: ${this.matchedCount} / ${this.pairs}`)
          .fontSize(16)
          .fontColor($r('app.color.text_secondary'))
          .margin({ top: 16, bottom: 24 })
        
        // 卡片网格
        Grid() {
          ForEach(this.cards, (card: Card, index: number) => {
            GridItem() {
              this.MemoryCard(card, index)
            }
          }, (card: Card) => card.id.toString())
        }
        .columnsTemplate(this.getColumnsTemplate())
        .rowsGap(12)
        .columnsGap(12)
        .width('90%')
        .height(300)
        .padding(16)
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16 })
    .justifyContent(FlexAlign.Center)
  }
  
  @Builder
  MemoryCard(card: Card, index: number) {
    Button() {
      if (card.isFlipped || card.isMatched) {
        Text(card.value.toString())
          .fontSize(32)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
      } else {
        Text('?')
          .fontSize(32)
          .fontColor(Color.White)
      }
    }
    .type(ButtonType.Normal)
    .width('100%')
    .height('100%')
    .backgroundColor(card.isMatched ? 
      $r('app.color.accent_blue') : 
      (card.isFlipped ? '#4CAF50' : $r('app.color.card_background')))
    .borderRadius(8)
    .enabled(!card.isMatched)
    .onClick(() => {
      this.onCardClick(index);
    })
  }
  
  private getColumnsTemplate(): string {
    // 根据配对数量计算列数
    const totalCards = this.pairs * 2;
    if (totalCards <= 6) {
      return '1fr 1fr 1fr';
    } else if (totalCards <= 8) {
      return '1fr 1fr 1fr 1fr';
    } else {
      return '1fr 1fr 1fr 1fr 1fr';
    }
  }
}

