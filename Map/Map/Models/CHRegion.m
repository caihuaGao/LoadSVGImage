//
//  CHRegion.m
//  Map
//
//  Created by gaocaihua on 2019/3/16.
//  Copyright © 2019 高才华. All rights reserved.
//

#import "CHRegion.h"

@implementation CHRegion

+ (instancetype)regionWithDictionary:(NSDictionary*)dict{
    return [[CHRegion alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        
        self.name = dict[@"desc"][@"name"];
        
        NSString *pathString = dict[@"_d"];//取出path
        
        [self createPath:pathString];
       
    }
    return self;

}


- (void)createPath:(NSString*)string{
    
    NSArray *pathArr1 = [string componentsSeparatedByString:@"Z"];
    NSMutableArray *pathArray = [NSMutableArray array];
    for (NSString *strPoint in pathArr1) {
        NSArray *pathArr2 = [strPoint componentsSeparatedByString:@" "];
        NSMutableArray *pointArray = [NSMutableArray array];
        for (NSString *str in pathArr2) {
            if (![str isEqualToString:@""]) {
                CHPoint *point = [CHPoint pointWithSting:str];
                [pointArray addObject:point];
            }
        }
        // 避免分割后产生的空数组
        if (pointArray.count >0) {
            [pathArray addObject:pointArray];
        }
    }
    self.pathArray = [pathArray copy];
}


@end
