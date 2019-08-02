//
//  CHMapView.m
//  Map
//
//  Created by gaocaihua on 2019/3/16.
//  Copyright © 2019 高才华. All rights reserved.
//

#import "CHMapView.h"
#import "CHMapModel.h"
#import "CHPolygonLayer.h"
#import "PopoverView.h"
#import "UIView+Frame.h"

@interface CHMapView ()<UIScrollViewDelegate>

/**
 * mapView
 */
@property (nonatomic,strong) UIView *mapView;

/**
 * 选中的区域（一个国家或一个省份的多个区域）
 */
@property (nonatomic,strong) NSMutableArray *selectedLayerArray;

/**
 * 记录选中修改前的颜色
 */
@property (nonatomic,strong) UIColor *selectedlayerColor;

/**
 * 记录选中的颜色
 */
@property (nonatomic,copy)   NSString *selectedLayerName;

/**
 * 地图上所以地区的颜色
 */
@property (nonatomic,strong) NSMutableDictionary *colorsDict;


@end

@implementation CHMapView

+ (instancetype)mapWithMapModel:(CHMapModel*)model{
    return [[CHMapView alloc] initWithMapModel:model];
}

- (instancetype)initWithMapModel:(CHMapModel*)model{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:109/255.0 green:224/255.0 blue:244/255.0 alpha:1.0];
        self.layers = [NSMutableArray array];
        self.bounces = NO;
        self.delegate = self;
        
        _mapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, model.width, model.height)];
        [self addSubview:_mapView];
        _mapView.backgroundColor = [UIColor colorWithRed:109/255.0 green:224/255.0 blue:244/255.0 alpha:1.0];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_mapView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [_mapView addGestureRecognizer:longPress];
        
        self.contentSize = CGSizeMake(model.width, model.height);
        [self setMapData:model];
        
    }
    return self;
}

- (void)setMapData:(CHMapModel*)model{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *regionArray = model.regionArray;
    for (CHRegion*region in regionArray) {
        UIColor *regionColor = [self randomColor];
        [dict setObject:regionColor forKey:region.name];
        for (NSArray *pointArray in region.pathArray) {
            CHPolygonLayer *layer = [CHPolygonLayer layerWithPoints:pointArray];
            layer.name = region.name;
            UIColor *color = [dict objectForKey:region.name];
            layer.fillColor = color.CGColor;
            [self.layer addSublayer:layer];
            [self.layers addObject:layer];
        }
    }
}


/**
 * 检查某点是否包含在多边形的范围内(核心算法 需要优化) 规定点在边上或顶点上属于多边形的内部
 */
- (BOOL)isInPolygon:(CHPolygonLayer*)polygon point:(CGPoint)point {
    NSUInteger verticesCount = polygon.count;
    NSArray *pointArray = polygon.pointArray;
    
    int nCross = 0;
    for (int i = 0; i < verticesCount; ++ i) {
        CHPoint *pointx = pointArray[i];
        CHPoint *pointm = pointArray[(i + 1) % verticesCount];
        float j = pointx.point.x;
        float k = pointx.point.y;
        float m = pointm.point.x;
        float n = pointm.point.y;
        CGPoint p1 = CGPointMake(j, k);
        CGPoint p2 = CGPointMake(m, n);
        
        //点在多边形的顶点上
        //        if (point.y == p1.y && point.x == p1.x) {
        //            return NO;
        //        }
        
        //求解 y=point.y与 p1 p2 的交点
        if ( p1.y == p2.y ) {  // p1p2与 y=p0.y平行
            continue;
        }
        if ( point.y < fminf(p1.y, p2.y) ) {//交点在p1p2延长线上 （规定）
            continue;
        }
        if ( point.y > fmaxf(p1.y, p2.y) ) {//交点在p1p2延长线上
            continue;
        }
        
        //求交点的 X坐标
        double x = (double)(point.y - p1.y) * (double)(p2.x - p1.x) / (double)(p2.y - p1.y) + p1.x;
        //        double y = point.y;
        
        if ( x > point.x ) { // 只统计单边交点
            nCross++;
        }
        
        //当射线穿过多边形的顶点的时候 规定交点属于射线上侧（也就是说只算一次穿越）
        //        if (x == p1.x && y == p1.y && p2.y<y) {
        //            nCross--;
        //        }
        
        
    }
    if(nCross%2 != 0) {   //单边交点为偶数，点在多边形之外
        return YES;
    } else {
        return NO;
    }
}


/**
 * 点击事件
 */
- (void)tap:(UITapGestureRecognizer*)gesture{
    
    CGPoint point = [gesture locationInView:_mapView];
    
    // 1.先还原之前点击的国家或省份
    for (CHPolygonLayer *layer in self.selectedLayerArray) {
        layer.fillColor = self.selectedlayerColor.CGColor;
    }
    
    // 2.获取到当前点击的国家或省份的名称和颜色
    for (CHPolygonLayer *layerp in self.layers) {
        BOOL isIn = [self isInPolygon:layerp point:point];
        if (isIn) {
            self.selectedLayerName = layerp.name;
            self.selectedlayerColor = [UIColor colorWithCGColor:layerp.fillColor];
            
            //点击事件
            if ([self.mapDelegate respondsToSelector:@selector(chmapView:didClickRegion:)]) {
                [self.mapDelegate chmapView:self didClickRegion:layerp.name];
            }
            
            break;
        }
    }
    
    // 3.保存点击中的某个国家或某个省的所有地区
    [self.selectedLayerArray removeAllObjects];
    for (CHPolygonLayer *layer in self.layers) {
        if ([self.selectedLayerName isEqualToString:layer.name]) {
            layer.fillColor = [UIColor redColor].CGColor;
            [self.selectedLayerArray addObject:layer];
        }
    }
    
    
    
}


/**
 * 长按事件
 */
- (void)longPress:(UITapGestureRecognizer*)gesture{
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        CGPoint pointV = [gesture locationInView:[UIApplication sharedApplication].keyWindow];
        CGPoint point = [gesture locationInView:_mapView];
        for (CHPolygonLayer *layerp in self.layers) {
            BOOL isIn = [self isInPolygon:layerp point:point];
            if (isIn) {
                [self showWithoutImage:pointV name:layerp.name];
                break;
                
            }
        }
    }
}


/**
 * 弹框
 */
- (void)showWithoutImage:(CGPoint)point name:(NSString*)name{
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    popoverView.hideAfterTouchOutside = YES; // 点击外部时不允许隐藏
    // 不带图片
    PopoverAction *action = [PopoverAction actionWithTitle:name handler:^(PopoverAction *action) {
    }];
    PopoverAction *action1 = [PopoverAction actionWithTitle:@"面积：8888万平方公里" handler:^(PopoverAction *action) {
    }];
    PopoverAction *action2 = [PopoverAction actionWithTitle:@"人口：8亿" handler:^(PopoverAction *action) {
    }];
    PopoverAction *action3 = [PopoverAction actionWithTitle:@"GDP：88888万亿" handler:^(PopoverAction *action) {
    }];
    [popoverView showToPoint:point withActions:@[action,action1, action2, action3]];
    
}

/**
 * 随机颜色
 */
- (UIColor*)randomColor{
    CGFloat hue = (arc4random() %256/256.0);
    CGFloat saturation = (arc4random() %128/256.0) +0.5;
    CGFloat brightness = (arc4random() %128/256.0) +0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

- (NSMutableArray *)selectedLayerArray{
    if (_selectedLayerArray == nil) {
        _selectedLayerArray = [NSMutableArray array];
    }
    return _selectedLayerArray;
}

@end
