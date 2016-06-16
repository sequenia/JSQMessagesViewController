//
//  JSQSystemMessageItem.h
//  Pods
//
//  Created by Nikolay Kagala on 16/06/16.
//
//

#import "JSQMediaItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSQSystemMessageItem : JSQMediaItem <JSQMessageMediaData, NSCopying>

@property (strong, nonatomic, nullable) UIImage* image;

@property (copy, nonatomic, nullable) NSString* title;

@property (copy, nonatomic, nullable) NSString* subTitle;

- (instancetype) initWithImage: (nullable UIImage*) image
                         title: (nullable NSString*) title
                      subTitle: (nullable NSString*) subTitle;



@end

NS_ASSUME_NONNULL_END