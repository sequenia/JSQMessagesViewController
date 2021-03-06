//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQMessagesAvatarImageFactory.h"

#import "UIColor+JSQMessages.h"
#import <NSData+SQExtended.h>

// TODO: define kJSQMessagesCollectionViewAvatarSizeDefault elsewhere so we can remove this import
#import "JSQMessagesCollectionViewFlowLayout.h"

@interface JSQMessagesAvatarImageFactory ()

@property (assign, nonatomic, readonly) NSUInteger diameter;

@property (nonatomic, readwrite) NSMutableDictionary *cache;

@end

@implementation JSQMessagesAvatarImageFactory

#pragma mark - Initialization

- (instancetype)init
{
    return [self initWithDiameter:kJSQMessagesCollectionViewAvatarSizeDefault];
}

- (instancetype)initWithDiameter:(NSUInteger)diameter
{
    NSParameterAssert(diameter > 0);
    
    self = [super init];
    if (self) {
        _diameter = diameter;
    }
    
    return self;
}

+ (instancetype)sharedInstance {
    static JSQMessagesAvatarImageFactory *_sharedInstance = nil;
    static dispatch_once_t onceSecurePredicate;
    dispatch_once(&onceSecurePredicate,^{
        _sharedInstance = [[self alloc] initWithDiameter: kJSQMessagesCollectionViewAvatarSizeDefault];
        _sharedInstance.cache = [@{} mutableCopy];
    });
    return _sharedInstance;
}

#pragma mark - Public

- (JSQMessagesAvatarImage *)avatarImageWithPlaceholder:(UIImage *)placeholderImage
{
    UIImage *circlePlaceholderImage = [self jsq_circularImage:placeholderImage
                                         withHighlightedColor:nil];

    return [JSQMessagesAvatarImage avatarImageWithPlaceholder:circlePlaceholderImage];
}

- (JSQMessagesAvatarImage *)avatarImageWithImage:(UIImage *)image
{
    NSDate* methodStart = [NSDate date];
    NSString *key = [UIImagePNGRepresentation(image) sq_md5Hash];
    JSQMessagesAvatarImage *fromCache = [self.cache valueForKey: key];
    if (fromCache) {
        NSLog(@"image[%@] from cache, time = %@", key, @(-[methodStart timeIntervalSinceNow]));
        return fromCache;
    }
    
    UIImage *squareImage = [self squareImageWithImage: image size:0];
    UIImage *avatar = [self circularAvatarImage: squareImage];
    UIImage *highlightedAvatar = [self circularAvatarHighlightedImage: squareImage];
    
    JSQMessagesAvatarImage *avatarImage = [[JSQMessagesAvatarImage alloc] initWithAvatarImage: avatar
                                                                             highlightedImage: highlightedAvatar
                                                                             placeholderImage: avatar];
    avatarImage.originalImage = [self squareImageWithImage: image size: 64];
    [self.cache setValue:avatarImage forKey: key];
    NSLog(@"image[%@] generate, time = %@", key, @([methodStart timeIntervalSinceNow]));
    return avatarImage;
}

- (UIImage *) squareImageWithImage: (UIImage *) image size: (CGFloat) size {
    
    double newCropSize;
    if (size == 0)
        newCropSize = MIN(image.size.width, image.size.height);
    else
        newCropSize = size;
    
    double x = image.size.width/2.0 - newCropSize/2.0;
    double y = image.size.height/2.0 - newCropSize/2.0;
    
    CGRect cropRect = CGRectMake(x, y, newCropSize, newCropSize);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropped;
}

- (UIImage *)scaledAvatarImageWithImage:(UIImage *)image {
    CGSize newSize;
    if (image.size.width > image.size.height) {
        newSize.width = self.diameter;
        newSize.height = image.size.height * self.diameter / image.size.width;
    } else {
        newSize.height = self.diameter;
        newSize.width = image.size.width * self.diameter / image.size.height;
    }
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)circularAvatarImage:(UIImage *)image
{
    return [self jsq_circularImage:image
              withHighlightedColor:nil];
}

- (UIImage *)circularAvatarHighlightedImage:(UIImage *)image
{
    return [self jsq_circularImage:image
              withHighlightedColor:[UIColor colorWithWhite:0.1f alpha:0.3f]];
}

- (JSQMessagesAvatarImage *)avatarImageWithUserInitials:(NSString *)userInitials
                                        backgroundColor:(UIColor *)backgroundColor
                                              textColor:(UIColor *)textColor
                                                   font:(UIFont *)font
{
    UIImage *avatarImage = [self jsq_imageWithInitials:userInitials
                                       backgroundColor:backgroundColor
                                             textColor:textColor
                                                  font:font];

    UIImage *avatarHighlightedImage = [self jsq_circularImage:avatarImage
                                         withHighlightedColor:[UIColor colorWithWhite:0.1f alpha:0.3f]];

    return [[JSQMessagesAvatarImage alloc] initWithAvatarImage:avatarImage
                                              highlightedImage:avatarHighlightedImage
                                              placeholderImage:avatarImage];
}

#pragma mark - Private

- (UIImage *)jsq_imageWithInitials:(NSString *)initials
                   backgroundColor:(UIColor *)backgroundColor
                         textColor:(UIColor *)textColor
                              font:(UIFont *)font
{
    NSParameterAssert(initials != nil);
    NSParameterAssert(backgroundColor != nil);
    NSParameterAssert(textColor != nil);
    NSParameterAssert(font != nil);

    CGRect frame = CGRectMake(0.0f, 0.0f, self.diameter, self.diameter);

    NSDictionary *attributes = @{ NSFontAttributeName : font,
                                  NSForegroundColorAttributeName : textColor };

    CGRect textFrame = [initials boundingRectWithSize:frame.size
                                              options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                           attributes:attributes
                                              context:nil];

    CGPoint frameMidPoint = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    CGPoint textFrameMidPoint = CGPointMake(CGRectGetMidX(textFrame), CGRectGetMidY(textFrame));

    CGFloat dx = frameMidPoint.x - textFrameMidPoint.x;
    CGFloat dy = frameMidPoint.y - textFrameMidPoint.y;
    CGPoint drawPoint = CGPointMake(dx, dy);
    UIImage *image = nil;

    UIGraphicsBeginImageContextWithOptions(frame.size, NO, [UIScreen mainScreen].scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();

        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, frame);
        [initials drawAtPoint:drawPoint withAttributes:attributes];

        image = UIGraphicsGetImageFromCurrentImageContext();

    }
    UIGraphicsEndImageContext();

    return [self jsq_circularImage:image withHighlightedColor:nil];
}

- (UIImage *)jsq_circularImage:(UIImage *)image withHighlightedColor:(UIColor *)highlightedColor
{
    NSParameterAssert(image != nil);

    CGRect frame = CGRectMake(0.0f, 0.0f, self.diameter, self.diameter);
    UIImage *newImage = nil;

    UIGraphicsBeginImageContextWithOptions(frame.size, NO, [UIScreen mainScreen].scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();

        UIBezierPath *imgPath = [UIBezierPath bezierPathWithOvalInRect:frame];
        [imgPath addClip];
        [image drawInRect:frame];

        if (highlightedColor != nil) {
            CGContextSetFillColorWithColor(context, highlightedColor.CGColor);
            CGContextFillEllipseInRect(context, frame);
        }

        newImage = UIGraphicsGetImageFromCurrentImageContext();
        
    }
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
