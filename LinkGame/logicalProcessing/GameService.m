//
//  GameService.m
//  LinkGame
//
//  Created by biznest on 15/5/28.
//  Copyright (c) 2015年 biznest. All rights reserved.
//

#import "GameService.h"
#import "RectModel.h"

@implementation GameService

- (void)start
{
    RectModel *rectModel = [[RectModel alloc] init];
    self.pieces = [rectModel creat];
}

- (BOOL)hasPieces
{
    for (int i = 0; i < self.pieces.count; i ++) {
        for (int j = 0; j < [self.pieces[i] count]; j ++) {
            if ([self.pieces[i][j] isKindOfClass:[Piece class]]) {
                return YES;
            }
        }
    }
    return NO;
}
- (Piece *)findPieceAtTouchX:(CGFloat)touchX touchY:(CGFloat)touchY
{
    CGFloat relativeX = touchX - BeginX;
    CGFloat relativeY = touchY - BeginY;
    if (relativeX < 0 || relativeY < 0) {
        return nil;
    }
    NSInteger indexX = [self getIndexWithRelative:relativeX size:ImageSize];
    NSInteger indexY = [self getIndexWithRelative:relativeY size:ImageSize];
    if (indexX < 0 || indexY <0) {
        return nil;
    }
    if (indexX >= Index_X || indexY >= Index_Y) {
        return nil;
    }
    return self.pieces[indexX][indexY];
}

