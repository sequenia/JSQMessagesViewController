//
//  JSQFileMessageView.m
//  Pods
//
//  Created by Tabriz Dzhavadov on 08/07/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "JSQFileMessageView.h"
#import "JSQMessageMediaData.h"
#import "JSQFileMediaItem.h"
#import "UIView+JSQMessages.h"
#import "UIColor+JSQMessages.h"
#import <JSQMessagesViewController.h>

@interface JSQFileMessageView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* fileViewWidthConstraint;

@property (assign, nonatomic) CGFloat fileViewNormalWidth;

@property SQFileViewer *fileViewer;

/* temp data
 * TODO: need refactoring
 */
@property JSQFileMediaItem *fileData;
@property id<JSQMessageData> messageData;
/* temp data */
@end

@implementation JSQFileMessageView

+ (instancetype) fileMessageView {
    NSString* nibName = NSStringFromClass([self class]);
    NSBundle* bundle = [NSBundle bundleForClass: [self class]];
    NSArray *subviewArray = [bundle loadNibNamed: nibName owner:self options:nil];
    return subviewArray.firstObject;
}

- (void) configureWithMessageData: (id<JSQMessageData>) messageData indexPath: (NSIndexPath *)indexPath {
    JSQFileMediaItem *fileItem = [messageData media];
    self.fileData = fileItem;
    self.messageData = messageData;
    self.indexPath = indexPath;
    
    [self fileViewer:fileItem.files];
    UIImageView* mediaView = [[UIImageView alloc] initWithImage: [[fileItem mediaView] jsq_image]];
    mediaView.contentMode = UIViewContentModeScaleAspectFill;
    [self.downloadView addSubview: mediaView];
    mediaView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.downloadView jsq_pinAllEdgesOfSubview: mediaView];
}

- (void) setHiddenFileView: (BOOL) hidden animated: (BOOL) animated {
    CGFloat width = hidden ? 0.0 : self.fileViewNormalWidth;
    CGFloat duration = animated ? 0.3 : 0.0;
    self.fileViewWidthConstraint.constant = width;
    [UIView animateWithDuration: duration
                     animations:^{
                         [self layoutIfNeeded];
                     }];
}

- (void) awakeFromNib {
    [super awakeFromNib];
    self.fileViewNormalWidth = CGRectGetWidth(self.downloadView.bounds);
    [self configureAppearance];
    
    
    
}

- (void) configureAppearance {
    self.fileNameLabel.text = @"";
    self.fileSizeLabel.text = @"";
    self.downloadView.clipsToBounds = YES;
    self.downloadView.layer.cornerRadius = 5.0;
    self.downloadView.backgroundColor = [UIColor clearColor];
}

- (CGFloat) contentHeight {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGFloat verticalPaddings = 8.0 * 2;
    CGFloat height = 0.0;
    NSArray* subviews = @[self.fileNameLabel,
                          self.fileSizeLabel];
    for (UIView* subview in subviews) {
        height += CGRectGetHeight(subview.bounds);
    }
    height += verticalPaddings;
    return ceilf(height);
}

+ (CGSize) viewSizeForWidth: (CGFloat) width withData: (id<JSQMessageData>) data {
    CGFloat horisontalPaddings = 8.0 * 4;
    CGFloat verticalPaddings = 8.0 * 2;
    CGFloat finalWidth = 0.0;
    JSQFileMessageView* view = [JSQFileMessageView fileMessageView];
    CGFloat constantWidth = horisontalPaddings;
    if ([data isMediaMessage]){
        constantWidth += CGRectGetWidth(view.downloadView.bounds);
    }
    width -= constantWidth;
    CGSize nameSize = [self labelSizeForWidth: width
                                         font: view.fileNameLabel.font
                                         text: [data senderDisplayName]];
    finalWidth = MAX(finalWidth, nameSize.width);
    
    CGSize fileSizeSize = CGSizeZero;
    NSString* contentText = [data text];
    if ([data isMediaMessage]){
        id<JSQMessageMediaData> media = [data media];
        fileSizeSize = [self labelSizeForWidth: width
                                          font: view.fileSizeLabel.font
                                          text: [media mediaItemInfo]];
        contentText = [media mediaViewTitle];
        finalWidth = MAX(finalWidth, fileSizeSize.width);
    }
    
    CGFloat finalHeight = verticalPaddings + nameSize.height + fileSizeSize.height;
    //TODO: Cache the size for better performance
    return CGSizeMake(finalWidth + constantWidth, finalHeight);
}

+ (CGSize) labelSizeForWidth: (CGFloat) width font: (UIFont*) font text: (NSString*) text {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:(NSStringDrawingUsesLineFragmentOrigin)
                                  attributes:@{ NSFontAttributeName : font }
                                     context:nil];
    return CGRectIntegral(rect).size;
}

#pragma mark - Downloading

- (SQFileViewer *) fileViewer: (NSArray <id <SQAttachment>> *) array {
    if (!_fileViewer){
        _fileViewer = [SQFileViewer fileViewerWithFileAttachments: array
                                                         delegate: self
                                                   preferredColor: [UIColor jsq_fileViewerColor]];
    }
    return _fileViewer;
}

- (void) didTapDownloadControl {
    [self.downloadControl setProgress:0.0];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (float i = 0; i < 1.0; i+=0.01) {
            [NSThread sleepForTimeInterval:0.05];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.downloadControl setProgress:i];
            });
        }
    });
//    (self.fileData.downloading) ? [self.fileData pauseDownloading] :[self.fileData startDownloading];
//    JSQMessagesViewController *chatController = [self currentChatController];
//    if (self.indexPath)
//        [chatController.collectionView reloadItemsAtIndexPaths:@[self.indexPath]];
//    
//    [self.fileViewer openFileAt:0
//                     controller:nil
//                     completion:^(UIViewController *fileViewerController, NSError *error) {
//                         NSLog(@"fileViewerController = %@", fileViewerController);
//                         if (fileViewerController)
//                             [chatController presentViewController: fileViewerController
//                                                          animated: YES
//                                                    	completion: nil];
//                     }];
}

- (JSQMessagesViewController *)currentChatController {
    UINavigationController *topVC = [[UIApplication sharedApplication].keyWindow rootViewController];
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    if ([topVC isKindOfClass:[UINavigationController class]])
        for (UIViewController *vc in topVC.viewControllers)
            if ([vc isKindOfClass:[JSQMessagesViewController class]])
                return vc;
    return nil;
}

- (void) fileDownloadedBy: (CGFloat) progress {
    //TODO: need change this function
    self.fileData.progress = progress;
//    JSQMessagesViewController *chatController = [self currentChatController];
//    if (self.indexPath)
        //visual artefacts will appear if you reload table too many times
//        [chatController.collectionView reloadItemsAtIndexPaths:@[self.indexPath]];
        [self.downloadControl setProgress:progress];
    NSLog(@"progress = %@", @(progress));
}

- (void) controller {
    NSLog(@"self = %@", self);
}

@end
