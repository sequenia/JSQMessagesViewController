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

@property (strong, nonatomic) UIImageView *cachedImageView;
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

- (UIImageView *) updateCachedImageView {
    CGSize size = [self mediaViewDisplaySize];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
    imageView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    if (self.appliesMediaViewMaskAsOutgoing) {
        if (self.status) {
            [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:imageView
                                                                        isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        } else {
            [JSQMessagesMediaViewBubbleImageMasker crp_applyBubbleImageMaskToMediaView:imageView
                                                                            isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        }
    } else {
        [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:imageView
                                                                    isOutgoing:self.appliesMediaViewMaskAsOutgoing];
    }
    return imageView;
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
