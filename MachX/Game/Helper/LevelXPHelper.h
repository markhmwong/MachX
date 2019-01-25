//
//  Level.h
//  CrazyPlanes_cc2
//
//  Created by Mark Wong on 12/12/12.
//  Copyright 2012 Mark Wong. All rights reserved.
//

@interface LevelXPHelper : NSObject {
    
}

+ (int) WallXP;
+ (int) nextLevel:(int)playerLevel;
+ (int) currLevel:(int)playerLevel;
+ (int) prevLevelXP:(int)playerLevel;
@end
