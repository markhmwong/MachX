//
//  GameUI.h
//  CrazyPlanes_cc2
//
//  Created by Mark Wong on 14/10/12.
//  Copyright 2012 Mark Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "XPManager.h"
#import "PlayerStats.h"
#import "Game.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import "SDCloudUserDefaults.h"
#import "GameManager.h"
#import "Background.h"
#import "StoreMenuLayer.h"
#import "MachXIAPHelper.h"
#import "CCLayerOpaque.h"
#import "GameKitHelper.h"
#import "MainScreen.h"

@class Background;

@interface EndGame : CCLayer {
    CGSize _winSize;
    XPManager *_xpManager;
    PlayerStats *_playerStats;
    CCMenu *_endGameMenu;
    
    //CCParallaxScrollNode *_parallax;
    CCSprite *_parallaxBG;
    CCSprite *_pillar;
    CCSprite *_pillar2;
    
    Background *_parallax;
    CCLayerColor *_background;
    StoreMenuLayer *_storeMenuLayer;

    CCLayer *_storeLayer;
    CCLayer *_scoresLayer;
    CCLayer *_statsLayer;
    CCScrollLayer *_scrollerMenu;
    
    int menuState;
    BOOL _checkInitialNetworkStatus;

    //Twitter
    UIViewController *viewController;
    
    //Stats
    //int _creditsCollected;
}

+(CCScene *) scene;
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) Background *parallax;

@end
