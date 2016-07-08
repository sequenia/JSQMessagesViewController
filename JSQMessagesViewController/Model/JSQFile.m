//
//  JSQFile.m
//  Threads
//
//  Created by Tabriz Dzhavadov on 08/07/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "JSQFile.h"

@implementation JSQFile

- (instancetype) initWithName:(NSString *)name
                          url:(NSString *)url {
    self = [super init];
    if (self) {
        _name = name;
        _url = [NSURL URLWithString:url];
    }
    return self;
}

@end

@implementation JSQFile (SQAttachment)

- (NSURL *) fileUrl {
    return _url;
}

- (NSString *) fileName {
    return _name;
}

- (void) setFileUrl:(NSURL *)url {
    _url = url.absoluteString;
}

@end