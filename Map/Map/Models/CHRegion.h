//
//  CHRegion.h
//  Map
//
//  Created by gaocaihua on 2019/3/16.
//  Copyright © 2019 高才华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHPoint.h"
NS_ASSUME_NONNULL_BEGIN

@interface CHRegion : NSObject

/**
 * 名称
 */
@property (nonatomic,copy) NSString *name;

/**
 * 区域中所有的path
 */
@property (nonatomic,strong) NSArray *pathArray;

+ (instancetype)regionWithDictionary:(NSDictionary*)dict;
- (instancetype)initWithDictionary:(NSDictionary*)dict;


@end

NS_ASSUME_NONNULL_END
