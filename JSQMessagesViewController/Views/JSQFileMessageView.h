//
//  JSQFileMessageView.h
//  Pods
//
//  Created by Tabriz Dzhavadov on 08/07/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessageData.h"
#import "NKDownloadControl.h"
#import <SQFileViewer.h>

@protocol JSQMessageData;

@interface JSQFileMessageView : UIView <SQFileViewerDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UIView *downloadView;

@property (unsafe_unretained, nonatomic) IBOutlet NKDownloadControl *downloadControl;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *fileNameLabel;

@property (weak, nonatomic) IBOutlet UILabel* fileSizeLabel;

+ (instancetype) fileMessageView;

+ (CGSize) viewSizeForWidth: (CGFloat) width withData: (id<JSQMessageData>) data;

- (void) configureWithMessageData: (id<JSQMessageData>) messageData;

- (CGFloat) contentHeight;

- (void) setHiddenFileView: (BOOL) hidden animated: (BOOL) animated;

- (void) didTapDownloadControl;

@end
