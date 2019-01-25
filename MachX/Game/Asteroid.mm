//
//  Missile.mm
//  MachX
//
//  Created by Mark Wong on 2/02/13.
//  Copyright 2013 Whizbang. All rights reserved.
//

#import "Asteroid.h"


@implementation Asteroid

@synthesize body = _body;
@synthesize game = _game;
@synthesize spriteBody = _spriteBody;

+ (id) InitWithGame:(Game*)game Position:(CGPoint) position {
	return [[self alloc] initWithMissile:(Game*)game Position:(CGPoint)position] ;
}

- (id) initWithMissile:(Game*)game Position:(CGPoint) position {
    if ((self = [super init])) {
        self.game = game;
        _posY = position.y;
        _posX = position.x;
        self.spriteBody = [CCSprite spriteWithFile:@"Asteroid-hd.png"];
        self.spriteBody.tag = -4;
        [self addChild:_spriteBody];
        [self addBody];
        [self updateNode];
    }
    return self;
}

- (void) addBody {
    //Box2D Body
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"AsteroidDef.plist"];
    
    b2BodyDef bd;
    bd.type = b2_dynamicBody;
    bd.linearDamping = 0.05f;
    bd.fixedRotation = true;
    bd.userData = (__bridge void*)self.spriteBody;
    
    CGPoint p = ccp(_posX, _posY);
    bd.position.Set(p.x * [Box2DHelper metersPerPoint], p.y * [Box2DHelper metersPerPoint]);
    _body = _game.world->CreateBody(&bd);
    
    _body->ApplyLinearImpulse(b2Vec2(0, -5), _body->GetPosition());
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_body forShapeName:@"Asteroid-hd"];
}

- (void) updateNode {
	CGPoint p;
	p.x = _body->GetPosition().x * [Box2DHelper pointsPerMeter];
	p.y = _body->GetPosition().y * [Box2DHelper pointsPerMeter];
	
    // CCNode position and rotation
    _spriteBody.position = p;
}

@end
