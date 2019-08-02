//
//  CHMapModel.h
//  Map
//
//  Created by gaocaihua on 2019/3/16.
//  Copyright © 2019 高才华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHRegion.h"

NS_ASSUME_NONNULL_BEGIN
@interface CHMapModel : NSObject

/**
 * 高度
 */
@property (nonatomic,assign) CGFloat  height;


/**
 * 宽度
 */
@property (nonatomic,assign) CGFloat  width;

/**
 * 名称
 */
@property (nonatomic,copy) NSString *name;


/**
 * 区域中所有的path
 */
@property (nonatomic,strong) NSArray <CHRegion*>*regionArray;


+ (instancetype)mapWithName:(NSString*)name;
- (instancetype)initWithName:(NSString*)name;

@end

NS_ASSUME_NONNULL_END
