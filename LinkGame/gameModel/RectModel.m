//
//  RectModel.m
//  LinkGame
//
//  Created by biznest on 15/5/29.
//  Copyright (c) 2015年 biznest. All rights reserved.
//

#import "RectModel.h"

@implementation RectModel

//矩形排列
- (NSArray *)creatPieces:(NSArray *)pieces
{
    NSMutableArray *notNullPieces = [NSMutableArray array];
    for (int i = 1; i < pieces.count - 1; i ++) {
        for (int j = 1; j < [pieces[i] count] - 1; j ++) {
            Piece *piece = [[Piece alloc] initWithIndexX:i indexY:j];
            [notNullPieces addObject:piece];
        }
    }
    return notNullPieces;
}

@end