- (LinkPoint *)linkWithbeginPiece:(Piece *)p1 endPiece:(Piece *)p2
{
    if (p1 == p2) {
        return nil;
    }
    if (![p1 isEqual:p2]) {
        return nil;
    }
    LinkPoint *linkPoints = [[LinkPoint alloc] init];
    CustomPoint *p1Center = [p1 getCenter];
    CustomPoint *p2Center = [p2 getCenter];
    
    //无转折点
    //横向
    if (p1.indexY == p2.indexY) {
        if ([self isXlinkWithP1:p1Center p2:p2Center pieceSize:ImageSize]) {
            return [[LinkPoint alloc] initWithP1:p1Center p2:p2Center];
        }
    }
    //纵向
    if (p1.indexX == p2.indexX) {
        if ([self isYlinkWithP1:p1Center p2:p2Center pieceSize:ImageSize]) {
            return [[LinkPoint alloc] initWithP1:p1Center p2:p2Center];
        }
    }
    
    //一个转折点
    CustomPoint *oneTurnPoint = [self isOneTurnPointWithP1:p1Center p2:p2Center];
    if (oneTurnPoint) {
        return [[LinkPoint alloc] initWithP1:p1Center p2:oneTurnPoint p3:p2Center];
    }
    
    // 该NSDictionaryp的key存放第一个转折点, value存放第二个转折点,
    // NSDictionary的count说明有多少种可以连的方式
    NSDictionary* turns = [self getLinkPointsFromPoint:p1Center
                                               toPoint:p2Center width:ImageSize height:ImageSize]; //④
    if (turns.count != 0)
    {
        return [self getShortcutFromPoint:p1Point toPoint:p2Point
                                    turns:turns distance:
                [self getDistanceFromPoint:p1Point toPoint:p2Point]];
    }


//    if (p1.indexY == p2.indexY) {
//        //同一行上
////        //能否直接连接
////        if ([self isXlinkWithP1:p1Center p2:p2Center pieceSize:ImageSize]) {
////            return [[LinkPoint alloc] initWithP1:p1Center p2:p2Center];
////        }
//        
//        //向下寻找
//        for (NSInteger i = p1Center.y + ImageSize; i <= (BeginY + Index_Y * ImageSize - ImageSize/2); i += ImageSize) {
//            CustomPoint *p1_x = [[CustomPoint alloc] initWithX:p1Center.x y:i];
//            CustomPoint *p2_x = [[CustomPoint alloc] initWithX:p2Center.x y:i];
//            if ([self hasPieceAtX:p1_x.x y:p1_x.y]) break;
//            NSLog(@"%d,%d,%d",[self isXlinkWithP1:p1_x p2:p2_x pieceSize:ImageSize],[self isYlinkWithP1:p2Center p2:p2_x pieceSize:ImageSize],[self hasPieceAtX:p2_x.x y:p2_x.y]);
//            if (![self isXlinkWithP1:p1_x p2:p2_x pieceSize:ImageSize] ||
//                ![self isYlinkWithP1:p2Center p2:p2_x pieceSize:ImageSize] ||
//                [self hasPieceAtX:p2_x.x y:p2_x.y]) continue;
//            [linkPoints.points addObject:p1Center];
//            [linkPoints.points addObject:p1_x];
//            [linkPoints.points addObject:p2_x];
//            [linkPoints.points addObject:p2Center];
//        }
//        //向上寻找
//        for (NSInteger i = p1Center.y - ImageSize; i >= BeginY + ImageSize/2; i += ImageSize) {
//            CustomPoint *p1_x = [[CustomPoint alloc] initWithX:p1Center.x y:i];
//            CustomPoint *p2_x = [[CustomPoint alloc] initWithX:p2Center.x y:i];
//            if ([self hasPieceAtX:p1_x.x y:p1_x.y]) break;
//            
//            if (![self isXlinkWithP1:p1_x p2:p2_x pieceSize:ImageSize] ||
//                ![self isYlinkWithP1:p2Center p2:p2_x pieceSize:ImageSize] ||
//                [self hasPieceAtX:p2_x.x y:p2_x.y]) continue;
//            
//            if (linkPoints.points.count == 0)   return [[LinkPoint alloc] initWithP1:p1Center p2:p1_x p3:p2_x p4:p2Center];
//            
//            CustomPoint *p1C = linkPoints.points[0];
//            CustomPoint *p1X = linkPoints.points[1];
//            CustomPoint *p2X = linkPoints.points[2];
//            CustomPoint *p2C = linkPoints.points[3];
//            NSInteger length1 = labs(p1C.y - p1X.y) + labs(p1X.x - p2X.x) + labs(p2X.y - p2C.y);
//            NSInteger length2 = labs(p1Center.y - p1_x.y) + labs(p1_x.x - p2_x.x) + labs(p2_x.y - p2Center.y);
//            
//            if (length1 <= length2)  return [[LinkPoint alloc] initWithP1:p1C p2:p1X p3:p2X p4:p2C];
//            
//            return [[LinkPoint alloc] initWithP1:p1Center p2:p1_x p3:p2_x p4:p2Center];
//        }
//    }else{
//        //不在同一行上
//        //横向寻找
//        LinkPoint *linkP1 = [self rightFindWithP1:p1Center p2:p2Center];
//        //纵向寻找
//        LinkPoint *linkP2 = [self downFindWithP1:p1Center p2:p2Center];
//        if (linkP1) {
//            if (linkP2) {
//                CustomPoint *p1_1 = linkP1.points[0];
//                CustomPoint *p1_2 = linkP1.points[1];
//                CustomPoint *p1_3 = linkP1.points[2];
//                CustomPoint *p1_4 = linkP1.points[3];
//                NSInteger length1 = labs(p1_1.x-p1_2.x) + labs(p1_2.y-p1_3.y) + labs(p1_3.x-p1_4.x);
//                
//                CustomPoint *p2_1 = linkP2.points[0];
//                CustomPoint *p2_2 = linkP2.points[1];
//                CustomPoint *p2_3 = linkP2.points[2];
//                CustomPoint *p2_4 = linkP2.points[3];
//                NSInteger length2 = labs(p2_1.y-p2_2.y) + labs(p2_2.x-p2_3.x) + labs(p2_3.y-p2_4.y);
//                
//                if (length1 <= length2) return linkP1;
//               
//                return linkP2;
//            }
//        }
//        return linkP1;
//    }
    
    return nil;
}

