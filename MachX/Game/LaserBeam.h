//
//  LaserBeam.h
//  MachX
//
//  Created by Mark Wong on 31/12/12.
//  Copyright 2012 Whizbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Game.h"
#import "Box2DHelper.h"

@interface LaserBeam : CCNode {
    CCSprite *_spriteBody;
    CCSprite *_spriteEmitterBottom;
    CCSprite *_spriteEmitterTop;
    Game *_game;
    b2Body *_body;
    BOOL _activeBeam;
    BOOL _moveLeft;
    BOOL _moveRight;
    BOOL _delayFinished;
    BOOL _damageActive;
    BOOL _endLaserBeamEvent;
    BOOL _removeBody;
    BOOL _endAnimation;
    int _spawnPosX;
    
    float _delayTimer;
    float _delayTime;
    float _timeActive;
    
    float _lifeTime;
    float _lifeTimeTimer;
    
    CGPoint _pos;
    float _posX;
    float _testPositionY;
}

@property (nonatomic, strong) CCSprite *spriteBody;
@property (nonatomic, strong) CCSprite *spriteEmitterBottom;
@property (nonatomic, strong) CCSprite *spriteEmitterTop;
@property (nonatomic, strong) Game *game;
@property (nonatomic, assign) BOOL activeBeam;
@property (nonatomic, assign) BOOL endLaserBeamEvent;
@property (nonatomic, assign) BOOL removeBody;
@property (nonatomic, assign) BOOL damageActive;
@property (nonatomic, assign) float timeActive;
@property (readwrite) b2Body *body;

+ (id) InitWithGame:(Game*)game Position:(CGPoint)position tag:(int)tag;
- (id) initWithLaserBeam:(Game*)game Position:(CGPoint)position tag:(int)tag;
- (void) addBody:(CGPoint)position;
- (void) setActiveBeam:(BOOL)activeBeam;
- (BOOL) getActiveBeam;
- (BOOL) getDamageActive;
- (BOOL) getRemoveBody;
- (BOOL) getEndLaserBeamEvent;
- (void) updateNode;
- (void) fireBeam:(ccTime)dt;
- (BOOL) getRemoveBody;
- (void) updatePosition:(CGPoint)position;
- (void) runLaserBeamEmitters:(float)lifeTime spawnPositionX:(int)positionX;
@end
