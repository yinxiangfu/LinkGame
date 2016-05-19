//
//  ImageTool.m
//  LinkGame
//
//  Created by biznest on 15/5/28.
//  Copyright (c) 2015年 biznest. All rights reserved.
//

#import "ImageTool.h"

@implementation ImageTool

+ (NSArray *)getImageValuesForSource
{
    NSMutableArray *resourceValues = [NSMutableArray array];
    NSArray *paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:nil];
    for (NSString *path in paths) {
        NSString *imageName = [path lastPathComponent];
        if ([imageName hasPrefix:@"kit_"]) {
            [resourceValues addObject:imageName];
        }
    }
    return [NSArray arrayWithArray:resourceValues];
}

+ (NSMutableArray *)getRandomValuesWithSourceValues:(NSArray *)sourceValues size:(NSInteger)size
{
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < size; i ++) {
        int index = arc4random() % sourceValues.count;
        NSString *imageName = sourceValues[index];
        [result addObject:imageName];
    }
    return result;
}

+ (NSArray *)getPlayValuesWithSize:(NSInteger)size
{
    if (size % 2 != 0) {
        size += 1;
    }
    NSMutableArray *playImageValues = [self getRandomValuesWithSourceValues:[self getImageValuesForSource] size:size/2];
    [playImageValues addObjectsFromArray:playImageValues];
    //打乱
    NSInteger i = playImageValues.count;
    while (--i > 0) {
        NSInteger j = arc4random() % (i + 1);
        [playImageValues exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    return [playImageValues copy];
}

+ (NSArray *)getPieceImagesWithSize:(NSInteger)size
{
    NSArray *imageNames = [self getPlayValuesWithSize:size];
    NSMutableArray *pieceImages = [NSMutableArray array];
    for (NSString *imageName in imageNames) {
        UIImage *image = [UIImage imageNamed:imageName];
        PieceImage *pieceImage = [[PieceImage alloc] initWithImage:image imageID:imageName];
        [pieceImages addObject:pieceImage];
    }
    return pieceImages;
}

@end
