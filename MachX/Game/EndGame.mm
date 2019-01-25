//
//  EndGame.m
//  MachX
//
//  Created by Mark Wong on 16/02/13.
//  Copyright 2013 Whizbang. All rights reserved.
//

#import "EndGame.h"

#define font "Walkway Bold"

@implementation EndGame

typedef enum menuButtons {
    kBackButton,
    kStoreButton,
    kTwitterButton,
    kRetryButton,
    kStoreBorder,
    kTwitterBorder,
    kRetryBorder
} menuButtons;

typedef enum menuState {
    kNormalState,
    kStoreState,
    kScoreState
} menuState;

@synthesize viewController;
@synthesize parallax = _parallax;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	EndGame *layer = [EndGame node];
    [scene addChild: layer];

    
    
	// return the scene
	return scene;
}

- (id) init {
    if((self=[super init])) {
        _winSize = [CCDirector sharedDirector].winSize;
        _xpManager = [XPManager sharedXPManager];
        _playerStats = [PlayerStats sharedXPManager];

        //Credits
        //_creditsCollected = [_playerStats getCredits];
        
        //For Twitter
        viewController = [[UIViewController alloc] init];
        
        //Stats
        [self submitToGameCenter];
        [self checkHiScore];
        [self updateGameStats];
        
        _scrollerMenu = [CCScrollLayer nodeWithLayers:[self scrollPages] widthOffset:70];
        [self addChild:_scrollerMenu];
        
        _storeLayer = [[CCLayer alloc] init];
        _storeLayer.position = ccp(-320,0);
        [self addChild:_storeLayer z:1];
        
        //parallaxbg
        self.parallax = [Background background];
        [self addChild:_parallax z:-1];
        
        _background = [CCLayerColor layerWithColor:ccc4(80, 100, 200, 255)];
        [self addChild:_background z:-10];
        
        [_background runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCDelayTime actionWithDuration:15], [CCTintTo actionWithDuration:20 red:40 green:60 blue:135], [CCDelayTime actionWithDuration:15], [CCTintTo actionWithDuration:15 red:30 green:40 blue:80], nil]]];
        
        [self showButtons];
        
        _storeMenuLayer = [StoreMenuLayer node];
        _storeMenuLayer.position = ccp(0, 0);
        [_storeMenuLayer hideScrollerMenuLayer];
        [self addChild:_storeMenuLayer];
        
        //iCloud
        //[self updateiCloud];
        //[self loadFromiCloud];
        
        [self scheduleUpdate];
    }
    return self;
}

- (void) checkHiScore {
    if ([GameManager sharedGameManager].distanceTraveled > [GameManager sharedGameManager].hiScore) {
        [GameManager sharedGameManager].hiScore = [GameManager sharedGameManager].distanceTraveled;
        [[GameManager sharedGameManager] saveGameData];
    }
}

- (void) submitToGameCenter {
    [[GameKitHelper sharedGameKitHelper] submitScore:[_playerStats getDistance] category:@"machx.topScores"];//sends the high score to game center
}

- (NSArray *) scrollPages {
    _scoresLayer = [CCLayer node];
    _scoresLayer.position = ccp(0, 0);
    [self showTitles];
    [self showMissionBorder];
    [self showDistance];
    [self showCredits];
    
    _statsLayer = [CCLayer node];
    _statsLayer.position = ccp(320, 0);
    
    //Most Credits collected in a game
    NSString *statsNameStr = [NSString stringWithFormat:@"Obstacles Dodged\n%d\nCredits Collected\n%d\nPowerups Collected\n%d\nTime Survived\n%d\nTotal Distance\n%d", [GameManager sharedGameManager].obstaclesPassed, [GameManager sharedGameManager].creditsCollectedThisGame, [GameManager sharedGameManager].powerupsCollected, [GameManager sharedGameManager].totalTimePlayed, [GameManager sharedGameManager].totalDistance];

    CCLabelTTF *statsLabel = [CCLabelTTF labelWithString:statsNameStr fontName:@font fontSize:20 dimensions:CGSizeMake(200, _winSize.height * 0.8) hAlignment:kCCTextAlignmentCenter];
    statsLabel.position = ccp(150, _winSize.height / 3);
    //statsNameLabel.tag = kStatsNameLabel;
    [_statsLayer addChild:statsLabel];
    
    return [NSArray arrayWithObjects: _scoresLayer, _statsLayer, nil];
}