//横向开始寻找
- (LinkPoint *)rightFindWithP1:(CustomPoint *)p1 p2:(CustomPoint *)p2
{
    if (p1.x > p2.x) {
        return [self rightFindWithP1:p2 p2:p1];
    }
    
    //一个转折点
    CustomPoint *p = [[CustomPoint alloc] initWithX:p2.x y:p1.y];
//    if ([self isXlinkWithP1:p1 p2:p pieceSize:ImageSize] &&
//        ![self hasPieceAtX:p.x y:p.y] &&
//        [self isYlinkWithP1:p p2:p2 pieceSize:ImageSize]) {
//        return [[LinkPoint alloc] initWithP1:p1 p2:p p3:p2];
//    }
    //两个转折点
    for (NSInteger i = p1.x + ImageSize; i <= (BeginX + Index_X * ImageSize - ImageSize/2); i += ImageSize) {
        if (i == p.x) continue;
        CustomPoint *p1_p = [[CustomPoint alloc] initWithX:i y:p1.y];
        CustomPoint *p2_p = [[CustomPoint alloc] initWithX:i y:p2.y];
        //遇到阻碍则向右行不通
        if ([self hasPieceAtX:p1_p.x y:p1_p.y]) {
            break ;
        }
        if (![self hasPieceAtX:p2_p.x y:p2_p.y] &&
            [self isYlinkWithP1:p1_p p2:p2_p pieceSize:ImageSize] &&
            [self isXlinkWithP1:p2_p p2:p2 pieceSize:ImageSize]) {
            return [[LinkPoint alloc] initWithP1:p1 p2:p1_p p3:p2_p p4:p2];
        }
    }
    for (NSInteger i = p1.x - ImageSize; i >= BeginX + ImageSize/2; i -= ImageSize) {
        if (i == p.x) continue;
        CustomPoint *p1_p = [[CustomPoint alloc] initWithX:i y:p1.y];
        CustomPoint *p2_p = [[CustomPoint alloc] initWithX:i y:p2.y];
        //遇到阻碍则向右行不通
        if ([self hasPieceAtX:p1_p.x y:p1_p.y]) {
            return nil;
        }
        if (![self hasPieceAtX:p2_p.x y:p2_p.y] &&
            [self isYlinkWithP1:p1_p p2:p2_p pieceSize:ImageSize] &&
            [self isXlinkWithP1:p2_p p2:p2 pieceSize:ImageSize]) {
            return [[LinkPoint alloc] initWithP1:p1 p2:p1_p p3:p2_p p4:p2];
        }
        
    }

    return nil;
}

//纵向寻找
- (LinkPoint *)downFindWithP1:(CustomPoint *)p1 p2:(CustomPoint *)p2
{
    if (p1.y > p2.y) {
        return [self downFindWithP1:p2 p2:p1];
    }
    //一个转折点
    CustomPoint *p = [[CustomPoint alloc] initWithX:p1.x y:p2.y];
//    if ([self isYlinkWithP1:p1 p2:p pieceSize:ImageSize] &&
//        ![self hasPieceAtX:p.x y:p.y] &&
//        [self isXlinkWithP1:p p2:p2 pieceSize:ImageSize]) {
//        return [[LinkPoint alloc] initWithP1:p1 p2:p p3:p2];
//    }
        //两个转折点
    for (NSInteger i = p1.y + ImageSize; i <= (BeginY + Index_Y * ImageSize - ImageSize/2); i += ImageSize) {
        if (i == p.y) continue;
        CustomPoint *p1_p = [[CustomPoint alloc] initWithX:p1.x y:i];
        CustomPoint *p2_p = [[CustomPoint alloc] initWithX:p2.x y:i];
        //遇到阻碍则向右行不通
        if ([self hasPieceAtX:p1_p.x y:p1_p.y]) {
            break ;
        }
        if (![self hasPieceAtX:p2_p.x y:p2_p.y] &&
            [self isYlinkWithP1:p1_p p2:p2_p pieceSize:ImageSize] &&
            [self isXlinkWithP1:p2_p p2:p2 pieceSize:ImageSize]) {
            return [[LinkPoint alloc] initWithP1:p1 p2:p1_p p3:p2_p p4:p2];
        }
    }
    for (NSInteger i = p1.y - ImageSize; i >= BeginY + ImageSize/2; i -= ImageSize ) {
        if (i == p.y) continue;
        CustomPoint *p1_p = [[CustomPoint alloc] initWithX:p1.x y:i];
        CustomPoint *p2_p = [[CustomPoint alloc] initWithX:p2.x y:i];
        //遇到阻碍则向右行不通
        if ([self hasPieceAtX:p1_p.x y:p1_p.y]) {
            return nil;
        }
        if (![self hasPieceAtX:p2_p.x y:p2_p.y] &&
            [self isYlinkWithP1:p1_p p2:p2_p pieceSize:ImageSize] &&
            [self isXlinkWithP1:p2_p p2:p2 pieceSize:ImageSize]) {
            return [[LinkPoint alloc] initWithP1:p1 p2:p1_p p3:p2_p p4:p2];
        }
    }
    
    return nil;
}

