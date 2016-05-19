//
//  Piece.h
//  LinkGame
//
//  Created by biznest on 15/5/28.
//  Copyright (c) 2015年 biznest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PieceImage.h"
#import "CustomPoint.h"

@interface Piece : NSObject
@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, assign) NSInteger indexX;
@property (nonatomic, assign) NSInteger indexY;
@property (nonatomic, strong) PieceImage *pieceImage;
- (id)initWithIndexX:(NSInteger)indexX indexY:(NSInteger)indexY;
- (CustomPoint *)getCenter;
- (BOOL)isEqual:(Piece *)piece;
@end
