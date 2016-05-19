//
//  CustomPoint.m
//  LinkGame
//
//  Created by biznest on 15/5/28.
//  Copyright (c) 2015年 biznest. All rights reserved.
//

#import "CustomPoint.h"

@implementation CustomPoint
- (id)initWithX:(NSInteger)x y:(NSInteger)y
{
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
    }
    return self;
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"x=%ld,y=%ld",_x,_y];
}
@end
