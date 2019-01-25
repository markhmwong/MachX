//
//  MachWave.m
//  MachX
//
//  Created by Mark Wong on 31/12/12.
//  Copyright 2012 Whizbang. All rights reserved.
//

#import "LaserBeam.h"

@implementation LaserBeam
@synthesize spriteBody = _spriteBody;
@synthesize game = _game;
@synthesize body = _body;
@synthesize spriteEmitterBottom = _spriteEmitterBottom;
@synthesize spriteEmitterTop = _spriteEmitterTop;
@synthesize activeBeam = _activeBeam;
@synthesize timeActive = _timeActive;
@synthesize removeBody = _removeBody;
@synthesize endLaserBeamEvent = _endLaserBeamEvent;

+ (id) InitWithGame:(Game*)game Position:(CGPoint) position tag:(int)tag {
	return [[self alloc] initWithLaserBeam:(Game*)game Position:(CGPoint)position tag:tag];
}

- (id) initWithLaserBeam:(Game*)game Position:(CGPoint)position tag:(int)tag {
    if ((self = [super init])) {
        self.game = game;
        
        
        _posX = position.x;
        _pos = position;
        
        self.spriteBody = [CCSprite spriteWithFile:@"LaserBeam-hd.png"];
        self.spriteBody.opacity = 0;
        self.spriteBody.tag = tag;
        [self addChild:_spriteBody z:-1];
        
        [self addBody:_pos];

    }
    return self;
}

- (void) runLaserBeamEmitters:(float)lifeTime spawnPositionX:(int)positionX {
    _endLaserBeamEvent = FALSE;
    _spawnPosX = _posX;
    _spawnPosX = positionX;
    _moveRight = FALSE;
    _moveLeft = FALSE;
    _endAnimation = FALSE;
    _delayFinished = FALSE;
    _damageActive = FALSE;
    _removeBody = FALSE;
    _delayTimer = 0;
    _delayTime = 2.0f;
    _lifeTimeTimer = 0;
    _lifeTime = lifeTime;
    
    if (_spawnPosX < 160) {
        _moveRight = TRUE;
    }
    else {
        _moveLeft = TRUE;
    }
    
    if (_spawnPosX == 160.0f) {
        if (arc4random() % 2 == 0) {
            _moveLeft = TRUE;
        }
        else {
            _moveRight = TRUE;
        }
    }
    
    [self flyInLaserEmitters];
    [self updateNode];
}

- (void) addBody:(CGPoint)position {
    //Box2D Body
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"LaserBeamDef.plist"];
    
    b2BodyDef bd;
    bd.type = b2_dynamicBody;
    bd.linearDamping = 0.05f;
    bd.fixedRotation = true;
    bd.userData = (__bridge void*)self.spriteBody;
    
    CGPoint p = position;
    bd.position.Set(p.x * [Box2DHelper metersPerPoint], p.y * [Box2DHelper metersPerPoint]);
    _body = _game.world->CreateBody(&bd);
    
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_body forShapeName:@"LaserBeam-hd"];
}

- (void) updateNode {
	CGPoint p;
	p.x = _body->GetPosition().x * [Box2DHelper pointsPerMeter];
	p.y = _body->GetPosition().y * [Box2DHelper pointsPerMeter];
	
    // CCNode position and rotation
    //_spriteBody.position = p;
    self.position = p;
}

- (void) animateBeam {
    [_spriteBody runAction:[CCFadeIn actionWithDuration:4.0]];
}

- (void) flyInLaserEmitters {

    //spawn offscreen
    self.spriteEmitterBottom = [CCSprite spriteWithFile:@"Emitter1.png"];
    self.spriteEmitterBottom.position = ccp(0 , -207);
    self.spriteEmitterBottom.tag = 1;
    [self addChild:_spriteEmitterBottom];
    
    self.spriteEmitterTop = [CCSprite spriteWithFile:@"Emitter1.png"];
    self.spriteEmitterTop.flipY = TRUE;
    self.spriteEmitterTop.position = ccp(0, 400);
    self.spriteEmitterTop.tag = 2;
    [self addChild:_spriteEmitterTop];
    
    //Pick a random beamType
    //Top first then bottom
    [_spriteEmitterTop runAction:[CCMoveTo actionWithDuration:1.4f position:ccp(0, 167)]];
    switch (arc4random() % 3 + 1) {
        case 1:
            [_spriteEmitterBottom runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.4f], [CCMoveTo actionWithDuration:0.8f position:ccp(0, -167)], [CCCallFuncN actionWithTarget:self selector:@selector(spawnBeamType1)], nil]];
            break;
        case 2:
            [_spriteEmitterBottom runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.4f], [CCMoveTo actionWithDuration:0.8f position:ccp(0, -167)], [CCCallFuncN actionWithTarget:self selector:@selector(spawnBeamType2)], nil]];
            break;
        case 3:
            [_spriteEmitterBottom runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.4f], [CCMoveTo actionWithDuration:0.8f position:ccp(0, -167)], [CCCallFuncN actionWithTarget:self selector:@selector(spawnBeamType3)], nil]];
            break;
        default:
            [_spriteEmitterBottom runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.4f], [CCMoveTo actionWithDuration:0.8f position:ccp(0, -167)], [CCCallFuncN actionWithTarget:self selector:@selector(spawnBeamType3)], nil]];
            break;
    }
}

//Type 1
//Beam pulses at a regular rate
- (void) spawnBeamType1 {
    CCCallBlockN * enable = [CCCallBlockN actionWithBlock:^(CCNode *node)  { _damageActive = TRUE; }];

    [_spriteBody runAction:[CCSequence actions:[CCSpawn actions:[CCFadeIn actionWithDuration:0.4f], enable,nil], [CCCallFuncN actionWithTarget:self selector:@selector(moveBeamType1)], nil]];
}