- (void) loadFromiCloud {
    //NSString * playCount = [SDCloudUserDefaults objectForKey:@"NumberOfTimesPlayed"];
    //[SDCloudUserDefaults synchronize];
}

- (void) updateiCloud {
    [SDCloudUserDefaults setInteger:[GameManager sharedGameManager].playCount forKey:@"PlayCount"];
    [SDCloudUserDefaults setInteger:[GameManager sharedGameManager].totalCredits forKey:@"TotalCredits"];
    [SDCloudUserDefaults synchronize];
}

- (void) updateGameStats {
    //Obstacles
    [[GameManager sharedGameManager] setObstaclesPassed:[_playerStats getObstacles]];
    [[GameManager sharedGameManager] setTotalObstaclesPassed:[GameManager sharedGameManager].totalObstaclesPassed + [_playerStats getObstacles]];
    [_playerStats setObstacles:0];
    
    //Distance travelled in game
    [[GameManager sharedGameManager] setDistanceTraveled:[_playerStats getDistance]];
    [[GameManager sharedGameManager] setTotalDistance:[GameManager sharedGameManager].totalDistance + [_playerStats getDistance]];
    
    //Powerups
    [[GameManager sharedGameManager] setPowerupsCollected:[_playerStats getPowerups]];
    [[GameManager sharedGameManager] setTotalPowerupsCollected:[GameManager sharedGameManager].totalPowerupsCollected + [_playerStats getPowerups]];
    [_playerStats setPowerups:0];
    
    //Credits
    if ([_playerStats getCredits] != 0) {
        int totalCredits = [GameManager sharedGameManager].totalCredits + [GameManager sharedGameManager].creditsCollectedThisGame;
        [[GameManager sharedGameManager] setTotalCredits:totalCredits];
    }
    [[GameManager sharedGameManager] setTotalCreditsCollected:[GameManager sharedGameManager].totalCreditsCollected + [GameManager sharedGameManager].creditsCollectedThisGame ];
    
    //get playCount
    [GameManager sharedGameManager].playCount++;
    [[GameManager sharedGameManager] saveGameData];
}

