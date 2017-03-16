//
//  JSQLinkMessageView.m
//  Pods
//
//  Created by Sequenia on 27.02.17.
//
//

#import "JSQLinkMessagesView.h"
#import "JSQMessageData.h"

@interface JSQLinkMessagesView() <UIGestureRecognizerDelegate> {
  __unsafe_unretained IBOutlet UILabel *linkLabel;
  __unsafe_unretained IBOutlet UILabel *linkDescriptionLabel;
  __unsafe_unretained IBOutlet UITextView *linkContentLabel;
  __unsafe_unretained IBOutlet UIView *separatorView;
}

@end

@implementation JSQLinkMessagesView

+ (instancetype) linkMessageView {
  NSString* nibName = NSStringFromClass([self class]);
  NSBundle* bundle = [NSBundle bundleForClass: [self class]];
  NSArray *subviewArray = [bundle loadNibNamed: nibName owner:self options:nil];
  return subviewArray.firstObject;
}

+ (CGSize) labelSizeForWidth: (CGFloat) width font: (UIFont*) font text: (NSString*) text {
  CGRect rect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                   options:(NSStringDrawingUsesLineFragmentOrigin)
                                attributes:@{ NSFontAttributeName : font }
                                   context:nil];
  return CGRectIntegral(rect).size;
}

+ (CGSize) viewSizeForWidth: (CGFloat) width withData: (id<JSQMessageData>) data {
  CGFloat horisontalPaddings = 8.0 * 4;
  CGFloat verticalPaddings = 8.0 * 2;
  JSQLinkMessagesView* view = [JSQLinkMessagesView linkMessageView];
  
  CGFloat constantWidth = horisontalPaddings + CGRectGetWidth(view->separatorView.bounds);

  width -= constantWidth;
  
  CGSize titleSize = [self labelSizeForWidth: width
                                        font: view->linkLabel.font
                                        text: [[data link] linkTitle]];
  
  CGFloat height = titleSize.height + CGRectGetHeight(view->separatorView.bounds) + verticalPaddings;
  
  CGSize contentSize = [self labelSizeForWidth: width
                                          font: view->linkContentLabel.font
                                          text: [[data link] linkContent]];
  
  CGFloat finalWidth = MAX(titleSize.width, contentSize.width);
  
  if ([[[data link] linkContent] isEqualToString:@""]) {
    return CGSizeMake(finalWidth + constantWidth, 0);
  }
  else {
    return CGSizeMake(finalWidth + constantWidth, height);
  }
}

- (IBAction)tapToLink:(UITapGestureRecognizer *)sender {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkLabel.text]];
}

- (void) configureWithMessageData: (id<JSQMessageData>) messageData {
  linkLabel.text = [[messageData link] linkUrl];
  linkDescriptionLabel.text = [[messageData link] linkTitle];
  
  if ([[messageData link] linkContent]) {
    if ([[messageData link] linkImage]) {

      linkContentLabel.text = [[messageData link] linkContent];
      
      UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 120, 110)];
      
      UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 102) ];
      
      [imageView setImage:[[messageData link] linkImage]];
      [imageView setContentMode:UIViewContentModeScaleToFill];
      [linkContentLabel addSubview:imageView];
      
      linkContentLabel.textContainer.exclusionPaths = @[circle];
      
      
//      NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
//      attachment.image = [[messageData link] linkImage];
//      attachment.bounds = CGRectMake(0, -5, 22, 22);
//      
//      NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
//      
//      [imageString appendAttributedString:attachmentString];
    }
  }
}

- (CGFloat) contentHeight {
  //TODO: Посчитать высоту
  CGFloat verticalPaddings = 8.0 * 2;
  JSQLinkMessagesView* view = [JSQLinkMessagesView linkMessageView];
  
  CGSize titleSize = [JSQLinkMessagesView labelSizeForWidth: CGRectGetWidth(linkLabel.bounds)
                                                       font: linkLabel.font
                                                       text: linkLabel.text];
  
  CGFloat height = titleSize.height + CGRectGetHeight(separatorView.bounds) + verticalPaddings;
  
  //return 500;
  return height;
}

@end
