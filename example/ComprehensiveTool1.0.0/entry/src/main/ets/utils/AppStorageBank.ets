import { AppStorageV2 } from '@kit.ArkUI';
import { FeedBack, FeedBacks } from '../model/FeedBacks';

export class AppStorageBank {
  private static _feedBacks: FeedBacks = AppStorageV2.connect(FeedBacks, 'FeedBacks', () => new FeedBacks())!;

  static addFeedback(feedback: FeedBack) {
    AppStorageBank._feedBacks.contents.unshift(feedback);
  }

  static getFeedBacks() {
    return AppStorageBank._feedBacks;
  }
}