- (void) tweetSL {
    NSString *tweetStr;
    //using social framework
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        
        switch (arc4random() % 5) {
            case 0:
                tweetStr = [NSString stringWithFormat:@"I reached %dm in an intense game of Mach X! Try and beat that!", [_playerStats getDistance]];
                break;
            case 1:
                tweetStr = [NSString stringWithFormat:@"I reached %dm in an intense game of Mach X! Woohoo!", [_playerStats getDistance]];
                break;
            case 2:
                tweetStr = [NSString stringWithFormat:@"Think you can beat %dm in an intense game of Mach X?", [_playerStats getDistance]];
                break;
            case 3:
                tweetStr = [NSString stringWithFormat:@"Yeah I reached %dm in Mach X... oh so you heard.. Just making sure!", [_playerStats getDistance]];
                break; 
            case 4:
                tweetStr = [NSString stringWithFormat:@"YYEEAAAHHH! I got %dm in Mach X. You like that? Cause I do!", [_playerStats getDistance]];
                break;
            default:
                tweetStr = [NSString stringWithFormat:@"I reached %dm in an intense game of Mach X! Try and beat that!", [_playerStats getDistance]];
                break;
        }
        
        //set tweetsheet
        [tweetSheet setInitialText:tweetStr];
        
        tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
            if (result == SLComposeViewControllerResultDone) {
                // the user finished composing a tweet
            }
            else if (result == SLComposeViewControllerResultCancelled) {
                // the user cancelled composing a tweet 
            }
            [viewController dismissViewControllerAnimated:YES completion:nil];

        };
        
        [[[CCDirector sharedDirector] view] addSubview:viewController.view];
        [viewController presentViewController:tweetSheet animated:YES completion:nil];

    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void) showButtons {
    //Back Button
    CCMenuItemSprite *backButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Back-hd.png"]selectedSprite:[CCSprite spriteWithFile:@"Back-hd.png"] target:self selector:@selector(Back)];
    backButton.position = ccp(40, 40);
    backButton.tag = kBackButton;

    CCSprite *backBorder = [CCSprite spriteWithFile:@"ButtonBorder-hd.png"];
    backBorder.position = ccp(40, 40);
    backBorder.scale = 0.55f;
    [backBorder runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:8.0f angle:360]]];
    [backBorder runAction:[CCFadeIn actionWithDuration:0.20f]];
    [self addChild:backBorder];
    
    CCMenuItemSprite *storeButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"ShoppingCart-hd.png"]selectedSprite:[CCSprite spriteWithFile:@"ShoppingCart-hd.png"] target:self selector:@selector(ShoppingCart)];
    storeButton.position = ccp(120, 40);
    storeButton.tag = kStoreButton;
    CCSprite *storeBorder = [CCSprite spriteWithFile:@"ButtonBorder-hd.png"];
    storeBorder.position = ccp(120, 40);
    storeBorder.tag = kStoreBorder;
    storeBorder.scale = 0.55f;
    [storeBorder runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:8.0f angle:360]]];
    [storeButton runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCTintTo actionWithDuration:0.3 red:200 green:0 blue:0], [CCTintTo actionWithDuration:0.5 red:255 green:255 blue:255], nil]]];
    [self addChild:storeBorder];
    
    CCMenuItemImage *tweetButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"twitterIcon-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"twitterIcon-hd.png"] target:self selector:@selector(tweetSL)];
    tweetButton.position = ccp(200, 40);
    tweetButton.tag = kTwitterButton;
    
    CCSprite *tweetBorder = [CCSprite spriteWithFile:@"ButtonBorder-hd.png"];
    tweetBorder.position = ccp(200, 40);
    tweetBorder.scale = 0.55;
    tweetBorder.tag = kTwitterBorder;
    [self addChild:tweetBorder];
    [tweetBorder runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:5 angle:360]]];
    
    CCMenuItemSprite *retryButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Retry-hd.png"]selectedSprite:[CCSprite spriteWithFile:@"Retry-hd.png"] target:self selector:@selector(Restart)];
    retryButton.tag = kRetryButton;
    retryButton.scale = 0.6;
    retryButton.position = ccp(280, 40);
    
    CCSprite *retryBorder = [CCSprite spriteWithFile:@"ButtonBorder-hd.png"];
    retryBorder.position = ccp(280, 40);
    retryBorder.tag = kRetryBorder;
    retryBorder.scale = 0.55f;
    [retryBorder runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:8.0f angle:360]]];
    [self addChild:retryBorder];
    
    _endGameMenu = [CCMenu menuWithItems:backButton, storeButton, tweetButton, retryButton, nil];
    _endGameMenu.position = ccp(0,0);
    [self addChild:_endGameMenu];
}

- (void) Back {
    //call main screen scene again
    
    if (menuState == kStoreState) {
        menuState = kNormalState;
        //fade in buttons
        [_scoresLayer runAction:[CCFadeIn actionWithDuration:0.4]];
        [_statsLayer runAction:[CCFadeIn actionWithDuration:0.4]];
        
        [_storeMenuLayer fadeOutStoreLayer];
        [_storeMenuLayer turnOffMenu];
        [_storeMenuLayer cancel];
        [_storeMenuLayer stopReachability];
        
        for (int i = 4; i <= 6; i++) {
            CCSprite *menuBorder = (CCSprite *)[self getChildByTag:i];
            [menuBorder runAction:[CCFadeIn actionWithDuration:0.4f]];
        }
        
        CCMenuItemSprite *storeButton = (CCMenuItemSprite *)[_endGameMenu getChildByTag:kStoreButton];
        storeButton.isEnabled = TRUE;
        [storeButton runAction:[CCFadeIn actionWithDuration:0.4]];
        
        CCMenuItemSprite *twitterButton = (CCMenuItemSprite *)[_endGameMenu getChildByTag:kTwitterButton];
        twitterButton.isEnabled = TRUE;
        [twitterButton runAction:[CCFadeIn actionWithDuration:0.4]];
        
        CCMenuItemSprite *retryButton = (CCMenuItemSprite *)[_endGameMenu getChildByTag:kRetryButton];
        retryButton.isEnabled = TRUE;
        [retryButton runAction:[CCFadeIn actionWithDuration:0.4]];
    }
    else {
        //return back to main menu
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.0f scene:[MainScreen scene] withColor:ccc3(0, 0, 0)]];
    }
}

