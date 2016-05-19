//
//  LinkPoint.h
//  LinkGame
//
//  Created by biznest on 15/5/28.
//  Copyright (c) 2015年 biznest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinkPoint : NSObject
@property (nonatomic, strong) NSMutableArray *points;
- (id)initWithP1:(CustomPoint *)p1 p2:(CustomPoint *)p2;
- (id)initWithP1:(CustomPoint *)p1 p2:(CustomPoint *)p2 p3:(CustomPoint *)p3;
- (id)initWithP1:(CustomPoint *)p1 p2:(CustomPoint *)p2 p3:(CustomPoint *)p3 p4:(CustomPoint *)p4;
@end
