//
//  XPDetector.m
//  MachX
//
//  Created by Mark Wong on 24/12/12.
//  Copyright 2012 Whizbang. All rights reserved.
//

#import "SideWall.h"


@implementation SideWall

@synthesize body = _body;
@synthesize game = _game;
@synthesize sprite = _sprite;

+ (id) InitWithGame:(Game*)game Position:(CGPoint)position {
	return [[self alloc] initWithSideWall:(Game*)game Position:(CGPoint)position];
}

- (id) initWithSideWall:(Game*)game Position:(CGPoint)position {
    if ((self = [super init])) {
        self.game = game;
        _wallPosition = &position;
        _posX = _wallPosition->x;

        [self addSprite];
        [self addBody];
    }
    return self;
}

- (void) addSprite {
    self.sprite = [CCSprite spriteWithFile:@"SideWall.png"];
    self.sprite.opacity = 0;
    _sprite.tag = 100;//!!!! must have proper tag or it will crash
    [self addChild:_sprite];
}

- (void) addBody {
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"SideWallDef.plist"];
    b2BodyDef bd;
    bd.type = b2_staticBody;
    bd.linearDamping = 0.05f;
    bd.fixedRotation = true;
    bd.userData = (__bridge void*)_sprite;
    
    CGPoint p = ccp(_wallPosition->x, _wallPosition->y);
    bd.position.Set(p.x * [Box2DHelper metersPerPoint], p.y * [Box2DHelper metersPerPoint]);
    _body = _game.world->CreateBody(&bd);
    
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_body forShapeName:@"SideWall"];
}

- (void) updatePosition:(CGPoint)position {
        
    b2Vec2 pos;
    pos.x = _posX * [Box2DHelper metersPerPoint];
    pos.y = (position.y) * [Box2DHelper metersPerPoint];
    _body->SetTransform(pos, 0);
}

@end