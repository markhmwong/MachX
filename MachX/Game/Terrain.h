//
//  Terrain.h
//  CrazyCars
//
//  Created by Mark Wong on 12/05/12.
//  Copyright 2012 Whizbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "Box2DHelper.h"
#import "GB2ShapeCache.h"
#import "Game.h"

@class Game;

@interface Terrain : CCNode {
    GLESDebugDraw *_debugDraw;
	b2World *world;
    int screenW;
	int screenH;
    b2Body *_leftBorderBody;
    b2Body *_rightBorderBody;
    b2BodyDef _leftBorderDef;
    CCSprite *_leftBorder;
}

@property (nonatomic, assign) float offsetY;

+ (id) terrainWithWorld:(b2World*)w;
- (id) initWithWorld:(b2World*)w;

//- (void) setupDebugDraw;

@end
