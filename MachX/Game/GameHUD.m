//
//  GameUI.m
//  CrazyPlanes_cc2
//
//  Created by Mark Wong on 14/10/12.
//  Copyright 2012 Mark Wong. All rights reserved.
//

#import "GameHUD.h"

#define font "Walkway Bold"

@implementation GameHUD

- (id) init {
    if((self=[super init])) {
        _xpManager = [XPManager sharedXPManager];
        _playerStats = [PlayerStats sharedXPManager];
        _winSize = [CCDirector sharedDirector].winSize;
//        _machLabel = [CCLabelTTF labelWithString:@"MACH" fontName:@"Newtown" fontSize:13 dimensions:CGSizeMake(150, 150) hAlignment:kCCTextAlignmentCenter];
//        _machLabel.position = ccp(-70, 300);
//        _machLabel.color = ccc3(255, 255, 255);
//        [self addChild:_machLabel z:100];
        
//        _machSpeed = [CCLabelTTF labelWithString:@"0" fontName:@"Newtown" fontSize:20 dimensions:CGSizeMake(200,200) hAlignment:kCCTextAlignmentCenter];
//        _machSpeed.position = ccp(-70, 240);
//        _machSpeed.color = ccc3(255,255,255);
//        [self addChild:_machSpeed];
        
        _extraLifeIcon = [CCSprite spriteWithFile:@"ExtraLife-hd.png"];
        _extraLifeIcon.opacity = 50;
        _extraLifeIcon.scale = 0.5;
        _extraLifeIcon.position = ccp(_winSize.width * 0.41, _winSize.height * 0.95);
        [self addChild:_extraLifeIcon];
        
        _doubleCreditIcon = [CCSprite spriteWithFile:@"DoubleCredits-hd.png"];
        _doubleCreditIcon.opacity = 50;
        _doubleCreditIcon.scale = 0.5;
        _doubleCreditIcon.position = ccp(_winSize.width * 0.50, _winSize.height * 0.95);

        [self addChild:_doubleCreditIcon];
        
        _magnetIcon = [CCSprite spriteWithFile:@"CreditMagnet-hd.png"];
        _magnetIcon.opacity = 50;
        _magnetIcon.scale = 0.5;
        _magnetIcon.position = ccp(_winSize.width * 0.59, _winSize.height * 0.95);
        [self addChild:_magnetIcon];
        
        _newHiScore = [CCLabelTTF labelWithString:@"New HiScore!" fontName:@font fontSize:15 dimensions:CGSizeMake(50,50) hAlignment:kCCTextAlignmentCenter];
        _newHiScore.opacity = 0;
        _newHiScore.position = ccp(_winSize.width / 2, _winSize.height / 2);
        [self addChild:_newHiScore];
        
        [self showDistanceLabel];
//        [self showXPBar];
//        [self showLevelLabel];
        [self energyBar];
//        [self showCoinLabel];
        [self addCoinIcon];
        [self showPowerupRadialTimer];
        [self ReadyGoLabel];
        [self AnimateReadyGoLabel];
        [self bonusLabel];
        
    }
    return self;
}

- (void) bonusLabel {
    _bonusLabel = [CCLabelTTF labelWithString:@"" fontName:@font fontSize:23 dimensions:CGSizeMake(100.0f, 50.0f) hAlignment:kCCTextAlignmentCenter lineBreakMode:kCCTextAlignmentCenter];
    _bonusLabel.opacity = 0;
    _bonusLabel.position = ccp(_winSize.width * 0.5, _winSize.height * 0.65);
    [self addChild:_bonusLabel];
}

- (void) showBonus:(int) level doubleCredits:(bool) flag {
    if (flag) {
        [_bonusLabel setString:[NSString stringWithFormat:@"Bonus\n%d", level * 20 * 2]];
    }
    else {
        [_bonusLabel setString:[NSString stringWithFormat:@"Bonus\n%d", level * 20]];
    }
    [_bonusLabel runAction:[CCSequence actions:[CCFadeIn actionWithDuration:0.3],[CCDelayTime actionWithDuration:2.0], [CCFadeOut actionWithDuration:1.0], nil]];
}

- (void) updateDistance:(int)distanceNumber {
    [_distanceLabel setString:[NSString stringWithFormat:@"%d", distanceNumber]];
    [_playerStats setDistance:distanceNumber];
    
    //UPDATE XP BAR
//    int levelDiff = [LevelXPHelper nextLevel:[_xpManager getPlayerLevel]] - [LevelXPHelper prevLevelXP:[_xpManager getPlayerLevel]];
    
//    int currXP = [_xpManager getPlayerXP] - [LevelXPHelper prevLevelXP:[_xpManager getPlayerLevel]];
    
//    _xpBar.percentage = ((float)currXP / levelDiff) * 100;
    
    _energyBar.percentage = ((float)[_playerStats getShieldBoostValue] / [_playerStats getShieldBoostMax]) * 100;

    //[self setLevelLabel];
}

