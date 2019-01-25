//
//  MachWave.h
//  MachX
//
//  Created by Mark Wong on 31/12/12.
//  Copyright 2012 Whizbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Game.h"
#import "Box2DHelper.h"

@interface MachWave : CCNode {
    CCSprite *_spriteBody;
    Game *_game;
    b2Body *_body;
    bool _machWaveEvent;
    float _playerVelocity;
}

@property (nonatomic, strong) CCSprite *spriteBody;
@property (nonatomic, strong) Game *game;
@property (readwrite) b2Body *body;

+ (id) InitWithGame:(Game*)game Position:(CGPoint)position;
- (id) initWithMachWave:(Game*)game Position:(CGPoint)position;
- (void) addBody;
- (void) updateNode;
- (void) updateVelocity:(float)vel;
- (void) updatePosition:(CGPoint)position;
- (b2Vec2) getVelocity;
- (void) printVelocityY;
- (void) printPositionY;
- (void) machWaveEvent;
@end
