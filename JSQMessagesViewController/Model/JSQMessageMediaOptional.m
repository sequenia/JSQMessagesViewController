//
//  JSQMessageMediaOptional.m
//  Pods
//
//  Created by Tabriz Dzhavadov on 01/08/16.
//
//

#import "JSQMessageMediaOptional.h"

@implementation JSQMessageMediaOptional

+ (instancetype) optionalWithType: (NSString *) type
                             name: (NSString *) name
                             size: (NSInteger ) size
                     lastModified: (NSInteger ) lastModified {
    return [[self alloc] initWithType: type
                                 name: name
                                 size: size
                         lastModified: lastModified];
}

- (instancetype) initWithType: (NSString *) type
                         name: (NSString *) name
                         size: (NSInteger ) size
                 lastModified: (NSInteger ) lastModified {
    if (self = [super init]) {
        _type = type;
        _name = name;
        _size = size;
        _lastModified = lastModified;
    }
    return self;
}

- (NSDictionary *) toDictionary {
    return @{@"type"            : self.type,
             @"name"            : self.name,
             @"size"            : [NSString stringWithFormat:@"%@", @(self.size)],
             @"lastModified"    : [NSString stringWithFormat:@"%@", @(self.lastModified)]
             };
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [[[self class] alloc] initWithType: self.type
                                         name: self.name
                                         size: self.size
                                 lastModified: self.lastModified];
}

@end
