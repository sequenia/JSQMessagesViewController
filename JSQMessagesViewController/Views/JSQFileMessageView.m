//
//  JSQFileMessageView.m
//  Pods
//
//  Created by Tabriz Dzhavadov on 08/07/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "JSQFileMessageView.h"
#import "JSQMessageMediaData.h"
#import "UIView+JSQMessages.h"

@interface JSQFileMessageView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* fileViewWidthConstraint;

@property (assign, nonatomic) CGFloat fileViewNormalWidth;

@end

@implementation JSQFileMessageView

+ (instancetype) fileMessageView {
    NSString* nibName = NSStringFromClass([self class]);
    NSBundle* bundle = [NSBundle bundleForClass: [self class]];
    NSArray *subviewArray = [bundle loadNibNamed: nibName owner:self options:nil];
    return subviewArray.firstObject;
}

- (void) configureWithMessageData: (id<JSQMessageData>) messageData {
    id <JSQMessageMediaData> mediaData = [messageData media];
    UIImageView* mediaView = [[UIImageView alloc] initWithImage: [[mediaData mediaView] jsq_image]];
    mediaView.contentMode = UIViewContentModeScaleAspectFill;
    [self.fileView addSubview: mediaView];
    mediaView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.fileView jsq_pinAllEdgesOfSubview: mediaView];
    
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
    self.fileViewNormalWidth = CGRectGetWidth(self.fileView.bounds);
    [self configureAppearance];
}

- (void) configureAppearance {
    self.fileNameLabel.text = @"";
    self.fileSizeLabel.text = @"";
    self.fileView.clipsToBounds = YES;
    self.fileView.layer.cornerRadius = 5.0;
    self.fileView.backgroundColor = [UIColor clearColor];
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
        constantWidth += CGRectGetWidth(view.fileView.bounds);
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


@end
