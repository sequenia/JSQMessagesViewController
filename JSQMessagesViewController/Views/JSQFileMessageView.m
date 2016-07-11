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
#import <JSQMessagesViewController.h>

@interface JSQFileMessageView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* fileViewWidthConstraint;

@property (assign, nonatomic) CGFloat fileViewNormalWidth;

@property SQFileViewer *fileViewer;

@end

@implementation JSQFileMessageView

+ (instancetype) fileMessageView {
    NSString* nibName = NSStringFromClass([self class]);
    NSBundle* bundle = [NSBundle bundleForClass: [self class]];
    NSArray *subviewArray = [bundle loadNibNamed: nibName owner:self options:nil];
    return subviewArray.firstObject;
}

- (void) configureWithMessageData: (id<JSQMessageData>) messageData {
    JSQFileMediaItem *fileItem = [messageData media];
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
        UIColor *preferredColor = [UIColor colorWithRed: 0.0f
                                                  green: 150.0f/225.0f
                                                   blue: 136.0f/225.0f
                                                  alpha: 1.0f];
        _fileViewer = [SQFileViewer fileViewerWithFileAttachments: array
                                                         delegate: self
                                                   preferredColor: preferredColor];
    }
    return _fileViewer;
}

- (void) didTapDownloadControl {
    [self.fileViewer openFileAt:0
                     controller:nil
                     completion:^(UIViewController *fileViewerController, NSError *error) {
                         NSLog(@"fileViewerController = %@", fileViewerController);
                         UIViewController *chatController = [self currentChatController];
                         [chatController presentViewController: fileViewerController
                                                      animated: YES
                                                    completion: nil];
                     }];
}

- (UIViewController *)currentChatController {
    UINavigationController *topVC = [[UIApplication sharedApplication].keyWindow rootViewController];
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    for (UIViewController *vc in topVC.viewControllers)
        if ([vc isKindOfClass:[JSQMessagesViewController class]])
            return vc;
    return nil;
}

- (void) fileDownloadedBy: (CGFloat) progress {
    NSLog(@"progress = %@", @(progress));
}

- (void) controller {
    NSLog(@"self = %@", self);
}

@end
