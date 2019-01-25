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

@interface SideWall : CCNode {
    CCSprite *_sprite;
    b2Body *_body;
    Game *_game;
    CGPoint *_wallPosition;
    int _posX;
}

+ (id) InitWithGame:(Game*)game Position:(CGPoint)position;
- (id) initWithSideWall:(Game*)game Position:(CGPoint)position;
- (void) updatePosition:(CGPoint)position;

@property (nonatomic, strong) Game *game;
@property (readwrite) b2Body * body;
@property (nonatomic, strong) CCSprite *sprite;

@end
