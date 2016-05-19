//
//  Piece.m
//  LinkGame
//
//  Created by biznest on 15/5/28.
//  Copyright (c) 2015年 biznest. All rights reserved.
//

#import "Piece.h"

@implementation Piece

- (id)initWithIndexX:(NSInteger)indexX indexY:(NSInteger)indexY
{
    self = [super init];
    if (self) {
        _indexX = indexX;
        _indexY = indexY;
    }
    return self;
}
- (CustomPoint *)getCenter
{
    return [[CustomPoint alloc] initWithX:self.pieceImage.image.size.width/2+self.x y:self.pieceImage.image.size.height/2+self.y];
}
- (BOOL)isEqual:(Piece *)piece
{
    return self.pieceImage.imageID == piece.pieceImage.imageID;
}

@end
