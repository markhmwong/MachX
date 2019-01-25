//
//  Walls.mm
//  CrazyPlanes_cc2
//
//  Created by Mark Wong on 13/11/12.
//  Copyright 2012 Mark Wong. All rights reserved.
//

#import "Wall.h"

@implementation Wall
@synthesize wallSprite = _wallSprite;
@synthesize wallBody = _wallBody;
@synthesize xpTag = _xpTag;
@synthesize game = _game;

//EASY
+ (id) InitWallEasy:(Game*)game Position:(CGPoint)position machLevel:(int)level sprite:(NSString *)spriteName {
    return [[self alloc] initWithGameEasyWall:game Position:(CGPoint)position machLevel:(int)level sprite:(NSString*)spriteName];
}

//EASY MOVING
+ (id) InitWallEasyWithDirection:(Game*)game Position:(CGPoint)position machLevel:(int)level moveWall:(BOOL)moveWall direction:(int)direction sprite:(NSString *)spriteName {
    return [[self alloc] initWithGameEasyWallWithDirection:game Position:(CGPoint)position machLevel:(int)level moveWall:(BOOL)moveWall direction:(int)direction sprite:(NSString*)spriteName];
}

//MEDIUM
+ (id) InitWallMedium:(Game*)game Position:(CGPoint)position machLevel:(int)level sprite:(NSString*)spriteName {
    return [[self alloc] initWithGameMediumWall:game Position:(CGPoint)position machLevel:(int)level sprite:(NSString*)spriteName];
}

//MEDIUM MOVING
+ (id) InitWallMediumWithDirection:(Game*)game Position:(CGPoint)position machLevel:(int)level moveWall:(BOOL)moveWall direction:(int)direction sprite:(NSString*)spriteName {
    return [[self alloc] initWithGameMediumWallWithDirection:game Position:(CGPoint)position machLevel:(int)level moveWall:(BOOL)moveWall direction:(int)direction sprite:(NSString*) spriteName];
}

//HARD
+ (id) InitWallHard:(Game*)game Position:(CGPoint)position machLevel:(int)level sprite:(NSString*)spriteName {
    return [[self alloc] initWithGameHardWall:game Position:(CGPoint)position machLevel:(int)level sprite:(NSString*)spriteName];
}

//HARD MOVING
+ (id) InitWallHardWithDirection:(Game*)game Position:(CGPoint)position machLevel:(int)level moveWall:(BOOL)moveWall direction:(int)direction sprite:(NSString*)spriteName {
    return [[self alloc] initWithGameHardWallWithDirection:game Position:(CGPoint)position machLevel:(int)level moveWall:(BOOL)moveWall direction:(int)direction sprite:(NSString*)spriteName];
}

- (id) initWithGameEasyWall:(Game*)game Position:(CGPoint)position machLevel:(int)level sprite:(NSString*)spriteName {
    if (self = [super init]) {
        self.game = game;
        _pos = &position;
        _machLevel = level;
        _lights = TRUE;
        _xpTag = TRUE;
        _damagePlayer = TRUE;
        
        _xpManager = [XPManager sharedXPManager];
        
        [self createWallSpriteEasy:spriteName];
        [self createWallBodyEasy:spriteName];
        [self updateWall];
    }
    return self;
}

- (id) initWithGameEasyWallWithDirection:(Game*)game Position:(CGPoint)position machLevel:(int)level moveWall:(BOOL)moveWall direction:(int)direction sprite:(NSString *)spriteName {
    if (self = [super init]) {
        self.game = game;
        _pos = &position;
        _machLevel = level;
        _lights = TRUE;
        _xpTag = TRUE;
        _damagePlayer = TRUE;
        _movingWall = moveWall;
        _direction = direction;
        _xpManager = [XPManager sharedXPManager];
        
        [self createWallSpriteEasy:spriteName];
        [self createWallBodyEasy:spriteName];
        [self updateWall];
    }
    return self;
}

- (id) initWithGameMediumWall:(Game*)game Position:(CGPoint)position machLevel:(int)level sprite:(NSString *)spriteName {
    if (self = [super init]) {
        self.game = game;
        _pos = &position;
        _machLevel = level;
        _lights = TRUE;
        _xpTag = TRUE;
        _damagePlayer = TRUE;
        
        _xpManager = [XPManager sharedXPManager];
        
        [self createWallSpriteMedium:spriteName];
        [self createWallBodyMedium:spriteName];
        [self updateWall];
    }
    return self;
}

- (id) initWithGameMediumWallWithDirection:(Game*)game Position:(CGPoint)position machLevel:(int)level moveWall:(BOOL)moveWall direction:(int)direction sprite:(NSString *)spriteName {
    if (self = [super init]) {
        self.game = game;
        _pos = &position;
        _machLevel = level;
        _lights = TRUE;
        _xpTag = TRUE;
        _damagePlayer = TRUE;
        _movingWall = moveWall;
        _direction = direction;
        _xpManager = [XPManager sharedXPManager];
        
        [self createWallSpriteMedium:spriteName];
        [self createWallBodyMedium:spriteName];
        [self updateWall];
    }
    return self;
}


