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
#import "Terrain.h"
#import "Player.h"

@class Explosion;
@class Wall;
@class WallGenerator;
@class Player;
@class Terrain;
@class Background;
@class MissileBarrage;
@class WallLight;
@class XPDetector;
@class MachWave;
@class PowerupSpeedBoost;
@class PowerupCoin;
@class PowerupSlowmo;
@class PowerupShield;
@class PowerupFullShield;
@class DebuffSlow;
@class DebuffReverse;
@class DebuffSlowCharge;
@class SideWall;
@class LaserBeam;
@class EndGame;
@class Missile;
@class GameHUD;
// HelloWorldLayer
@interface Tutorial : CCLayer
{
    Background *_parallax;
    CCLabelTTF *_playCountLabel;
    CCMenuItemSprite *_BGMButton;
    CCMenuItemSprite *_SFXButton;
    
    GLESDebugDraw *m_debugDraw;		// strong ref

    Player *_player;
    Terrain *_terrain;
    SideWall *_sideWallLeft;
    SideWall *_sideWallRight;
    b2Body *_body;
    b2World* _world;
    CCLayerColor *_background;
    CCLayerColor *_background2;
    BOOL _increaseSpeed;
    int _speed;
    int _textNum;
    id _flash;
    ShootingStars *_shootingStarsLayer;
    CCLabelTTF *_tutorialText;
    
    //HUDLayer
    GameHUD *_HUD;
    CGSize _winSize;
}

@property (nonatomic, readonly) b2World *world;
@property (nonatomic, strong) Background *parallax;
@property (nonatomic, strong) Player *player;
@property (nonatomic, strong) Terrain *terrain;
@property (nonatomic, strong) GameHUD *HUD;
@property (nonatomic, strong) Wall *leftWall;
@property (nonatomic, strong) Wall *rightWall;
@property (nonatomic, strong) Wall *middleWall;
@property (nonatomic, strong) SideWall *sideWallLeft;
@property (nonatomic, strong) SideWall *sideWallRight;
@property (nonatomic, strong) PowerupSpeedBoost *speedPowerup;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
