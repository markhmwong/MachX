//
//  EnemyHelper.h
//  MachX
//
//  Created by Mark Wong on 23/01/13.
//  Copyright 2013 Whizbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EnemyHelper : NSObject {
    int _spaceBetweenWalls;
    double _explosionTime;
}

@property (nonatomic, assign) int spaceBetweenWalls;

+ (id) sharedXPManager;

- (int) getSpaceBetweenWalls;
- (int) getSpaceBetweenWalls:(int)machLevel;
- (double) getTimeForExplosions:(int)machLevel;
@end