- (id) initWithGameHardWall:(Game*)game Position:(CGPoint)position machLevel:(int)level sprite:(NSString *)spriteName {
    if (self = [super init]) {
        self.game = game;
        _pos = &position;
        _machLevel = level;
        _lights = TRUE;
        _xpTag = TRUE;
        _damagePlayer = TRUE;
        
        _xpManager = [XPManager sharedXPManager];
        
        [self createWallSpriteHard:spriteName];
        [self createWallBodyHard:spriteName];
        [self updateWall];
    }
    return self;
}

- (id) initWithGameHardWallWithDirection:(Game*)game Position:(CGPoint)position machLevel:(int)level moveWall:(BOOL)moveWall direction:(int)direction sprite:(NSString *)spriteName {
    if (self = [super init]) {
        self.game = game;
        _pos = &position;
        _machLevel = level;
        _lights = TRUE;
        _xpTag = TRUE;
        _damagePlayer = TRUE;
        _movingWall = moveWall;
        _direction = direction;
        _xpManager = [XPManager sharedXPManager];
        
        [self createWallSpriteHard:spriteName];
        [self createWallBodyHard:spriteName];
        [self updateWall];
    }
    return self;
}

- (void) createWallSpriteEasy:(NSString *)spriteName {
    NSString *spriteNameWithPNG = [spriteName stringByAppendingString:@".png"];
    self.wallSprite = [CCSprite spriteWithFile:spriteNameWithPNG];
    self.wallSprite.tag = -1;
    [self addChild:_wallSprite];
}

- (void) createWallBodyEasy:(NSString *)spriteName {
    //Box2D Body
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"WallDef.plist"];
    b2BodyDef bd;
    bd.type = b2_dynamicBody;
    bd.linearDamping = 0.05f;
    bd.fixedRotation = true;
    bd.userData = (__bridge void*)self.wallSprite;
    
    CGPoint p = ccp(_pos->x, _pos->y);
    bd.position.Set(p.x * [Box2DHelper metersPerPoint], p.y * [Box2DHelper metersPerPoint]);
    _wallBody = _game.world->CreateBody(&bd);
    if (_movingWall) {
        [self moveWall];
    }    
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_wallBody forShapeName:spriteName];
}

- (void) createWallSpriteMedium:(NSString *)spriteName {
    NSString *spriteNameWithPNG = [spriteName stringByAppendingString:@".png"];

    self.wallSprite = [CCSprite spriteWithFile:spriteNameWithPNG];
    self.wallSprite.tag = -1;
    [self addChild:_wallSprite];
}

- (void) createWallBodyMedium:(NSString *)spriteName {
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"WallDef.plist"];

    b2BodyDef bd;
    bd.type = b2_dynamicBody;
    bd.linearDamping = 0.05f;
    bd.fixedRotation = true;
    bd.userData = (__bridge void*)self.wallSprite;
    
    CGPoint p = ccp(_pos->x, _pos->y);
    bd.position.Set(p.x * [Box2DHelper metersPerPoint], p.y * [Box2DHelper metersPerPoint]);
    _wallBody = _game.world->CreateBody(&bd);
    
    if (_movingWall) {
        [self moveWall];
    }
    
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_wallBody forShapeName:spriteName];
}

- (void) createWallSpriteHard:(NSString *)spriteName {
    NSString *spriteNameWithPNG = [spriteName stringByAppendingString:@".png"];

    self.wallSprite = [CCSprite spriteWithFile:spriteNameWithPNG];
    self.wallSprite.tag = -1;
    [self addChild:_wallSprite];
}

- (void) createWallBodyHard:(NSString *)spriteName {
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"WallDef.plist"];

    b2BodyDef bd;
    bd.type = b2_dynamicBody;
    bd.linearDamping = 0.05f;
    bd.fixedRotation = true;
    bd.userData = (__bridge void*)self.wallSprite;
    
    CGPoint p = ccp(_pos->x, _pos->y);
    bd.position.Set(p.x * [Box2DHelper metersPerPoint], p.y * [Box2DHelper metersPerPoint]);
    _wallBody = _game.world->CreateBody(&bd);
    
    if (_movingWall) {
        [self moveWall];
    }
    
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_wallBody forShapeName:spriteName];
}

- (void) lightEvent {
    if (_lights) {
        //[self runAction:[CCFadeTo actionWithDuration:.5f opacity:30]];
        _lights = FALSE;
    }
}

- (void) updateWall {
    CGPoint p;
	p.x = _wallBody->GetPosition().x * [Box2DHelper pointsPerMeter];
	p.y = _wallBody->GetPosition().y * [Box2DHelper pointsPerMeter];
    // CCNode position and rotation
    _wallSprite.position = p;
}

- (void) setXpTag {
    _xpTag = TRUE;
}

- (BOOL) getXpTag {
    return _xpTag;
}

- (BOOL) tagXp {
    if (_xpTag) {
        int wallXP = [_xpManager getWallXP];
        [_xpManager addXP:wallXP];
        [_xpManager incrementMultiplier];
        _xpTag = FALSE;
    }
    return _xpTag;
}

- (BOOL) damage {
    if (_damagePlayer) {
        _damagePlayer = FALSE;
        return TRUE;
    }
    return FALSE;
}

- (void) moveWall {
    _wallBody->ApplyLinearImpulse(b2Vec2(_direction, 0), _wallBody->GetPosition());
}


@end
