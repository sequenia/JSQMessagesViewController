//
//  JSQMessageMediaOptional.h
//  Pods
//
//  Created by Tabriz Dzhavadov on 01/08/16.
//
//

#import <Foundation/Foundation.h>

@interface JSQMessageMediaOptional : NSObject

NS_ASSUME_NONNULL_BEGIN

@property (copy, nonatomic, readwrite) NSString *type;

@property (copy, nonatomic, readwrite) NSString *name;

@property (nonatomic, readwrite) NSInteger size;

@property (nonatomic, readwrite) NSInteger lastModified;

+ (instancetype) optionalWithType: (NSString *) type
                             name: (NSString *) name
                             size: (NSInteger ) size
                     lastModified: (NSInteger ) lastModified;

- (NSDictionary *) toDictionary;

NS_ASSUME_NONNULL_END

@end
