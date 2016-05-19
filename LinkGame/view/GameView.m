//
//  GameView.m
//  LinkGame
//
//  Created by biznest on 15/5/28.
//  Copyright (c) 2015年 biznest. All rights reserved.
//

#import "GameView.h"
#import <AVFoundation/AVFoundation.h>

@interface GameView ()
{
    UIImage *_selectImage;
    UIColor *_lineColor;
    SystemSoundID  _clickSound;
    SystemSoundID _linkSound;;
}
@end

@implementation GameView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectImage = [UIImage imageNamed:@"selected"];
        _lineColor = [UIColor purpleColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (self.gameServiece.pieces == nil) {
        return;
    }
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ref, _lineColor.CGColor);
    CGContextSetLineWidth(ref, 3);
    CGContextSetLineJoin(ref, kCGLineJoinRound);
    CGContextSetLineCap(ref, kCGLineCapRound);
    
    //将图片绘出
    NSArray *pieces = self.gameServiece.pieces;
    if (pieces != nil) {
        for (int i = 0; i < pieces.count; i ++) {
            for (int j = 0; j < [pieces[i] count]; j ++) {
                if ([pieces[i][j] isKindOfClass:[Piece class]]) {
                    Piece *piece = pieces[i][j];
                    [piece.pieceImage.image drawAtPoint:CGPointMake(piece.x, piece.y)];
                }
            }
        }
    }
    
    //绘制连线
    if (self.linkPoint != nil) {
        [self drawLine:self.linkPoint context:ref];
        self.linkPoint = nil;
        [self performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0.3];
    }
    
    //选中图片背景绘制
    if (self.selectPiece != nil) {
        [_selectImage drawAtPoint:CGPointMake(self.selectPiece.x, self.selectPiece.y)];
    }
}

- (void)drawLine:(LinkPoint *)linkPoint context:(CGContextRef)ref
{
    NSArray *pointsArr = linkPoint.points;
    CustomPoint *firstPoint = pointsArr[0];
    CGContextMoveToPoint(ref, firstPoint.x, firstPoint.y);
    for (int i = 1; i < pointsArr.count; i ++) {
        CustomPoint *nextPoint = pointsArr[i];
        CGContextAddLineToPoint(ref, nextPoint.x, nextPoint.y);
    }
    CGContextStrokePath(ref);
}

- (void)endGame
{
    self.userInteractionEnabled = NO;
}
- (void)startGame
{
    self.userInteractionEnabled = YES;
    [self.gameServiece start];
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSArray *pieces = self.gameServiece.pieces;
    CGPoint touchPoint = [touch locationInView:self];
    Piece *currentPiece = [self.gameServiece findPieceAtTouchX:touchPoint.x touchY:touchPoint.y];

    if (![currentPiece isKindOfClass:[Piece class]]) {
        return;
    }
    if (self.selectPiece == nil) {
        self.selectPiece = currentPiece;
        [self setNeedsDisplay];
    }else{
        LinkPoint *linkPint = [self.gameServiece linkWithbeginPiece:self.selectPiece endPiece:currentPiece];
        if (linkPint == nil) {
            self.selectPiece = currentPiece;
            [self setNeedsDisplay];
        }else{
            [pieces[self.selectPiece.indexX] setObject:[NSObject new] atIndex:self.selectPiece.indexY];
            [pieces[currentPiece.indexX] setObject:[NSObject new] atIndex:currentPiece.indexY];
            self.linkPoint = linkPint;
            self.selectPiece = nil;
            [self setNeedsDisplay];
            if (self.checkWin) {
                self.checkWin(self);
            }
        }
    }
}

@end
