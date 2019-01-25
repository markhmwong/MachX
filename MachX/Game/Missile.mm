//
//  Missile.mm
//  MachX
//
//  Created by Mark Wong on 2/02/13.
//  Copyright 2013 Whizbang. All rights reserved.
//

#import "Missile.h"


@implementation Missile

@synthesize body = _body;
@synthesize game = _game;
@synthesize spriteBody = _spriteBody;
@synthesize spriteFlame = _spriteFlame;

+ (id) InitWithGame:(Game*)game Position:(CGPoint) position {
	return [[self alloc] initWithMissile:(Game*)game Position:(CGPoint)position] ;
}

- (id) initWithMissile:(Game*)game Position:(CGPoint) position {
    if ((self = [super init])) {
        self.game = game;
        _posY = position.y;
        _posX = position.x;
        self.spriteBody = [CCSprite spriteWithFile:@"Missile-hd.png"];
        self.spriteBody.tag = -4;
        [self addChild:_spriteBody];
        //self.spriteFlame = [CCSprite spriteWithFile:@"MissileFlame-hd.png"];
        //[self addChild:_spriteFlame];
        
        [self addBody];
        [self updateNode];
    }
    return self;
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
    
    _body->ApplyLinearImpulse(b2Vec2(0, -5), _body->GetPosition());
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_body forShapeName:@"Missile-hd"];
}

- (void) updateNode {
	CGPoint p;
//	p.x = _body->GetPosition().x * [Box2DHelper pointsPerMeter];
//	p.y = _body->GetPosition().y * [Box2DHelper pointsPerMeter];
    p.x = _body->GetPosition().x;
	p.y = _body->GetPosition().y;
    
//    CGPoint p2;
//    p2.x = _body->GetPosition().x;
//    p2.y = _body->GetPosition().y;
    
    // CCNode position and rotation
    _spriteBody.position = p;
//    _spriteFlame.position = p2;
    //self.position = p;
}

@end
