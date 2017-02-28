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

- (void) configureWithMessageData: (id<JSQMessageData>) messageData;

- (CGFloat) contentHeight;

@end
