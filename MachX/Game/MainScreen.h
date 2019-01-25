//
//  IntroLayer.h
//  CrazyPlanes_cc2
//
//  Created by Mark Wong on 23/09/12.
//  Copyright Mark Wong 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Game.h"
#import "EndGame.h"
#import "ShootingStars.h"
#import "Background.h"
#import "SDCloudUserDefaults.h"
#import <Twitter/Twitter.h>
#import "GameManager.h"
#import "CCScrollLayer.h"
#import "StoreMenuLayer.h"
#import "CCLayerOpaque.h"
#import "MachXIAPHelper.h"
#import <GameKit/GameKit.h>
#import "Tutorial.h"

@class Game;
@class Background;

// HelloWorldLayer
@interface MainScreen : CCLayer <GKLeaderboardViewControllerDelegate>
{
    Background *_parallax;
    CCLabelTTF *_playCountLabel;
    CCMenuItemSprite *_BGMButton;
    CCMenuItemSprite *_SFXButton;
        
    BOOL _increaseSpeed;
    int _speed;

    CCLayer *_titleLayer;
    CCLayer *_settingsLayer;
    CCLayer *_storeLayer;
    CCLayer *_statsLayer;
    StoreMenuLayer *_storeMenuLayer;
    ShootingStars *_shootingStarsLayer;
    
    CCLayerColor *_background;
    CCLayerColor *_background2;
    id _flash;
    CCScrollLayer *_storeScrollLayer;
    CCMenu *_mainMenu;
    CCMenu *_settingsMenu;
    int _state;
    BOOL _canStartGame;
    BOOL _checkInitialNetworkStatus;
    
    CGSize _winSize;
    UIViewController *gcViewController;
}

@property (nonatomic, strong) Background *parallax;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
