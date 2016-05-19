//
//  ViewController.m
//  LinkGame
//
//  Created by biznest on 15/5/28.
//  Copyright (c) 2015年 biznest. All rights reserved.
//

#import "ViewController.h"
#import "GameView.h"

@interface ViewController () <UIAlertViewDelegate>
{
    GameView *_gameView;
    NSInteger _remainTime;
    NSTimer *_timer;
    BOOL _isPlaying;
    UIAlertView *_lostAlter;
    UIAlertView *_winAlter;
}
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *remainTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *startGameBt;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImage"]];
    self.view.backgroundColor = bgColor;
    
    _lostAlter = [[UIAlertView alloc] initWithTitle:@"失败!" message:@"游戏失败!重新开始?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    _winAlter = [[UIAlertView alloc] initWithTitle:@"胜利!" message:@"游戏胜利!重新开始?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    _gameView= [[GameView alloc] initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEIGHT - self.bottomView.frame.size.height)];

    _gameView.gameServiece = [[GameService alloc] init];
    _gameView.backgroundColor = [UIColor clearColor];
    
    __block typeof(self) weakSelf = self;
    _gameView.checkWin = ^(GameView *gameView){
        if (![gameView.gameServiece hasPieces]) {
            [weakSelf->_winAlter show];
            if ([weakSelf->_timer isValid]) {
                [weakSelf->_timer invalidate];
                weakSelf->_timer = nil;
            }
        }
    };
 
    [self.view addSubview:_gameView];
}
- (IBAction)startGame:(UIButton *)sender {
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    _remainTime = GAME_TIME;
    self.remainTimeLabel.text = [NSString stringWithFormat:@"%ld",(long)_remainTime];
    [_gameView startGame];
    _isPlaying = YES;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshView) userInfo:nil repeats:YES];
    _gameView.selectPiece = nil;
}

- (void)refreshView
{
    _remainTime --;
    self.remainTimeLabel.text = [NSString stringWithFormat:@"%ld",(long)_remainTime];
    if (_remainTime <= 0) {
        _isPlaying = NO;
        [_lostAlter show];
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self startGame:self.startGameBt];
    }else{
        [_gameView endGame];
    }
}


@end
