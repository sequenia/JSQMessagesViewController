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

#import "JSQMediaItem.h"

NS_ASSUME_NONNULL_BEGIN

@class JSQPhotoMediaItem;

@protocol JSQPhotoLoadedDelegate <NSObject>
@optional
- (void) jsq_imageLoaded: (JSQPhotoMediaItem *) item;
@end


/**
 *  The `JSQPhotoMediaItem` class is a concrete `JSQMediaItem` subclass that implements the `JSQMessageMediaData` protocol
 *  and represents a photo media message. An initialized `JSQPhotoMediaItem` object can be passed 
 *  to a `JSQMediaMessage` object during its initialization to construct a valid media message object.
 *  You may wish to subclass `JSQPhotoMediaItem` to provide additional functionality or behavior.
 */
@interface JSQPhotoMediaItem : JSQMediaItem <JSQMessageMediaData, NSCoding, NSCopying>

/**
 *  The image for the photo media item. The default value is `nil`.
 
 */
@property (strong, nonatomic) UIImage *maskImage;
@property (strong, nonatomic) UIImage *strokedMaskImage;
@property (nonatomic, strong) UIColor *emptyImageColor;
@property (nonatomic, strong) UIColor *errorColor;

@property (copy, nonatomic, nullable) UIImage *image;

/**
 *  The image url for the photo media item. The default value is `""`.
 */
@property (copy, nonatomic, nullable) NSString *imageURL;

/**
 *  The image local url for the photo media item. The default value is `""`.
 */
@property (copy, nonatomic, nullable) NSString *localURL; //TODO: need to save image

/**
 *  Initializes and returns a photo media item object having the given image.
 *
 *  @param image The image for the photo media item. This value may be `nil`.
 *
 *  @return An initialized `JSQPhotoMediaItem`.
 *
 *  @discussion If the image must be dowloaded from the network, 
 *  you may initialize a `JSQPhotoMediaItem` object with a `nil` image. 
 *  Once the image has been retrieved, you can then set the image property.
 
 */
- (instancetype)initWithImage:(UIImage *)image
                    maskImage:(UIImage *)maskImage
                  strokedMask:(UIImage *)strokedMask
              emptyImageColor:(UIColor *)emptyImageColor
                   errorColor:(UIColor *)errorColor;
/**
 *  Initializes and returns a photo media item object having the given image with url.
 *
 *  @param url The url for the photo media item.
 *
 *  @return An initialized `JSQPhotoMediaItem`.
 *
 *  @discussion Image will be downloaded from the network.
 */
- (instancetype)initWithURL:(NSString *)url
                  maskImage:(UIImage *)maskImage
                strokedMask:(UIImage *)strokedMask
            emptyImageColor:(UIColor *)emptyImageColor
                 errorColor:(UIColor *)errorColor
                   delegate:(id <JSQPhotoLoadedDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
