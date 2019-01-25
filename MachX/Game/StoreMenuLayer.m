//
//  StoreLayer.m
//  MachX
//
//  Created by Mark Wong on 24/02/13.
//  Copyright 2013 Whizbang. All rights reserved.
//

#import "StoreMenuLayer.h"

#define font "Walkway Bold"

@implementation StoreMenuLayer

typedef enum tag {
    kBorderTag,
    kStatusLabelTag,
    kBuyButton,
    kCancelButton,
    kDescriptionLabel,
    kPriceLabel,
    kMenuTopBorder,
    kMenuBotBorder,
    kConfirmationMenu,
    kDarkenScreenTag,
    kItemTitleLabel,
    kConfirmPurchaseMenu,
    kPurchaseStatusLabel,
    kInventoryMenu,
    kOkButtonInventoryMenu,
    kDisclaimerLabel
} tag;

typedef enum layerNumber {
    kDarkenLayer,
    kItemPurchaseLayer    
} layerNumber;

typedef enum itemTags {
    kSpaceBridge1000,
    kSpaceBridge5000,
    kSpaceBridge10000,
    kCreditMagnet,
    kDoubleCredits,
    kExtraLife
} itemTags;

typedef enum itemNumbers {
    kBlankItem,
    kSpaceBridge1Num,
    kSpaceBridge2Num,
    kSpaceBridge3Num,
    kCreditMagnetNum,
    kDoubleCreditsNum,
    kExtraLifeNum
}itemNumbers;

typedef enum priceTags {
    kSpaceBridge1000Price = 1000,
    kSpaceBridge5000Price = 5000,
    kSpaceBridge10000Price = 10000,
    kCreditMagnetPrice = 4000,
    kDoubleCreditsPrice = 4000,
    kExtraLifePrice = 8000,
} priceTags;

- (id) init {
    if((self=[super init])) {
        _winSize = [CCDirector sharedDirector].winSize;
        _scrollerMenu = [CCScrollLayer nodeWithLayers:[self scrollPages] widthOffset:70];
        [self addChild:_scrollerMenu];
        _scrollerMenu.isTouchEnabled = FALSE;
        _inventoryOpen = FALSE;
        
        _products = [[NSArray alloc] init];
        
        [self coinIcon];
        //[self IAPMenu];
        [self checkInternetConnection];
        [self displayPurchasableCoins];
        [self displayLoading];
        [self displayItems];
        
        //get inventory slot items
        switch ([GameManager sharedGameManager].slot1) {
            case kBlankItem:
                _inventoryItem1 = [CCSprite spriteWithFile:@"SelectItem-hd.png"];
                [_pageOne addChild:_inventoryItem1];
                _inventoryItem1.position = ccp(100, 260);
                [GameManager sharedGameManager].slot1 = kBlankItem;
                break;
            case kSpaceBridge1Num:
                if ([GameManager sharedGameManager].spaceBridge1Stock > 0) {
                    _inventoryItem1 = [CCSprite spriteWithFile:@"SpaceBridge1-hd.png"];
                    [_pageOne addChild:_inventoryItem1];
                    _inventoryItem1.position = ccp(100, 260);
                    [GameManager sharedGameManager].slot1 = kSpaceBridge1Num;
                }
                else {
                    _inventoryItem1 = [CCSprite spriteWithFile:@"SelectItem-hd.png"];
                    _inventoryItem1.position = ccp(100, 260);
                    [_pageOne addChild:_inventoryItem1];

                }
                break;
            case kSpaceBridge2Num:
                if ([GameManager sharedGameManager].spaceBridge2Stock > 0) {

                _inventoryItem1 = [CCSprite spriteWithFile:@"SpaceBridge2-hd.png"];
                [_pageOne addChild:_inventoryItem1];
                _inventoryItem1.position = ccp(100, 260);
                
                [GameManager sharedGameManager].slot1 = kSpaceBridge2Num;
                }
                else {
                    _inventoryItem1 = [CCSprite spriteWithFile:@"SelectItem-hd.png"];
                    _inventoryItem1.position = ccp(100, 260);
                    [_pageOne addChild:_inventoryItem1];

                }
                break;
            case kSpaceBridge3Num:
                if ([GameManager sharedGameManager].spaceBridge3Stock > 0) {

                    _inventoryItem1 = [CCSprite spriteWithFile:@"SpaceBridge3-hd.png"];
                    [_pageOne addChild:_inventoryItem1];
                    _inventoryItem1.position = ccp(100, 260);
                
                    [GameManager sharedGameManager].slot1 = kSpaceBridge3Num;
                }
                else {
                    _inventoryItem1 = [CCSprite spriteWithFile:@"SelectItem-hd.png"];
                    _inventoryItem1.position = ccp(100, 260);
                    [_pageOne addChild:_inventoryItem1];

                }
                break;
            case kCreditMagnetNum:
                if ([GameManager sharedGameManager].magnetStock > 0) {

                    _inventoryItem1 = [CCSprite spriteWithFile:@"CreditMagnet-hd.png"];
                    [_pageOne addChild:_inventoryItem1];
                    _inventoryItem1.position = ccp(100, 260);
                
                    [GameManager sharedGameManager].slot1 = kCreditMagnetNum;
                }
                else {
                    _inventoryItem1 = [CCSprite spriteWithFile:@"SelectItem-hd.png"];
                    _inventoryItem1.position = ccp(100, 260);
                    [_pageOne addChild:_inventoryItem1];

                }
                break;
            case kDoubleCreditsNum:
                if ([GameManager sharedGameManager].doubleCreditsStock > 0) {
                    _inventoryItem1 = [CCSprite spriteWithFile:@"DoubleCredits-hd.png"];
                    [_pageOne addChild:_inventoryItem1];
                    _inventoryItem1.position = ccp(100, 260);
                
                    [GameManager sharedGameManager].slot1 = kDoubleCreditsNum;
                }
                else {
                    _inventoryItem1 = [CCSprite spriteWithFile:@"SelectItem-hd.png"];
                    _inventoryItem1.position = ccp(100, 260);
                    [_pageOne addChild:_inventoryItem1];

                }
                break;
            case kExtraLifeNum:
                if ([GameManager sharedGameManager].extraLifeStock > 0) {
                    _inventoryItem1 = [CCSprite spriteWithFile:@"ExtraLife-hd.png"];
                    [_pageOne addChild:_inventoryItem1];
                    _inventoryItem1.position = ccp(100, 260);
                    [GameManager sharedGameManager].slot1 = kExtraLifeNum;
                }
                else {
                    _inventoryItem1 = [CCSprite spriteWithFile:@"SelectItem-hd.png"];
                    _inventoryItem1.position = ccp(100, 260);
                    [_pageOne addChild:_inventoryItem1];
                }
                break;
            default:
                _inventoryItem1 = [CCSprite spriteWithFile:@"SelectItem-hd.png"];
                _inventoryItem1.position = ccp(100, 260);
                [_pageOne addChild:_inventoryItem1];
                break;
        }
        
        
        switch ([GameManager sharedGameManager].slot2) {
            case kBlankItem:
                _inventoryItem2 = [CCSprite spriteWithFile:@"SelectItem-hd.png"];
                [_pageOne addChild:_inventoryItem2];
                _inventoryItem2.position = ccp(220, 260);
                [GameManager sharedGameManager].slot2 = kBlankItem;
                break;
            case kSpaceBridge1Num:
                if ([GameManager sharedGameManager].spaceBridge1Stock > 0) {

                _inventoryItem2 = [CCSprite spriteWithFile:@"SpaceBridge1-hd.png"];
                [_pageOne addChild:_inventoryItem2];
                _inventoryItem2.position = ccp(220, 260);
                [GameManager sharedGameManager].slot2 = kSpaceBridge1Num;
                }
                else {
                    _inventoryItem2 = [CCSprite spriteWithFile:@"SelectItem-hd.png"];
                    _inventoryItem2.position = ccp(220, 260);
                    [_pageOne addChild:_inventoryItem2];
                }
                break;
            case kSpaceBridge2Num:
                if ([GameManager sharedGameManager].spaceBridge2Stock > 0) {

                _inventoryItem2 = [CCSprite spriteWithFile:@"SpaceBridge2-hd.png"];
                [_pageOne addChild:_inventoryItem2];
                _inventoryItem2.position = ccp(220, 260);

                [GameManager sharedGameManager].slot2 = kSpaceBridge2Num;
                }
                else {
                    _inventoryItem2 = [CCSprite spriteWithFile:@"SelectItem-hd.png"];
                    _inventoryItem2.position = ccp(220, 260);
                    [_pageOne addChild:_inventoryItem2];
                }
                break;
            case kSpaceBridge3Num:
                if ([GameManager sharedGameManager].spaceBridge3Stock > 0) {

                _inventoryItem2 = [CCSprite spriteWithFile:@"SpaceBridge3-hd.png"];
                [_pageOne addChild:_inventoryItem2];
                _inventoryItem2.position = ccp(220, 260);

                [GameManager sharedGameManager].slot2 = kSpaceBridge3Num;
                }
                else {
                    _inventoryItem2 = [CCSprite spriteWithFile:@"SelectItem-hd.png"];
                    _inventoryItem2.position = ccp(220, 260);
                    [_pageOne addChild:_inventoryItem2];
                }
                break;
            case kCreditMagnetNum:
                if ([GameManager sharedGameManager].magnetStock > 0) {

                _inventoryItem2 = [CCSprite spriteWithFile:@"CreditMagnet-hd.png"];
                [_pageOne addChild:_inventoryItem2];
                _inventoryItem2.position = ccp(220, 260);

                [GameManager sharedGameManager].slot2 = kCreditMagnetNum;
                }
                else {
                    _inventoryItem2 = [CCSprite spriteWithFile:@"SelectItem-hd.png"];
                    _inventoryItem2.position = ccp(220, 260);
                    [_pageOne addChild:_inventoryItem2];
                }
                break;
            case kDoubleCreditsNum:
                if ([GameManager sharedGameManager].doubleCreditsStock > 0) {

                _inventoryItem2 = [CCSprite spriteWithFile:@"DoubleCredits-hd.png"];
                [_pageOne addChild:_inventoryItem2];
                _inventoryItem2.position = ccp(220, 260);

                [GameManager sharedGameManager].slot2 = kDoubleCreditsNum;
                }
                else {
                    _inventoryItem2 = [CCSprite spriteWithFile:@"SelectItem-hd.png"];
                    _inventoryItem2.position = ccp(220, 260);
                    [_pageOne addChild:_inventoryItem2];
                }
                break;
            case kExtraLifeNum:
                if ([GameManager sharedGameManager].extraLifeStock > 0) {

                _inventoryItem2 = [CCSprite spriteWithFile:@"ExtraLife-hd.png"];
                [_pageOne addChild:_inventoryItem2];
                _inventoryItem2.position = ccp(220, 260);
                [GameManager sharedGameManager].slot2 = kExtraLifeNum;
                }
                else {
                    _inventoryItem2 = [CCSprite spriteWithFile:@"SelectItem-hd.png"];
                    _inventoryItem2.position = ccp(220, 260);
                    [_pageOne addChild:_inventoryItem2];
                }
                break;
            default:
                _inventoryItem2 = [CCSprite spriteWithFile:@"SelectItem-hd.png"];
                _inventoryItem2.position = ccp(220, 260);

                [_pageOne addChild:_inventoryItem2];
                break;
        }
        
        [self schedule:@selector(update:)];
    }
    return self;
}

