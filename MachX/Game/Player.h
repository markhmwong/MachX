//
//  Player.h
//  CCParallaxScrollNodeTest
//
//  Created by Mark Wong on 29/09/12.
//  Copyright 2012 Whizbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Game.h"
#import "GB2ShapeCache.h"
#import "Box2DHelper.h"
#import "LevelXPHelper.h"
#import "XPManager.h"
#import "PlayerStats.h"
#import "Tutorial.h"

@class Game;
@class Tutorial;
@interface Player : CCNode {
    @private float _cruiseSpeed;
    @private float _weaponPower;
    //weaponType variable
    CCSprite *_spriteBody;
    CCSprite *_leftWing;
    CCSprite *_rightWing;
    CCSprite *_jetThruster;
    CCSprite *_boostPowerup;
    CCSprite *_shield;
    Game *_game;
    Tutorial *_tutorial;
    b2Body *_body;
    
    //Stats
    @private float _turnRateStat;
    float _rechargeRate;
    
    //@private float _boostStat;
    @private float _shieldStat;
    @private float _minVelY;
    @private float _maxVelY;
    @private int _playerLevel;
    @private int _playerXP;
    @private int _nextXPLevel;
    @private int _credits;
    @private int _obstacles;
    @private int _powerups;

    BOOL _hitWall;
    BOOL _hitExplosion;
    BOOL _collide;
    BOOL _levelUp;
    BOOL _boost;
    BOOL _dead;
    BOOL _damage;
    BOOL _shieldEnabled;
    BOOL _boostEnabled;
    BOOL _thruster;
    BOOL _isInvulnerable;
    
    //Powerups
    BOOL _speedPowerup;
    BOOL _shieldPowerup;
    int _machCombo;
    
    float _collisionRate;
    float _recoveryRate;
    
    //Damage
    float _machWaveDamage;
    float _wallDamage;
    float _meteorDamage;
    
    XPManager *_xpManager;
    PlayerStats *_playerStats;
}

@property (readwrite, assign) float cruiseRate;
@property (readwrite, assign) float maxVelY;
@property (readwrite, assign) float turnRate;
@property (readwrite, assign) float weaponPower;
@property (readwrite, assign) int playerXP;
@property (readwrite, assign) int playerLevel;
@property (readwrite, assign) int nextXPLevel;
@property (readwrite, assign) int machCombo;
@property (nonatomic, strong) CCSprite *spriteBody;
@property (nonatomic, strong) CCSprite *jetThrusters;
@property (readwrite) b2Body * body;
@property (nonatomic, strong) Game *game;
@property (nonatomic, strong) Tutorial *tut;
@property (nonatomic) BOOL hitWall;
@property (nonatomic) BOOL hitExplosion;
@property (nonatomic, assign) BOOL levelUp;
@property (nonatomic, assign) BOOL boost;
@property (nonatomic, assign) BOOL dead;
@property (nonatomic, assign) BOOL isInvulnerable;
@property (nonatomic, assign) BOOL damage;
@property (readwrite, assign) float minVelY;
@property (nonatomic, assign) BOOL speedPowerup;
@property (nonatomic, assign) int credits;
@property (nonatomic, assign) int powerups;
@property (nonatomic, assign) int obstacles;

+ (id) InitWithGame:(Game*)game;
- (id) initWithPlayer:(Game*)game;
+ (id) InitWithTut:(Tutorial*)tut;
- (id) initWithPlayerTut:(Tutorial*)tut;

- (void) updateNode;
- (void) updatePhysics;

- (void) applyBoost;

- (void) levelUpPlayer:(int)playerLevel;
- (void) addWallXP:(BOOL)xpTag;
- (CGPoint) getPlayerPosition;
- (void) checkXPLevel;
- (void) activateSpeedPowerup;
- (void) rechargeShield;
- (void) resetShield;
- (void) rechargeShieldPowerup;
- (void) slowDebuff;
- (void) slowChargeDebuff;
- (BOOL) shieldIsNotEmpty;
- (void) boostAnimation;
- (void) shieldAnimation;
- (void) resetCredits;
- (void) spaceBridge1;
- (void) spaceBridge2;
- (void) spaceBridge3;
- (void) stopSpaceBridgePowerup;

- (void) takeWallDamage:(int)machLevel;
- (void) takeLaserDamage:(int)machLevel;
- (void) takeMachNovaDamage:(int)machLevel;
- (void) takeExplosionDamage:(int)machLevel;

- (BOOL) checkIfShieldIsFull;
- (BOOL) checkShieldDeath;
- (BOOL) checkIfShieldIsCritical;
- (BOOL) checkIfShieldIsNominal;

- (void) printVelocityY;
- (void) printPositionY;
- (void) printXP;

- (void) setCruiseSpeed;
- (void) setHitWall:(BOOL)hitWall;
- (void) setMaxSpeed;
- (void) setShieldToMax;
- (void) addCredits:(int)amount;
- (void) addPowerup:(int)amount;
- (void) addObstacle:(int)amount;

- (BOOL) getHitWall;
- (int) getPlayerLevel;
- (int) getPlayerXP;
- (b2Vec2) getPlayerVelocity;
- (BOOL) getBoost;
- (float) getPositionY;
- (float) getPositionX;
- (b2Vec2) getLinearVelocity;
- (float) getTurnSpeedStat;
- (b2Vec2) getBodyPosition;
- (float) getPlayerCruiseSpeed;
- (int) getMachCombo;
- (int) getCredits;
- (float) getMachLevelVelocity:(int)machLevel;
- (BOOL) getIsInvulnerable;

- (void) death;
@end
