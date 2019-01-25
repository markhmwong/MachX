//
//  XPDetector.m
//  MachX
//
//  Created by Mark Wong on 24/12/12.
//  Copyright 2012 Whizbang. All rights reserved.
//

#import "XPDetector.h"


@implementation XPDetector

@synthesize body = _body;
@synthesize game = _game;
@synthesize sprite = _sprite;

+ (id) InitWithGame:(Game*)game {
	return [[self alloc] initWithXPDetector:(Game*)game];
}

- (id) initWithXPDetector:(Game*)game {
    if ((self = [super init])) {
        self.game = game;
        [self addSprite];
        [self addBody];
    }
    return self;
}

- (void) addSprite {
    self.sprite = [CCSprite spriteWithFile:@"XPDetector-hd.png"];
    self.sprite.opacity = 0;
    _sprite.tag = -2;
    [self addChild:_sprite];
}

- (void) addBody {
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"XPDetector-hd.plist"];
    b2BodyDef bd;
    bd.type = b2_dynamicBody;
    bd.linearDamping = 0.05f;
    bd.fixedRotation = true;
    bd.userData = (__bridge void*)_sprite;
    
    CGPoint p = ccp(160, 80);
    bd.position.Set(p.x * [Box2DHelper metersPerPoint], p.y * [Box2DHelper metersPerPoint]);
    _body = _game.world->CreateBody(&bd);
    
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_body forShapeName:@"XPDetector-hd"];
    [_sprite setAnchorPoint:[[GB2ShapeCache sharedShapeCache] anchorPointForShape:@"XPDetector-hd"]];
}

- (void) updatePosition:(CGPoint)position {
    CGPoint p;
	p.x = _body->GetPosition().x * [Box2DHelper pointsPerMeter];
	p.y = _body->GetPosition().y * [Box2DHelper pointsPerMeter];
	
    // CCNode position and rotation
    //self.position = p;
    b2Vec2 pos;
    pos.x = 160 * [Box2DHelper metersPerPoint];
    pos.y = (position.y - 30) * [Box2DHelper metersPerPoint];
    _body->SetTransform(pos, 0);
}

@end