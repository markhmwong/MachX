//
//  XPManager.m
//  MachX
//
//  Created by Mark Wong on 26/12/12.
//  Copyright 2012 Whizbang. All rights reserved.
//

#import "XPManager.h"


@implementation XPManager

@synthesize playerXP = _playerXP;
@synthesize wallXP = _wallXP;
@synthesize multiplier = _multiplier;

+ (id)sharedXPManager {
    static id sharedXPManager = nil;
    
    if (sharedXPManager == nil) {
        sharedXPManager = [[self alloc] init];
    }
    
    return sharedXPManager;
}

/*
 +(MyClass *)singleton {
 static dispatch_once_t pred;
 static MyClass *shared = nil;
 
 dispatch_once(&pred, ^{
 shared = [[MyClass alloc] init];
 });
 return shared;
 }
*/


- (id) init
{
	if( (self=[super init]) ) {
        _playerXP = 0;
        //get player level from database
        _playerLevel = 1;
        _multiplier = 1;
    }
	return self;
}


- (void) setupXP {
    //Wall XP
    //[self wallXP];
}

- (int) getWallXP {
    _wallXP = 100 * _multiplier;
    return _wallXP;
}

- (void) addXP:(int)xp {
    _playerXP = _playerXP + xp;
}

- (int) getPlayerLevel {
    //get player Level from database
    //temporary test
    return _playerLevel;
}

- (void) incrementMultiplier {
    if (_multiplier < 20) {
        _multiplierCounter++;
        if (_multiplierCounter % 3 == 0) {
            _multiplier++;
        }
    }
}

- (void) resetMultiplier {
    _multiplier = 1;
    _multiplierCounter = 0;
}

- (void) incrementPlayerLevel {
    _playerLevel++;
}

- (int) getPlayerXP {
    return _playerXP;
}

- (int) getTotalGold {
    return _totalGold;
}

- (void) setTotalGold:(int) amount {
    _totalGold = _totalGold + amount;
}

- (void) printPlayerXP {
    NSLog(@"%d", _playerXP);
}

- (void) printMultiplier {
    NSLog(@"%d", _multiplier);
}

- (void) printTotalGold {
    NSLog(@"%d", _totalGold);
}

@end
