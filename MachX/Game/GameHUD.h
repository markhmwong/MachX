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


@interface GameHUD : CCLayer {
    CCLabelTTF *_distanceLabel;
    CCLabelTTF *_levelLabel;
    CCLabelTTF *_coinLabel;
    
    XPManager *_xpManager;
    PlayerStats *_playerStats;
    
    CCProgressTimer *_energyBar;
    CCProgressTimer *_xpBar;
    
    CCSprite *_xpBarContainer;
    CCSprite *_xpMarker;
    CCSprite *_coinIcon;
    CCSprite *_energyBarBorder;
    CCSprite *_energyBarBorder2;
    CCSprite *_powerupSprite;
    CCSprite *_missileWarning;
    
    CCMenu *_ingameMenu;

    CCLabelTTF *_machLabel;
    CCLabelTTF *_machSpeed;
    CCLabelTTF *_readyLabel;
    CCLabelTTF *_goLabel;
    CCLabelTTF *_bonusLabel;
    CCLabelTTF *_newHiScore;
    CCProgressTimer *_powerupRadialTimer;
    CGSize _winSize;
    
    CCSprite *_doubleCreditIcon;
    CCSprite *_magnetIcon;
    CCSprite *_extraLifeIcon;
    
    /*
    int _prevX;
    int _prevY;
    
    int _x;
    int _y;*/
}


- (void) updateDistance:(int)distanceNumber;
- (void) xpLabel;
- (void) setCoinLabel:(int) amount;
- (void) animateCoinIcon;
- (void) flashEnergyBar;
- (void) stopFlashingEnergyBar;
- (void) machSpeedLabel:(int)machLevel;
- (void) powerupTimer:(float) timer time:(float)time;
- (void) powerupSprite:(NSString *) spriteName;
- (void) removePowerupSprite;
- (void) addReticle:(int)x y:(int)y;
- (void) generateReticleCoords;
- (void) AnimateReadyGoLabel;
- (void) enableDoubleCreditsIcon;
- (void) enableMagnetIcon;
- (void) enableExtraLifeIcon;
- (void) disableDoubleCreditsIcon;
- (void) disableMagnetIcon;
- (void) disableExtraLifeIcon;
- (void) showBonus:(int) level doubleCredits:(bool) flag;
- (void) showNewHiScore;
@end
