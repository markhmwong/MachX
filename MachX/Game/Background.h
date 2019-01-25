//
//  Background.h
//  CrazyPlanes_cc2
//
//  Created by Mark Wong on 16/10/12.
//  Copyright 2012 Mark Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCParallaxScrollNode.h"
#import "Game.h"
@class Game;
@interface Background : CCLayer {
    CCParallaxScrollNode *_parallax;
    CCParallaxScrollNode *_parallax_Border;
    CCParallaxScrollNode *_parallax_Border_Glow;
    CCParallaxScrollNode *_parallax_Pillar;
    CCParallaxScrollNode *_parallax_LightBorder;
    CCParallaxScrollNode *_parallax_Lights;
    CCParallaxScrollNode *_env_clouds;
    Game *_game;
    double _time;
    CCSprite *_parallaxBG;
    Boolean _newEvent;
    double _dtEvent;
    double _nextEvent;
    CCTexture2D* _tex;
    CCSprite *_pillar;
    CCSprite *_pillar2;
    CCSprite *_lights;
    CCSprite *_lights2;
    CCSprite *_lights_Right;
    CCSprite *_lights2_Right;
    CCSprite *_Border_Left_1;
    CCSprite *_Border_Left_2;
    CCSprite *_Border_Right_1;
    CCSprite *_Border_Right_2;
    CCSprite *_Border_Left_1_Glow;
    CCSprite *_Border_Left_2_Glow;
    CCSprite *_Border_Right_1_Glow;
    CCSprite *_Border_Right_2_Glow;
    
    CCSprite *_opticalLense;
    float opticalLenseY;
    float opticalLenseX;
    CGSize _winSize;
    BOOL _lenseFlag;
    BOOL _lenseSpawn;
    BOOL _lenseFinish;
    
    BOOL wallLight;
    BOOL darkenBG;
}

@property (nonatomic, strong) Game *game;
@property (nonatomic, assign) BOOL darkenBG;

//+ (id) backgrounWithGame:(Game*)game;
//- (id) initWithBackground:(Game*)game;
+ (id) background;
- (id) initWithBackground;
- (void) updateVelocity:(CGPoint) position delta:(ccTime)dt;
- (void) turnOffWallLight;
- (void) darkenWalls;
- (void) lightenWalls;
- (void) redFlashingWalls;
- (void) darkenWallsMainMenu;
@end
