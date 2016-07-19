//
//  JSQFile.h
//  Threads
//
//  Created by Tabriz Dzhavadov on 08/07/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SQAttachment.h>

@interface JSQFile : NSObject

@property NSURL *url;

@property NSString *name;

- (instancetype) initWithName:(NSString *)name
                          url:(NSString *)url;

- (NSDictionary *)toDictionary;

@end

@interface JSQFile (SQAttachment) <SQAttachment>

@end