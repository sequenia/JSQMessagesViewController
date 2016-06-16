//
//  JSQSystemMessageView.h
//  Pods
//
//  Created by Nikolay Kagala on 16/06/16.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSQSystemMessageView : UIView

@property (weak, nonatomic, nullable) IBOutlet UIImageView* image;

@property (weak, nonatomic, nullable) IBOutlet UILabel* titleLabel;

@property (weak, nonatomic, nullable) IBOutlet UILabel* subTitleLabel;

+ (UINib *)nib;

+ (instancetype)systemMessageView;

@end

NS_ASSUME_NONNULL_END