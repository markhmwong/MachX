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

@interface DebuffSlowCharge : CCNode {
    CCSprite *_spriteBody;
    Game *_game;
    b2Body *_body;
    CGPoint *_pos;
}

@property (nonatomic, strong) CCSprite *spriteBody;
@property (nonatomic, strong) Game *game;
@property (readwrite) b2Body *body;

+ (id) InitDebuffSlowCharge:(Game*)game Position:(CGPoint)position;
- (id) initWithGame:(Game*)game Position:(CGPoint)position;
- (void) updateNode;
@end
