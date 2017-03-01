//
//  JSQLinkMessageView.h
//  Pods
//
//  Created by Sequenia on 27.02.17.
//
//

#import <UIKit/UIKit.h>

@protocol JSQMessageData;

@interface JSQLinkMessagesView : UIView

+ (instancetype) linkMessageView;

+ (CGSize) viewSizeForWidth: (CGFloat) width withData: (id<JSQMessageData>) data;

- (void) configureWithMessageData: (id<JSQMessageData>) messageData;

- (CGFloat) contentHeight;

@end
