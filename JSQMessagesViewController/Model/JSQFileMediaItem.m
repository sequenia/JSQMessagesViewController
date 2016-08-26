//
//  JSQFileMediaItem.m
//  Threads
//
//  Created by Tabriz Dzhavadov on 08/07/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "JSQFileMediaItem.h"
#import "JSQFileMessageView.h"
#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"
#import "UIImage+JSQMessages.h"

@interface JSQFileMediaItem ()

@property (strong, nonatomic) JSQFileMessageView *cachedView;
@property (strong, nonatomic) UIImageView *cachedQuotedView;

@end


@implementation JSQFileMediaItem

- (instancetype)initWithFiles:(NSArray<JSQFile *> *)files {
    self = [super init];
    if (self) {
        _files = files;
        _downloading = NO;
    }
    return self;
}


#pragma mark - Setters

- (void)setFiles:(NSArray<JSQFile *> *)files
{
    _files = files;
    _cachedView = nil;
    _cachedQuotedView = nil;
}

- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing
{
    [super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
    _cachedView = nil;
    _cachedQuotedView = nil;
}

#pragma mark - Getters

- (JSQFile *) file {
    return self.files.firstObject;
}

#pragma mark - JSQMessageMediaData protocol

- (CGSize)mediaViewDisplaySize
{
    CGFloat height = 64.0f;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return CGSizeMake(315.0f, height);
    }
    return CGSizeMake(210.0f, height);
}

- (UIView *)mediaView
{
    if (!self.cachedView) {
        CGSize size = [self mediaViewDisplaySize];
        self.cachedView = [JSQFileMessageView fileMessageView];
        self.cachedView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
        [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:self.cachedView
                                                                    isOutgoing:self.appliesMediaViewMaskAsOutgoing];
    }
    return self.cachedView;
}

- (UIImageView *) mediaQuotedView{
    if(!_cachedQuotedView){
        _cachedQuotedView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"ic_file" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        if(self.appliesMediaViewMaskAsOutgoing){
            _cachedQuotedView.tintColor = [UIColor colorWithRed:53.f/255.f green:152.f/255.f blue:220.f/255.f alpha:1.f];
        }
        else{
            _cachedQuotedView.tintColor = [UIColor whiteColor];
        }
    }
    return _cachedQuotedView;
}

- (NSUInteger)mediaHash
{
    return self.hash;
}

- (NSString *)mediaDataType
{
    return NSStringFromClass([self class]);
}

- (id)mediaData
{
    return self.files.firstObject;
}

- (NSDictionary *)toDictionary {
    NSURL *url = [self file].networkURL;
    return @{@"result" : ([url isKindOfClass:[NSURL class]]) ? url.absoluteString : url,
             @"optional" : (self.optional) ? self.optional.toDictionary : @{}
             };
}

#pragma mark - NSObject

- (NSUInteger)hash
{
    return super.hash ^ self.files.firstObject.hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: file=%@, appliesMediaViewMaskAsOutgoing=%@>",
            [self class], self.files.firstObject, @(self.appliesMediaViewMaskAsOutgoing)];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _files = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(files))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.files forKey:NSStringFromSelector(@selector(files))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    JSQFileMediaItem *copy = [[JSQFileMediaItem allocWithZone:zone] initWithFiles:self.files];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    return copy;
}

- (void)startDownloading {
    _downloading = YES;
}

- (void)pauseDownloading {
    _downloading = NO;
}

@end