- (void) update:(ccTime)dt {
    //update coins
    [_coinLabel setString:[NSString stringWithFormat:@"%d", [GameManager sharedGameManager].totalCredits]];
    [_spaceBridge1Stock setString:[NSString stringWithFormat:@"%d", [GameManager sharedGameManager].spaceBridge1Stock]];
    [_spaceBridge2Stock setString:[NSString stringWithFormat:@"%d", [GameManager sharedGameManager].spaceBridge2Stock]];
    [_spaceBridge3Stock setString:[NSString stringWithFormat:@"%d", [GameManager sharedGameManager].spaceBridge3Stock]];
    [_magnetStock setString:[NSString stringWithFormat:@"%d", [GameManager sharedGameManager].magnetStock]];
    [_doubleCreditsStock setString:[NSString stringWithFormat:@"%d", [GameManager sharedGameManager].doubleCreditsStock]];
    [_extraLifeStock setString:[NSString stringWithFormat:@"%d", [GameManager sharedGameManager].extraLifeStock]];
}

- (void) checkInternetConnection {
    reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableOnWWAN = YES;
    
    __weak typeof(self) weakSelf = self;
    // set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        //NSLog(@"REACHABLE!");
        //[weakSelf IAPMenu];
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        //NSLog(@"UNREACHABLE!");
    };

    // here we set up a NSNotification observer. The Reachability that caused the notification
    // is passed in the object parameter
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [reach startNotifier];
}

- (void) stopReachability {
    [reach stopNotifier];
}

- (void) reachabilityChanged:(NSNotification *)notice {
    NetworkStatus internetStatus = [reach currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            [_statusLabel setString:@"No Internet\n\nConnection"];
            break;
        }
        case ReachableViaWiFi:
        {
            //[self IAPMenu];
            break;
        }
        case ReachableViaWWAN:
        {
            //[self IAPMenu];
            break;
        }
    }
    
    [reach stopNotifier];
}

- (void) displayLoading {
    CGSize size = [[CCDirector sharedDirector] winSize];
    _statusLabel = [CCLabelTTF labelWithString:@"Loading..." fontName:@font fontSize:18 dimensions:CGSizeMake(150, 190) hAlignment:kCCTextAlignmentCenter];
    _statusLabel.position = ccp(size.width/2, size.height/2);
    _statusLabel.tag = kStatusLabelTag;
    [_pageTwo addChild:_statusLabel];
}

