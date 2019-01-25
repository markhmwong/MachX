//
//  Missile.h
//  MachX
//
//  Created by Mark Wong on 2/02/13.
//  Copyright 2013 Whizbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Game.h"

@interface Missile : CCNode {
    CCSprite *_spriteBody;
    CCSprite *_spriteFlame;
    Game *_game;
    b2Body *_body;
    int _posY;
    int _posX;
}

@property (nonatomic, strong) CCSprite *spriteBody;
@property (nonatomic, strong) CCSprite *spriteFlame;
@property (nonatomic, strong) Game *game;
@property (readwrite) b2Body *body;

+ (id) InitWithGame:(Game*)game Position:(CGPoint)position;
- (id) initWithMissile:(Game*)game Position:(CGPoint)position;
- (void) addBody;
- (void) updateNode;


@end
