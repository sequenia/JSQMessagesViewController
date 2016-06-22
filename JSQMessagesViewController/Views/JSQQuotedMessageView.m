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

+ (CGSize) viewSizeForWidth: (CGFloat) width withData: (id<JSQMessageData>) data {
    CGFloat horisontalPaddings = 8.0 * 4;
    CGFloat verticalPaddings = 8.0 * 2;
    CGFloat finalWidth = 0.0;
    JSQQuotedMessageView* view = [JSQQuotedMessageView qoutedMessageView];
    CGFloat constantWidth = horisontalPaddings + CGRectGetWidth(view.separatorView.bounds);
    if ([data isMediaMessage]){
        constantWidth += CGRectGetWidth(view.fileView.bounds);
    }
    width -= constantWidth;
    CGSize senderSize = [self labelSizeForWidth: width
                                           font: view.senderDisplayNameLabel.font
                                           text: [data senderDisplayName]];
    finalWidth = MAX(finalWidth, senderSize.width);
    CGSize contentSize = [self labelSizeForWidth: width
                                            font: view.contentLabel.font
                                            text: [data text]];
    finalWidth = MAX(finalWidth, contentSize.width);
    CGSize fileSizeSize = CGSizeZero;
    if ([data isMediaMessage]){
        //FIXME: Remove `file size placeholder`
        fileSizeSize = [self labelSizeForWidth: width
                                          font: view.fileSizeLabel.font
                                          text: @"file size placeholder"];
    }
    finalWidth = MAX(finalWidth, fileSizeSize.width);
    
    CGSize dateSize = [self labelSizeForWidth: width
                                         font: view.dateLabel.font
                                         text: [data sentDateDescription]];
    finalWidth = MAX(finalWidth, dateSize.width);
    
    CGFloat finalHeight = verticalPaddings + senderSize.height + contentSize.height + fileSizeSize.height + dateSize.height;
    
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
