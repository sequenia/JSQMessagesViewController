//
//  JSQHelper.m
//  Pods
//
//  Created by Tabriz Dzhavadov on 15/07/16.
//
//

#import "JSQHelper.h"

@implementation JSQHelper

+ (instancetype)sharedInstance {
    static JSQHelper *_sharedInstance = nil;
    static dispatch_once_t onceSecurePredicate;
    dispatch_once(&onceSecurePredicate,^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (JSQMessagesViewController *)currentChatController {
    UINavigationController *topVC = [[UIApplication sharedApplication].keyWindow rootViewController];
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    if ([topVC isKindOfClass:[UINavigationController class]])
        for (UIViewController *vc in topVC.viewControllers)
            if ([vc isKindOfClass:[JSQMessagesViewController class]])
                return vc;
    return nil;
}

@end
