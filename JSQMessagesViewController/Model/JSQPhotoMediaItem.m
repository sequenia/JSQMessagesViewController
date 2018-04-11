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

#import "JSQPhotoMediaItem.h"

#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"
#import "JSQMessagesViewController.h"
#import "UIImage+JSQMessages.h"
#import "JSQHelper.h"
#import "JSQMessageMediaOptional.h"

#import <MobileCoreServices/UTCoreTypes.h>

@interface JSQPhotoMediaItem ()

@property (strong, nonatomic) UIView *cachedImageView;
@property (strong, nonatomic) UIImageView *cachedQuoteImageView;

@property BOOL status;

@end


@implementation JSQPhotoMediaItem

#pragma mark - Initialization

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        _image = [image copy];
        _imageURL = @"";
        _localURL = @"";
        _cachedImageView = nil;
        _cachedQuoteImageView = nil;
        _status = YES;
    }
    return self;
}

- (instancetype)initWithURL:(NSString *)url
{
    self = [super init];
    if (self) {
        _image = nil;
        _imageURL = url;
        _cachedImageView = nil;
        _cachedQuoteImageView = nil;
        _status = YES;
        [UIImage jsq_downloadImageFromURL:[NSURL URLWithString:self.imageURL]
                           withCompletion:^(UIImage *image, NSError *errorOrNil) {
                               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                   UIImage *resultImage = [image jsq_scaleProportionalToSize:[self mediaViewDisplaySize]];
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       self.image = resultImage;
                                       JSQMessagesViewController *controller = [JSQHelper sharedInstance].currentChatController;
                                       if (controller)
                                           [controller finishReceivingPhotoMessage:self];
                                   });
                               });
                           }];
    }
    return self;
}

- (void)clearCachedMediaViews
{
    [super clearCachedMediaViews];
    _cachedImageView = nil;
    _cachedQuoteImageView = nil;
}

#pragma mark - Setters

- (void)setImage:(UIImage *)image
{
    _image = [image copy];
    _cachedImageView = nil;
    _cachedQuoteImageView = nil;
}


- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing
{
    [super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
    _cachedImageView = nil;
    _cachedQuoteImageView = nil;
}

#pragma mark - JSQMessageMediaData protocol

- (UIView *)mediaView
{
    if (self.image == nil) {
        return nil;
    }
    
    if (self.cachedImageView == nil) {
        self.cachedImageView = [self updateCachedImageView];
    }
    
    return self.cachedImageView;
}

- (UIView *) updateCachedImageView {
    CGSize size = [self mediaViewDisplaySize];
    UIView *result;
    if(self.image.size.width <= 0 && self.image.size.height <= 0) {
        UIFont *font = [UIFont systemFontOfSize:17.f];

        NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:[self mediaString]];
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(size.width, FLT_MAX)];
        NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
        [layoutManager addTextContainer:textContainer];
        [textStorage addLayoutManager:layoutManager];
        [textStorage addAttribute:NSFontAttributeName
                            value:font
                            range:NSMakeRange(0, [textStorage length])];
        [textContainer setLineFragmentPadding:0.0];
        (void) [layoutManager glyphRangeForTextContainer:textContainer];
        
        CGFloat height = [layoutManager usedRectForTextContainer:textContainer].size.height;
        JSQMessagesCellTextView *textView = [[JSQMessagesCellTextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, height + 30)];
        textView.text = [self mediaString];
        textView.textColor = self.appliesMediaViewMaskAsOutgoing ? [UIColor blackColor] : [UIColor whiteColor];
        textView.backgroundColor = self.appliesMediaViewMaskAsOutgoing ? [UIColor colorWithHue:240.0f / 360.0f saturation:0.02f brightness:0.92f alpha:1.0f] : [UIColor colorWithRed:0.96 green:0.49 blue:0.2 alpha:1.f];
        textView.editable = NO;
        textView.font = font;
        [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:textView isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        textView.dataDetectorTypes = UIDataDetectorTypeLink;
        result = textView;
    }
    else {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
        imageView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        result = imageView;
    }
    
    
    if (self.appliesMediaViewMaskAsOutgoing) {
        if (self.status) {
            [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:result
                                                                        isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        } else {
            [JSQMessagesMediaViewBubbleImageMasker crp_applyBubbleImageMaskToMediaView:result
                                                                            isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        }
    } else {
        [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:result
                                                                    isOutgoing:self.appliesMediaViewMaskAsOutgoing];
    }
    return result;
}

- (UIImageView *)mediaQuotedView{
    if(!_cachedQuoteImageView){
        _cachedQuoteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _cachedQuoteImageView.contentMode = UIViewContentModeScaleAspectFill;
        _cachedQuoteImageView.image = nil;
        if(self.image){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *resultImage = [self.image jsq_scaleProportionalToSize:_cachedQuoteImageView.frame.size];
                dispatch_async(dispatch_get_main_queue(), ^{
                    _cachedQuoteImageView.image = resultImage;
                });
            });
        }
        else{
            [UIImage jsq_downloadImageFromURL:[NSURL URLWithString:self.imageURL]
                               withCompletion:^(UIImage *image, NSError *errorOrNil) {
                                   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                       UIImage *resultImage = [image jsq_scaleProportionalToSize:_cachedQuoteImageView.frame.size];
                                       self.image = resultImage;
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           _cachedQuoteImageView.image = resultImage;
                                       });
                                   });
                               }];
        }
    }
    return _cachedQuoteImageView;
}

- (NSUInteger)mediaHash
{
    return (self.image) ? self.image.hash : self.hash;
}

- (NSString *)mediaDataType
{
    return (NSString *)kUTTypeJPEG;
}

- (id)mediaData
{
    return UIImageJPEGRepresentation(self.image, 1);
}

- (NSDictionary *)toDictionary {
    return @{@"optional": (self.optional) ? self.optional.toDictionary : @[],
             @"result"  : (self.imageURL) ? self.imageURL : @""};
}

#pragma mark - NSObject

- (NSUInteger)hash
{
    return super.hash ^ self.image.hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: image=%@, appliesMediaViewMaskAsOutgoing=%@>",
            [self class], self.image, @(self.appliesMediaViewMaskAsOutgoing)];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _image = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(image))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.image forKey:NSStringFromSelector(@selector(image))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    JSQPhotoMediaItem *copy = [[JSQPhotoMediaItem allocWithZone:zone] initWithImage:self.image];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    return copy;
}

- (void)sentSuccesfully:(BOOL)success {
    self.status = success;
    self.cachedImageView = [self updateCachedImageView];
}

@end