//私有工具方法
//获得触碰点piece的数组下标
- (NSInteger)getIndexWithRelative:(NSInteger)relative size:(NSInteger)size
{
    NSInteger index;
    if (relative % size == 0) {
        index = relative / size - 1;

    }else{
        index = relative / size;
    }
    return index;
}

//触碰点是否有方块
- (BOOL)hasPieceAtX:(NSInteger)x y:(NSInteger)y
{
    return [[self findPieceAtTouchX:x touchY:y] isKindOfClass:[Piece class]];
}

//是否能连接
//横向连接y相等
- (BOOL)isXlinkWithP1:(CustomPoint *)p1 p2:(CustomPoint *)p2 pieceSize:(NSInteger)pieceSize
{
    if (p2.x < p1.x) {
        return [self isXlinkWithP1:p2 p2:p1 pieceSize:pieceSize];
    }
    for (NSInteger i = p1.x + pieceSize; i < p2.x; i += pieceSize) {
        if ([self hasPieceAtX:i y:p1.y]) {
            return NO;
        }
    }
    return YES;
}
//纵向连接X相等
- (BOOL)isYlinkWithP1:(CustomPoint *)p1 p2:(CustomPoint *)p2 pieceSize:(NSInteger)pieceSize
{
    if (p2.y < p1.y) {
        return [self isYlinkWithP1:p2 p2:p1 pieceSize:pieceSize];
    }
    for (NSInteger i = p1.y + pieceSize; i < p2.y; i += pieceSize) {
        if ([self hasPieceAtX:p1.x y:i]) {
            return NO;
        }
    }
    return YES;
}
//一个转折点连接
- (CustomPoint *)isOneTurnPointWithP1:(CustomPoint *)p1 p2:(CustomPoint *)p2
{
    if (p1.x > p2.x) {
        return [self isOneTurnPointWithP1:p2 p2:p1];
    }
    
    //横向转折点
    CustomPoint *xTurnPoint = [[CustomPoint alloc] initWithX:p2.x y:p1.y];
    if ([self isXlinkWithP1:p1 p2:xTurnPoint pieceSize:ImageSize]) {
        if (![self hasPieceAtX:xTurnPoint.x y:xTurnPoint.y]) {
            if ([self isYlinkWithP1:xTurnPoint p2:p2 pieceSize:ImageSize]) {
                return xTurnPoint;
            }
        }
    }
    //纵向转折点
    CustomPoint *yTurnPoint = [[CustomPoint alloc] initWithX:p1.x y:p2.y];
    if ([self isYlinkWithP1:p1 p2:yTurnPoint pieceSize:ImageSize]) {
        if (![self hasPieceAtX:yTurnPoint.x y:yTurnPoint.y]) {
            if ([self isXlinkWithP1:yTurnPoint p2:p2 pieceSize:ImageSize]) {
                return yTurnPoint;
            }
        }
    }
    
    return nil;
}

