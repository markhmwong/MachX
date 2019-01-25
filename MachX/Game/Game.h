//
//  Game.h
//  CrazyPlanes_cc2
//
//  Created by Mark Wong on 30/09/12.
//  Copyright 2012 Mark Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "CCParallaxScrollNode.h"
#import "Player.h"
#import "Terrain.h"
#import "GLES-Render.h"
#import "GameHUD.h"
#import "Background.h"
#import "MyContactListener.h"
#import "Wall.h"
#import "WallLight.h"
#import "LevelXPHelper.h"
#import "XPDetector.h"
#import "XPManager.h"
#import "MachWave.h"
#import "CCShake.h"
#import "PowerupSpeedBoost.h"
#import "PowerupCoin.h"
#import "SideWall.h"
#import "CCHoldableMenuItemSprite.h"
#import "EnemyHelper.h"
#import "DebuffReverse.h"
#import "PowerupSlowmo.h"
#import "PowerupShield.h"
#import "DebuffSlowCharge.h"
#import "DebuffSlow.h"
#import "PowerupFullShield.h"
#import "LaserBeam.h"
#import "EndGame.h"
#import "ShootingStars.h"
#import "Missile.h"
#import "Explosion.h"

//Sound
#import "SimpleAudioEngine.h"

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

@interface Game : CCLayer {
    int _machLevel;
    Background *_parallax;
    float time;
    MissileBarrage *_nukeEvent;
    BOOL _newGameDelay;
    
    //World Objects
    Player *_player;
    Terrain *_terrain;
    XPDetector *_xpDetector;
    SideWall *_sideWallLeft;
    SideWall *_sideWallRight;
    b2Body *_body;
    b2World* _world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
    CCLayerColor *_background;
    CCLayerColor *_background2;
    id _flash;
    ShootingStars *_shootingStarsLayer;
    
    //HUDLayer
    GameHUD *_HUD;
    BOOL _closeCallBuffer;
    
    CCHoldableMenuItemSprite *_shieldButton;
    CCHoldableMenuItemSprite *_boostButton;

    //Record Line
    CCSprite *_recordLine;
    
    //distance
    CCLabelTTF *distanceLabel;
    //int distance;
    
    //terrain movement
    int _terrainMovement;
    
    //Player Stuff
    float _rechargeDelay;
    BOOL _startRecharge;
    BOOL _recharge;
    BOOL _checkIfShieldIsCritical;
    BOOL _checkIfShieldIsNominal;
    BOOL _showHiScore;
    int _hiScorePosY;
    //Score
    float _distance;
    
    //Collision
    MyContactListener *_contactListener;
    
    //Walls
    Wall *_leftWall;
    Wall *_rightWall;
    Wall *_middleWall;
    Wall *_middleLeftWall;
    Wall *_middleRightWall;
    NSMutableArray *_xpWallArray;
    NSMutableArray *_xpWallCountArray;
    int _nextWallPosY;
    int _prevWallPosY;
    int _offscreenSpawnPosY;
    
    //Powerups
    PowerupSpeedBoost *_speedPowerup;
    PowerupCoin *_coinPowerup;
    PowerupShield *_rechargeShield;
    PowerupFullShield *_fullShield;
    DebuffReverse *_reverse;
    PowerupSlowmo *_slowmo;
    DebuffSlow *_slow;
    DebuffSlowCharge *_slowCharge;
    BOOL _powerupBoost;
    
    BOOL _coinSpawnLeft;
    BOOL _coinSpawnRight;
    BOOL _coinSpawnMiddle;
    BOOL _powerup;
    BOOL _powerupCoin;
    BOOL _shieldEnabled;
    BOOL _boostEnabled;
    BOOL _reverseDebuff;
    BOOL _shieldPowerup;
    int _reverseControls;
    BOOL _slowmoPowerup;
    BOOL _slowDebuff;
    BOOL _slowChargeDebuff;
    BOOL _fullShieldPowerup;
    BOOL _powerupSpawnReset;
    BOOL _powerupIndicator;
    
