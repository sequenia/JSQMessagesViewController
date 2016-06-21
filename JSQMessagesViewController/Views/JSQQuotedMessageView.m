//
//  JSQQuotedMessageView.m
//  Pods
//
//  Created by Nikolay Kagala on 21/06/16.
//
//

#import "JSQQuotedMessageView.h"

@interface JSQQuotedMessageView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* fileViewWidthConstraint;

@property (assign, nonatomic) CGFloat fileViewNormalWidth;

@end

@implementation JSQQuotedMessageView

+ (instancetype) qoutedMessageView {
    NSString* nibName = NSStringFromClass([self class]);
    NSBundle* bundle = [NSBundle bundleForClass: [self class]];
    NSArray *subviewArray = [bundle loadNibNamed: nibName owner:self options:nil];
    return subviewArray.firstObject;
}

- (void) configureWithMessageData: (id<JSQMessageData>) messageData {
    self.senderDisplayNameLabel.text = [messageData senderDisplayName];
    self.contentLabel.text = [messageData text];
    self.dateLabel.text = [messageData sentDateDescription];
    BOOL hideFileView = ![messageData isMediaMessage];
    [self setHiddenFileView: hideFileView animated: NO];
    if ([messageData isMediaMessage]){
        
    }
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
    self.senderDisplayNameLabel.text = @"";
    self.contentLabel.text = @"";
    self.fileSizeLabel.text = @"";
    self.dateLabel.text = @"";
    
}

- (CGFloat) contentHeight {
    [self layoutIfNeeded];
    CGFloat verticalPaddings = 8.0 * 2;
    CGFloat height = 0.0;
    NSArray* subviews = @[self.senderDisplayNameLabel,
                          self.contentLabel,
                          self.fileSizeLabel,
                          self.dateLabel];
    for (UIView* subview in subviews) {
        height += CGRectGetHeight(subview.bounds);
    }
    height += verticalPaddings;
    return ceilf(height);
}

+ (CGFloat) viewHeightForWidth: (CGFloat) width withData: (id<JSQMessageData>) data {
    CGFloat horisontalPaddings = 8.0 * 4;
    CGFloat verticalPaddings = 8.0 * 2;
    JSQQuotedMessageView* view = [JSQQuotedMessageView qoutedMessageView];
    width -= horisontalPaddings + CGRectGetWidth(view.fileView.bounds) + CGRectGetWidth(view.separatorView.bounds);
    CGFloat senderHeight = [self labelHeightForWidth: width
                                                font: view.senderDisplayNameLabel.font
                                                text: [data senderDisplayName]];
    CGFloat contentHeight = [self labelHeightForWidth: width
                                                 font: view.contentLabel.font
                                                 text: [data text]];
    CGFloat fileSizeHeight = 0.0;
    if ([data isMediaMessage]){
        //FIXME: Remove `file size placeholder`
        fileSizeHeight = [self labelHeightForWidth: width
                                              font: view.fileSizeLabel.font
                                              text: @"file size placeholder"];
    }
    
    CGFloat dateHeight = [self labelHeightForWidth: width
                                              font: view.dateLabel.font
                                              text: [data sentDateDescription]];
    CGFloat totalHeight = verticalPaddings + senderHeight + contentHeight + fileSizeHeight + dateHeight;
    return ceilf(totalHeight);
}

+ (CGFloat) labelHeightForWidth: (CGFloat) width font: (UIFont*) font text: (NSString*) text {
    return [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                              options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                           attributes:@{ NSFontAttributeName : font }
                              context:nil].size.height;
}


@end
