//
//  XPManager.h
//  MachX
//
//  Created by Mark Wong on 26/12/12.
//  Copyright 2012 Whizbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "LevelXPHelper.h"

@interface XPManager : NSObject {
    int _playerXP;
    int _wallXP;
    int _playerLevel;
    int _multiplier;
    int _multiplierCounter;
    int _totalGold;
}

@property (nonatomic, assign) int playerXP;
@property (nonatomic, assign) int wallXP;
@property (nonatomic, assign) int playerLevel;
@property (nonatomic, assign) int multiplier;
@property (nonatomic, assign) int totalGold;

+(id)sharedXPManager;

- (void) setupXP;
- (void) addXP:(int)xp;
- (void) incrementMultiplier;
- (void) incrementPlayerLevel;
- (void) resetMultiplier;

- (int) getWallXP;
- (int) getPlayerLevel;
- (int) getPlayerXP;
- (int) getTotalGold;

- (void) printPlayerXP;
- (void) printMultiplier;
- (void) printTotalGold;

- (void) setTotalGold:(int)amount;

@end