- (void) moveBeamType1 {
    _activeBeam = TRUE;
    //Play sound
    CCCallBlockN * disable = [CCCallBlockN actionWithBlock:^(CCNode *node)  { _damageActive = FALSE; }];
    CCCallBlockN * enable = [CCCallBlockN actionWithBlock:^(CCNode *node)  { _damageActive = TRUE; }];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.8f], disable, [CCFadeOut actionWithDuration:0.4f], [CCDelayTime actionWithDuration:0.8f], [CCFadeIn actionWithDuration:0.4f], enable, nil]];
    repeat.tag = 100;
    [_spriteBody runAction:repeat];
}

//Type 2
//Beam pulses at a rapid rate
- (void) spawnBeamType2 {
    CCCallBlockN * enable = [CCCallBlockN actionWithBlock:^(CCNode *node)  { _damageActive = TRUE; }];
    
    [_spriteBody runAction:[CCSequence actions:[CCSpawn actions:[CCFadeIn actionWithDuration:0.1f], enable, nil], [CCCallFuncN actionWithTarget:self selector:@selector(moveBeamType2)], nil]];
}

- (void) moveBeamType2 {
    //fast
    _activeBeam = TRUE;
    //Play sound
    CCCallBlockN * disable = [CCCallBlockN actionWithBlock:^(CCNode *node)  { _damageActive = FALSE; }];
    CCCallBlockN * enable = [CCCallBlockN actionWithBlock:^(CCNode *node)  { _damageActive = TRUE; }];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.3f], disable, [CCFadeOut actionWithDuration:0.1f], [CCDelayTime actionWithDuration:0.3f], [CCFadeIn actionWithDuration:0.1f], enable, nil]];
    repeat.tag = 100;
    [_spriteBody runAction:repeat];
}

//Type 3
//Beam pulses with longer intervals
- (void) spawnBeamType3 {
    CCCallBlockN * enable = [CCCallBlockN actionWithBlock:^(CCNode *node)  { _damageActive = TRUE; }];
    
    [_spriteBody runAction:[CCSequence actions:[CCSpawn actions:[CCFadeIn actionWithDuration:0.3f], enable, nil], [CCCallFuncN actionWithTarget:self selector:@selector(moveBeamType3)], nil]];
}

- (void) moveBeamType3 {
    _activeBeam = TRUE;
    //Play sound
    CCCallBlockN * disable = [CCCallBlockN actionWithBlock:^(CCNode *node)  { _damageActive = FALSE; }];
    CCCallBlockN * enable = [CCCallBlockN actionWithBlock:^(CCNode *node)  { _damageActive = TRUE; }];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.2f], disable, [CCFadeOut actionWithDuration:0.3f], [CCDelayTime actionWithDuration:1.2f], [CCFadeIn actionWithDuration:0.3f], enable, nil]];
    repeat.tag = 100;
    [_spriteBody runAction:repeat];
}

- (void) flyOutEmitters {
    [_spriteEmitterBottom runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.0f], [CCMoveBy actionWithDuration:1.0f position:ccp(0,-100)], nil]];
    [_spriteEmitterTop runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.0], [CCMoveBy actionWithDuration:1.0f position:ccp(0,250)], [CCCallFuncN actionWithTarget:self selector:@selector(removeLaserBody)], nil]];
}

- (void) removeLaserBody {
    _endLaserBeamEvent = TRUE;
    _removeBody = TRUE;
    _activeBeam = FALSE;
    [self repositionNodeOffScreen];
}

- (BOOL) getRemoveBody {
    return _removeBody;
}

- (void) setActiveBeam:(BOOL)activeBeam {
    _activeBeam = activeBeam;
}

- (BOOL) getActiveBeam {
    return _activeBeam;
}

- (BOOL) getDamageActive {
    return _damageActive;
}

- (void) updatePosition:(CGPoint)position {
    //limit to 30pixels on the left and 290 pixels on the right
    //move body left and right
    if (_delayFinished) {
        if (_moveLeft && _endLaserBeamEvent == FALSE) {
            _spawnPosX--;
            if (_spawnPosX < 10) {
                _moveRight = TRUE;
                _moveLeft = FALSE;
            }
            
        }
        
        if (_moveRight && _endLaserBeamEvent == FALSE) {
            if (_spawnPosX > 310) {
                _moveLeft = TRUE;
                _moveRight = FALSE;
            }
            _spawnPosX++;

        }
    }
    
    //turn it on and off
    b2Vec2 pos;
    pos.x = _spawnPosX * [Box2DHelper metersPerPoint];
    pos.y = (position.y + 80) * [Box2DHelper metersPerPoint];
    _testPositionY = pos.y;
    _body->SetTransform(pos, 0);
}

- (void) fireBeam:(ccTime)dt {
    //1.5 sec to fire beam
    if (_delayTimer > _delayTime) {
        _delayFinished = TRUE;
    }
    if (_lifeTimeTimer > _lifeTime && !_endAnimation) {
        _damageActive = FALSE;
        _endAnimation = TRUE;
        //stop actions
        [_spriteBody stopActionByTag:100];

        [_spriteBody runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.5f], [CCCallFuncN actionWithTarget:self selector:@selector(flyOutEmitters)], nil]];
    }
    
    _lifeTimeTimer += dt;
    _delayTimer += dt;
}

- (BOOL) getEndLaserBeamEvent {
    return _endLaserBeamEvent;
}

- (void) setLifeTime:(float)lifeTime {
    _lifeTime = lifeTime;
}

- (void) repositionNodeOffScreen {
    self.position = ccp(40, 100);
}


@end
