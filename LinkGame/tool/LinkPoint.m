//
//  LinkPoint.m
//  LinkGame
//
//  Created by biznest on 15/5/28.
//  Copyright (c) 2015年 biznest. All rights reserved.
//

#import "LinkPoint.h"

@implementation LinkPoint
- (id)initWithP1:(CustomPoint *)p1 p2:(CustomPoint *)p2
{
    self = [super init];
    if (self) {
        _points = [NSMutableArray arrayWithObjects:p1, p2, nil];
    }
    return self;
}
- (id)initWithP1:(CustomPoint *)p1 p2:(CustomPoint *)p2 p3:(CustomPoint *)p3
{
    self = [super init];
    if (self) {
        _points = [NSMutableArray arrayWithObjects:p1, p2, p3, nil];
    }
    return self;
}
- (id)initWithP1:(CustomPoint *)p1 p2:(CustomPoint *)p2 p3:(CustomPoint *)p3 p4:(CustomPoint *)p4
{
    self = [super init];
    if (self) {
        _points = [NSMutableArray arrayWithObjects:p1, p2, p3, p4, nil];
    }
    return self;
}
@end
