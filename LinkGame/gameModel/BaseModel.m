//
//  BaseModel.m
//  LinkGame
//
//  Created by biznest on 15/5/28.
//  Copyright (c) 2015年 biznest. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

//基类重写
- (NSArray *)creatPieces:(NSArray *)pieces
{
    return nil;
}

- (NSArray *)creat
{
    NSMutableArray *pieces = [NSMutableArray array];
    for (int i = 0; i < Index_X; i ++) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int j = 0; j < Index_Y; j ++) {
            [arr addObject:[NSObject new]];
        }
        [pieces addObject:arr];
    }
    NSArray *notNullPieces = [self creatPieces:pieces];
    
    NSArray *pieceImages = [ImageTool getPieceImagesWithSize:notNullPieces.count];
//    int imageWidth = ImageSize;//[pieceImages[0] pieceImage].image.size.width;
//    int imageHeight = ImageSize;//[pieceImages[0] pieceImage].image.size.height;
    
    for (int i = 0; i < notNullPieces.count; i ++) {
        Piece *piece = notNullPieces[i];
        piece.pieceImage = pieceImages[i];
        piece.x = piece.indexX * ImageSize + BeginX;
        piece.y = piece.indexY * ImageSize +BeginY;
        [pieces[piece.indexX] setObject:piece atIndex:piece.indexY];
    }
    return pieces;
}

@end
