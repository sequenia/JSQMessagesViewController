//
//  JSQLinkMessageView.m
//  Pods
//
//  Created by Sequenia on 27.02.17.
//
//

#import "JSQLinkMessagesView.h"
#import "JSQMessageData.h"

@interface JSQLinkMessagesView() {
  __unsafe_unretained IBOutlet UILabel *linkLabel;
  __unsafe_unretained IBOutlet UILabel *linkDescriptionLabel;
  __unsafe_unretained IBOutlet UILabel *linkContentLabel;
}

@end

@implementation JSQLinkMessagesView

+ (instancetype) linkMessageView {
  NSString* nibName = NSStringFromClass([self class]);
  NSBundle* bundle = [NSBundle bundleForClass: [self class]];
  NSArray *subviewArray = [bundle loadNibNamed: nibName owner:self options:nil];
  return subviewArray.firstObject;
}

+ (CGSize) viewSizeForWidth: (CGFloat) width withData: (id<JSQMessageData>) data {
//  CGFloat horisontalPaddings = 8.0 * 4;
//  CGFloat verticalPaddings = 8.0 * 2;
//  CGFloat finalWidth = 0.0;
//  JSQLinkMessagesView* view = [JSQLinkMessagesView linkMessageView];
//  CGFloat constantWidth = horisontalPaddings + CGRectGetWidth(view.separatorView.bounds);
//  if ([data isMediaMessage]) {
//    constantWidth += CGRectGetWidth(view.fileView.bounds);
//  }
//  width -= constantWidth;
//  CGSize senderSize = [self labelSizeForWidth: width
//                                         font: view.senderDisplayNameLabel.font
//                                         text: [data senderDisplayName]];
//  finalWidth = MAX(finalWidth, senderSize.width);
//  
//  CGSize fileSizeSize = CGSizeZero;
//  NSString* contentText = [data text];
//  if ([data isMediaMessage]){
//    id<JSQMessageMediaData> media = [data media];
//    fileSizeSize = [self labelSizeForWidth: width
//                                      font: view.fileSizeLabel.font
//                                      text: [media mediaItemInfo]];
//    contentText = [media mediaViewTitle];
//    finalWidth = MAX(finalWidth, fileSizeSize.width);
//  }
//  CGSize contentSize = [self labelSizeForWidth: width
//                                          font: view.contentLabel.font
//                                          text: contentText];
//  finalWidth = MAX(finalWidth, contentSize.width);
//  
//  CGSize dateSize = [self labelSizeForWidth: width
//                                       font: view.dateLabel.font
//                                       text: [data sentDateDescription]];
//  finalWidth = MAX(finalWidth, dateSize.width);
//  
//  CGFloat finalHeight = verticalPaddings + senderSize.height + contentSize.height + fileSizeSize.height + dateSize.height;
//  //TODO: Cache the size for better performance
//  return CGSizeMake(finalWidth + constantWidth, finalHeight);
  return CGSizeMake(100, 100);
}

- (void) configureWithMessageData: (id<JSQMessageData>) messageData {
  linkLabel.text = @"http://test.test";

}

- (CGFloat) contentHeight {
  return 100.;
}

@end