#pragma mark =========================两个转折点算法==============================

/**
 * 获取两个转折点的情况
 * @return NSDictionary对象的每个key-value对代表一种连接方式，
 * 其中key、value分别代表第1个、第2个连接点
 */
- (NSDictionary*) getLinkPointsFromPoint:(CustomPoint *) point1
                                 toPoint:(CustomPoint *) point2 width:(NSInteger)pieceWidth
                                  height:(NSInteger)pieceHeight
{
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    // 获取以point1为中心的向上, 向右, 向下的通道
    NSArray* p1UpChanel = [self getUpChanelFromPoint:point1
                                                 min:point2.y height:pieceHeight];
    NSArray* p1RightChanel = [self getRightChanelFromPoint:point1
                                                       max:point2.x width:pieceWidth];
    NSArray* p1DownChanel = [self getDownChanelFromPoint:point1
                                                     max:point2.y height:pieceHeight];
    // 获取以point2为中心的向下, 向左, 向上的通道
    NSArray* p2DownChanel = [self getDownChanelFromPoint:point2
                                                     max:point1.y height:pieceHeight];
    NSArray* p2LeftChanel = [self getLeftChanelFromPoint:point2
                                                     min:point1.x width:pieceWidth];
    NSArray* p2UpChanel = [self getUpChanelFromPoint:point2
                                                 min:point1.y height:pieceHeight];
    // 获取FKBaseBoard的最大高度
    NSInteger heightMax = (Index_Y + 1) * pieceHeight + BeginY;
    // 获取FKBaseBoard的最大宽度
    NSInteger widthMax = (Index_X + 1) * pieceWidth + BeginX;
    // 先确定两个点的关系, point2在point1的左上角或者左下角
    if (point1.x > point2.x)
    {
        // 参数换位, 调用本方法
        return [self getLinkPointsFromPoint:point2 toPoint:point1
                                      width:pieceWidth height:pieceWidth];
    }
    // p1、p2位于同一行不能直接相连
    if (point1.y == point2.y)
    {
        // 在同一行,向上遍历
        // 以point1的中心点向上遍历获取点集合
        p1UpChanel = [self getUpChanelFromPoint:point1
                                            min:0 height:pieceHeight];
        // 以point2的中心点向上遍历获取点集合
        p2UpChanel = [self getUpChanelFromPoint:point2
                                            min:0 height:pieceHeight];
        NSDictionary* upLinkPoints = [self getXLinkPoints:p1UpChanel
                                                 p2Chanel:p2UpChanel pieceWidth:pieceHeight];
        // 向下遍历,不超过Board(有方块的地方)的边框
        // 以p1中心点向下遍历获取点集合
        p1DownChanel = [self getDownChanelFromPoint:point1
                                                max:heightMax height:pieceHeight];
        // 以p2中心点向下遍历获取点集合
        p2DownChanel = [self getDownChanelFromPoint:point2
                                                max:heightMax height:pieceHeight];
        NSDictionary* downLinkPoints = [self getXLinkPoints:p1DownChanel
                                                   p2Chanel:p2DownChanel pieceWidth:pieceHeight];
        [result addEntriesFromDictionary:upLinkPoints];
        [result addEntriesFromDictionary:downLinkPoints];
    }
    // p1、p2位于同一列不能直接相连
    if (point1.x == point2.x)
    {
        // 在同一列, 向左遍历
        // 以p1的中心点向左遍历获取点集合
        NSArray* p1LeftChanel = [self getLeftChanelFromPoint:point1
                                                         min:0 width:pieceWidth];
        // 以p2的中心点向左遍历获取点集合
        p2LeftChanel = [self getLeftChanelFromPoint:point2
                                                min:0 width:pieceWidth];
        NSDictionary* leftLinkPoints = [self getYLinkPoints:p1LeftChanel
                                                   p2Chanel:p2LeftChanel pieceHeight:pieceWidth];
        // 向右遍历, 不得超过Board的边框（有方块的地方）
        // 以p1的中心点向右遍历获取点集合
        p1RightChanel = [self getRightChanelFromPoint:point1
                                                  max:widthMax width:pieceWidth];
        // 以p2的中心点向右遍历获取点集合
        NSArray* p2RightChanel = [self getRightChanelFromPoint:point2
                                                           max:widthMax width:pieceWidth];
        NSDictionary* rightLinkPoints = [self getYLinkPoints:p1RightChanel
                                                    p2Chanel:p2RightChanel pieceHeight:pieceWidth];
        [result addEntriesFromDictionary:leftLinkPoints];
        [result addEntriesFromDictionary:rightLinkPoints];
    }
    // point2位于point1的右上角
    if ([self isRightUpP1:point1 p2:point2])
    {
        // 获取point1向上遍历, point2向下遍历时横向可以连接的点
        NSDictionary* upDownLinkPoints = [self getXLinkPoints:p1UpChanel
                                                     p2Chanel:p2DownChanel pieceWidth:pieceWidth];
        // 获取point1向右遍历, point2向左遍历时纵向可以连接的点
        NSDictionary* rightLeftLinkPoints = [self getYLinkPoints:p1RightChanel
                                                        p2Chanel:p2LeftChanel pieceHeight:pieceHeight];
        // 获取以p1为中心的向上通道
        p1UpChanel = [self getUpChanelFromPoint:point1
                                            min:0 height:pieceHeight];
        // 获取以p2为中心的向上通道
        p2UpChanel = [self getUpChanelFromPoint:point2
                                            min:0 height:pieceHeight];
        // 获取point1向上遍历, point2向上遍历时横向可以连接的点
        NSDictionary* upUpLinkPoints = [self getXLinkPoints:p1UpChanel
                                                   p2Chanel:p2UpChanel pieceWidth:pieceWidth];
        // 获取以p1为中心的向下通道
        p1DownChanel = [self getDownChanelFromPoint:point1
                                                max:heightMax height:pieceHeight];
        // 获取以p2为中心的向下通道
        p2DownChanel = [self getDownChanelFromPoint:point2
                                                max:heightMax height:pieceHeight];
        // 获取point1向下遍历, point2向下遍历时横向可以连接的点
        NSDictionary* downDownLinkPoints = [self getXLinkPoints:p1DownChanel
                                                       p2Chanel:p2DownChanel pieceWidth:pieceWidth];
        // 获取以p1为中心的向右通道
        p1RightChanel = [self getRightChanelFromPoint:point1
                                                  max:widthMax width:pieceWidth];
        // 获取以p2为中心的向右通道
        NSArray* p2RightChanel = [self getRightChanelFromPoint:point2
                                                           max:widthMax width:pieceWidth];
        // 获取point1向右遍历, point2向右遍历时纵向可以连接的点
        NSDictionary* rightRightLinkPoints = [self getYLinkPoints:p1RightChanel
                                                         p2Chanel:p2RightChanel pieceHeight:pieceHeight];
        // 获取以p1为中心的向左通道
        NSArray* p1LeftChanel = [self getLeftChanelFromPoint:point1
                                                         min:0 width:pieceWidth];
        // 获取以p2为中心的向左通道
        p2LeftChanel = [self getLeftChanelFromPoint:point2
                                                min:0 width:pieceWidth];
        // 获取point1向左遍历, point2向右遍历时纵向可以连接的点
        NSDictionary* leftLeftLinkPoints = [self getYLinkPoints:p1LeftChanel
                                                       p2Chanel:p2LeftChanel pieceHeight:pieceHeight];
        [result addEntriesFromDictionary:upDownLinkPoints];
        [result addEntriesFromDictionary:rightLeftLinkPoints];
        [result addEntriesFromDictionary:upUpLinkPoints];
        [result addEntriesFromDictionary:downDownLinkPoints];
        [result addEntriesFromDictionary:rightRightLinkPoints];
        [result addEntriesFromDictionary:leftLeftLinkPoints];
    }
    // point2位于point1的右下角
    if ([self isRightDownP1:point1 p2:point2])
    {
        // 获取point1向下遍历, point2向上遍历时横向可连接的点
        NSDictionary* downUpLinkPoints = [self getXLinkPoints:p1DownChanel
                                                     p2Chanel:p2UpChanel pieceWidth:pieceWidth];
        // 获取point1向右遍历, point2向左遍历时纵向可连接的点
        NSDictionary* rightLeftLinkPoints = [self getYLinkPoints:p1RightChanel
                                                        p2Chanel:p2LeftChanel pieceHeight:pieceHeight];
        // 获取以p1为中心的向上通道
        p1UpChanel = [self getUpChanelFromPoint:point1
                                            min:0 height:pieceHeight];
        // 获取以p2为中心的向上通道
        p2UpChanel = [self getUpChanelFromPoint:point2
                                            min:0 height:pieceHeight];
        // 获取point1向上遍历, point2向上遍历时横向可连接的点
        NSDictionary* upUpLinkPoints = [self getXLinkPoints:p1UpChanel
                                                   p2Chanel:p2UpChanel pieceWidth:pieceWidth];
        // 获取以p1为中心的向下通道
        p1DownChanel = [self getDownChanelFromPoint:point1
                                                max:heightMax height:pieceHeight];
        // 获取以p2为中心的向下通道
        p2DownChanel = [self getDownChanelFromPoint:point2
                                                max:heightMax height:pieceHeight];
        // 获取point1向下遍历, point2向下遍历时横向可连接的点
        NSDictionary* downDownLinkPoints = [self getXLinkPoints:p1DownChanel
                                                       p2Chanel:p2DownChanel pieceWidth:pieceWidth];
        // 获取以p1为中心的向左通道
        NSArray* p1LeftChanel = [self getLeftChanelFromPoint:point1
                                                         min:0 width:pieceWidth];
        // 获取以p2为中心的向左通道
        p2LeftChanel = [self getLeftChanelFromPoint:point2
                                                min:0 width:pieceWidth];
        // 获取point1向左遍历, point2向左遍历时纵向可连接的点
        NSDictionary* leftLeftLinkPoints = [self getYLinkPoints:p1LeftChanel
                                                       p2Chanel:p2LeftChanel pieceHeight:pieceHeight];
        // 获取以p1为中心的向右通道
        p1RightChanel = [self getRightChanelFromPoint:point1
                                                  max:widthMax width:pieceWidth];
        // 获取以p2为中心的向右通道
        NSArray* p2RightChanel = [self getRightChanelFromPoint:point2
                                                           max:widthMax width:pieceWidth];
        // 获取point1向右遍历, point2向右遍历时纵向可以连接的点
        NSDictionary* rightRightLinkPoints = [self getYLinkPoints:p1RightChanel
                                                         p2Chanel:p2RightChanel pieceHeight:pieceHeight];
        [result addEntriesFromDictionary:downUpLinkPoints];
        [result addEntriesFromDictionary:rightLeftLinkPoints];
        [result addEntriesFromDictionary:upUpLinkPoints];
        [result addEntriesFromDictionary:downDownLinkPoints];
        [result addEntriesFromDictionary:leftLeftLinkPoints];
        [result addEntriesFromDictionary:rightRightLinkPoints];
    }
    return result;
}