- (void) showDistanceLabel {
    _distanceLabel = [CCLabelTTF labelWithString:@"0" fontName:@font fontSize:18 dimensions:CGSizeMake(100.0f, 50.0f) hAlignment:kCCTextAlignmentCenter lineBreakMode:kCCLineBreakModeWordWrap];
    _distanceLabel.position = ccp(160, 400);
    _distanceLabel.opacity = 220;
    [_distanceLabel setColor:ccc3(255,255,255)];
    [self addChild:_distanceLabel];
}

- (void) showXPBar {
    _xpBarContainer = [CCSprite spriteWithFile:@"XPBar-hd.png"];
    _xpBarContainer.opacity = 50;
    _xpBarContainer.position = ccp(160, 10);
    [self addChild:_xpBarContainer];
    
    _xpBar = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"XPBar-hd.png"]];
    _xpBar.type = kCCProgressTimerTypeBar;
    _xpBar.percentage = 0;
    //_xpBar.anchorPoint = ccp(0,0);
    //_xpBar.position = ccp(37, 3);
    _xpBar.position = ccp(160, 10);
    _xpBar.midpoint = ccp(0,1);
    _xpBar.barChangeRate = ccp(1, 0);
    [self addChild:_xpBar];
}

- (void) showLevelLabel {
    _levelLabel = [CCLabelTTF labelWithString:@"" fontName:@font fontSize:15 dimensions:CGSizeMake(100.0f, 50.0f) hAlignment:kCCTextAlignmentCenter lineBreakMode:kCCLabelAutomaticWidth];
    _levelLabel.position = ccp(300, -5);
    [self addChild:_levelLabel];
}

- (void) setLevelLabel {
    [_levelLabel setString:[[NSNumber numberWithInt:[_xpManager getPlayerLevel]] stringValue]];
}

- (void) xpLabel {
    _xpMarker = [CCSprite spriteWithFile:@"xpMarker.png"];
    _xpMarker.position = ccp(160, 250);
    _xpMarker.opacity = 0;
    [self addChild:_xpMarker];
    
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    
    [_xpMarker runAction:[CCSequence actions:[CCSpawn actions:[CCMoveTo actionWithDuration:.20f position:ccp(160, 255)], [CCFadeIn actionWithDuration:0.20f], nil], [CCMoveTo actionWithDuration:0.8f position:ccp(160, 260)], [CCFadeOut actionWithDuration:0.1f], [CCMoveTo actionWithDuration:0.8f position:ccp(160, 250)], actionMoveDone, nil]];
}

- (void) energyBar {
    _energyBarBorder = [CCSprite spriteWithFile:@"EnergyBar-hd.png"];
    _energyBarBorder.opacity = 50;
    _energyBarBorder.position = ccp(160, _winSize.height * 0.895);
    [self addChild:_energyBarBorder];
    
    _energyBar = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"EnergyBar-hd.png"]];
    _energyBar.type = kCCProgressTimerTypeBar;
    _energyBar.percentage = 100;
    _energyBar.position = ccp(160, _winSize.height * 0.9);
    _energyBar.midpoint = ccp(0,300);
    _energyBar.barChangeRate = ccp(1, 0);
    [self addChild:_energyBar];
}

- (void) addCoinIcon {
    _coinIcon = [CCSprite spriteWithFile:@"Coin-hd.png"];
    _coinIcon.scale = 0.8;
    _coinIcon.position = ccp(140, 460);
    //[self addChild:_coinIcon];
}

- (void) showCoinLabel {
    _coinLabel = [CCLabelTTF labelWithString:@"0" fontName:@font fontSize:15 dimensions:CGSizeMake(100.0f, 50.0f) hAlignment:kCCTextAlignmentCenter lineBreakMode:kCCLabelAutomaticWidth];
    _coinLabel.position = ccp(160, 440);
    //[self addChild:_coinLabel];
}

- (void) setCoinLabel:(int) amount {
    [_coinLabel setString:[[NSNumber numberWithInt:amount] stringValue]];
}

- (void) animateCoinIcon {
    //bounce coin icon
    [_coinIcon runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.1f scale:1.2], [CCScaleTo actionWithDuration:0.1f scale:0.85f], [CCScaleTo actionWithDuration:0.05f scale:1.0f], nil]];
}

- (void) flashEnergyBar {
    [_energyBarBorder runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCTintTo actionWithDuration:0.1 red:205 green:0 blue:0], [CCTintTo actionWithDuration:0.1f red:255 green:255 blue:255], nil]]];
}

- (void) stopFlashingEnergyBar {
    [_energyBarBorder stopAllActions];
    _energyBarBorder.opacity = 50;
}

