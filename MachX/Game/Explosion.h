//
//  Explosion.h
//  CrazyPlanes_cc2
//
//  Created by Mark Wong on 16/10/12.
//  Copyright 2012 Mark Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GB2ShapeCache.h"
#import "Box2DHelper.h"
#import "Game.h"

@interface Explosion : CCNode {
    CCSprite *_spriteBody;
    CCSprite *_spriteShockWave;
    Game *_game;
    b2Body *_body;
    b2Body *_explosionBody;
    int _posY;
    int _posX;
}

@property (nonatomic, strong) CCSprite *spriteBody;
@property (nonatomic, strong) CCSprite *spriteShockWave;
@property (nonatomic, strong) Game *game;
@property (readwrite) b2Body *body;

+ (id) InitWithGame:(Game*)game Position:(CGPoint)position;
- (id) initWithExplosion:(Game*)game Position:(CGPoint)position;
- (void) addBody;
- (void) explosionAnimation;
- (void) updateNode;


@end
