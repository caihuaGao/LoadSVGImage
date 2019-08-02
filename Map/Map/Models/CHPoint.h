//
//  CHPoint.h
//  Map
//
//  Created by gaocaihua on 2019/3/14.
//  Copyright © 2019 高才华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CHPoint : NSObject

/**
 * x坐标
 */
@property (nonatomic,copy) NSString *x;

/**
 * y坐标
 */
@property (nonatomic,copy) NSString *y;

/**
 * 坐标
 */
@property (nonatomic,assign) CGPoint point;

+ (instancetype)pointWithSting:(NSString*)string;
- (instancetype)initWithSting:(NSString*)string;

@end

NS_ASSUME_NONNULL_END
