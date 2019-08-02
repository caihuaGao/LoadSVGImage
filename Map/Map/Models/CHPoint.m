//
//  CHPoint.m
//  Map
//
//  Created by gaocaihua on 2019/3/14.
//  Copyright © 2019 高才华. All rights reserved.
//

#import "CHPoint.h"

@implementation CHPoint

+ (instancetype)pointWithSting:(NSString*)string{
    return [[CHPoint alloc] initWithSting:string];
}

- (instancetype)initWithSting:(NSString*)string{
    self = [super init];
    if (self) {
        
        NSArray *pathArr = [string componentsSeparatedByString:@","];
        if (pathArr.count>=2) {
            self.x = [pathArr[0] substringFromIndex:1];
            self.y = pathArr[1];
            self.point = CGPointMake([self.x floatValue], [self.y floatValue]);
        }
    }
    return self;
}


@end