- (void) displayPurchasableCoins {
    _coins1 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Coins1-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"Coins1-hd.png"] target:self selector:@selector(IAP:)];
    _coins1.tag = 1;
    _coins1.position = ccp(100, 370);
    _coins1.isEnabled = FALSE;
    _coins1.color = ccc3(150, 150, 150);
    
    _coins2 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Coins2-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"Coins2-hd.png"] target:self selector:@selector(IAP:)];
    _coins2.tag = 4;
    _coins2.position = ccp(220, 370);
    _coins2.isEnabled = FALSE;
    _coins2.color = ccc3(150, 150, 150);
    
    _coins3 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Coins3-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"Coins3-hd.png"] target:self selector:@selector(IAP:)];
    _coins3.tag = 2;
    _coins3.position = ccp(100, 260);
    _coins3.isEnabled = FALSE;
    _coins3.color = ccc3(150, 150, 150);
    
    _coins4 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Coins4-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"Coins4-hd.png"] target:self selector:@selector(IAP:)];
    _coins4.tag = 5;
    _coins4.position = ccp(220, 260);
    _coins4.isEnabled = FALSE;
    _coins4.color = ccc3(150, 150, 150);
    
    _coins5 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Coins5-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"Coins5-hd.png"] target:self selector:@selector(IAP:)];
    _coins5.tag = 0;
    _coins5.position = ccp(100, 150);
    _coins5.isEnabled = FALSE;
    _coins5.color = ccc3(150, 150, 150);
    
    _coins6 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Coins6-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"Coins6-hd.png"] target:self selector:@selector(IAP:)];
    _coins6.tag = 3;
    _coins6.position = ccp(220, 150);
    _coins6.isEnabled = FALSE;
    _coins6.color = ccc3(150, 150, 150);
    
    _IAPMenu = [CCMenu menuWithItems:_coins1, _coins2, _coins3, _coins4, _coins5, _coins6, nil];
//    _IAPMenu = [CCMenu menuWithItems:_coins1, _coins2, _coins3, _coins4, nil];

    _IAPMenu.position = ccp(0,0);
    
    [_pageTwo addChild:_IAPMenu];
}

- (void) coinIcon {
    _coinIcon = [CCSprite spriteWithFile:@"Coin-hd.png"];
    _coinIcon.scale = 0.8;
    _coinIcon.position = ccp(20, _winSize.height * 0.95);
    [self addChild:_coinIcon];
    
    _coinLabel = [CCLabelTTF labelWithString:@"" fontName:@font fontSize:18 dimensions:CGSizeMake(200, 50) hAlignment:kCCTextAlignmentLeft];
    _coinLabel.position = ccp(_winSize.width * 0.45, _winSize.height * 0.92);
    [self addChild:_coinLabel];
    //NSLog(@"Total Credits %d StoreMenulayer.m", [GameManager sharedGameManager].totalCredits);
    [_coinLabel setString:[NSString stringWithFormat:@"%d", [GameManager sharedGameManager].totalCredits]];
}

- (void) hideScrollerMenuLayer {
    _pageOne.visible = FALSE;
    _pageTwo.visible = FALSE;
    _pageThree.visible = FALSE;
}

- (void) showScrollerMenuLayer {
    _pageOne.visible = TRUE;
    _pageTwo.visible = TRUE;
    _pageThree.visible = TRUE;
}

- (void) fadeInStoreLayer {
    [_pageOne runAction:[CCFadeIn actionWithDuration:1.0f]];
    [_pageTwo runAction:[CCFadeIn actionWithDuration:1.0f]];
    [_pageThree runAction:[CCFadeIn actionWithDuration:1.0f]];
}

- (void) fadeOutStoreLayer {
    [_pageOne runAction:[CCFadeOut actionWithDuration:0.6f]];
    [_pageTwo runAction:[CCFadeOut actionWithDuration:0.6f]];
    [_pageThree runAction:[CCFadeOut actionWithDuration:0.6f]];
}

- (void) turnOnMenu {
    _scrollerMenu.isTouchEnabled = TRUE;
    _itemMenu.isTouchEnabled = TRUE;
    _IAPMenu.isTouchEnabled = TRUE;
}

- (void) turnOffMenu {
    _scrollerMenu.isTouchEnabled = FALSE;
    _itemMenu.isTouchEnabled = FALSE;
    _IAPMenu.isTouchEnabled = FALSE;
}

- (void) IAPMenu {
    _products = nil;
    [[MachXIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
            [_pageTwo removeChildByTag:kStatusLabelTag cleanup:YES];
            //NSLog(@"products %@", _products[0]);
            _coins1.color = ccc3(255, 255, 255);
            _coins1.isEnabled = TRUE;
            _coins2.color = ccc3(255, 255, 255);
            _coins2.isEnabled = TRUE;
            _coins3.color = ccc3(255, 255, 255);
            _coins3.isEnabled = TRUE;
            _coins4.color = ccc3(255, 255, 255);
            _coins4.isEnabled = TRUE;
            _coins5.color = ccc3(255, 255, 255);
            _coins5.isEnabled = TRUE;
            _coins6.color = ccc3(255, 255, 255);
            _coins6.isEnabled = TRUE;
            //[self showLocalisedTitlesAndPrices];//FIX THIS
        }
    }];
}

- (void) showLocalisedTitlesAndPrices {
    //SKProduct *product = (SKProduct *)_products[0];
//    NSLog(@"Description %@", product.localizedDescription);
}

- (void) IAP:(id)sender {
    SKProduct *product = (SKProduct *)_products[((CCMenuItemSprite *)sender).tag];
//    NSLog(@"%@", product.localizedTitle);
//    NSLog(@"%@", product.localizedPrice);
//    NSLog(@"Buying %@...", product.productIdentifier);
    [[MachXIAPHelper sharedInstance] buyProduct:product];
    
}

- (void) slot1:(id) sender {
    _slotState = 1;
    [self itemMenu];

    //disable slot1/2 buttons
    
    //disable scrolling
    _slotMenu.isTouchEnabled = FALSE;
    _scrollerMenu.isTouchEnabled = FALSE;
}

- (void) slot2:(id) sender {
    _slotState = 2;
    [self itemMenu];

    //disable slot1/2 buttons

    //disable scrolling
    _slotMenu.isTouchEnabled = FALSE;
    _scrollerMenu.isTouchEnabled = FALSE;

}