/**
 * 遍历两个集合, 先判断第一个集合的元素的y坐标与另一个集合中的元素y坐标相同(横向),
 * 如果相同, 即在同一行, 再判断是否有障碍, 没有则加到NSMutableDictionary中去
 * @return 存放可以横向直线连接的连接点的键值对
 */
- (NSDictionary*) getXLinkPoints:(NSArray*) p1Chanel
                        p2Chanel:(NSArray*) p2Chanel pieceWidth:(NSInteger) pieceWidth
{
    NSMutableDictionary* result = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < p1Chanel.count; i++)
    {
        // 从第一通道中取一个点
        FKPoint* temp1 = [p1Chanel objectAtIndex:i];
        // 再遍历第二个通道, 看下第二通道中是否有点可以与temp1横向相连
        for (int j = 0; j < p2Chanel.count; j++)
        {
            FKPoint* temp2 = [p2Chanel objectAtIndex:j];
            // 如果y坐标相同(在同一行), 再判断它们之间是否有直接障碍
            if (temp1.y == temp2.y)
            {
                if (![self isXBlockFromP1:temp1 toP2:temp2 pieceWidth:pieceWidth])
                {
                    // 没有障碍则加到结果的NSMutableDictionary中
                    [result setObject:temp2 forKey:temp1];
                }
            }
        }
    }
    return [result copy];
}

