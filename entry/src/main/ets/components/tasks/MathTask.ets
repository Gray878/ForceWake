/**
 * 数学题任务组件
 */
import { TaskType, TaskConfig } from '../../model/Task';

interface MathProblem {
  question: string;
  answer: number;
}

@Component
export struct MathTask {
  @Prop taskConfig: TaskConfig = {};
  onComplete?: () => void;
  
  @State currentProblem: MathProblem | null = null;
  @State userAnswer: string = '';
  @State currentIndex: number = 0;
  @State totalCount: number = 3;
  @State isCompleted: boolean = false;
  
  aboutToAppear() {
    this.totalCount = this.taskConfig.mathCount || 3;
    this.generateNextProblem();
  }
  
  generateNextProblem() {
    const level = this.taskConfig.mathLevel || 1;
    let num1: number, num2: number, operator: string, answer: number;
    
    if (level === 1) {
      // 简单：10以内加减法
      num1 = Math.floor(Math.random() * 10) + 1;
      num2 = Math.floor(Math.random() * 10) + 1;
      operator = Math.random() > 0.5 ? '+' : '-';
      if (operator === '+') {
        answer = num1 + num2;
      } else {
        // 确保结果为正
        if (num1 < num2) {
          [num1, num2] = [num2, num1];
        }
        answer = num1 - num2;
      }
    } else if (level === 2) {
      // 中等：20以内加减法，包含乘法
      if (Math.random() > 0.3) {
        num1 = Math.floor(Math.random() * 20) + 1;
        num2 = Math.floor(Math.random() * 20) + 1;
        operator = Math.random() > 0.5 ? '+' : '-';
        if (operator === '+') {
          answer = num1 + num2;
        } else {
          if (num1 < num2) {
            [num1, num2] = [num2, num1];
          }
          answer = num1 - num2;
        }
      } else {
        num1 = Math.floor(Math.random() * 9) + 1;
        num2 = Math.floor(Math.random() * 9) + 1;
        operator = '×';
        answer = num1 * num2;
      }
    } else {
      // 困难：包含除法
      const ops = ['+', '-', '×', '÷'];
      operator = ops[Math.floor(Math.random() * ops.length)];
      
      if (operator === '÷') {
        num2 = Math.floor(Math.random() * 9) + 1;
        answer = Math.floor(Math.random() * 9) + 1;
        num1 = num2 * answer;
      } else if (operator === '×') {
        num1 = Math.floor(Math.random() * 9) + 1;
        num2 = Math.floor(Math.random() * 9) + 1;
        answer = num1 * num2;
      } else if (operator === '+') {
        num1 = Math.floor(Math.random() * 50) + 1;
        num2 = Math.floor(Math.random() * 50) + 1;
        answer = num1 + num2;
      } else {
        num1 = Math.floor(Math.random() * 50) + 20;
        num2 = Math.floor(Math.random() * 20) + 1;
        answer = num1 - num2;
      }
    }
    
    this.currentProblem = {
      question: `${num1} ${operator} ${num2} = ?`,
      answer: answer
    };
    this.userAnswer = '';
  }
  
  onSubmit() {
    if (!this.currentProblem) return;
    
    const userAns = parseInt(this.userAnswer);
    if (userAns === this.currentProblem.answer) {
      // 答对了
      this.currentIndex++;
      if (this.currentIndex >= this.totalCount) {
        // 完成所有题目
        this.isCompleted = true;
        if (this.onComplete) {
          this.onComplete();
        }
      } else {
        // 下一题
        this.generateNextProblem();
      }
    } else {
      // 答错了，清空输入重新答
      this.userAnswer = '';
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
        Text(`${this.currentIndex + 1} / ${this.totalCount}`)
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
          .margin({ top: 16, bottom: 24 })
        
        // 题目
        Text(this.currentProblem?.question || '')
          .fontSize(32)
          .fontColor($r('app.color.text_primary'))
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 32 })
        
        // 输入框
        TextInput({ placeholder: '输入答案', text: this.userAnswer })
          .type(InputType.Number)
          .width(200)
          .height(50)
          .fontSize(20)
          .textAlign(TextAlign.Center)
          .backgroundColor($r('app.color.card_background'))
          .borderRadius(8)
          .onChange((value: string) => {
            this.userAnswer = value;
          })
          .onSubmit(() => {
            this.onSubmit();
          })
        
        // 提交按钮
        Button('提交')
          .type(ButtonType.Capsule)
          .width(150)
          .height(40)
          .margin({ top: 24 })
          .enabled(this.userAnswer.length > 0)
          .onClick(() => {
            this.onSubmit();
          })
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16 })
    .justifyContent(FlexAlign.Center)
  }
}