- (void) itemMenu {
    //INVENTORY
    _inventoryOpen = TRUE;
    [self itemMenuEnable];

    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    //bring up item menu
    CCSprite *BorderGlowTop = [CCSprite spriteWithFile:@"MenuBorder-hd.png"];
    BorderGlowTop.position = ccp(160, 370);
    BorderGlowTop.tag = kMenuTopBorder;
    [_pageOne addChild:BorderGlowTop z:kDarkenLayer+1];
    
    CCSprite *BorderGlowBot = [CCSprite spriteWithFile:@"MenuBorder-hd.png"];
    BorderGlowBot.position = ccp(160, 160);
    BorderGlowBot.flipY = TRUE;
    BorderGlowBot.tag = kMenuBotBorder;
    [_pageOne addChild:BorderGlowBot z:kDarkenLayer+1];
    
    //bring up items
    CCMenuItemSprite *item1 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"SpaceBridge1-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"SpaceBridge1-hd.png"] target:self selector:@selector(item:)];
    //item1.scale = 0.5;
    item1.tag = kSpaceBridge1Num;
    
    _spaceBridge1Stock = [CCLabelTTF labelWithString:@"0" fontName:@font fontSize:15 dimensions:CGSizeMake(150, 190) hAlignment:kCCTextAlignmentCenter];
    _spaceBridge1Stock.position = ccp(96, 189);
    [_pageOne addChild:_spaceBridge1Stock z:kDarkenLayer+1];
    
    CCMenuItemSprite *item2 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"SpaceBridge2-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"SpaceBridge2-hd.png"] target:self selector:@selector(item:)];
    //item2.scale = 0.5;
    item2.tag = kSpaceBridge2Num;
    
    _spaceBridge2Stock = [CCLabelTTF labelWithString:@"0" fontName:@font fontSize:15 dimensions:CGSizeMake(150, 190) hAlignment:kCCTextAlignmentCenter];
    _spaceBridge2Stock.position = ccp(160, 189);
    [_pageOne addChild:_spaceBridge2Stock z:kDarkenLayer+1];
    
    CCMenuItemSprite *item3 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"SpaceBridge3-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"SpaceBridge3-hd.png"] target:self selector:@selector(item:)];
    //item3.scale = 0.5;
    item3.tag = kSpaceBridge3Num;

    _spaceBridge3Stock = [CCLabelTTF labelWithString:@"0" fontName:@font fontSize:15 dimensions:CGSizeMake(150, 190) hAlignment:kCCTextAlignmentCenter];
    _spaceBridge3Stock.position = ccp(224, 189);
    [_pageOne addChild:_spaceBridge3Stock z:kDarkenLayer+1];
    
    _inventoryMenu1 = [CCMenu menuWithItems:item1, item2, item3, nil];
    _inventoryMenu1.position = ccp(160, 310);
    [_inventoryMenu1 alignItemsHorizontallyWithPadding:20];
    [_pageOne addChild:_inventoryMenu1 z:kDarkenLayer+1];    
    
    CCMenuItemSprite *item4 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"CreditMagnet-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"CreditMagnet-hd.png"] target:self selector:@selector(item:)];
    item4.tag = kCreditMagnetNum;

    _magnetStock = [CCLabelTTF labelWithString:@"0" fontName:@font fontSize:15 dimensions:CGSizeMake(150, 190) hAlignment:kCCTextAlignmentCenter];
    _magnetStock.position = ccp(96, 99);
    [_pageOne addChild:_magnetStock z:kDarkenLayer+1];
    
    CCMenuItemSprite *item5 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"DoubleCredits-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"DoubleCredits-hd.png"] target:self selector:@selector(item:)];
    item5.tag = kDoubleCreditsNum;

    _doubleCreditsStock = [CCLabelTTF labelWithString:@"0" fontName:@font fontSize:15 dimensions:CGSizeMake(150, 190) hAlignment:kCCTextAlignmentCenter];
    _doubleCreditsStock.position = ccp(160, 99);
    [_pageOne addChild:_doubleCreditsStock z:kDarkenLayer+1];
    
    CCMenuItemSprite *item6 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"ExtraLife-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"ExtraLife-hd.png"] target:self selector:@selector(item:)];
    item6.tag = kExtraLifeNum;

    _extraLifeStock = [CCLabelTTF labelWithString:@"0" fontName:@font fontSize:15 dimensions:CGSizeMake(150, 190) hAlignment:kCCTextAlignmentCenter];
    _extraLifeStock.position = ccp(224, 99);
    [_pageOne addChild:_extraLifeStock z:kDarkenLayer+1];
    
    _inventoryMenu2 = [CCMenu menuWithItems:item4, item5, item6, nil];
    _inventoryMenu2.position = ccp(160, 220);
    [_inventoryMenu2 alignItemsHorizontallyWithPadding:20];
    
    [_pageOne addChild:_inventoryMenu2 z:kDarkenLayer+1];
    
    CCLayerColor *darkenScreen = [CCLayerColor layerWithColor:ccc4(5, 5, 5, 0)];
    darkenScreen.tag = kDarkenScreenTag;
    [_pageOne addChild:darkenScreen z:kDarkenLayer];
    [darkenScreen runAction:[CCFadeTo actionWithDuration:0.3f opacity:100]];
    
    CCLabelTTF *okLabel = [CCLabelTTF labelWithString:@"OK" fontName:@font fontSize:20 dimensions:CGSizeMake(50, 50) hAlignment:kCCTextAlignmentCenter];
    
    CCMenuItemSprite *okButton = [CCMenuItemLabel itemWithLabel:okLabel block:
                                  ^(id sender)
                                  {
                                      [self cancelInventory];
                                  }];
    okButton.position = ccp(winSize.width/2, winSize.height * 0.2);
    
    CCMenu *okMenu = [CCMenu menuWithItems:okButton, nil];
    okMenu.position = ccp(0,0);
    okMenu.tag = kInventoryMenu;
    [_pageOne addChild:okMenu];
}

- (void) cancelInventory {
    //remove inventory from screen 
    [_pageOne removeChild:_inventoryMenu1 cleanup:YES];
    [_pageOne removeChild:_inventoryMenu2 cleanup:YES];
    [_pageOne removeChildByTag:kDarkenScreenTag cleanup:YES];
    [_pageOne removeChildByTag:kMenuBotBorder cleanup:YES];
    [_pageOne removeChildByTag:kMenuTopBorder cleanup:YES];
    [_pageOne removeChildByTag:kInventoryMenu cleanup:YES];
    
    //remove stock numbers
    [_pageOne removeChild:_spaceBridge1Stock cleanup:YES];
    [_pageOne removeChild:_spaceBridge2Stock cleanup:YES];
    [_pageOne removeChild:_spaceBridge3Stock cleanup:YES];
    [_pageOne removeChild:_extraLifeStock cleanup:YES];
    [_pageOne removeChild:_doubleCreditsStock cleanup:YES];
    [_pageOne removeChild:_magnetStock cleanup:YES];

    //disable back button
    
    _slotMenu.isTouchEnabled = TRUE;
    _scrollerMenu.isTouchEnabled = TRUE;
    _itemMenu.isTouchEnabled = TRUE;
}

