//
//  Player.m
//  CCParallaxScrollNodeTest
//
//  Created by Mark Wong on 29/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"


@implementation Player
@synthesize cruiseRate = _cruiseRate;
@synthesize boost = _boost;
@synthesize spriteBody = _spriteBody;
@synthesize turnRate = _turnRateStat;
@synthesize weaponPower = _weaponPower;
@synthesize body = _body;
@synthesize game = _game;
@synthesize tut = _tut;
@synthesize hitWall = _hitWall;
@synthesize hitExplosion = _hitExplosion;
@synthesize minVelY = _minVelY;
@synthesize maxVelY = _maxVelY;
@synthesize playerLevel = _playerLevel;
@synthesize playerXP = _playerXP;
@synthesize levelUp = _levelUp;
@synthesize damage = _damage;
@synthesize speedPowerup = _speedPowerup;
@synthesize credits = _credits;
@synthesize powerups = _powerups;
@synthesize jetThrusters = _jetThruster;
@synthesize isInvulnerable = _isInvulnerable;

+ (id) InitWithGame:(Game*)game {
	return [[self alloc] initWithPlayer:(Game*)game];
}

+ (id) InitWithTut:(Tutorial*) tut {
    return [[self alloc] initWithPlayerTut:(Tutorial*)tut];
}

- (id) initWithPlayerTut:(Tutorial*)tut {
    if ((self = [super init])) {
        _cruiseSpeed = [_playerStats getVelocity];
        _minVelY = _cruiseSpeed;
        _maxVelY = (_cruiseSpeed * .1) + _cruiseSpeed;
        _recoveryRate = [_playerStats getRecoveryRate];
        _hitWall = FALSE;
        _hitExplosion = FALSE;
        _collisionRate = _minVelY * 0.6;
        _turnRateStat = [_playerStats getTurningRate];
        _rechargeRate = [_playerStats getRechargeRate];
        
        self.tut = tut;
        self.spriteBody = [CCSprite spriteWithFile:@"Player-hd.png"];
        _spriteBody.tag = 1;
        [self addChild:_spriteBody];
        
        _jetThruster = [CCSprite spriteWithFile:@"jetThruster-hd.png"];
        _jetThruster.position = ccp(0, -20);
        _jetThruster.opacity = 0;
        _jetThruster.scaleY = 0.2;
        [self addChild:_jetThruster];
        
        
        _boostPowerup = [CCSprite spriteWithFile:@"PlayerBoost-hd.png"];
        _boostPowerup.opacity = 0;
        _boostPowerup.position = ccp(0, -68);
        [self addChild:_boostPowerup];
        
        _shield = [CCSprite spriteWithFile:@"PlayerShield-hd.png"];
        _shield.opacity = 0;
        _shield.position = ccp(0, 15);
        [self addChild:_shield];
        
        //Box2D Body
        [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"SpaceShipModelDef-hd.plist"];
        b2BodyDef bd;
        bd.type = b2_dynamicBody;
        bd.linearDamping = 0.05f;
        bd.fixedRotation = true;
        bd.userData = (__bridge void*)_spriteBody;
        
        CGPoint p = ccp(160, 100);
        bd.position.Set(p.x * [Box2DHelper metersPerPoint], p.y * [Box2DHelper metersPerPoint]);
        _body = _tut.world->CreateBody(&bd);
        
        [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_body forShapeName:@"Player-hd"];
        [_spriteBody setAnchorPoint:[[GB2ShapeCache sharedShapeCache] anchorPointForShape:@"Player-hd"]];
        
        [self updateNode];

    }
    return self;
}

