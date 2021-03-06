//
//  JSQFileMessageView.h
//  Pods
//
//  Created by Tabriz Dzhavadov on 08/07/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessageData.h"
#import "IBCircularProgressButton.h"

@protocol JSQMessageData;

@interface JSQFileMessageView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *defaultFileIcon;

@property (weak, nonatomic) IBOutlet UIView *downloadView;

@property (weak, nonatomic) IBOutlet IBCircularProgressButton *downloadControl;

@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;

@property (weak, nonatomic) IBOutlet UILabel* fileSizeLabel;

+ (instancetype) fileMessageView;

+ (CGSize) viewSizeForWidth: (CGFloat) width withData: (id<JSQMessageData>) data;

- (void) configureWithMessageData: (id<JSQMessageData>) messageData;

- (CGFloat) contentHeight;

- (void) setHiddenFileView: (BOOL) hidden animated: (BOOL) animated;

- (void) setFileProgress: (CGFloat) progress;

@end
