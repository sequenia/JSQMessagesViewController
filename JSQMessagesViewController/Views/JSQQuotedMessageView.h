//
//  JSQQuotedMessageView.h
//  Pods
//
//  Created by Nikolay Kagala on 21/06/16.
//
//

#import <UIKit/UIKit.h>
#import "JSQMessageData.h"

@protocol JSQMessageData;

@interface JSQQuotedMessageView : UIView

@property (weak, nonatomic) IBOutlet UIView* separatorView;

@property (weak, nonatomic) IBOutlet UIView* fileView;

@property (weak, nonatomic) IBOutlet UILabel* senderDisplayNameLabel;

@property (weak, nonatomic) IBOutlet UILabel* contentLabel;

@property (weak, nonatomic) IBOutlet UILabel* fileSizeLabel;

@property (weak, nonatomic) IBOutlet UILabel* dateLabel;

+ (instancetype) qoutedMessageView;

+ (CGFloat) viewHeightForWidth: (CGFloat) width withData: (id<JSQMessageData>) data;

- (void) configureWithMessageData: (id<JSQMessageData>) messageData;

- (CGFloat) contentHeight;

- (void) setHiddenFileView: (BOOL) hidden animated: (BOOL) animated;


@end
