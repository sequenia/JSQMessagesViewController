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

#define TRAILING_MEDIA  20
#define TRAILING_TEXT   12

#define BOTTOM_MEDIA    6
#define BOTTOM_TEXT     4


#import "JSQMessagesCollectionViewCellIncoming.h"

@interface JSQMessagesCollectionViewCellIncoming()

@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *timeBottom;

@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *timeTrailing;

@end

@implementation JSQMessagesCollectionViewCellIncoming

#pragma mark - Overrides

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.messageBubbleTopLabel.textAlignment = NSTextAlignmentLeft;
    self.cellBottomLabel.textAlignment = NSTextAlignmentLeft;
}

- (void) setConstraintsForMedia: (BOOL) media {
    if (media) {
        self.timeTrailing.constant = TRAILING_MEDIA;
        self.timeBottom.constant = BOTTOM_MEDIA;
    } else {
        self.timeTrailing.constant = TRAILING_TEXT;
        self.timeBottom.constant = BOTTOM_TEXT;
    }
}

@end
