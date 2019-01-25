//
//  Walls.h
//  CrazyPlanes_cc2
//
//  Created by Mark Wong on 13/11/12.
//  Copyright 2012 Mark Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Game.h"
#import "GB2ShapeCache.h"
#import "Box2DHelper.h"
#import "XPManager.h"

@class Player;

@interface Wall : CCNode {
    CCSprite *_wallSprite;
    Game *_game;
    b2Body *_wallBody;
    CGPoint *_pos;
    int _machLevel;
    int _direction;
    BOOL _lights;
    BOOL _xpTag;
    BOOL _damagePlayer;
    BOOL _movingWall;
    Player *_player;
    XPManager *_xpManager;
}

@property (nonatomic, strong) Game *game;
@property (nonatomic, strong) CCSprite *wallSprite;
@property (readwrite) b2Body *wallBody;
@property (nonatomic, assign) BOOL xpTag;
@property (nonatomic, assign) BOOL damagePlayer;

+ (id) InitWallEasy:(Game*)game Position:(CGPoint)position machLevel:(int)level sprite:(NSString*)spriteName;
+ (id) InitWallEasyWithDirection:(Game*)game Position:(CGPoint)position machLevel:(int)level moveWall:(BOOL)moveWall direction:(int)direction sprite:(NSString*)spriteName;
- (id) initWithGameEasyWall:(Game*)game Position:(CGPoint)position machLevel:(int)level sprite:(NSString*)spriteName;
- (id) initWithGameEasyWallWithDirection:(Game*)game Position:(CGPoint)position machLevel:(int)level moveWall:(BOOL)moveWall direction:(int)direction sprite:(NSString*)spriteName;

+ (id) InitWallMedium:(Game*)game Position:(CGPoint)position machLevel:(int)level sprite:(NSString*)spriteName;
+ (id) InitWallMediumWithDirection:(Game*)game Position:(CGPoint)position machLevel:(int)level moveWall:(BOOL)moveWall direction:(int)direction sprite:(NSString*)spriteName;
- (id) initWithGameMediumWall:(Game*)game Position:(CGPoint)position machLevel:(int)level sprite:(NSString*)spriteName;
- (id) initWithGameMediumWallWithDirection:(Game*)game Position:(CGPoint)position machLevel:(int)level moveWall:(BOOL)moveWall direction:(int)direction sprite:(NSString*)spriteName;

+ (id) InitWallHard:(Game*)game Position:(CGPoint)position machLevel:(int)level sprite:(NSString*)spriteName;
+ (id) InitWallHardWithDirection:(Game*)game Position:(CGPoint)position machLevel:(int)level moveWall:(BOOL)moveWall direction:(int)direction sprite:(NSString*)spriteName;
- (id) initWithGameHardWall:(Game*)game Position:(CGPoint)position machLevel:(int)level sprite:(NSString*)spriteName;
- (id) initWithGameHardWallWithDirection:(Game*)game Position:(CGPoint)position machLevel:(int)level moveWall:(BOOL)moveWall direction:(int)direction sprite:(NSString*)spriteName;

- (void) createWallSpriteEasy:(NSString *)spriteName;
- (void) createWallBodyEasy:(NSString *)spriteName;
- (void) createWallSpriteMedium:(NSString *)spriteName;
- (void) createWallBodyMedium:(NSString *)spriteName;
- (void) createWallSpriteHard:(NSString *)spriteName;
- (void) createWallBodyHard:(NSString *)spriteName;

- (void) updateWall;
- (void) lightEvent;
- (void) setXpTag;
- (BOOL) tagXp;
- (BOOL) damage;

- (void) moveWall;
@end