- (void) item:(id) sender {
    _inventoryState = ((CCMenuItemSprite*)sender).tag;
    
    //remove inventory
    [self cancelInventory];
    
    //switch for inventory slot
    switch (_slotState) {
        case 1:
            switch (_inventoryState) {
                case kSpaceBridge1Num:
                    //add space bridge to inventory
                    if ([GameManager sharedGameManager].spaceBridge1Stock > 0) {
                        [_inventoryItem1 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"SpaceBridge1-hd.png"]];
                        _inventoryItem1.position = ccp(100, 260);
                        [GameManager sharedGameManager].slot1 = kSpaceBridge1Num;
                    }
                    else {
                        [_inventoryItem1 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"SelectItem-hd.png"]];
                        _inventoryItem1.position = ccp(100, 260);
                    }
                    break;
                case kSpaceBridge2Num:
                    if ([GameManager sharedGameManager].spaceBridge2Stock > 0) {
                        [_inventoryItem1 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"SpaceBridge2-hd.png"]];
                        _inventoryItem1.position = ccp(100, 260);
                        [GameManager sharedGameManager].slot1 = kSpaceBridge2Num;
                    }
                    else {
                        [_inventoryItem1 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"SelectItem-hd.png"]];
                        _inventoryItem1.position = ccp(100, 260);
                    }
                    break;
                case kSpaceBridge3Num:
                    if ([GameManager sharedGameManager].spaceBridge3Stock > 0) {
                        [_inventoryItem1 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"SpaceBridge3-hd.png"]];
                        _inventoryItem1.position = ccp(100, 260);
                        [GameManager sharedGameManager].slot1 = kSpaceBridge3Num;
                    }
                    else {
                        [_inventoryItem1 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"SelectItem-hd.png"]];
                        _inventoryItem1.position = ccp(100, 260);
                    }
                    break;
                case kCreditMagnetNum:
                    if ([GameManager sharedGameManager].magnetStock > 0) {
                        [_inventoryItem1 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"CreditMagnet-hd.png"]];
                        _inventoryItem1.position = ccp(100, 260);
                        [GameManager sharedGameManager].slot1 = kCreditMagnetNum;
                    }
                    else {
                        [_inventoryItem1 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"SelectItem-hd.png"]];
                        _inventoryItem1.position = ccp(100, 260);
                    }
                    break;
                case kDoubleCreditsNum:
                    if ([GameManager sharedGameManager].doubleCreditsStock > 0) {
                        [_inventoryItem1 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"DoubleCredits-hd.png"]];
                        _inventoryItem1.position = ccp(100, 260);
                        [GameManager sharedGameManager].slot1 = kDoubleCreditsNum;
                    }
                    else {
                        [_inventoryItem1 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"SelectItem-hd.png"]];
                        _inventoryItem1.position = ccp(100, 260);
                    }
                    break;
                case kExtraLifeNum:
                    if ([GameManager sharedGameManager].extraLifeStock > 0) {
                        [_inventoryItem1 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"ExtraLife-hd.png"]];
                        _inventoryItem1.position = ccp(100, 260);
                        [GameManager sharedGameManager].slot1 = kExtraLifeNum;
                    }
                    else {
                        [_inventoryItem1 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"SelectItem-hd.png"]];
                        _inventoryItem1.position = ccp(100, 260);
                    }
                    break;
                default:
                    [_inventoryItem1 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"SelectItem-hd.png"]];
                    [GameManager sharedGameManager].slot1 = kBlankItem;

                    break;
            }
            break;
        case 2:
            switch (_inventoryState) {
                case kSpaceBridge1Num:
                    //add space bridge to inventory
                    if ([GameManager sharedGameManager].spaceBridge1Stock > 0) {
                        [_inventoryItem2 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"SpaceBridge1-hd.png"]];
                        _inventoryItem2.position = ccp(220, 260);
                        [GameManager sharedGameManager].slot2 = kSpaceBridge1Num;
                    }
                    else {
                        [_inventoryItem2 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"SelectItem-hd.png"]];
                        _inventoryItem2.position = ccp(220, 260);
                    }
                    break;
                case kSpaceBridge2Num:
                    if ([GameManager sharedGameManager].spaceBridge2Stock > 0) {
                        [_inventoryItem2 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"SpaceBridge2-hd.png"]];
                        _inventoryItem2.position = ccp(220, 260);
                        [GameManager sharedGameManager].slot2 = kSpaceBridge2Num;
                    }
                    else {
                        [_inventoryItem2 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"SelectItem-hd.png"]];
                        _inventoryItem2.position = ccp(220, 260);
                    }
                    break;
                case kSpaceBridge3Num:
                    if ([GameManager sharedGameManager].spaceBridge3Stock > 0) {
                        [_inventoryItem2 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"SpaceBridge3-hd.png"]];
                        _inventoryItem2.position = ccp(220, 260);
                        [GameManager sharedGameManager].slot2 = kSpaceBridge3Num;
                    }
                    break;
                case kCreditMagnetNum:
                    if ([GameManager sharedGameManager].magnetStock > 0) {
                        [_inventoryItem2 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"CreditMagnet-hd.png"]];
                        _inventoryItem2.position = ccp(220, 260);
                        [GameManager sharedGameManager].slot2 = kCreditMagnetNum;
                    }
                    else {
                        [_inventoryItem2 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"SelectItem-hd.png"]];
                        _inventoryItem2.position = ccp(220, 260);
                    }
                    break;
                case kDoubleCreditsNum:
                    if ([GameManager sharedGameManager].doubleCreditsStock > 0) {
                        [_inventoryItem2 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"DoubleCredits-hd.png"]];
                        _inventoryItem2.position = ccp(220, 260);
                        [GameManager sharedGameManager].slot2 = kDoubleCreditsNum;
                    }
                    else {
                        [_inventoryItem2 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"SelectItem-hd.png"]];
                        _inventoryItem2.position = ccp(220, 260);
                    }
                    break;
                case kExtraLifeNum:
                    if ([GameManager sharedGameManager].extraLifeStock > 0) {
                        [_inventoryItem2 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"ExtraLife-hd.png"]];
                        _inventoryItem2.position = ccp(220, 260);
                        [GameManager sharedGameManager].slot2 = kExtraLifeNum;
                    }
                    else {
                        [_inventoryItem2 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"SelectItem-hd.png"]];
                        _inventoryItem2.position = ccp(220, 260);
                    }
                    break;
                default:
                    [_inventoryItem2 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"SelectItem-hd.png"]];
                    [GameManager sharedGameManager].slot2 = kBlankItem;
                    break;
            }
            break;
        default:
            break;
    }
    [[GameManager sharedGameManager] saveGameData];
}

