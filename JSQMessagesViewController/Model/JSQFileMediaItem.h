//
//  JSQFileMediaItem.h
//  Threads
//
//  Created by Tabriz Dzhavadov on 08/07/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SQAttachment.h>
#import "JSQMediaItem.h"
#import "JSQFile.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  The `JSQPhotoMediaItem` class is a concrete `JSQMediaItem` subclass that implements the `JSQMessageMediaData` protocol
 *  and represents an any file media message. An initialized `JSQFileMediaItem` object can be passed
 *  to a `JSQMediaMessage` object during its initialization to construct a valid file media message object.
 *  You may wish to subclass `JSQFileMediaItem` to provide additional functionality or behavior.
 */
@interface JSQFileMediaItem : JSQMediaItem <JSQMessageMediaData, NSCoding, NSCopying>

/**
 *  The array of files. The default value is `nil`.
 */
@property (copy, nonatomic, nullable) NSArray <JSQFile *> *files;

/**
 *  Initializes and returns a file media item object having the given array of files.
 *
 *  @param files The array of files for the file media item. This value may be `nil`.
 *
 *  @return An initialized `JSQFileMediaItem`.
 *
 */
- (instancetype)initWithFiles:(NSArray <JSQFile *> *)files;

@end

NS_ASSUME_NONNULL_END