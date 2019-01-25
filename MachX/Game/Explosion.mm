//
//  Explosion.mm
//  CrazyPlanes_cc2
//
//  Created by Mark Wong on 16/10/12.
//  Copyright 2012 Mark Wong. All rights reserved.
//

#import "Explosion.h"


@implementation Explosion

@synthesize body = _body;
@synthesize game = _game;
@synthesize spriteBody = _spriteBody;

+ (id) InitWithGame:(Game*)game Position:(CGPoint) position {
	return [[self alloc] initWithExplosion:(Game*)game Position:(CGPoint)position] ;
}

- (id) initWithExplosion:(Game*)game Position:(CGPoint) position {
    if ((self = [super init])) {
        self.game = game;
        _posY = position.y;
        _posX = position.x;
        self.spriteBody = [CCSprite spriteWithFile:@"Explosion-hd.png"];
        self.spriteBody.tag = -5;
        
        [self addChild:_spriteBody];
        [self addBody];
        
        self.spriteShockWave = [CCSprite spriteWithFile:@"ExplosionShockWave-hd.png"];
        [self addChild:_spriteShockWave];
        [self shockWaveAnimation];
        [self updateNode];
        [self explosionAnimation];
    }
    return self;
}

- (void) shockWaveAnimation {
    CCCallBlockN * removeShockwave = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    [_spriteShockWave runAction:[CCSequence actions:[CCSpawn actions:[CCScaleTo actionWithDuration:1.0f scale:3.0f],[CCFadeOut actionWithDuration:2.0],  nil], removeShockwave, nil]];
}

- (void) addBody {
    //Box2D Body
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"MissileDef.plist"];
    
    b2BodyDef bd;
    bd.type = b2_dynamicBody;
    bd.linearDamping = 0.05f;
    bd.fixedRotation = true;
    bd.userData = (__bridge void*)self.spriteBody;
    
    CGPoint p = ccp(_posX, _posY);
    bd.position.Set(p.x * [Box2DHelper metersPerPoint], p.y * [Box2DHelper metersPerPoint]);
    _body = _game.world->CreateBody(&bd);
    
    _body->ApplyLinearImpulse(b2Vec2(0, 0), _body->GetPosition());
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_body forShapeName:@"Explosion-hd"];
    _body->ApplyTorque(1000);
}

- (void) updateNode {
	CGPoint p;
	p.x = _body->GetPosition().x * [Box2DHelper pointsPerMeter];
	p.y = _body->GetPosition().y * [Box2DHelper pointsPerMeter];
	
    // CCNode position and rotation
    _spriteBody.position = p;
    _spriteShockWave.position = p;
    
//    float angle = 90.0; //or whatever you angle is
//    b2Vec2 pos = _body->GetPosition();
//    _body->SetTransform(pos, angle);
}

- (void) explosionAnimation {
    [_spriteBody runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:0.83 angle:360]]];
    [_spriteBody runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.08f scale:0.85], [CCScaleTo actionWithDuration:0.08f scale:1.0], nil]]];
}
@end
