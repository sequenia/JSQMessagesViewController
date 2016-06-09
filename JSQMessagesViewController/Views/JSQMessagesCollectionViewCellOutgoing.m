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

@interface JSQMessagesCollectionViewCellOutgoing ()

@property (weak, nonatomic, readwrite) IBOutlet UIImageView *messageStatusImageView;

@property (weak, nonatomic, readwrite) IBOutlet UIButton *messageInfoButton;

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
    
    self.messageStatusImageView.image = nil;
    self.messageInfoButton.alpha = 0.0;
    self.infoButtonActionHandler = nil;
}

- (IBAction) tapInfoButton:(id)sender {
    if (self.infoButtonActionHandler) {
        self.infoButtonActionHandler(self);
    }
}


@end
