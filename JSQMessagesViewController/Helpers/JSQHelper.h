//
//  JSQHelper.h
//  Pods
//
//  Created by Tabriz Dzhavadov on 15/07/16.
//
//

#import <Foundation/Foundation.h>
#import "JSQMessagesViewController.h"

@interface JSQHelper : NSObject

+ (instancetype)sharedInstance;

- (JSQMessagesViewController *)currentChatController;

@end