- (id) initWithPlayer:(Game*)game {
    if ((self = [super init])) {
        //stats
        _xpManager = [XPManager sharedXPManager];
        _playerStats = [PlayerStats sharedXPManager];
        
        //PLAYER STATS STUFF
        _cruiseSpeed = [_playerStats getVelocity];
        _minVelY = _cruiseSpeed;
        _maxVelY = (_cruiseSpeed * .1) + _cruiseSpeed;
        _recoveryRate = [_playerStats getRecoveryRate];
        _hitWall = FALSE;
        _hitExplosion = FALSE;
        _collisionRate = _minVelY * 0.6;
        _turnRateStat = [_playerStats getTurningRate];
        _rechargeRate = [_playerStats getRechargeRate];

        //XP STUFF
        _playerLevel = [self getPlayerLevel];
        _playerXP = [self getPlayerXP];
        _nextXPLevel = [LevelXPHelper nextLevel:_playerLevel];
        
        //IN-GAME STUFF
        _machCombo = 0;
        _credits = 0;
        _powerups = 0;
        _obstacles = 0;
        
        self.game = game;
        self.spriteBody = [CCSprite spriteWithFile:@"Player-hd.png"];
        _spriteBody.tag = 1;
        [self addChild:_spriteBody];
        
        _jetThruster = [CCSprite spriteWithFile:@"jetThruster-hd.png"];
        _jetThruster.position = ccp(0, -20);
        _jetThruster.opacity = 0;
        _jetThruster.scaleY = 0.2;
        [self addChild:_jetThruster];
        
        
        _boostPowerup = [CCSprite spriteWithFile:@"PlayerBoost-hd.png"];
        _boostPowerup.opacity = 0;
        _boostPowerup.position = ccp(0, -68);
        [self addChild:_boostPowerup];
        
        _shield = [CCSprite spriteWithFile:@"PlayerShield-hd.png"];
        _shield.opacity = 0;
        _shield.position = ccp(0, 15);
        [self addChild:_shield];
        
        //Box2D Body
        [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"SpaceShipModelDef-hd.plist"];
        b2BodyDef bd;
        bd.type = b2_dynamicBody;
        bd.linearDamping = 0.05f;
        bd.fixedRotation = true;
        bd.userData = (__bridge void*)_spriteBody;
        
        CGPoint p = ccp(160, 100);
        bd.position.Set(p.x * [Box2DHelper metersPerPoint], p.y * [Box2DHelper metersPerPoint]);
        _body = _game.world->CreateBody(&bd);

        [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_body forShapeName:@"Player-hd"];
        [_spriteBody setAnchorPoint:[[GB2ShapeCache sharedShapeCache] anchorPointForShape:@"Player-hd"]];
        
        
        //[self addShieldBar];
        [self updateNode];
    }
    return self;
}

- (void) shieldDamage {
    _shield.opacity = 255;
    [_shield runAction:[CCFadeTo actionWithDuration:0.6f opacity:0]];
}

- (void) addShieldBar {
    CCSprite *shieldBar = [CCSprite spriteWithFile:@"ShieldBar-hd.png"];
    shieldBar.color = ccc3(0, 50, 0);
    [self addChild:shieldBar];
}

- (void) updateNode {
    CGPoint p;
	p.x = _body->GetPosition().x * [Box2DHelper pointsPerMeter];
	p.y = _body->GetPosition().y * [Box2DHelper pointsPerMeter];
	
    // CCNode position and rotation
    self.position = p;

    b2Vec2 vel = _body->GetLinearVelocity();
    float angle = atan2f(vel.x, vel.y);
    
	self.rotation = 1 * CC_RADIANS_TO_DEGREES(angle) * .15;//.30 a good turning value
    _body->SetTransform(_body->GetPosition(), -angle *.15);
    
    //fire thrusters
    if (_boost && _thruster) {
        [self fireThrusters];
        _thruster = FALSE;
    }
    
    if (!_thruster && !_boost) {
        [self stopThrusters];
    }
}

- (void) updatePhysics {
	// limit velocity
    b2Vec2 vel = _body->GetLinearVelocity();
    
	if (_hitWall && !_isInvulnerable) {
        //slowdown rate
        if  (_minVelY > _collisionRate) {
            _minVelY = _minVelY * 0.95;
        }
    }
    else if (_hitExplosion) {
        if  (_minVelY > _collisionRate) {
            _minVelY = _minVelY * 0.99;
        }
    }
    else {
        //ramp up
        if (_boost) {
            if ([_playerStats getShieldBoostValue] >= 0) {
                _minVelY = (_cruiseSpeed * 0.2) + _cruiseSpeed;
                _maxVelY = (_cruiseSpeed * 0.2) + _cruiseSpeed;
                [_playerStats applyBoost];
            }
            else if ([_playerStats getShieldBoostValue] >= 0 && _hitWall) {
                _minVelY = (_cruiseSpeed * 0.05) + _cruiseSpeed;
                _maxVelY = (_cruiseSpeed * 0.05) + _cruiseSpeed;
                [_playerStats applyBoost];
            }
        }
        else {
            if (_minVelY < _cruiseSpeed) {
                _minVelY = _minVelY * _recoveryRate;
            }
            else {
                _minVelY = _cruiseSpeed;
                _maxVelY = _cruiseSpeed;
            }
        }
    }
    
    //min speed unless hitting wall should go below
	if (vel.y <= _minVelY) {
		vel.y = _minVelY;
	}
    if (vel.y > _maxVelY) {
        vel.y = _maxVelY;
    }
    
	_body->SetLinearVelocity(vel);
}

- (BOOL) getBoost {
    return _boost;
}

