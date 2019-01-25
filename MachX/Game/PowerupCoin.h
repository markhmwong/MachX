//
//  SpeedBoost.h
//  MachX
//
//  Created by Mark Wong on 10/01/13.
//  Copyright 2013 Whizbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Game.h"

@interface PowerupCoin : CCNode {
    CCSprite *_spriteBody;
    Game *_game;
    b2Body *_body;
    CGPoint *_pos;
    BOOL _activeCoin;
}

@property (nonatomic, strong) CCSprite *spriteBody;
@property (nonatomic, strong) Game *game;
@property (readwrite) b2Body *body;
@property (nonatomic, assign) BOOL activeCoin;

+ (id) InitCoinSingle:(Game*)game Position:(CGPoint)position;
+ (id) InitCoinTen:(Game*)game Position:(CGPoint)position;

- (id) initWithGameSingle:(Game*)game Position:(CGPoint)position;
- (void) updateNode;
- (BOOL) getActiveCoin;
- (void) setActiveCoin:(BOOL)active;

@end
