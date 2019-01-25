//
//  Level.m
//  CrazyPlanes_cc2
//
//  Created by Mark Wong on 12/12/12.
//  Copyright 2012 Mark Wong. All rights reserved.
//

#import "LevelXPHelper.h"

#define BASE_XP 1000

@implementation LevelXPHelper

+ (int) WallXP {
    return 300;
}

+ (int) nextLevel:(int)playerLevel {
    return [self prevLevelXP:playerLevel] + (playerLevel * 1000);
}

+ (int) currLevel:(int)playerLevel {
    return [self prevLevelXP:playerLevel] + 1;
}

+ (int) prevLevelXP:(int)playerLevel {
    //for loop
    int prevXP = 0;
    for (int i = 1; i <= playerLevel; i++) {
        prevXP = prevXP + (i - 1) * BASE_XP;
    }
    return prevXP;
}

@end
