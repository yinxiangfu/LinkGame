//
//  GameService.h
//  LinkGame
//
//  Created by biznest on 15/5/28.
//  Copyright (c) 2015年 biznest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameService : NSObject
@property (nonatomic, strong) NSArray *pieces;
- (void)start;
- (BOOL)hasPieces;
- (Piece *)findPieceAtTouchX:(CGFloat)touchX touchY:(CGFloat)touchY;
- (LinkPoint *)linkWithbeginPiece:(Piece *)beginPiece endPiece:(Piece *)endPiece;
@end
