//
//  EnemyHelper.m
//  MachX
//
//  Created by Mark Wong on 23/01/13.
//  Copyright 2013 Whizbang. All rights reserved.
//

#import "EnemyHelper.h"


@implementation EnemyHelper

@synthesize spaceBetweenWalls = _spaceBetweenWalls;

+ (id)sharedXPManager {
    static id sharedXPManager = nil;
    
    if (sharedXPManager == nil) {
        sharedXPManager = [[self alloc] init];
    }
    
    return sharedXPManager;
}

- (id) init
{
	if( (self=[super init]) ) {
        //Dependent on level
        _spaceBetweenWalls = 300;
    }
	return self;
}

- (int) getSpaceBetweenWalls {
    return _spaceBetweenWalls;
}

- (int) getSpaceBetweenWalls:(int)machLevel {
    if (machLevel >= 1 && machLevel <= 9) {
        _spaceBetweenWalls = 305;//410
    }
    else if (machLevel >= 10 && machLevel <= 19) {
        _spaceBetweenWalls = 315;
    }
    else if (machLevel >= 20 && machLevel <= 29) {
        _spaceBetweenWalls = 325;
    }
    else if (machLevel >= 30 && machLevel <= 39) {
        _spaceBetweenWalls = 335;
    }
    else if (machLevel >= 40 && machLevel <= 49) {
        _spaceBetweenWalls = 345;
    }
    else {
        _spaceBetweenWalls = 355;
    }
    
    return _spaceBetweenWalls;
}

- (double) getTimeForExplosions:(int)machLevel {
    if (machLevel >= 1 && machLevel <= 9) {
        _explosionTime = 7;
    }
    else if (machLevel >= 10 && machLevel <= 19) {
        _explosionTime = 6;
    }
    else if (machLevel >= 20 && machLevel <= 29) {
        _explosionTime = 5;
    }
    else if (machLevel >= 30 && machLevel <= 39) {
        _explosionTime = 4;
    }
    else if (machLevel >= 40 && machLevel <= 49) {
        _explosionTime = 3;
    }
    else {
        _explosionTime = 2;
    }
    
    return _explosionTime;
}

- (double) getDistanceForExplosion:(int)machLevel {
    if (machLevel >= 1 && machLevel <= 9) {
        _explosionTime = 7;
    }
    else if (machLevel >= 10 && machLevel <= 19) {
        _explosionTime = 6;
    }
    else if (machLevel >= 20 && machLevel <= 29) {
        _explosionTime = 5;
    }
    else if (machLevel >= 30 && machLevel <= 39) {
        _explosionTime = 4;
    }
    else if (machLevel >= 40 && machLevel <= 49) {
        _explosionTime = 3;
    }
    else {
        _explosionTime = 2;
    }
    
    return _explosionTime;
}

@end
