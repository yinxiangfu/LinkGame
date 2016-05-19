//
//  GameView.h
//  LinkGame
//
//  Created by biznest on 15/5/28.
//  Copyright (c) 2015年 biznest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinkPoint.h"
#import "GameService.h"

@interface GameView : UIView

@property (nonatomic, strong) GameService *gameServiece;
@property (nonatomic, strong) LinkPoint *linkPoint;
@property (nonatomic, strong) Piece *selectPiece;
@property (nonatomic, copy) void(^checkWin)(GameView *gameView);
- (void)startGame;
- (void)endGame;
@end
