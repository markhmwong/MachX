//
//  MachWave.m
//  MachX
//
//  Created by Mark Wong on 31/12/12.
//  Copyright 2012 Whizbang. All rights reserved.
//

#import "MachWave.h"


@implementation MachWave
@synthesize spriteBody = _spriteBody;
@synthesize game = _game;
@synthesize body = _body;

+ (id) InitWithGame:(Game*)game Position:(CGPoint) position {
	return [[self alloc] initWithMachWave:(Game*)game Position:(CGPoint)position] ;
}

- (id) initWithMachWave:(Game*)game Position:(CGPoint) position {
    if ((self = [super init])) {
        _playerVelocity = self.game.player.getPlayerCruiseSpeed;
        self.game = game;
        self.spriteBody = [CCSprite spriteWithFile:@"MachWave-hd.png"];
        self.spriteBody.tag = -3;
        [self addChild:_spriteBody];
        [self addBody];
        [self updateNode];
    }
    return self;
}

- (void) addBody {
    //Box2D Body
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"MachWaveDef.plist"];
    
    b2BodyDef bd;
    bd.type = b2_dynamicBody;
    bd.linearDamping = 0.05f;
    bd.fixedRotation = true;
    bd.userData = (__bridge void*)self.spriteBody;
    
    CGPoint p = ccp(160, -20);
    bd.position.Set(p.x * [Box2DHelper metersPerPoint], p.y * [Box2DHelper metersPerPoint]);
    _body = _game.world->CreateBody(&bd);
    
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_body forShapeName:@"MachWave-hd"];
}

- (void) updateNode {
    //UPDATES THE SPRITE POSITION
	CGPoint p;
	p.x = _body->GetPosition().x * [Box2DHelper pointsPerMeter];
	p.y = _body->GetPosition().y * [Box2DHelper pointsPerMeter];
	
    // CCNode position and rotation
    _spriteBody.position = p;
}

- (void) updateVelocity:(float) velY {
    b2Vec2 velocity;
    if (_machWaveEvent) {
        velocity.y = _playerVelocity + 0.2;
        velocity.x = 0;
        _body->SetLinearVelocity(velocity);
    }
    else {
        velocity.y = _playerVelocity;
        velocity.x = 0;
        _body->SetLinearVelocity(velocity);
    }
}

- (b2Vec2) getVelocity {
    return _body->GetLinearVelocity();
}

- (void) printVelocityY {
    NSLog(@"%f", _body->GetLinearVelocity().y);
}

- (void) printPositionY {
    NSLog(@"wave %f", _body->GetPosition().y * [Box2DHelper pointsPerMeter]);
}

- (void) machWaveEvent {
    //increase mach speed
    _playerVelocity = self.game.player.getPlayerCruiseSpeed;
}

- (void) updatePosition:(CGPoint)position {
    b2Vec2 pos;
    pos.x = 160 * [Box2DHelper metersPerPoint];
    pos.y = (position.y - 200) * [Box2DHelper metersPerPoint];
    _body->SetTransform(pos, 0);
}


@end
