//
//  CHPolygonLayer.m
//  Map
//
//  Created by gaocaihua on 2019/3/15.
//  Copyright © 2019 高才华. All rights reserved.
//

#import "CHPolygonLayer.h"
#import "CHPoint.h"
@implementation CHPolygonLayer

+ (instancetype)layerWithPoints:(NSArray<CHPoint*>*)points{
    return [[CHPolygonLayer alloc] initWithPoints:points];
}

- (instancetype)initWithPoints:(NSArray<CHPoint*>*)points{
    self = [super init];
    if (self) {
        self.count = points.count;
        self.pointArray = points;
        [self drawPathWith:points];
        
    }
    return self;
}

- (void)drawPathWith:(NSArray*)points{
    
    //创建path
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int i = 0; i<points.count; i++) {
        CHPoint *point = points[i];
        if (i == 0) {
            [path moveToPoint:point.point];
        }else{
            [path addLineToPoint:point.point];
        }
    }
    [path closePath];
    self.path  = path.CGPath;
    self.lineWidth = 1;
    self.strokeColor = [UIColor grayColor].CGColor;
    
}

@end
