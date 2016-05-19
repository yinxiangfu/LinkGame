//
//  CustomPoint.h
//  LinkGame
//
//  Created by biznest on 15/5/28.
//  Copyright (c) 2015年 biznest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomPoint : NSObject
@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
- (id)initWithX:(NSInteger)x y:(NSInteger)y;
@end
