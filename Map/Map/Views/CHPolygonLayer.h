//
//  CHPolygonLayer.h
//  Map
//
//  Created by gaocaihua on 2019/3/15.
//  Copyright © 2019 高才华. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
@class CHPoint;
NS_ASSUME_NONNULL_BEGIN

@interface CHPolygonLayer : CAShapeLayer

/**
 * 多边形的定点数
 */
@property (nonatomic,assign) NSUInteger  count;

/**
 * 存放多边形的顶点的数组
 */
@property (nonatomic,strong) NSArray<CHPoint*> *pointArray;

+ (instancetype)layerWithPoints:(NSArray<CHPoint*>*)points;

- (instancetype)initWithPoints:(NSArray<CHPoint*>*)points;

@end

NS_ASSUME_NONNULL_END
