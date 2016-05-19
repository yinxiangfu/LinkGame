//
//  PieceImage.m
//  LinkGame
//
//  Created by biznest on 15/5/28.
//  Copyright (c) 2015年 biznest. All rights reserved.
//

#import "PieceImage.h"

@implementation PieceImage
- (id)initWithImage:(UIImage *)image imageID:(NSString *)imageID
{
    self = [super init];
    if (self) {
        _image = image;
        _imageID = imageID;
    }
    return self;
}
@end
