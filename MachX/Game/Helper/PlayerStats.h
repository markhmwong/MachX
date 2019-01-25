//
//  PlayerStats.h
//  MachX
//
//  Created by Mark Wong on 22/01/13.
//  Copyright 2013 Whizbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PlayerStats : NSObject {
    //Stats Stuff
    float _turningRate;
    float _recoveryRate;
    float _velocity;
    int _shieldBoostValue;
    int _shieldBoostMaxValue;
    int _playerLevel;
    int _shieldBoostRechargeRate;
    int _score;
    int _distance;
    int _credits;
    int _powerups;
    int _obstacles;
    
    //Damage Stuff
    int _wallDamage;
    int _machWaveDamage;
    int _meteorDamage;
    
    int _playCount;
}

@property (nonatomic, assign) int shieldBoostValue;
@property (nonatomic, assign) int shieldBoostMaxValue;
@property (nonatomic, assign) float turningRate;
@property (nonatomic, assign) float velocity;
@property (nonatomic, assign) int playerLevel;
@property (nonatomic, assign) float recoveryRate;
@property (nonatomic, assign) int distance;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) int credits;
@property (nonatomic, assign) int powerups;
@property (nonatomic, assign) int obstacles;

+(id)sharedXPManager;

- (int) getShieldBoostMax;
- (int) getShieldBoostValue;
- (float) getTurningRate;
- (float) getVelocity;
- (int) getPlayerLevel;
- (float) getRecoveryRate;
- (int) getRechargeRate;
- (float) getVelocityBasedOnMachLevel:(int)machLevel;
- (int) getScore;
- (int) getDistance;
- (int) getCredits;
- (int) getPowerups;
- (int) getObstacles;

//Only if it is need to be grabbed from a database or an equation
- (void) setShieldBoostValue:(int)value;
- (void) setDistance:(int)distance;
- (void) setScore:(int)score;
- (void) setCredits:(int)credits;
- (void) setPowerups:(int)powerups;
- (void) setObstacles:(int)obstacles;

- (void) wallDamage;
- (void) laserDamage;
- (void) machNovaDamage;
- (void) explosionDamage;
- (void) meteorDamage;

- (void) applyBoost;
@end