/**
 * 返回指定FKPoint对象的左边通道
 * @param p 给定的FKPoint参数
 * @param pieceWidth piece图片的宽
 * @param min 向左遍历时最小的界限
 * @return 给定Point左边的通道
 */
- (NSArray*) getLeftChanelFromPoint:(CustomPoint*)p min:(NSInteger)min
                              width:(NSInteger)pieceWidth
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    // 获取向左通道, 由一个点向左遍历, 步长为FKPiece图片的宽
    for (int i = p.x - pieceWidth; i >= min
         ; i = i - pieceWidth)
    {
        // 遇到障碍, 表示通道已经到尽头, 直接返回
        if ([self hasPieceAtX:i y:p.y])
        {
            return result;
        }
        [result addObject:[[CustomPoint alloc] initWithX:i y:p.y]];
    }
    return result;
}

/**
 * 返回指定FKPoint对象的右边通道
 * @param p 给定的FKPoint参数
 * @param pieceWidth
 * @param max 向右时的最右界限
 * @return 给定Point右边的通道
 */
- (NSArray*) getRightChanelFromPoint:(CustomPoint*)p max:(NSInteger)max
                               width:(NSInteger)pieceWidth
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    // 获取向右通道, 由一个点向右遍历, 步长为FKPiece图片的宽
    for (int i = p.x + pieceWidth; i <= max
         ; i = i + pieceWidth)
    {
        // 遇到障碍, 表示通道已经到尽头, 直接返回
        if ([self hasPieceAtX:i y:p.y])
        {
            return result;
        }
        [result addObject:[[CustomPoint alloc] initWithX:i y:p.y]];
    }
    return result;
}

