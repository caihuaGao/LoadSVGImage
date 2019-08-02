//
//  CHMapView.h
//  Map
//
//  Created by gaocaihua on 2019/3/16.
//  Copyright © 2019 高才华. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHPolygonLayer;
@class CHMapModel;
@class CHMapView;

@protocol CHMapViewDelegate <NSObject>

- (void)chmapView:(CHMapView*)mapView didClickRegion:(NSString*)name;

@end


NS_ASSUME_NONNULL_BEGIN

@interface CHMapView : UIScrollView <UIScrollViewDelegate>

/**
 *  名称
 */
@property (nonatomic,copy) NSString *name;

/**
 *  图层  （便于管理自定义的图层）
 */
@property (nonatomic,strong) NSMutableArray <CHPolygonLayer*>*layers;

/**
 * 代理
 */
@property (nonatomic,weak) id<CHMapViewDelegate> mapDelegate;


+ (instancetype)mapWithMapModel:(CHMapModel*)model;
- (instancetype)initWithMapModel:(CHMapModel*)model;
- (void)setMapData:(CHMapModel*)model;

@end

NS_ASSUME_NONNULL_END