- (void) ShoppingCart {
    
    menuState = kStoreState;
    
    //fade out scores
    // bring in store
    
    if  (_checkInitialNetworkStatus) {
        [_storeMenuLayer checkInternetConnection];
    }
    _checkInitialNetworkStatus = TRUE;

    //Shows the menu
    [_storeMenuLayer fadeInStoreLayer];
    [_storeMenuLayer turnOnMenu];
    [_storeMenuLayer showScrollerMenuLayer];
    
    //Fade out scores
    [_scoresLayer runAction:[CCFadeOut actionWithDuration:0.3f]];
    [_statsLayer runAction:[CCFadeOut actionWithDuration:0.3f]];
    
    //Fade out buttons but the backButton
    //disable buttons
    CCMenuItemSprite *storeButton = (CCMenuItemSprite *)[_endGameMenu getChildByTag:kStoreButton];
    storeButton.isEnabled = FALSE;
    [storeButton runAction:[CCFadeOut actionWithDuration:0.4]];
    
    CCMenuItemSprite *twitterButton = (CCMenuItemSprite *)[_endGameMenu getChildByTag:kTwitterButton];
    twitterButton.isEnabled = FALSE;
    [twitterButton runAction:[CCFadeOut actionWithDuration:0.4]];
    
    CCMenuItemSprite *retryButton = (CCMenuItemSprite *)[_endGameMenu getChildByTag:kRetryButton];
    retryButton.isEnabled = FALSE;
    [retryButton runAction:[CCFadeOut actionWithDuration:0.4]];
    
    for (int i = 4; i <= 6; i++) {
        CCSprite *menuBorder = (CCSprite *)[self getChildByTag:i];
        [menuBorder runAction:[CCFadeOut actionWithDuration:0.4f]];
    }
}

- (void) Restart {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.5f scene:[Game scene] withColor:ccc3(0, 0, 0)]];
}

- (void) showTitles {
    //Score Title
    CCSprite *ScoreTitle = [CCSprite spriteWithFile:@"ScoreTitle-hd.png"];
    ScoreTitle.position = ccp(160, 380);
    [_scoresLayer addChild:ScoreTitle];
    
    //Credits Title
    CCSprite *creditsTitle = [CCSprite spriteWithFile:@"CreditsTitle-hd.png"];
    creditsTitle.position = ccp(160, 300);
    [_scoresLayer addChild:creditsTitle];
    
    //Missions Title
//    CCSprite *missionsTitle = [CCSprite spriteWithFile:@"MissionsTitle-hd.png"];
//    missionsTitle.position = ccp(160, 220);
//    [_scoresLayer addChild:missionsTitle];
}

- (void) showMissionBorder {
//    CCSprite *missionBorder = [CCSprite spriteWithFile:@"MissionBorder-hd.png"];
//    missionBorder.position = ccp(160, 150);
//    [_scoresLayer addChild:missionBorder];
}

- (void) update:(ccTime)dt {
    [_parallax updateVelocity:ccp(0, -15) delta:dt];
}

- (void) showDistance {
    NSString *distance = [NSString stringWithFormat:@"%d", [_playerStats getDistance]];
    CCLabelTTF *distanceLabel = [CCLabelTTF labelWithString:distance fontName:@font fontSize:15 dimensions:CGSizeMake(100.0f, 50.0f) hAlignment:kCCTextAlignmentCenter lineBreakMode:kCCLineBreakModeWordWrap];
    distanceLabel.position = ccp(160, 330);
    [_scoresLayer addChild:distanceLabel];
}

- (void) showCredits {
    NSString *creditsCollected = [NSString stringWithFormat:@"%d", [GameManager sharedGameManager].creditsCollectedThisGame];
    CCLabelTTF *creditsLabel = [CCLabelTTF labelWithString:creditsCollected fontName:@font fontSize:15 dimensions:CGSizeMake(100.0f, 50.0f) hAlignment:kCCTextAlignmentCenter lineBreakMode:kCCLineBreakModeWordWrap];
    creditsLabel.position = ccp(160, 250);
    [_scoresLayer addChild:creditsLabel];
}

- (void) checkMissions {
    //1
    
    //2
    
    //3
}

@end
