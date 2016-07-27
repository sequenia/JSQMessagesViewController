//
//  JSQHelper.h
//  Pods
//
//  Created by Tabriz Dzhavadov on 15/07/16.
//
//

#import <Foundation/Foundation.h>
#import "JSQMessagesViewController.h"
#import "JSQFile.h"

@interface JSQHelper : NSObject

+ (instancetype)sharedInstance;

- (JSQMessagesViewController *)currentChatController;

- (BOOL) isFileExist: (JSQFile *) file;

@end