- (BOOL) shieldIsNotEmpty {
    if ([_playerStats getShieldBoostValue] >= 0) {
        return TRUE;
    }
    else {
        return FALSE;
    }
}

- (float) getPositionY {
    return _body->GetPosition().y * [Box2DHelper pointsPerMeter];
}

- (float) getPositionX {
    return _body->GetPosition().x * [Box2DHelper pointsPerMeter];
}

- (b2Vec2) getLinearVelocity {
    return _body->GetLinearVelocity();
}

- (float) getTurnSpeedStat {
    return _turnRateStat;
}

- (b2Vec2) getBodyPosition {
    return _body->GetPosition();
}

- (void) applyBoost {
    _body->ApplyLinearImpulse(b2Vec2(0, (_cruiseSpeed * 20.5) + _cruiseSpeed), [self getBodyPosition]);
}

- (void) setBoost:(BOOL)boost {
    _boost = boost;
    _thruster = boost;
}

- (void) setCruiseSpeed {
    if (_cruiseSpeed < 25.0) {
        _cruiseSpeed = _cruiseSpeed + 0.6;
    }
    else {
        _cruiseSpeed = 25;
    }
}

- (void) setMaxSpeed {
    _maxVelY = (_cruiseSpeed * 0.1) + _cruiseSpeed;
}

- (int) getPlayerLevel {
    //get playerlevel from saved stats
    int playerLevel = 1;
    
    return playerLevel;
}

- (int) getPlayerXP {
    int playerXP = 0;
    
    return playerXP;
}

- (int) getNextXPLevel {
    return [LevelXPHelper nextLevel:_playerLevel];
}

- (void) levelUpPlayer:(int)playerLevel {
    //Level Up!
    if (_playerXP > _nextXPLevel) {
        //add level
        _playerLevel = playerLevel + 1;
        //assign new nextXPLevel
        _nextXPLevel = [LevelXPHelper nextLevel:_playerLevel];
        //play animation
        //play sound
    }
}

- (void) checkXPLevel {
    if  ([_xpManager getPlayerXP] >= [LevelXPHelper nextLevel:[_xpManager getPlayerLevel]]) {
        _levelUp = TRUE;
        //NSLog(@"LevelUp");
        [_xpManager incrementPlayerLevel];
    }
}

- (void) addWallXP:(BOOL)xpTag {
    if (xpTag) {
        _playerXP = _playerXP + 1000;
    }
}

- (CGPoint) getPlayerPosition {
    return ccp(_body->GetPosition().x * [Box2DHelper pointsPerMeter], _body->GetPosition().y * [Box2DHelper pointsPerMeter]);
}

- (b2Vec2) getPlayerVelocity {
    return _body->GetLinearVelocity();
}

- (BOOL) getHitWall {
    return _hitWall;
}

- (void) printXP {
    NSLog(@"XP: %d", _playerXP);
}

- (void) printVelocityY {
    NSLog(@"Player Vel.y %f", _body->GetLinearVelocity().y);
}

- (void) printPositionY {
    NSLog(@"player %f", _body->GetPosition().y * [Box2DHelper pointsPerMeter]);
}

- (float) getPlayerCruiseSpeed {
    return _cruiseSpeed;
}

- (BOOL) checkShieldDeath {
    if ([_playerStats getShieldBoostValue] <= 0) {
        _dead = TRUE;
    }
    else {
        _dead = FALSE;
    }
    return _dead;
}

- (void) takeWallDamage:(int)machLevel {
    //for spacebridge powerup
    if (!_isInvulnerable) {
        [_playerStats wallDamage];
        [self shieldDamage];
        //Reset cruise Speed
        _cruiseSpeed = [_playerStats getVelocityBasedOnMachLevel:machLevel];
        //Reset turning speed
        _turnRateStat = 0.35;//turning speed based on player level
        [self stopBoostAnimation];
    }
}

- (void) takeLaserDamage:(int)machLevel {
    if (!_isInvulnerable) {
        [_playerStats laserDamage];
        [self shieldDamage];
    }

}

- (void) takeMachNovaDamage:(int)machLevel {
    if (!_isInvulnerable) {
        [_playerStats machNovaDamage];
        [self shieldDamage];
    }
}

- (void) takeExplosionDamage:(int)machLevel {
    if (!_isInvulnerable) {
        [_playerStats explosionDamage];
        [self shieldDamage];
    }
}

- (void) rechargeShield {
    //Recharges the shield
    //NSLog(@"shield %d", [_playerStats getShieldBoostValue]);
    [_playerStats setShieldBoostValue:[_playerStats getShieldBoostValue] + [_playerStats getRechargeRate]];
}

