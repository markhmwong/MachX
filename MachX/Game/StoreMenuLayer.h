//
//  StoreLayer.h
//  MachX
//
//  Created by Mark Wong on 24/02/13.
//  Copyright 2013 Whizbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCScrollLayer.h"
#import "CCItemsScroller.h"
#import "CCSelectableItem.h"
#import "MachXIAPHelper.h"
#import "CCLayerOpaque.h"
#import "SKProduct+LocalizedPrice.h"
#import "Reachability.h"

@class Reachability;

@interface StoreMenuLayer : CCLayer {
    CGSize _winSize;
    NSArray *_products;
    CCMenuItemSprite *_coins1;
    CCMenuItemSprite *_coins2;
    CCMenuItemSprite *_coins3;
    CCMenuItemSprite *_coins4;
    CCMenuItemSprite *_coins5;
    CCMenuItemSprite *_coins6;

    CCLayer *_pageOne;
    CCLayer *_pageTwo;
    CCLayer *_pageThree;
    CCScrollLayer *_scrollerMenu;
    
    CCSprite *_coinIcon;

    //Reachability* internetReachable;
    //Reachability* hostReachable;
    Reachability* reach;
    
    CCLabelTTF *_statusLabel;
    CCLabelTTF *_coinLabel;
    CCLabelTTF *_disclaimerLabel;
    CCLabelTTF *_itemTitleLabel;
    CCMenuItemSprite *_disclaimerButton;
    CCSprite *_disclaimerIcon;
    CCMenu *_itemMenu;
    CCMenu *_confirmationMenu;
    CCMenu *_slotMenu;
    CCMenu *_IAPMenu;
    CCMenu *_inventoryMenu1;
    CCMenu *_inventoryMenu2;
    CCSprite *_inventoryItem1;
    CCSprite *_inventoryItem2;

    BOOL _itemDescription;
    BOOL _reachable;
    BOOL _disclaimer;
    int _itemState;
    int _inventoryState;
    int _slotState;
    
    BOOL _inventoryOpen;
    CCLabelTTF *_spaceBridge1Stock;
    CCLabelTTF *_spaceBridge2Stock;
    CCLabelTTF *_spaceBridge3Stock;
    CCLabelTTF *_magnetStock;
    CCLabelTTF *_doubleCreditsStock;
    CCLabelTTF *_extraLifeStock;
}

- (void) fadeInStoreLayer;
- (void) fadeOutStoreLayer;
- (void) turnOnMenu;
- (void) turnOffMenu;
- (void) hideScrollerMenuLayer;
- (void) showScrollerMenuLayer;
- (void) reachabilityChanged:(NSNotification *)notice;
- (void) checkInternetConnection;
- (void) cancel;
- (void) stopReachability;
@end