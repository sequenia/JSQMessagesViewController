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

#import "JSQMessagesMediaViewBubbleImageMasker.h"
#import "JSQMessagesBubbleImageFactory.h"
#import "UIImage+JSQMessages.h"
#import "UIColor+JSQMessages.h"

@implementation JSQMessagesMediaViewBubbleImageMasker

#pragma mark - Initialization

- (instancetype)init
{
    return [self initWithBubbleImageFactory:[[JSQMessagesBubbleImageFactory alloc] init]];
}

- (instancetype)initWithBubbleImageFactory:(JSQMessagesBubbleImageFactory *)bubbleImageFactory
{
    NSParameterAssert(bubbleImageFactory != nil);
    
    self = [super init];
    if (self) {
        _bubbleImageFactory = bubbleImageFactory;
    }
    return self;
}

#pragma mark - View masking

- (void)applyOutgoingBubbleImageMaskToMediaView:(UIView *)mediaView
{
    JSQMessagesBubbleImage *bubbleImageData = [self.bubbleImageFactory outgoingMessagesBubbleImageWithColor:[UIColor whiteColor]];
    [self jsq_maskView:mediaView withImage:[bubbleImageData messageBubbleImage]];
}

- (void)applyIncomingBubbleImageMaskToMediaView:(UIView *)mediaView
{
    JSQMessagesBubbleImage *bubbleImageData = [self.bubbleImageFactory incomingMessagesBubbleImageWithColor:[UIColor whiteColor]];
    [self jsq_maskView:mediaView withImage:[bubbleImageData messageBubbleImage]];
}

+ (void)applyBubbleImageMaskToMediaView:(UIView *)mediaView isOutgoing:(BOOL)isOutgoing
{
    JSQMessagesMediaViewBubbleImageMasker *masker = [[JSQMessagesMediaViewBubbleImageMasker alloc] init];
    
    if (isOutgoing) {
        [masker applyOutgoingBubbleImageMaskToMediaView:mediaView];
    }
    else {
        [masker applyIncomingBubbleImageMaskToMediaView:mediaView];
    }
}

+ (void)applyBubbleImageMaskToMediaView:(UIView *)mediaView isOutgoing:(BOOL)isOutgoing maskImage:(UIImage *)maskImage
{
    JSQMessagesMediaViewBubbleImageMasker *masker = [[JSQMessagesMediaViewBubbleImageMasker alloc] initWithBubbleImageFactory:[[JSQMessagesBubbleImageFactory alloc] initWithBubbleImage:maskImage]];
    
    if (isOutgoing) {
        [masker applyOutgoingBubbleImageMaskToMediaView:mediaView];
    }
    else {
        [masker applyIncomingBubbleImageMaskToMediaView:mediaView];
    }
}

#pragma mark - Private

- (void)jsq_maskView:(UIView *)view withImage:(UIImage *)image
{
    NSParameterAssert(view != nil);
    NSParameterAssert(image != nil);
    
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.frame = CGRectInset(view.frame, 2.0f, 2.0f);
    
    view.layer.mask = imageViewMask.layer;
}

#pragma mark CRP

+ (void)crp_applyBubbleImageMaskToMediaView:(UIView *)mediaView isOutgoing:(BOOL)isOutgoing maskImage:(nonnull UIImage *)maskImage
{
    JSQMessagesBubbleImageFactory *factory =
    [[JSQMessagesBubbleImageFactory alloc] initWithBubbleImage:maskImage
                                                     capInsets:UIEdgeInsetsZero
                                               layoutDirection:[UIApplication sharedApplication].userInterfaceLayoutDirection];

    JSQMessagesMediaViewBubbleImageMasker *masker =
    [[JSQMessagesMediaViewBubbleImageMasker alloc] initWithBubbleImageFactory:factory];
    
    if (isOutgoing) {
        [masker crp_applyOutgoingBubbleImageMaskToMediaView:mediaView];
    }
    else {
        [masker crp_applyIncomingBubbleImageMaskToMediaView:mediaView];
    }
}

- (void)crp_applyOutgoingBubbleImageMaskToMediaView:(UIView *)mediaView
{
    JSQMessagesBubbleImage *bubbleImageData = [self.bubbleImageFactory outgoingMessagesBubbleImageWithColor:[UIColor whiteColor]];
    [self crp_maskView:mediaView withImage:[bubbleImageData messageBubbleImage]];
}

- (void)crp_applyIncomingBubbleImageMaskToMediaView:(UIView *)mediaView
{
    JSQMessagesBubbleImage *bubbleImageData = [self.bubbleImageFactory incomingMessagesBubbleImageWithColor:[UIColor whiteColor]];
    [self crp_maskView:mediaView withImage:[bubbleImageData messageBubbleImage]];
}

- (void)crp_maskView:(UIView *)view withImage:(UIImage *)image
{
    NSParameterAssert(view != nil);
    NSParameterAssert(image != nil);
    
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.frame = CGRectInset(view.frame, 2.0f, 2.0f);
    
    view.layer.mask = imageViewMask.layer;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(16.0f, 16.0f)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = imageViewMask.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.frame = imageViewMask.bounds;
    shape.path = maskPath.CGPath;
    shape.lineWidth = 2.0f;
    shape.strokeColor = [UIColor jsq_messageBubbleRedColor].CGColor;
    shape.fillColor = [UIColor clearColor].CGColor;
    [view.layer addSublayer:shape];
}

@end
