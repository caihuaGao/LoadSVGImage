//
//  CHMapModel.m
//  Map
//
//  Created by gaocaihua on 2019/3/16.
//  Copyright © 2019 高才华. All rights reserved.
//

#import "CHMapModel.h"
#import "XMLDictionary.h"

@implementation CHMapModel

+ (instancetype)mapWithName:(NSString*)name{
    return [[CHMapModel alloc] initWithName:name];
}
- (instancetype)initWithName:(NSString*)name{
    self = [super init];
    if (self) {
        
        self.name = name;
        
        //解析数据
        [self parserData:name];
        
    }
    return self;
}

- (void)parserData:(NSString*)name{
    
    NSString *svgPath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSData *svgData = [NSData dataWithContentsOfFile:svgPath];
    XMLDictionaryParser *parser=[[XMLDictionaryParser alloc]init];
    NSDictionary *dic=[parser dictionaryWithData:svgData];
    
    self.height = [dic[@"_height"] floatValue];
    self.width = [dic[@"_width"] floatValue];
    
    NSDictionary *dict = dic[@"g"];
    NSArray *pathArr = dict[@"path"];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict2 in pathArr) {
        CHRegion *region = [CHRegion regionWithDictionary:dict2];
        [array addObject:region];
    }
    
    self.regionArray = [array copy];
}
@end
