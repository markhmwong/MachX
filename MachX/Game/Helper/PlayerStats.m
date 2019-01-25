//
//  PlayerStats.m
//  MachX
//
//  Created by Mark Wong on 22/01/13.
//  Copyright 2013 Whizbang. All rights reserved.
//

#import "PlayerStats.h"


@implementation PlayerStats
@synthesize shieldBoostValue = _shieldBoostValue;
@synthesize shieldBoostMaxValue = _shieldBoostMaxValue;
@synthesize score = _score;
@synthesize distance = _distance;
@synthesize credits = _credits;
@synthesize powerups = _powerups;
@synthesize obstacles = _obstacles;

+ (id)sharedXPManager {
    static id sharedXPManager = nil;
    
    if (sharedXPManager == nil) {
        sharedXPManager = [[self alloc] init];
    }
    
    return sharedXPManager;
}

- (id) init
{
	if( (self=[super init]) ) {
        _velocity = 6.0; //5.5 to 25
        _turningRate = 0.55; //.35 to .40
        _shieldBoostRechargeRate = 1;
        _shieldBoostValue = 1000;
        _shieldBoostMaxValue = _shieldBoostValue;
        _recoveryRate = 1.05;
    }
	return self;
}

- (int) getShieldBoostMax {
    //_shieldBoostMaxValue = 1000;
    return _shieldBoostMaxValue;
}

- (int) getShieldBoostValue {
    return _shieldBoostValue;
}

- (void) setShieldBoostValue:(int)value {
    //Based on Level?
    _shieldBoostValue = value;
}

- (float) getTurningRate {
    return _turningRate;
}

- (float) getRecoveryRate {
    return _recoveryRate;
}

- (int) getRechargeRate {
    return _shieldBoostRechargeRate;
}

- (float) getVelocity {
    return _velocity;
}

- (int) getPlayerLevel {
    return _playerLevel;
}

- (float) getVelocityBasedOnMachLevel:(int) machLevel {
    return _velocity + machLevel * 0.25;
}

- (int) getDistance {
    return _distance;
}

- (int) getScore {
    return _score;
}

- (int) getCredits {
    return _credits;
}

- (int) getPowerups {
    return _powerups;
}

- (int) getObstacles {
    return _obstacles;
}

//testing purposes
- (void) setVelocityBaseOnMachLevel:(int) machLevel {
    _velocity = _velocity + machLevel * 0.25;
}

- (void) setMachWaveDamage:(int) machLevel {
    //based on mach level
    _machWaveDamage = machLevel * 0.8;
}

- (void) setWallDamage {
    //based on mach level
    
}

- (void) setMeteorDamage {
    //Based on mach level
    
}

- (void) setLaserDamage {
    
}

- (void) setDistance:(int)distance {
    _distance = distance;
}

- (void) setScore:(int)score {
    _score = score;
}

- (void) setCredits:(int)credits {
    _credits = credits;
}

- (void) setPowerups:(int)powerups {
    _powerups = powerups;
}

- (void) setObstacles:(int)obstacles {
    _obstacles = obstacles;
}

- (void) wallDamage {
    _shieldBoostValue = _shieldBoostValue - 3;
}

- (void) laserDamage {
    _shieldBoostValue = _shieldBoostValue - 2;
}

- (void) machNovaDamage {
    _shieldBoostValue = _shieldBoostValue - 1;
}

- (void) explosionDamage {
   _shieldBoostValue = _shieldBoostValue - 1;
}

- (void) meteorDamage {
    _shieldBoostMaxValue = _shieldBoostValue - 6;
}

- (void) applyBoost {
    //_shieldBoostValue = _shieldBoostValue - 3;
}

@end
