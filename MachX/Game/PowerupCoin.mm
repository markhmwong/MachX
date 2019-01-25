//
//  SpeedBoost.m
//  MachX
//
//  Created by Mark Wong on 10/01/13.
//  Copyright 2013 Whizbang. All rights reserved.
//

#import "PowerupSpeedBoost.h"


@implementation PowerupCoin
@synthesize spriteBody = _spriteBody;
@synthesize game = _game;
@synthesize body = _body;
@synthesize activeCoin = _activeCoin;

+ (id) InitCoinSingle:(Game*)game Position:(CGPoint)position {
    return [[self alloc] initWithGameSingle:game Position:(CGPoint)position];
}

+ (id) InitCoinTen:(Game*)game Position:(CGPoint)position {
    return [[self alloc] initWithGameTen:game Position:(CGPoint)position];
}

- (id) initWithGameSingle:(Game*)game Position:(CGPoint)position {
    if (self = [super init]) {
        self.game = game;
        _pos = &position;
        _activeCoin = TRUE;
        
        self.spriteBody = [CCSprite spriteWithFile:@"CoinSingle-hd.png"];
        self.spriteBody.tag = 15;
        //self.spriteBody.opacity = 50;
        [self addChild:_spriteBody];

        [self addBodySingle];
        [self updateNode];
    }
    return self;
}

- (id) initWithGameTen:(Game*)game Position:(CGPoint)position {
    if (self = [super init]) {
        self.game = game;
        _pos = &position;
        _activeCoin = TRUE;
        
        self.spriteBody = [CCSprite spriteWithFile:@"Coin-hd.png"];
        self.spriteBody.tag = 15;
        //self.spriteBody.opacity = 50;
        [self addChild:_spriteBody];
        
        [self addBodyTen];
        [self updateNode];
    }
    return self;
}

- (void) addBodySingle {
    //Box2D Body
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"CoinDef.plist"];
    
    b2BodyDef bd;
    bd.type = b2_dynamicBody;
    bd.linearDamping = 0.05f;
    bd.fixedRotation = true;
    bd.userData = (__bridge void*)self.spriteBody;
    
    CGPoint p = ccp(_pos->x, _pos->y);
    bd.position.Set(p.x * [Box2DHelper metersPerPoint], p.y * [Box2DHelper metersPerPoint]);
    _body = _game.world->CreateBody(&bd);
    
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_body forShapeName:@"CoinSingle-hd"];
    //_body->ApplyLinearImpulse(b2Vec2(0, -1), _body->GetPosition());
}

- (void) addBodyTen {
    //Box2D Body
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"CoinDef.plist"];
    
    b2BodyDef bd;
    bd.type = b2_dynamicBody;
    bd.linearDamping = 0.05f;
    bd.fixedRotation = true;
    bd.userData = (__bridge void*)self.spriteBody;
    
    CGPoint p = ccp(_pos->x, _pos->y);
    bd.position.Set(p.x * [Box2DHelper metersPerPoint], p.y * [Box2DHelper metersPerPoint]);
    _body = _game.world->CreateBody(&bd);
    
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_body forShapeName:@"Coin-hd"];
    _body->ApplyLinearImpulse(b2Vec2(0, -1), _body->GetPosition());
    
}

- (BOOL) getActiveCoin {
    return _activeCoin;
}

- (void) setActiveCoin:(BOOL)active {
    _activeCoin = active;
}

- (void) updateNode {
	CGPoint p;
	p.x = _body->GetPosition().x * [Box2DHelper pointsPerMeter];
	p.y = _body->GetPosition().y * [Box2DHelper pointsPerMeter];
	
    // CCNode position and rotation
    _spriteBody.position = p;
}


@end
