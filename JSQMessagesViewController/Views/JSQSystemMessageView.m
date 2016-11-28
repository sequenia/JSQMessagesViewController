//
//  JSQSystemMessageView.m
//  Pods
//
//  Created by Nikolay Kagala on 16/06/16.
//
//

#import "JSQSystemMessageView.h"

@implementation JSQSystemMessageView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutIfNeeded];
    self.image.layer.cornerRadius = CGRectGetWidth(self.image.bounds)/2.0;
}

- (void) awakeFromNib {
    [self configureAppearance];
}

- (void) configureAppearance {
    self.titleLabel.text = @"";
    self.subTitleLabel.text = @"";
    self.image.clipsToBounds = YES;
    
    self.image.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundColor = [UIColor clearColor];
}

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([JSQSystemMessageView class])
                          bundle:[NSBundle bundleForClass:[JSQSystemMessageView class]]];
}

+ (instancetype)systemMessageView {
    NSString* nibName = NSStringFromClass([self class]);
    NSBundle* bundle = [NSBundle bundleForClass: [self class]];
    NSArray *subviewArray = [bundle loadNibNamed: nibName owner:self options:nil];
    return subviewArray.firstObject;
}


@end
