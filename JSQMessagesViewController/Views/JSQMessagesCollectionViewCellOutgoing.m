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

#import "JSQMessagesCollectionViewCellOutgoing.h"

#define TRAILING_MEDIA  12
#define TRAILING_TEXT   6

#define BOTTOM_MEDIA    8
#define BOTTOM_TEXT     4

@interface JSQMessagesCollectionViewCellOutgoing ()

@property (weak, nonatomic, readwrite) IBOutlet UIButton *messageInfoButton;

@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *timeTrailing;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *timeBottom;

@end

@implementation JSQMessagesCollectionViewCellOutgoing

#pragma mark - Overrides

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.messageBubbleTopLabel.textAlignment = NSTextAlignmentRight;
    self.cellBottomLabel.textAlignment = NSTextAlignmentRight;
    self.messageInfoButton.alpha = 0.0;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.messageInfoButton.alpha = 0.0;
    self.infoButtonActionHandler = nil;
}

- (IBAction) tapInfoButton:(id)sender {
    if (self.infoButtonActionHandler) {
        self.infoButtonActionHandler(self);
    }
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
