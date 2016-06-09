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

#import "JSQMessagesCollectionViewCell.h"

@class JSQMessagesCollectionViewCellOutgoing;

typedef void(^JSQInfoButtonHandler)(JSQMessagesCollectionViewCellOutgoing* cell);

/**
 *  A `JSQMessagesCollectionViewCellOutgoing` object is a concrete instance 
 *  of `JSQMessagesCollectionViewCell` that represents an outgoing message data item.
 */
@interface JSQMessagesCollectionViewCellOutgoing : JSQMessagesCollectionViewCell

/**
 *  Returns image view that is pinned to the right bottom corner of the message bubble
 *  This image is used to display the current message status
 */
@property (weak, nonatomic, readonly) UIImageView *messageStatusImageView;

/**
 *  Returns the info button. Uses for retrying sending failed messages.
 */
@property (weak, nonatomic, readonly) UIButton *messageInfoButton;

@property (copy, nonatomic, readwrite) JSQInfoButtonHandler infoButtonActionHandler;

@end