- (void) machSpeedLabel:(int)machLevel {
    //[_machSpeed setString:[NSString stringWithFormat:@"%d", machLevel]];
    
    //[_machLabel runAction:[CCSequence actions:[CCMoveTo actionWithDuration:.11f position:ccp(155, 300)], [CCMoveTo actionWithDuration:2.7f position:ccp(165, 300)], [CCMoveTo actionWithDuration:.11f position:ccp(350, 300)], [CCMoveTo actionWithDuration:0 position:ccp(-70, 300)], nil]];
    //[_machSpeed runAction:[CCSequence actions:[CCMoveTo actionWithDuration:.2f position:ccp(155, 240)], [CCMoveTo actionWithDuration:2.7f position:ccp(165, 240)], [CCMoveTo actionWithDuration:.2f position:ccp(350, 240)], [CCMoveTo actionWithDuration:0 position:ccp(-70, 200)], nil]];
}

- (void) powerupTimer:(float) timer time:(float)time {
    _powerupRadialTimer.percentage = (timer / time) * 100;
}

- (void) showPowerupRadialTimer {
    _powerupRadialTimer = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"PowerupTimer-hd.png"]];
    _powerupRadialTimer.color = ccc3(40, 40, 40);
    _powerupRadialTimer.type = kCCProgressTimerTypeRadial;
    _powerupRadialTimer.percentage = 0;
    _powerupRadialTimer.position = ccp(160, 50);
    [self addChild:_powerupRadialTimer z:2];
}

- (void) powerupSprite:(NSString *) spriteName {
    _powerupSprite = [CCSprite spriteWithFile:[spriteName stringByAppendingString:@".png"]];
    _powerupSprite.position = ccp(160, 50);
    _powerupSprite.opacity = 0;
    [self addChild:_powerupSprite];
    [_powerupSprite runAction:[CCFadeIn actionWithDuration:0.4f]];
}

- (void) removePowerupSprite {
    _powerupRadialTimer.percentage = 0;
    [self removeChild:_powerupSprite cleanup:YES];
}

- (void) addReticle:(int)x y:(int)y {
    _missileWarning = [CCSprite spriteWithFile:@"MissileWarning-hd.png"];
    _missileWarning.position = ccp(x, y);
    _missileWarning.tag = 100;
    //[self addChild:_missileWarning];
}

- (void) removeReticle {
    [self removeChild:_missileWarning cleanup:YES];
}

- (void) ReadyGoLabel {
    _readyLabel = [CCLabelTTF labelWithString:@"READY" fontName:@font fontSize:40 dimensions:CGSizeMake(200,200) hAlignment:kCCTextAlignmentCenter];
    _readyLabel.scale = 3;
    _readyLabel.position = ccp(160, 240);
    _readyLabel.opacity = 0;
    [self addChild:_readyLabel];
    
    _goLabel = [CCLabelTTF labelWithString:@"GO" fontName:@font fontSize:40 dimensions:CGSizeMake(200,200) hAlignment:kCCTextAlignmentCenter];
    _goLabel.position = ccp(160, 240);
    _goLabel.scale = 3;
    _goLabel.opacity = 0;
    [self addChild:_goLabel];
}

- (void) AnimateReadyGoLabel {
    [_readyLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.8f], [CCFadeIn actionWithDuration:0.1], [CCScaleTo actionWithDuration:0.2 scale:1], [CCDelayTime actionWithDuration:1.2], [CCFadeOut actionWithDuration:0.1], nil]];
    
    [_goLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:3.2], [CCFadeIn actionWithDuration:0.1], [CCScaleTo actionWithDuration:0.2 scale:1], [CCDelayTime actionWithDuration:1.0], [CCFadeOut actionWithDuration:0.1], nil]];
}

- (void) generateReticleCoords {
    /*
    do {
        _x = arc4random() % 300 + 20;
    } while ((_x < _prevX - 50) && (_x > _prevX + 50));
    
    do {
        _y = arc4random() % 200 + 200;
    } while ((_y < _prevY - 50) && (_y > _prevY + 50));
    
    CCSprite *reticle = [CCSprite spriteWithFile:@"Reticle-hd.png"];
    reticle.position = ccp(_x, _y);
    [self addChild:reticle];
    
    _prevX = _x;
    _prevY = _y;
    */
}

- (void) showNewHiScore {
    _newHiScore.opacity = 255;
    [_newHiScore runAction:[CCSequence actions:[CCMoveTo actionWithDuration:2 position:ccp(_winSize.width / 2, (_winSize.height / 2) + 50)], [CCFadeOut actionWithDuration:0.5], [CCMoveTo actionWithDuration:0 position:ccp(_winSize.width / 2, _winSize.height / 2)], nil]];
}

- (void) enableDoubleCreditsIcon {
    _doubleCreditIcon.opacity = 255;
}

- (void) enableMagnetIcon {
    _magnetIcon.opacity = 255;
}

- (void) enableExtraLifeIcon {
    _extraLifeIcon.opacity = 255;
}

- (void) disableDoubleCreditsIcon {
    _doubleCreditIcon.opacity = 50;
}

- (void) disableMagnetIcon {
    _magnetIcon.opacity = 50;
}

- (void) disableExtraLifeIcon {
    _extraLifeIcon.opacity = 50;
}

@end