- (void) rechargeShieldPowerup {
    [_playerStats setShieldBoostValue:[_playerStats getShieldBoostValue] + ([_playerStats getRechargeRate] * 6)];
}

- (void) slowDebuff {
    [_playerStats setVelocity:[_playerStats getVelocity] - ([_playerStats getVelocity] / 2)];
}

- (void) slowChargeDebuff {
    [_playerStats setShieldBoostValue:[_playerStats getShieldBoostValue] + ([_playerStats getRechargeRate] / 2)];
}

- (BOOL) checkIfShieldIsFull {
    if ([_playerStats getShieldBoostValue] == [_playerStats getShieldBoostMax]) {
        return TRUE;
    }
    else {
        return FALSE;
    }
}

- (BOOL) checkIfShieldIsCritical {
    //make it a percentage
    int energyValue = [_playerStats getShieldBoostValue];
    if (energyValue <= 300) {
        return TRUE;
    }
    else {
        return FALSE;
    }
}

- (BOOL) checkIfShieldIsNominal {
    int energyValue = [_playerStats getShieldBoostValue];
    if (energyValue > 300) {
        return TRUE;
    }
    else {
        return FALSE;
    }
}

- (void) fireThrusters {
    [_jetThruster runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCFadeTo actionWithDuration:0.1f opacity:200], [CCFadeTo actionWithDuration:0.1f opacity:255], nil]]];
    [_jetThruster runAction:[CCScaleTo actionWithDuration:0.1f scaleX:1 scaleY:1]];
}

- (void) stopThrusters {
    //NSLog(@"test");
    [_jetThruster stopAllActions];
    _jetThruster.opacity = 0;
    _jetThruster.scaleY = 0.2f;
    //[_jetThruster runAction:[CCFadeTo actionWithDuration:0.3f opacity:0]];
}

- (void) boostAnimation {
    //_boostPowerup.opacity = 255;
    [_boostPowerup runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCFadeTo actionWithDuration:0.1f opacity:230], [CCFadeTo actionWithDuration:0.1f opacity:255], nil]]];
    [_boostPowerup runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.1f scale:1.03], [CCScaleTo actionWithDuration:0.1f scale:0.98], nil]]];
}

- (void) stopBoostAnimation {
    [_boostPowerup stopAllActions];
    _boostPowerup.opacity = 0;
    
}

- (void) shieldAnimation {
    
}

- (void) setShieldToMax {
    [_playerStats setShieldBoostValue:[_playerStats getShieldBoostMax]];
}

- (void) setHitWall:(BOOL)hitWall {
    _hitWall = hitWall;
}

- (void) setHitExplosion:(BOOL)hitExplosion {
    _hitExplosion = hitExplosion;
}

- (void) activateSpeedPowerup {
    if (_machCombo < 5) {
        _machCombo++;
        //Increase Velocity Y
        _cruiseSpeed = _cruiseSpeed + 5.0;//was 3.0
        //Increase Turn Speed
        _turnRateStat = _turnRateStat + 0.08;//was 0.05
    }
}

- (void) resetShield {
    [_playerStats setShieldBoostValue:[_playerStats getShieldBoostMax]];
}

- (int) getMachCombo {
    return _machCombo;
}

- (void) addCredits:(int)amount {
    _credits = _credits + amount;
    [_playerStats setCredits:_credits];
}

- (void) addPowerup:(int)amount {
    _powerups = _powerups + amount;
    [_playerStats setPowerups:_powerups];
}

- (void) addObstacle:(int)amount {
    _obstacles = _obstacles + amount;
    [_playerStats setObstacles:_obstacles];
}

- (void) resetCredits {
    [_playerStats setCredits:0];
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

- (float) getMachLevelVelocity:(int)machLevel {
    return [_playerStats getVelocityBasedOnMachLevel:machLevel];
}

- (void) spaceBridge1 {
    _cruiseSpeed = _cruiseSpeed + 30;
    _isInvulnerable = TRUE;
}

- (void) spaceBridge2 {
    _cruiseSpeed = _cruiseSpeed + 60;
    _isInvulnerable = TRUE;
}

- (void) spaceBridge3 {
    _cruiseSpeed = _cruiseSpeed + 120;
    _isInvulnerable = TRUE;
}

- (void) stopSpaceBridgePowerup {
    _isInvulnerable = FALSE;
    _cruiseSpeed = 6.0;
}

- (BOOL) getIsInvulnerable {
    return _isInvulnerable;
}

- (void) death {
    CCSprite *death = [CCSprite spriteWithFile:@"DeathExplosion-hd.png"];
    death.scale = 0;
    [self addChild:death];
    
    [death runAction:[CCScaleTo actionWithDuration:1.2 scale:1]];
}

@end
