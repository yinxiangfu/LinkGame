//
//  PieceImage.h
//  LinkGame
//
//  Created by biznest on 15/5/28.
//  Copyright (c) 2015年 biznest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PieceImage : NSObject
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *imageID;
- (id)initWithImage:(UIImage *)image imageID:(NSString *)imageID;
@end
