//
//  SpeedBoost.m
//  MachX
//
//  Created by Mark Wong on 10/01/13.
//  Copyright 2013 Whizbang. All rights reserved.
//

#import "PowerupSlowmo.h"


@implementation PowerupSlowmo
@synthesize spriteBody = _spriteBody;
@synthesize game = _game;
@synthesize body = _body;

+ (id) InitSlowmo:(Game*)game Position:(CGPoint)position {
    return [[self alloc] initWithGame:game Position:(CGPoint)position];
}

- (id) initWithGame:(Game*)game Position:(CGPoint)position {
    if (self = [super init]) {
        self.game = game;
        _pos = &position;
        
        self.spriteBody = [CCSprite spriteWithFile:@"SlowMo-hd.png"];
        self.spriteBody.tag = 12;
        [self addChild:_spriteBody];
        
        [self addBody];
        [self updateNode];
    }
    return self;
}

- (void) addBody {
    //Box2D Body
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"PowerupsDef.plist"];
    
    b2BodyDef bd;
    bd.type = b2_dynamicBody;
    bd.linearDamping = 0.05f;
    bd.fixedRotation = true;
    bd.userData = (__bridge void*)self.spriteBody;
    
    CGPoint p = ccp(_pos->x, _pos->y);
    bd.position.Set(p.x * [Box2DHelper metersPerPoint], p.y * [Box2DHelper metersPerPoint]);
    _body = _game.world->CreateBody(&bd);
    
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_body forShapeName:@"SlowMo-hd"];
    _body->ApplyLinearImpulse(b2Vec2(0, -1), _body->GetPosition());
    
}

- (void) updateNode {
	CGPoint p;
	p.x = _body->GetPosition().x * [Box2DHelper pointsPerMeter];
	p.y = _body->GetPosition().y * [Box2DHelper pointsPerMeter];
	
    // CCNode position and rotation
    _spriteBody.position = p;
    
}


@end
