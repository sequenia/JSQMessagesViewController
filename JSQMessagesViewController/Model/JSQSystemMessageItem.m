//
//  JSQSystemMessageItem.m
//  Pods
//
//  Created by Nikolay Kagala on 16/06/16.
//
//

#import "JSQSystemMessageItem.h"
#import "JSQSystemMessageView.h"

@interface JSQSystemMessageItem ()


@end

@implementation JSQSystemMessageItem

- (instancetype) initWithImage: (nullable UIImage*) image
                         title: (nullable NSString*) title
                      subTitle: (nullable NSString*) subTitle {
    if (self = [super init]){
        _image = [image copy];
        _title = [title copy];
        _subTitle = [subTitle copy];
    }
    return self;
}

#pragma mark - JSQMessageMediaData

- (nullable UIView *)mediaView {
    CGSize size = [self mediaViewDisplaySize];
    JSQSystemMessageView* view = [JSQSystemMessageView systemMessageView];
    view.titleLabel.text = self.title;
    view.subTitleLabel.text = self.subTitle;
    view.image.image = self.image ?: [self blankImage];
    view.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
    return view;
}

- (UIImage*)blankImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(5, 5), NO, 0.0);
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blank;
}

- (CGSize)mediaViewDisplaySize {
    CGFloat height = 60.0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width * 0.90;
    return CGSizeMake(width, height);
}

- (UIView *)mediaPlaceholderView {
    return [self mediaView];
}

- (NSUInteger)mediaHash{
    return self.hash;
}

#pragma mark - NSObject

- (NSUInteger)hash{
    return super.hash ^ self.subTitle.hash;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: image=%@, title=%@, subTitle=%@>",
            [self class], self.image, self.title, self.subTitle];
}


#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    JSQSystemMessageItem *copy =
    [[JSQSystemMessageItem allocWithZone: zone] initWithImage: self.image
                                                        title: self.title
                                                     subTitle: self.subTitle];
    return copy;
}

@end