    //Timers
    float _intervalLevel;
    float _levelTimer;
    float _wallSpawnTimer;
    int _wallTimerdt;
    int _prevSpawnPosition;
    int _newSpawnPosition;
    int _minSpawnPosition;
    float _slowDownDelay;
    float _randomSpawnTimer;
    float _closeCallTimer;
    float _countDown;
    float _powerupTimer;
    float _nextPowerupTime;
    float _coinTime;
    float _coinTimer;
    float _reverseTimer;
    float _slowmoTimer;
    float _globalEventTimer;
    float _globalEventTime;
    float _breakTimer;
    float _breakTime;
    float _laserBeamTimer;
    float _laserBeamTime;
    float _slowmoTime;
    float _missileTime;
    float _missileTimer;
    double _reticleTime;
    double _reticleTimer;
    double _delayMachWaveTimer;
    
    //Event
    BOOL _newEvent;
    BOOL _nukeEvent2;
    BOOL _wallLight;
    int _eventType;
    BOOL _shutdownEvent;
    BOOL _collaspingWallEvent;
    BOOL _massiveShipEvent;
    BOOL _eventFinishedState;
    BOOL _machWaveEvent;
    BOOL _tutorialEvent;
    BOOL _movingWall;
    
    //ENEMIES
    MachWave *_machWave;
    BOOL _delayMachWave;
    BOOL _enableMachWaveAfterDelay;
    LaserBeam *_laserBeam;
    LaserBeam *_laserBeam1;
    LaserBeam *_laserBeam2;
    LaserBeam *_laserBeam3;
    LaserBeam *_laserBeam4;
    Missile *_missile;
    Missile *_missile2;
    Missile *_missile3;
    Missile *_missile4;
    Missile *_missile5;
    Missile *_missile6;
    Missile *_missile7;
    Missile *_missile8;
    Explosion *_explosion;
    
    //LASERBEAM VARIABLES
    BOOL _laserBeamEvent;
    BOOL _break;
    BOOL _tutorial;
    NSMutableArray *_laserBeamArray;
    int _numOfBeams;
    
    //MISSILE VARIABLES
    int _reticleX;
    int _reticleY;
    int _prevReticleX;
    int _prevReticleY;
    NSMutableArray *_missileArray;
    NSMutableArray *_missileWarningArray;
    NSMutableArray *_explosionArray;
    CCSprite *_missileWarning;
    
    //UI
    CCMenu *_ingameMenu;
    CCSprite *_pauseBorder;
    CCMenuItemSprite *_BGMButton;
    CCMenuItemSprite *_SFXButton;
    CCMenuItemSprite *_powerupButton1;
    CCMenuItemSprite *_powerupButton2;
    CCMenu *_powerupMenu;
    CCSprite *_tiltLeft;
    CCSprite *_tiltRight;
    CCLabelTTF *_tiltText;
    CGSize _winSize;
    
    //Managers
    XPManager *_xpManager;
    EnemyHelper *_enemyHelper;
    PlayerStats *_playerStats;
    
    //Powerup
    BOOL magnetState;
    BOOL doubleCreditsState;
    BOOL extraLifeState;
    CCSprite *_powerupSlot1;
    CCSprite *_powerupSlot2;
    int _spaceBridgeType;
    
    //Bonus
    int _bonusCredits;
}

@property (nonatomic, readonly) b2World *world;
@property (nonatomic, strong) Player *player;
@property (nonatomic, strong) Terrain *terrain;
@property (nonatomic, strong) GameHUD *HUD;
@property (nonatomic, strong) Background *parallax;
@property (nonatomic, strong) Wall *leftWall;
@property (nonatomic, strong) Wall *rightWall;
@property (nonatomic, strong) Wall *middleWall;
@property (nonatomic, strong) XPDetector *xpDetector;
@property (nonatomic, strong) SideWall *sideWallLeft;
@property (nonatomic, strong) SideWall *sideWallRight;
@property (nonatomic, strong) PowerupSpeedBoost *speedPowerup;

+ (CCScene *) scene;
- (void) update:(ccTime)dt;
- (void) spawnRandomWall;
- (void) eventLabel:(NSString*) label;
- (void) spawnPowerup:(ccTime)dt;
@end