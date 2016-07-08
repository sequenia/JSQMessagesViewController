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
        _fileName = name;
        _fileUrl = url;
    }
    return self;
}

@end

@implementation JSQFile (SQAttachment)

- (NSURL *) fileUrl {
    return [NSURL URLWithString:self.fileUrl];
}

- (NSString *) fileName {
    return self.fileName;
}

- (void) setFileUrl:(NSURL *)url {
    _fileUrl = url.absoluteString;
}

@end