/**
 * 返回指定FKPoint对象的上边通道
 * @param p 给定的FKPoint参数
 * @param min 向上遍历时最小的界限
 * @param pieceHeight
 * @return 给定Point上面的通道
 */
- (NSArray*) getUpChanelFromPoint:(CustomPoint*)p min:(NSInteger)min
                           height:(NSInteger)pieceHeight
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    // 获取向上通道, 由一个点向上遍历, 步长为FKPiece图片的高
    for (int i = p.y - pieceHeight; i >= min
         ; i = i - pieceHeight)
    {
        // 遇到障碍, 表示通道已经到尽头, 直接返回
        if ([self hasPieceAtX:p.x y:i])
        {
            // 如果遇到障碍, 直接返回
            return result;
        }
        [result addObject:[[CustomPoint alloc] initWithX:p.x y:i]];
    }
    return result;
}
/**
 * 返回指定FKPoint对象的下边通道
 * @param p 给定的FKPoint参数
 * @param max 向上遍历时的最大界限
 * @return 给定Point下面的通道
 */
- (NSArray*) getDownChanelFromPoint:(CustomPoint*)p max:(NSInteger)max
                             height:(NSInteger)pieceHeight
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    // 获取向下通道, 由一个点向下遍历, 步长为FKPiece图片的高
    for (int i = p.y + pieceHeight; i <= max
         ; i = i + pieceHeight)
    {
        // 遇到障碍, 表示通道已经到尽头, 直接返回
        if ([self hasPieceAtX:p.x y:i])
        {
            // 如果遇到障碍, 直接返回
            return result;
        }
        [result addObject:[[CustomPoint alloc] initWithX:p.x y:i]];
    }
    return result;
}

@end