- (void) disclaimer:(id) sender {
    _disclaimer = TRUE;
    _slotMenu.enabled = FALSE;
    [self itemMenuEnable];

    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    //Disclaimer

    _disclaimerLabel = [CCLabelTTF labelWithString:@"iCloud is currently not available in this version to backup your coins that you collect in game or buy from the store. Removing this app will result in you losing your stats, items and coins you collect or purchased." fontName:@"Walkway Bold" fontSize:15 dimensions:CGSizeMake(300, 200) hAlignment:kCCTextAlignmentCenter];
    _disclaimerLabel.tag = kDisclaimerLabel;
    _disclaimerLabel.position = ccp(winSize.width / 2, winSize.height / 2);
    [_pageOne addChild:_disclaimerLabel z:kDarkenLayer + 1];

    
    CCLayerColor *darkenScreen = [CCLayerColor layerWithColor:ccc4(5, 5, 5, 0)];
    darkenScreen.tag = kDarkenScreenTag;
    [_pageOne addChild:darkenScreen z:kDarkenLayer];
    [darkenScreen runAction:[CCFadeTo actionWithDuration:0.3f opacity:100]];
    
    _disclaimerButton.opacity = 255;
    
    //OK Button
    CCLabelTTF *okLabel = [CCLabelTTF labelWithString:@"OK" fontName:@font fontSize:20 dimensions:CGSizeMake(150, 50) hAlignment:kCCTextAlignmentCenter];

    CCMenuItemSprite *okButton = [CCMenuItemLabel itemWithLabel:okLabel block:
                                  ^(id sender)
                                  {
                                      [self cancel];
                                  }];
    okButton.position = ccp(winSize.width * 0.5, winSize.height * .4);
    
    CCMenu *confirmPurchaseMenu = [CCMenu menuWithItems:okButton, nil];
    confirmPurchaseMenu.position = ccp(0, 0);
    confirmPurchaseMenu.tag = kConfirmPurchaseMenu;
    [_pageOne addChild:confirmPurchaseMenu z:kDarkenLayer + 1];
}

- (NSArray *) scrollPages {
    
    //SELECT ITEMS
    
    _pageOne = [CCLayer node];    
    
    CGSize winSize = [CCDirector sharedDirector].winSize;

    _disclaimerButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"ButtonBorder-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"ButtonBorder-hd.png"] target:self selector:@selector(disclaimer:)];
    _disclaimerButton.position = ccp(winSize.width * 0.5, winSize.height * .35);
    _disclaimerButton.scale = 0.3;
    //[_disclaimerButton runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:5 angle:360]]];

    //info button here!
    _disclaimerIcon = [CCSprite spriteWithFile:@"MissileWarning-hd.png"];
    _disclaimerIcon.position = ccp(winSize.width * 0.5, winSize.height * .35);
    _disclaimerIcon.scale = 0.7;
    //[_pageOne addChild:_disclaimerIcon];
    
    CCMenuItemSprite *borderSlot1 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"ButtonBorder-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"ButtonBorder-hd.png"] target:self selector:@selector(slot1:)];
    borderSlot1.rotation = arc4random() % 360 + 10;
    borderSlot1.position = ccp(100, 260);
    [borderSlot1 runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:5 angle:360]]];

    CCMenuItemSprite *borderSlot2 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"ButtonBorder-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"ButtonBorder-hd.png"] target:self selector:@selector(slot2:)];
    borderSlot2.rotation = arc4random() % 360 + 10;
    borderSlot2.position = ccp(220, 260);
    [borderSlot2 runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:5 angle:360]]];
    
//    _slotMenu = [CCMenu menuWithItems:borderSlot1, borderSlot2, _disclaimerButton, nil];
    _slotMenu = [CCMenu menuWithItems:borderSlot1, borderSlot2, nil];

    _slotMenu.position = ccp(0,0);
    [_pageOne addChild:_slotMenu];
    
    CCLabelTTF *selectItemLabel = [CCLabelTTF labelWithString:@"Choose an Item" fontName:@font fontSize:15 dimensions:CGSizeMake(150, 150) hAlignment:kCCTextAlignmentCenter];
    selectItemLabel.position = ccp(winSize.width * 0.5, winSize.height * 0.60);
    [_pageOne addChild:selectItemLabel];
    
    //Purchase ITEMS
    _pageTwo = [CCLayer node];
    
    CCLabelTTF *coinTitleLabel = [CCLabelTTF labelWithString:@"Purchase Credits" fontName:@font fontSize:15 dimensions:CGSizeMake(150, 150) hAlignment:kCCTextAlignmentCenter];
    coinTitleLabel.position = ccp(160, 372);
    [_pageTwo addChild:coinTitleLabel];
    
    for (int i = 0; i < 2; i++) {
        int x = 0, y = 0;
        
        if (i == 0) {
            x = 100;
        }
        else {
            x = 220;
        }
        
        for (int j = 0; j < 3; j++) { // j < 3 to open up another 2 slots for coins
            y = 370 - 110 * j;
            CCSprite *border = [CCSprite spriteWithFile:@"ButtonBorder-hd.png"];
            border.position = ccp(x, y);
            border.opacity = 0;
            border.scale = 0.85;
            border.tag = kBorderTag;
            border.rotation = arc4random() % 360 + 10;
            [_pageTwo addChild:border];
            
            [border runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:5 angle:360]]];
        }
    }
    
    //Purchase CREDITS
    
    _pageThree = [CCLayer node];
    
    CCLabelTTF *itemTitleLabel = [CCLabelTTF labelWithString:@"Purchase Items" fontName:@font fontSize:15 dimensions:CGSizeMake(150, 150) hAlignment:kCCTextAlignmentCenter];
    itemTitleLabel.position = ccp(160, 372);
    [_pageThree addChild:itemTitleLabel];
    
    for (int i = 0; i < 2; i++) {
        int x = 0, y = 0;
        
        if (i == 0) {
            x = 100;
        }
        else {
            x = 220;
        }
        
        for (int j = 0; j < 3; j++) {
            y = 370 - 110 * j;
            CCSprite *border = [CCSprite spriteWithFile:@"ButtonBorder-hd.png"];
            border.position = ccp(x, y);
            border.opacity = 0;
            border.scale = 0.85;
            border.tag = kBorderTag;
            border.rotation = arc4random() % 360 + 10;
            [_pageThree addChild:border];
            
            [border runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:5 angle:360]]];
        }
    }
    
    return [NSArray arrayWithObjects: _pageOne, _pageTwo, _pageThree, nil];
}

- (void) displayItems {
    //to page two
    
    CCMenuItemSprite * spaceBridge1000 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"SpaceBridge1-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"SpaceBridge1-hd.png"] target:self selector:@selector(itemInfo:)];
    spaceBridge1000.position = ccp(100, 370);
    spaceBridge1000.scale = 0.7;
    spaceBridge1000.tag = kSpaceBridge1000;
    
    CCMenuItemSprite *spaceBridge5000 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"SpaceBridge2-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"SpaceBridge2-hd.png"] target:self selector:@selector(itemInfo:)];
    spaceBridge5000.position = ccp(220, 370);
    spaceBridge5000.scale = 0.7;
    spaceBridge5000.tag = kSpaceBridge5000;
    
    CCMenuItemSprite *spaceBridge10000 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"SpaceBridge3-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"SpaceBridge3-hd.png"] target:self selector:@selector(itemInfo:)];
    spaceBridge10000.position = ccp(100, 260);
    spaceBridge10000.scale = 0.7;
    spaceBridge10000.tag = kSpaceBridge10000;
    
    CCMenuItemSprite *creditMagnet = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"CreditMagnet-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"CreditMagnet-hd.png"] target:self selector:@selector(itemInfo:)];
    creditMagnet.position = ccp(220, 260);
    creditMagnet.tag = kCreditMagnet;
    
    CCMenuItemSprite *doubleCredit = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"DoubleCredits-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"DoubleCredits-hd.png"] target:self selector:@selector(itemInfo:)];
    doubleCredit.position = ccp(100, 150);
    doubleCredit.tag = kDoubleCredits;
    
    CCMenuItemSprite *extraLife = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"ExtraLife-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"ExtraLife-hd.png"] target:self selector:@selector(itemInfo:)];
    extraLife.position = ccp(220, 150);
    extraLife.tag = kExtraLife;
    
    _itemMenu = [CCMenu menuWithItems:spaceBridge1000, spaceBridge5000, spaceBridge10000, creditMagnet, doubleCredit, extraLife, nil];
    _itemMenu.position = ccp(0, 0);
    [_pageThree addChild:_itemMenu];
}

