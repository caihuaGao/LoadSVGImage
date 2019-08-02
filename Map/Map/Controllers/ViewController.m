//
//  ViewController.m
//  Map
//
//  Created by gaocaihua on 2019/3/11.
//  Copyright © 2019 高才华. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Frame.h"
#import "CHMapModel.h"
#import "CHMapView.h"
#import "CHPolygonLayer.h"

@interface ViewController ()<CHMapViewDelegate>

@property (nonatomic,strong) CHMapView *mapView;
@property (nonatomic,strong) UIButton *backBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建地图
    CHMapModel *mapModel =  [CHMapModel mapWithName:@"world.svg"];
    _mapView = [CHMapView mapWithMapModel:mapModel];
    _mapView.mapDelegate = self;
    _mapView.frame = self.view.frame;
    [self.view addSubview:_mapView];
    
    //添加按钮
    _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-60, 40, 50, 25)];
    [_backBtn setTitle:@"Back" forState:UIControlStateNormal];
    _backBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _backBtn.hidden = YES;
    [_backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self.view addSubview:_backBtn];
    [self.view bringSubviewToFront:_backBtn];
    
}

#pragma mark ---------  MapDelegate  -----------
- (void)chmapView:(CHMapView *)mapView didClickRegion:(NSString *)name{
    if ([name isEqualToString:@"China"]) {
        //清除图层
        [self clearLayer];
        
        //中国地图
        CHMapModel *mapModel = [CHMapModel mapWithName:@"cn-all.svg"];
        [_mapView setMapData:mapModel];
        
        _backBtn.hidden = NO;
    }
}

//返回世界地图
- (void)back:(UIButton*)btn{
    _backBtn.hidden = YES;
    [self createWorldMap];
}

//切换世界地图数据
- (void)createWorldMap{
    [self clearLayer];
    CHMapModel *mapModel = [CHMapModel mapWithName:@"world.svg"];
    [_mapView setMapData:mapModel];
}

//清除自定义的图层
- (void)clearLayer{
    
    //删除mapView上添加的layer
    NSArray<CALayer *> *subLayers = _mapView.layer.sublayers;
    NSArray<CALayer *> *removedLayers = [subLayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject isKindOfClass:[CHPolygonLayer class]];
    }]];
    [removedLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    
    //清除添加在数组中的图层
    [_mapView.layers removeAllObjects];
    
}

@end
