//
//  XPDetector.h
//  MachX
//
//  Created by Mark Wong on 24/12/12.
//  Copyright 2012 Whizbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GB2ShapeCache.h"
#import "Game.h"

@interface XPDetector : CCNode {
    CCSprite *_sprite;
    b2Body *_body;
    Game *_game;
}

+ (id) InitWithGame:(Game*)game;
- (id) initWithXPDetector:(Game*)game;
- (void) updatePosition:(CGPoint)position;

@property (nonatomic, strong) Game *game;
@property (readwrite) b2Body * body;
@property (nonatomic, strong) CCSprite *sprite;

@end