- (void) itemInfo:(id) sender {

    int tag = ((CCMenuItemSprite *)sender).tag;

    [self itemConfirmation];
    [self description:tag];
    
}

- (void) itemMenuEnable {
    _itemMenu.isTouchEnabled = (!_itemMenu.isTouchEnabled);
    _scrollerMenu.isTouchEnabled = (!_scrollerMenu.isTouchEnabled);
}

- (void) itemConfirmation {
    //Disable menu
    [self itemMenuEnable];
    //fade out menu
    [_itemMenu runAction:[CCFadeTo actionWithDuration:0.3f opacity:100]];
    //fade out item borders
    
    CCLayerColor *darkenScreen = [CCLayerColor layerWithColor:ccc4(5, 5, 5, 0)];
    darkenScreen.tag = kDarkenScreenTag;
    [_pageThree addChild:darkenScreen z:kDarkenLayer];
    [darkenScreen runAction:[CCFadeTo actionWithDuration:0.3f opacity:100]];
    
    CCSprite *topMenuBorder = [CCSprite spriteWithFile:@"MenuBorder-hd.png"];
    topMenuBorder.position = ccp(160, 370);
    topMenuBorder.opacity = 0;
    topMenuBorder.tag = kMenuTopBorder;
    [_pageThree addChild:topMenuBorder z:kItemPurchaseLayer];
    [topMenuBorder runAction:[CCFadeIn actionWithDuration:0.3f]];
    
    CCSprite *botMenuBorder = [CCSprite spriteWithFile:@"MenuBorder-hd.png"];
    botMenuBorder.position = ccp(160, 115);
    botMenuBorder.flipY = TRUE;
    botMenuBorder.opacity = 0;
    botMenuBorder.tag = kMenuBotBorder;
    [botMenuBorder runAction:[CCFadeIn actionWithDuration:0.3f]];
    [_pageThree addChild:botMenuBorder z:kItemPurchaseLayer];
    
    CCLabelTTF *buyLabel = [CCLabelTTF labelWithString:@"BUY" fontName:@font fontSize:20 dimensions:CGSizeMake(150, 50) hAlignment:kCCTextAlignmentCenter];
    CCMenuItemLabel *buyButton = [CCMenuItemLabel itemWithLabel:buyLabel block:^(id sender){[self buyItem];}];
    buyButton.tag = kBuyButton;
    buyButton.position = ccp(220, 115);
    CCLabelTTF *cancelLabel = [CCLabelTTF labelWithString:@"CANCEL" fontName:@font fontSize:20 dimensions:CGSizeMake(150, 50) hAlignment:kCCTextAlignmentCenter];
    CCMenuItemLabel *cancelButton = [CCMenuItemLabel itemWithLabel:cancelLabel block:
        ^(id sender)
        {
        [self cancel];
        }];
    
    cancelButton.tag = kCancelButton;
    cancelButton.position = ccp(110, 115);
    
    //add to pageTwo
    CCMenu *confirmationMenu = [CCMenu menuWithItems:buyButton, cancelButton, nil];
    confirmationMenu.position = ccp(0, 0);
    confirmationMenu.tag = kConfirmationMenu;
    [_pageThree addChild:confirmationMenu z:kItemPurchaseLayer];
}

- (void) description:(int) itemTag {
    _itemDescription = TRUE;
    
    CCLabelTTF *descriptionLabel = [CCLabelTTF labelWithString:@"" fontName:@font fontSize:14 dimensions:CGSizeMake(220, 100) hAlignment:kCCTextAlignmentCenter];
    descriptionLabel.position = ccp(160, 165);
    descriptionLabel.tag = kDescriptionLabel;
    [_pageThree addChild:descriptionLabel z:kItemPurchaseLayer];

    CCLabelTTF *priceLabel = [CCLabelTTF labelWithString:@"" fontName:@font fontSize:16 dimensions:CGSizeMake(180, 50) hAlignment:kCCTextAlignmentCenter];
    priceLabel.position = ccp(160, 215);
    priceLabel.tag = kPriceLabel;
    [_pageThree addChild:priceLabel z:kItemPurchaseLayer];
    
    _itemTitleLabel = [CCLabelTTF labelWithString:@"" fontName:@font fontSize:20 dimensions:CGSizeMake(180, 50) hAlignment:kCCTextAlignmentCenter];
    _itemTitleLabel.position = ccp(160, 330);
    _itemTitleLabel.tag = kItemTitleLabel;
    [_pageThree addChild:_itemTitleLabel z:kItemPurchaseLayer];
    
    CCLabelTTF *stockLabel = [CCLabelTTF labelWithString:@"" fontName:@font fontSize:15 dimensions:CGSizeMake(180, 50) hAlignment:kCCTextAlignmentCenter];
    stockLabel.position = ccp(160, 330);
    stockLabel.tag = kItemTitleLabel;
    [_pageThree addChild:stockLabel z:kItemPurchaseLayer];
    
    switch (itemTag) {
        case kSpaceBridge1000:
            _itemState = kSpaceBridge1000;
            [_itemTitleLabel setString:@"Space Bridge 1000"];
            [priceLabel setString:[NSString stringWithFormat:@"%d Credits", kSpaceBridge1000Price]];
            [descriptionLabel setString:@"Use this consumable item at the start of the game, to enter Mach Speed for 1000m!\n"];
            break;
        case kSpaceBridge5000:
            _itemState = kSpaceBridge5000;
            [_itemTitleLabel setString:@"Space Bridge 5000"];
            [priceLabel setString:[NSString stringWithFormat:@"%d Credits", kSpaceBridge5000Price]];
            [descriptionLabel setString:@"Use this consumable item at the start of the game, to enter Mach Speed for 5000m. Hold on!\n"];
            break;
        case kSpaceBridge10000:
            _itemState = kSpaceBridge10000;
            [_itemTitleLabel setString:@"Space Bridge 10000"];
            [priceLabel setString:[NSString stringWithFormat:@"%d Credits", kSpaceBridge10000Price]];
            [descriptionLabel setString:@"Use this consumable item at the start of the game, to enter Mach Speed for 10000m! Mind bottling!"];
            break;
        case kCreditMagnet:
            _itemState = kCreditMagnet;
            [_itemTitleLabel setString:@"Magnet"];
            [priceLabel setString:[NSString stringWithFormat:@"%d Credits", kCreditMagnetPrice]];
            [descriptionLabel setString:@"Buy this magnet, become attractive and collect all kinds of credits! Lasts until death."];
            break;
        case kDoubleCredits:
            _itemState = kDoubleCredits;
            [_itemTitleLabel setString:@"Double Credits"];
            [priceLabel setString:[NSString stringWithFormat:@"%d Credits", kDoubleCreditsPrice]];
            [descriptionLabel setString:@"Using this gives you double the credits! Lasts until death."];
            break;
        case kExtraLife:
            _itemState = kExtraLife;
            [_itemTitleLabel setString:@"Extra Life"];
            [priceLabel setString:[NSString stringWithFormat:@"%d Credits", kExtraLifePrice]];
            [descriptionLabel setString:@"Who wouldn't want a second chance at life!"];
            break;
        default:
            break;
    }
}

- (void) cancel {
    //cancelling from backbutton with item description open
    if (_itemDescription) {
        [self itemMenuEnable];
        _itemDescription = FALSE;
        [_pageThree removeChildByTag:kMenuTopBorder cleanup:YES];
        [_pageThree removeChildByTag:kMenuBotBorder cleanup:YES];
        [_pageThree removeChildByTag:kDescriptionLabel cleanup:YES];
        [_pageThree removeChildByTag:kConfirmationMenu cleanup:YES];
        [_pageThree removeChildByTag:kDarkenScreenTag cleanup:YES];
        [_pageThree removeChildByTag:kPriceLabel cleanup:YES];
        [_itemTitleLabel setString:@""];
        [_pageThree removeChildByTag:kItemTitleLabel cleanup:YES];
        [_pageThree removeChildByTag:kConfirmPurchaseMenu cleanup:YES];
        [_pageThree removeChildByTag:kPurchaseStatusLabel cleanup:YES];
        [_itemMenu runAction:[CCFadeTo actionWithDuration:0.3f opacity:255]];
    }
    else if (_inventoryOpen) {
        _inventoryOpen = FALSE;
        [self itemMenuEnable];
        [self cancelInventory];
    }
    else if (_disclaimer) {
        [self itemMenuEnable];
        _disclaimer = FALSE;
        _slotMenu.enabled = TRUE;
        [_pageOne removeChildByTag:kDarkenScreenTag cleanup:YES];
        [_pageOne removeChildByTag:kDisclaimerLabel cleanup:YES];
        [_pageOne removeChildByTag:kConfirmPurchaseMenu cleanup:YES];
    }
    else {
        //canceling from back button with item description closed
        [_pageThree removeChildByTag:kMenuTopBorder cleanup:YES];
        [_pageThree removeChildByTag:kMenuBotBorder cleanup:YES];
        [_pageThree removeChildByTag:kDescriptionLabel cleanup:YES];
        [_pageThree removeChildByTag:kConfirmationMenu cleanup:YES];
        [_pageThree removeChildByTag:kDarkenScreenTag cleanup:YES];
        [_pageThree removeChildByTag:kPriceLabel cleanup:YES];
        [_itemTitleLabel setString:@""];
        [_pageThree removeChildByTag:kItemTitleLabel cleanup:YES];
        [_pageThree removeChildByTag:kConfirmPurchaseMenu cleanup:YES];
        [_pageThree removeChildByTag:kPurchaseStatusLabel cleanup:YES];
        [_itemMenu runAction:[CCFadeTo actionWithDuration:0.3f opacity:255]];
    }
}

- (void) buyItem {
    int price = 0;
    CGSize winSize = [CCDirector sharedDirector].winSize;
    //check credits
    switch (_itemState) {
        case kSpaceBridge1000:
            price = kSpaceBridge1000Price;
            [GameManager sharedGameManager].spaceBridge1Stock++;
            break;
        case kSpaceBridge5000:
            price = kSpaceBridge5000Price;
            [GameManager sharedGameManager].spaceBridge2Stock++;
            break;
        case kSpaceBridge10000:
            price = kSpaceBridge10000Price;
            [GameManager sharedGameManager].spaceBridge3Stock++;
            break;
        case kCreditMagnet:
            price = kCreditMagnetPrice;
            [GameManager sharedGameManager].magnetStock++;
            break;
        case kDoubleCredits:
            price = kDoubleCreditsPrice;
            [GameManager sharedGameManager].doubleCreditsStock++;
            break;
        case kExtraLife:
            price = kExtraLifePrice;
            [GameManager sharedGameManager].extraLifeStock++;
            break;
        default:
            break;
    }
    //[[GameManager sharedGameManager] saveGameData];
    
    CCLabelTTF *purchaseStatusLabel = [CCLabelTTF labelWithString:@"" fontName:@font fontSize:15 dimensions:CGSizeMake(180, 50) hAlignment:kCCTextAlignmentCenter];
    purchaseStatusLabel.position = ccp(_winSize.width * 0.5, _winSize.height * 0.5);
    purchaseStatusLabel.tag = kPurchaseStatusLabel;
    [_pageThree addChild:purchaseStatusLabel];
    
    if ([GameManager sharedGameManager].totalCredits >= price) {
        [_pageThree removeChildByTag:kDescriptionLabel cleanup:YES];
        [_pageThree removeChildByTag:kConfirmationMenu cleanup:YES];
        [_pageThree removeChildByTag:kPriceLabel cleanup:YES];
        [_pageThree removeChildByTag:kItemTitleLabel cleanup:YES];

        [GameManager sharedGameManager].totalCredits = [GameManager sharedGameManager].totalCredits - price;
        [_coinLabel setString:[NSString stringWithFormat:@"%d", [GameManager sharedGameManager].totalCredits]];
        
        [purchaseStatusLabel setString:@"Purchased"];
        //save item stock
        [[GameManager sharedGameManager] saveGameData];
    }
    else {
        [_pageThree removeChildByTag:kDescriptionLabel cleanup:YES];
        [_pageThree removeChildByTag:kConfirmationMenu cleanup:YES];
        [_pageThree removeChildByTag:kPriceLabel cleanup:YES];
        [_pageThree removeChildByTag:kItemTitleLabel cleanup:YES];
        
        [purchaseStatusLabel setString:@"Insufficient Credits"];
    }
    
    CCLabelTTF *okLabel = [CCLabelTTF labelWithString:@"OK" fontName:@font fontSize:20 dimensions:CGSizeMake(150, 50) hAlignment:kCCTextAlignmentCenter];

    CCMenuItemSprite *okButton = [CCMenuItemLabel itemWithLabel:okLabel block:
                                  ^(id sender)
                                  {
                                      [self cancel];
                                  }];
    okButton.position = ccp(winSize.width * .5, winSize.height * .3);
    
    CCMenu *confirmPurchaseMenu = [CCMenu menuWithItems:okButton, nil];
    confirmPurchaseMenu.position = ccp(0, 0);
    confirmPurchaseMenu.tag = kConfirmPurchaseMenu;
    [_pageThree addChild:confirmPurchaseMenu];
}

@end
