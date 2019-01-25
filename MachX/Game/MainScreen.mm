//
//  IntroLayer.m
//  CrazyPlanes_cc2
//
//  Created by Mark Wong on 23/09/12.
//  Copyright Mark Wong 2012. All rights reserved.
//


// Import the interfaces
#import "MainScreen.h"

#define font "Walkway Bold"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation MainScreen

typedef enum menuButtons {
    kSettingsButton = 0,
    kStoreButton = 1,
    kFacebookButton = 2,
    kBackButton = 3,
    kStoreBorder = 4,
    kFacebookBorder = 5,
    kSettingsBorder = 6,
    kStatsNameLabel = 7
} menuButtons;

typedef enum menuState {
    kStoreState,
    kSettingState,
    kStatsState
} menuState;

typedef enum itemNumbers {
    kSpaceBridge1Num,
    kSpaceBridge2Num,
    kSpaceBridge3Num,
    kCreditMagnetNum,
    kDoubleCreditsNum,
    kExtraLifeNum
}itemNumbers;

@synthesize parallax = _parallax;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainScreen *layer = [[MainScreen alloc] init];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

//
-(id) init
{
	if ((self=[super init])) {
//        [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
        [[GameManager sharedGameManager] loadGameData];

        [self addImagesToCache];
        _winSize = [CCDirector sharedDirector].winSize;

        self.isTouchEnabled = TRUE;
        _canStartGame = TRUE;
        
        _background = [CCLayerColor layerWithColor:ccc4(80, 100, 200, 255)];
        [self addChild:_background z:-10];
        _background2 = [CCLayerColor layerWithColor:ccc4(80, 100, 200, 255)];
        [self addChild:_background2 z:-9];
        
        _flash = [CCSequence actions:[CCSpawn actions:[CCFadeIn actionWithDuration:0.09], [CCTintTo actionWithDuration:0.09 red:185 green:185 blue:215], nil], [CCSpawn actions:[CCFadeOut actionWithDuration:0.09], [CCTintTo actionWithDuration:0.09 red:0 green:0 blue:0], nil], nil];
        
        [_background runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCDelayTime actionWithDuration:15], [CCTintTo actionWithDuration:20 red:40 green:60 blue:135], [CCDelayTime actionWithDuration:15], [CCTintTo actionWithDuration:15 red:30 green:40 blue:80], nil]]];
        
        _titleLayer = [[CCLayer alloc] init];
        [self addChild:_titleLayer z:1];
        
        _settingsLayer = [[CCLayer alloc] init];
        _settingsLayer.position = ccp(320, 0);
        [self addChild:_settingsLayer z:1];
        
        _statsLayer = [[CCLayer alloc] init];
        _statsLayer.position = ccp(_settingsLayer.position.x, 0);
        [self addChild:_statsLayer z:1];
        
        _storeLayer = [[CCLayer alloc] init];
        _storeLayer.position = ccp(-320,0);
        [self addChild:_storeLayer z:1];
        
        _shootingStarsLayer = [[ShootingStars alloc] init];
        [self addChild:_shootingStarsLayer z:-3];
        
        [self performSelector:@selector(introScene) withObject:self afterDelay:1];
        //[self introScene];
        [self parallaxBG];
        [self schedule:@selector(update:)];
        [self storeLayer];
        [self settingsLayer];
        [self playCount];
        [self menu];
        [self BGMCheck];
        [self SFXCheck];
        //[self printiCloudDictionary];
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"MainMenu.mp3" loop:TRUE];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"mainMenuAmbience.m4a" loop:TRUE];
	}
	return self;
}

- (void) addImagesToCache {
    [[CCTextureCache sharedTextureCache] addImage:@"BlankItem-hd.png"];
    [[CCTextureCache sharedTextureCache] addImage:@"ExtraLife-hd.png"];
    [[CCTextureCache sharedTextureCache] addImage:@"DoubleCredits-hd.png"];
    [[CCTextureCache sharedTextureCache] addImage:@"SpaceBridge1-hd.png"];
    [[CCTextureCache sharedTextureCache] addImage:@"SpaceBridge2-hd.png"];
    [[CCTextureCache sharedTextureCache] addImage:@"SpaceBridge3-hd.png"];
    [[CCTextureCache sharedTextureCache] addImage:@"CreditMagnet-hd.png"];
}

- (void) playCount {
    //int playCount = 0;//grab from database/iCloud
    //NSString *playCountStr = [NSString stringWithFormat:@"Play Count: %d", playCount];
    //int playCount = [SDCloudUserDefaults]
    _playCountLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Play Count: %d", [GameManager sharedGameManager].playCount] fontName:@font fontSize:14 dimensions:CGSizeMake(300, 30) hAlignment:kCCTextAlignmentCenter];
    _playCountLabel.position = ccp(160, 0);
    [self addChild:_playCountLabel];
}

- (void) facebookButton {
    NSURL *url = [NSURL URLWithString:@"http://www.facebook.com/106361042867903"];
    [[UIApplication sharedApplication] openURL:url];
}

- (void) introScene {
    _speed = -12;
    
    CCSprite *title = [CCSprite spriteWithFile:@"title-hd.png"];
    title.position = ccp(160, _winSize.height * 0.80);
    //[self addChild:title];
    
    CCSprite *title_fill = [CCSprite spriteWithFile:@"title_fill-hd.png"];
    title_fill.position = ccp(130, _winSize.height * 0.83);
    title_fill.opacity = 0;
    //[self addChild:title_fill];
    CCSprite *title_outline = [CCSprite spriteWithFile:@"title_outline-hd.png"];
    title_outline.position = ccp(130, _winSize.height * 0.83);
    title_outline.opacity = 0;
    //[self addChild:title_outline];
    
    [title_outline runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2], [CCFadeTo actionWithDuration:0.2 opacity:200], [CCFadeTo actionWithDuration:0.2 opacity:255], nil]]];
    [title_fill runAction:[CCSequence actions:[CCFadeIn actionWithDuration:0.2], [CCDelayTime actionWithDuration:0.2f], [CCFadeTo actionWithDuration:0.3 opacity:20], nil]];
    
    CCSprite *titleM_outline = [CCSprite spriteWithFile:@"titleM_outline-hd.png"];
    titleM_outline.position = ccp(60, _winSize.height * 0.81);
    titleM_outline.opacity = 0;
    [_titleLayer addChild:titleM_outline];
    
    CCSprite *titleA_outline = [CCSprite spriteWithFile:@"titleA_outline-hd.png"];
    titleA_outline.position = ccp(95, _winSize.height * 0.81);
    titleA_outline.opacity = 0;
    [_titleLayer addChild:titleA_outline];
    
    CCSprite *titleC_outline = [CCSprite spriteWithFile:@"titleC_outline-hd.png"];
    titleC_outline.position = ccp(135, _winSize.height * 0.81);
    titleC_outline.opacity = 0;
    [_titleLayer addChild:titleC_outline];
    
    CCSprite *titleH_outline = [CCSprite spriteWithFile:@"titleH_outline-hd.png"];
    titleH_outline.position = ccp(165, _winSize.height * 0.81);
    titleH_outline.opacity = 0;
    [_titleLayer addChild:titleH_outline];
    
    CCSprite *titleM_fill = [CCSprite spriteWithFile:@"titleM_fill-hd.png"];
    titleM_fill.position = ccp(70, _winSize.height * 0.81);
    titleM_fill.opacity = 0;
    [_titleLayer addChild:titleM_fill];
    
    CCSprite *titleA_fill = [CCSprite spriteWithFile:@"titleA_fill-hd.png"];
    titleA_fill.position = ccp(105, _winSize.height * 0.81);
    titleA_fill.opacity = 0;
    [_titleLayer addChild:titleA_fill];
    
    CCSprite *titleC_fill = [CCSprite spriteWithFile:@"titleC_fill-hd.png"];
    titleC_fill.position = ccp(145, _winSize.height * 0.81);
    titleC_fill.opacity = 0;
    [_titleLayer addChild:titleC_fill];
    
    CCSprite *titleH_fill = [CCSprite spriteWithFile:@"titleH_fill-hd.png"];
    titleH_fill.position = ccp(175, _winSize.height * 0.81);
    titleH_fill.opacity = 0;
    [_titleLayer addChild:titleH_fill];
    
    [titleM_outline runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.25], [CCSpawn actions:[CCFadeTo actionWithDuration:0.2 opacity:255], [CCMoveTo actionWithDuration:0.2 position:ccp(70, _winSize.height * 0.81)], nil], nil]];
    [titleA_outline runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.45], [CCSpawn actions:[CCFadeTo actionWithDuration:0.2 opacity:255], [CCMoveTo actionWithDuration:0.2 position:ccp(105, _winSize.height * 0.81)], nil], nil]];
    [titleC_outline runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.65], [CCSpawn actions:[CCFadeTo actionWithDuration:0.2 opacity:255], [CCMoveTo actionWithDuration:0.2 position:ccp(145, _winSize.height * 0.81)], nil], nil]];
    [titleH_outline runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.85], [CCSpawn actions:[CCFadeTo actionWithDuration:0.2 opacity:255], [CCMoveTo actionWithDuration:0.2 position:ccp(175, _winSize.height * 0.81)], nil], nil]];
    
    [titleM_fill runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.25], [CCFadeIn actionWithDuration:0.25], [CCDelayTime actionWithDuration:0.4], [CCFadeTo actionWithDuration:0.25 opacity:50], nil]];
    [titleA_fill runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.25], [CCFadeIn actionWithDuration:0.25], [CCDelayTime actionWithDuration:0.4], [CCFadeTo actionWithDuration:0.25 opacity:50], nil]];
    [titleC_fill runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.25], [CCFadeIn actionWithDuration:0.25], [CCDelayTime actionWithDuration:0.4], [CCFadeTo actionWithDuration:0.25 opacity:50], nil]];
    [titleH_fill runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.25], [CCFadeIn actionWithDuration:0.25], [CCDelayTime actionWithDuration:0.4], [CCFadeTo actionWithDuration:0.25 opacity:50], nil]];
    
    CCSprite *titleX_outline = [CCSprite spriteWithFile:@"titleX_outline-hd.png"];
    titleX_outline.position = ccp(230, _winSize.height * 0.83);
    titleX_outline.opacity = 0;
    [_titleLayer addChild:titleX_outline];
    
    CCSprite *titleX_fill = [CCSprite spriteWithFile:@"titleX_fill-hd.png"];
    titleX_fill.position = ccp(245, _winSize.height * 0.83);
    titleX_fill.opacity = 0;
    [_titleLayer addChild:titleX_fill];
    
    [titleX_outline runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.05], [CCMoveTo actionWithDuration:0.2 position:ccp(245, _winSize.height * 0.83)], nil]];
    
    [titleX_outline runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.1], [CCFadeTo actionWithDuration:0.2 opacity:150], [CCFadeTo actionWithDuration:0.2 opacity:255], nil]]];
    [titleX_fill runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.25], [CCFadeIn actionWithDuration:0.2], [CCDelayTime actionWithDuration:0.4], [CCFadeTo actionWithDuration:0.3 opacity:50], nil]];
    
    CCLabelTTF *startLabel = [CCLabelTTF labelWithString:@"Touch\nTo\nStart" fontName:@font fontSize:30 dimensions:CGSizeMake(150, 150) hAlignment:kCCTextAlignmentCenter];
    startLabel.opacity = 0;
    startLabel.position = ccp(160, _winSize.height * 0.31);
    [_titleLayer addChild:startLabel];
    
    [startLabel runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCFadeIn actionWithDuration:0.8], [CCFadeOut actionWithDuration:0.8], nil]]];
    
    NSString *hiScoreStr = [NSString stringWithFormat:@"Hi-Score\n%d", [GameManager sharedGameManager].hiScore];
    
    CCLabelTTF *hiScoreLabel = [CCLabelTTF labelWithString:hiScoreStr fontName:@font fontSize:13 dimensions:CGSizeMake(150, 30) hAlignment:kCCTextAlignmentCenter];
    hiScoreLabel.position = ccp(_winSize.width / 2, _winSize.height * 0.60);
    [_titleLayer addChild:hiScoreLabel];
    //[self schedule:@selector(update:)];
}

- (void) parallaxBG {
    self.parallax = [Background background];
    [self addChild:_parallax z:-1];
    [_parallax darkenWallsMainMenu];
}

- (void) update:(ccTime)dt {
    [_parallax updateVelocity:ccp(0, _speed) delta:dt];
    [_shootingStarsLayer fireShootingStars:dt];
    if (_increaseSpeed) {
        _speed = _speed - 15;
    }
    
    [_playCountLabel setString:[NSString stringWithFormat:@"Play Count: %d", [GameManager sharedGameManager].playCount]];
    
    if (arc4random() % 800 + 1 == 5) {
        if (arc4random() % 2 + 1) {
            [_background2 runAction:[CCSequence actions:_flash, _flash, nil]];
        }
        else {
            [_background2 runAction:[CCSequence actions:_flash, nil]];
        }
    }
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //make stars fly by faster before going to the game
    if (_canStartGame) {
        //_increaseSpeed = TRUE;
        [_storeMenuLayer stopReachability];
        [[SimpleAudioEngine sharedEngine] playEffect:@"MenuStart.m4a"];
        //[self performSelector:@selector(nextScene) withObject:self afterDelay:1.5];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.5f scene:[Game scene] withColor:ccc3(0, 0, 0)]];
    }
}

- (void) nextScene {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.5f scene:[EndGame scene] withColor:ccc3(0, 0, 0)]];

    //Testing endgame layout
    //CCScene *endScene = [EndGame scene];
    //[[CCDirector sharedDirector] replaceScene:endScene];
}

- (void) settingsLayer {
    //Music
    _BGMButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"BGMOn-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"BGMOn-hd.png"] target:self selector:@selector(BGM)];
    _BGMButton.position = ccp(100, 350);
    
    CCSprite *BGMBorder = [CCSprite spriteWithFile:@"ButtonBorder-hd.png"];
    BGMBorder.position = ccp(100, 350);
    BGMBorder.scale = 0.75;
    BGMBorder.rotation = 110;
    [_settingsLayer addChild:BGMBorder];
    [BGMBorder runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:5 angle:360]]];
    
    //Sound
    _SFXButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"SFXOn-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"SFXOn-hd.png"] target:self selector:@selector(SFX)];
    _SFXButton.position = ccp(220, 350);
    
    CCSprite *SFXBorder = [CCSprite spriteWithFile:@"ButtonBorder-hd.png"];
    SFXBorder.position = ccp(220, 350);
    SFXBorder.scale = 0.75;
    SFXBorder.rotation = 210;
    [_settingsLayer addChild:SFXBorder];
    [SFXBorder runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:5 angle:360]]];
        
    //Stats
    CCMenuItemSprite *statsButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Stats-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"Stats-hd.png"] target:self selector:@selector(stats:)];
    statsButton.position = ccp(100, 230);

    CCSprite *statsBorder = [CCSprite spriteWithFile:@"ButtonBorder-hd.png"];
    statsBorder.position = ccp(100, 230);
    statsBorder.scale = 0.75;
    statsBorder.rotation = 86;
    [_settingsLayer addChild:statsBorder];
    [statsBorder runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:5 angle:360]]];
    
    //Game Center
    CCMenuItemSprite *gameCenterButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"GamecenterIcon-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"GamecenterIcon-hd.png"] target:self selector:@selector(showLeaderBoard:)];
    gameCenterButton.position = ccp(220, 230);
    
    CCSprite *gameCenterBorder = [CCSprite spriteWithFile:@"ButtonBorder-hd.png"];
    gameCenterBorder.position = ccp(220, 230);
    gameCenterBorder.scale = 0.75;
    [_settingsLayer addChild:gameCenterBorder];
    [gameCenterBorder runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:5 angle:360]]];

    //iCloud
    CCMenuItemSprite *synciCloudButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"iCloud-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"iCloud-hd.png"] target:self selector:@selector(syncToiCloud:)];
    synciCloudButton.position = ccp(160, 140);
    //TURNED OFF TEMPORARILY
//    synciCloudButton.isEnabled = FALSE;

//    CCSprite *iCloudBorder = [CCSprite spriteWithFile:@"ButtonBorder-hd.png"];
//    iCloudBorder.position = ccp(160, 140);
//    iCloudBorder.scale = 0.75;
//    [_settingsLayer addChild:iCloudBorder];
//    [iCloudBorder runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:5 angle:360]]];
    
    _settingsMenu = [CCMenu menuWithItems:_BGMButton, _SFXButton, statsButton, gameCenterButton, nil];
    _settingsMenu.position = ccp(0, 0);
    [_settingsLayer addChild:_settingsMenu z:4];
}

- (void) stats:(id)sender {

    _settingsMenu.isTouchEnabled = FALSE;
    [_settingsLayer runAction:[CCFadeOut actionWithDuration:0.3f]];
    
    NSString *statsNameStr = [NSString stringWithFormat:@"Obstacles Dodged\n%d\nCredits Collected\n%d\nPowerups Collected\n%d\nTime Survived\n%d\nTotal Distance\n%d", [GameManager sharedGameManager].totalObstaclesPassed, [GameManager sharedGameManager].totalCreditsCollected, [GameManager sharedGameManager].totalPowerupsCollected, [GameManager sharedGameManager].totalTimePlayed, [GameManager sharedGameManager].totalDistanceTraveled];
    CCLabelTTF *statsNameLabel = [CCLabelTTF labelWithString:statsNameStr fontName:@font fontSize:20 dimensions:CGSizeMake(200, _winSize.height) hAlignment:kCCTextAlignmentCenter];
    statsNameLabel.position = ccp(_winSize.width / 2, _winSize.height / 4);
    statsNameLabel.tag = kStatsNameLabel;
    [_statsLayer addChild:statsNameLabel];
}

- (void) BGM {
    [GameManager sharedGameManager].isMusicOff = ![GameManager sharedGameManager].isMusicOff;
    
    if ([GameManager sharedGameManager].isMusicOff) {
        //Music is off
        [_BGMButton setNormalImage:[CCSprite spriteWithFile:@"BGMOff-hd.png"]];
        //Turn music off
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0;
    }
    else {
        //Turn music on
        [_BGMButton setNormalImage:[CCSprite spriteWithFile:@"BGMOn-hd.png"]];
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 1;
    }
    [[GameManager sharedGameManager] saveGameData];
}

- (void) SFX {
    [GameManager sharedGameManager].isSoundEffectsOff = ![GameManager sharedGameManager].isSoundEffectsOff;

    if ([GameManager sharedGameManager].isSoundEffectsOff) {
        //SFX is off
        [_SFXButton setNormalImage:[CCSprite spriteWithFile:@"SFXOff-hd.png"]];
        [SimpleAudioEngine sharedEngine].effectsVolume = 0;
    }
    else {
        [_SFXButton setNormalImage:[CCSprite spriteWithFile:@"SFXOn-hd.png"]];
        [SimpleAudioEngine sharedEngine].effectsVolume = 1;
    }
    
    [[GameManager sharedGameManager] saveGameData];
}

- (void) BGMCheck {
    
    if ([GameManager sharedGameManager].isMusicOff) {
        //Music is off
        [_BGMButton setNormalImage:[CCSprite spriteWithFile:@"BGMOff-hd.png"]];
        //Turn music off
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0;
    }
    else {
        //Turn music on
        [_BGMButton setNormalImage:[CCSprite spriteWithFile:@"BGMOn-hd.png"]];
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 1;
    }
    [[GameManager sharedGameManager] saveGameData];
}

- (void) SFXCheck {
    if ([GameManager sharedGameManager].isSoundEffectsOff) {
        //SFX is off
        [_SFXButton setNormalImage:[CCSprite spriteWithFile:@"SFXOff-hd.png"]];
        [SimpleAudioEngine sharedEngine].effectsVolume = 0;
    }
    else {
        [_SFXButton setNormalImage:[CCSprite spriteWithFile:@"SFXOn-hd.png"]];
        [SimpleAudioEngine sharedEngine].effectsVolume = 1;
    }
    
    [[GameManager sharedGameManager] saveGameData];
}

- (void) menu {    
    //STORE BUTTON
    CCMenuItemSprite *storeButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Store-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"Store-hd.png"] target:self selector:@selector(store:)];
    storeButton.position = ccp(70, 50);
    storeButton.color = ccc3(255, 0, 0);
    storeButton.tag = kStoreButton;
    CCSprite *storeBorder = [CCSprite spriteWithFile:@"ButtonBorder-hd.png"];
    storeBorder.position = ccp(70, 50);
    storeBorder.rotation = 40;
    storeBorder.tag = kStoreBorder;
    storeBorder.scale = 0.75;
    [self addChild:storeBorder];
    [storeBorder runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:5 angle:360]]];
    [storeButton runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCTintTo actionWithDuration:0.3 red:200 green:0 blue:0], [CCTintTo actionWithDuration:0.5 red:255 green:255 blue:255], nil]]];

    //FACEBOOK BUTTON
    CCMenuItemSprite *facebookButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Facebook-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"Facebook-hd.png"] target:self selector:@selector(facebookButton)];
    facebookButton.position = ccp(160, 50);
    facebookButton.tag = kFacebookButton;
    facebookButton.scale = 0.8;
    
    CCSprite *facebookBorder = [CCSprite spriteWithFile:@"ButtonBorder-hd.png"];
    facebookBorder.position = ccp(160, 50);
    facebookBorder.scale = 0.6;
    facebookBorder.tag = kFacebookBorder;
    [self addChild:facebookBorder];
    [facebookBorder runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:5 angle:360]]];
    
    //SETTINGS BUTTON
    CCMenuItemSprite *settingsButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Settings-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"Settings-hd.png"] target:self selector:@selector(settings:)];
    settingsButton.position = ccp(250, 50);
    settingsButton.tag = kSettingsButton;
    
    CCSprite *settingsBorder = [CCSprite spriteWithFile:@"ButtonBorder-hd.png"];
    settingsBorder.position = ccp(250, 50);
    settingsBorder.scale = 0.75;
    settingsBorder.tag = kSettingsBorder;
    settingsBorder.rotation = 130;
    [self addChild:settingsBorder];
    [settingsBorder runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:5 angle:360]]];

    //BACK BUTTON
    CCMenuItemSprite *backButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Back-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"Back-hd.png"] target:self selector:@selector(back:)];
    backButton.opacity = 0;
    backButton.position = ccp(70, 50);
    backButton.tag = kBackButton;
    backButton.isEnabled = FALSE;
    
    _mainMenu = [CCMenu menuWithItems:settingsButton, storeButton, backButton, facebookButton, nil];
    _mainMenu.position = ccp(0, 0);
    [self addChild:_mainMenu z:4];
    
}

- (void) store:(id) sender {
    //STATE
    _state = kStoreState;
    _canStartGame = FALSE;

    
    //Shows the menu
    [_storeMenuLayer fadeInStoreLayer];
    [_storeMenuLayer turnOnMenu];
    [_storeMenuLayer showScrollerMenuLayer];
    
    if  (_checkInitialNetworkStatus) {
        [_storeMenuLayer checkInternetConnection];
    }
    _checkInitialNetworkStatus = TRUE;
    [[SimpleAudioEngine sharedEngine] playEffect:@"MenuStart.m4a" pitch:.8 pan:.1 gain:1];
    //Fade Out? YES!
    [_titleLayer runAction:[CCEaseSineIn actionWithAction:[CCMoveTo actionWithDuration:0.4f position:ccp(320,0)]]];
    [_storeLayer runAction:[CCEaseSineIn actionWithAction:[CCMoveTo actionWithDuration:0.4f position:ccp(0,0)]]];
    
    //Fade out store, facebook, settings buttons.
    CCMenuItemSprite *storeButton = (CCMenuItemSprite *)[_mainMenu getChildByTag:kStoreButton];
    storeButton.isEnabled = FALSE;
    [storeButton runAction:[CCFadeOut actionWithDuration:0.4f]];
    
    CCMenuItemSprite *facebookButton = (CCMenuItemSprite *)[_mainMenu getChildByTag:kFacebookButton];
    facebookButton.isEnabled = FALSE;
    [facebookButton runAction:[CCFadeOut actionWithDuration:0.4]];
    
    CCMenuItemSprite *settingsButton = (CCMenuItemSprite *)[_mainMenu getChildByTag:kSettingsButton];
    settingsButton.isEnabled = FALSE;
    [settingsButton runAction:[CCFadeOut actionWithDuration:0.4f]];

    CCSprite *FacebookBorders = (CCSprite *)[self getChildByTag:kFacebookBorder];
    [FacebookBorders runAction:[CCFadeOut actionWithDuration:0.4f]];
    
    CCSprite *SettingsBorders = (CCSprite *)[self getChildByTag:kSettingsBorder];
    [SettingsBorders runAction:[CCFadeOut actionWithDuration:0.4f]];
    
    [self fadeInBackButton];
}

- (void) syncToiCloud:(id) sender {
    if ([GameManager sharedGameManager].iCloudTimestamp == NULL) {
        NSDate *newDate = [NSDate date];

        if ([SDCloudUserDefaults objectForKey:@"IcloudTimestamp"] == NULL) {
//            NSLog(@"NEW INSTALL");
            [SDCloudUserDefaults setObject:newDate forKey:@"IcloudTimestamp"];
            [[GameManager sharedGameManager] setICloudTimestamp:newDate];
        }
        //[[GameManager sharedGameManager] setICloudTimestamp:newDate];
    }
    //if timestamp exists then save data to the cloud
    if ([SDCloudUserDefaults objectForKey:@"IcloudTimestamp"] != NULL) {
//        if local timestamp is not NULL
        if ([GameManager sharedGameManager].iCloudTimestamp == NULL) {
//            NSLog(@"New device");
//            NSLog(@"RETREIVING DATA");
//            NEW DEVICE if icloud timestamp exists but doesn't exist on the device, then DOWNLOAD data
//            NSLog(@"%d", [SDCloudUserDefaults integerForKey:@"PlayCount"]);
//            NSLog(@"%@", [GameManager sharedGameManager].iCloudTimestamp);
            //[GameManager sharedGameManager].totalCredits = [SDCloudUserDefaults integerForKey:@"TotalCredits"];
            
            [GameManager sharedGameManager].playCount = [SDCloudUserDefaults integerForKey:@"PlayCount"];
        }
    }
    if ([SDCloudUserDefaults objectForKey:@"IcloudTimestamp"] != NULL) {
        //        if local timestamp is not NULL and icloud timestamp is not NULL then save data to cloud
        if ([GameManager sharedGameManager].iCloudTimestamp != NULL) {
//            NSLog(@"SAVING DATA");
//            Do I need this? Data gets saved after game is finished
        }
    }
    
    [SDCloudUserDefaults synchronize];
    [[GameManager sharedGameManager] saveGameData];
    
    //NSLog(@"Timestamp %f", [[SDCloudUserDefaults objectForKey:@"IcloudTimestamp"] timeIntervalSinceNow]);
}

- (void) printiCloudDictionary {
    NSUbiquitousKeyValueStore *iCloudStore = [NSUbiquitousKeyValueStore defaultStore];
    NSDictionary *iCloudDict = [iCloudStore dictionaryRepresentation];
    if (iCloudDict) {
        NSLog(@"iCloud dictionary contents:%@", [iCloudDict description]);
    } else {
        NSLog(@"iCloud dictionary not found.");
    }
}
     
- (void) settings:(id) sender {    
    //STATE
    _state = kSettingState;
    _canStartGame = FALSE;

    [[SimpleAudioEngine sharedEngine] playEffect:@"MenuStart.m4a"];
    [_settingsLayer runAction:[CCFadeIn actionWithDuration:0.4f]];
    _settingsMenu.isTouchEnabled = TRUE;
    [_titleLayer runAction:[CCEaseSineIn actionWithAction:[CCMoveTo actionWithDuration:0.4f position:ccp(-320,0)]]];
    [_settingsLayer runAction:[CCEaseSineIn actionWithAction:[CCMoveTo actionWithDuration:0.4f position:ccp(0,0)]]];
    [_statsLayer runAction:[CCEaseSineIn actionWithAction:[CCMoveTo actionWithDuration:0.4f position:ccp(0,0)]]];
    
    //Fade out main menu buttons, facbeook button and settings button
    for (int i = 0; i <= 2; i++) {
        CCMenuItemSprite *menuButton = (CCMenuItemSprite *)[_mainMenu getChildByTag:i];
        [menuButton runAction:[CCFadeOut actionWithDuration:0.4f]];
        menuButton.isEnabled = FALSE;
    }
    
    for (int i = 5; i <= 6; i++) {
        CCSprite *menuBorder = (CCSprite *)[self getChildByTag:i];
        [menuBorder runAction:[CCFadeOut actionWithDuration:0.4f]];
    }
    
    [self fadeInBackButton];
}

- (void) fadeInBackButton {
    //show back button
    CCMenuItemSprite *backButton = (CCMenuItemSprite *)[_mainMenu getChildByTag:kBackButton];
    
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [backButton runAction:[CCFadeIn actionWithDuration:0.4f]];
    }];
    [backButton runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.4f], actionMoveDone, nil]];
    backButton.isEnabled = TRUE;
}

- (void) back:(id) sender {
    
    //Fade out back button
    CCMenuItemSprite *backButton = (CCMenuItemSprite*) sender;
    [backButton runAction:[CCFadeOut actionWithDuration:0.4f]];
    //Disable back button
    backButton.isEnabled = FALSE;
    _canStartGame = TRUE;

    if (_state == kSettingState) {
        //move title and setting layers to the right
        [_titleLayer runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2f], [CCEaseSineIn actionWithAction:[CCMoveTo actionWithDuration:0.4f position:ccp(0,0)]], nil]];
        [_settingsLayer runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2f], [CCEaseSineIn actionWithAction:[CCMoveTo actionWithDuration:0.4f position:ccp(320,0)]], nil]];
        [_statsLayer removeChildByTag:kStatsNameLabel cleanup:YES];
    }
    else if (_state == kStoreState) {
        //move title back to main screen. store to the left
        [_titleLayer runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2f], [CCEaseSineIn actionWithAction:[CCMoveTo actionWithDuration:0.4f position:ccp(0,0)]], nil]];
        [_storeLayer runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2f], [CCEaseSineIn actionWithAction:[CCMoveTo actionWithDuration:0.4f position:ccp(-320,0)]], nil]];
        [_storeLayer runAction:[CCFadeOut actionWithDuration:0.1f]];
        
        [_storeMenuLayer stopReachability];
        [_storeMenuLayer turnOffMenu];
        [_storeMenuLayer fadeOutStoreLayer];
        [_storeMenuLayer cancel];
    }
    
    //Fade In borders
    for (int i = 5; i <= 6; i++) {
        CCSprite *border = (CCSprite *)[self getChildByTag:i];
        [border runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.4f], [CCFadeIn actionWithDuration:0.4f], nil]];
    }
    
    //Bring back main menu
    CCMenuItemSprite *storeButton = (CCMenuItemSprite *)[_mainMenu getChildByTag:kStoreButton];
    storeButton.isEnabled = TRUE;
    [storeButton runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.4f], [CCFadeIn actionWithDuration:0.4f], nil]];
    
    CCMenuItemSprite *facebookButton = (CCMenuItemSprite *)[_mainMenu getChildByTag:kFacebookButton];
    facebookButton.isEnabled = TRUE;
    [facebookButton runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.4f], [CCFadeIn actionWithDuration:0.4f], nil]];
    
    CCMenuItemSprite *settingsButton = (CCMenuItemSprite *)[_mainMenu getChildByTag:kSettingsButton];
    settingsButton.isEnabled = TRUE;
    [settingsButton runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.4f], [CCFadeIn actionWithDuration:0.4f], nil]];
    
}

- (void) storeLayer {
    _storeMenuLayer = [StoreMenuLayer node];
    _storeMenuLayer.position = ccp(0, 0);
    [_storeMenuLayer hideScrollerMenuLayer];
    [_storeLayer addChild:_storeMenuLayer];
}

//GAMECENTER STUFF!!!

- (void) showLeaderBoard:(id) sender {
    [self showLeaderBoardGameCenter:@"machx.topScores"];
}

- (void) showLeaderBoardGameCenter:(NSString *) leaderboardKey {
    
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != NULL)
    {
        leaderboardController.leaderboardDelegate = self;
        leaderboardController.category = leaderboardKey;
        leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
        gcViewController = [[UIViewController alloc] init];
        [[[CCDirector sharedDirector] view] addSubview:gcViewController.view];
        [gcViewController presentViewController:leaderboardController animated:YES completion:nil];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *) viewController
{
    //AppDelegate *delegate = [UIApplication sharedApplication].delegate;
	[gcViewController dismissViewControllerAnimated:YES completion:nil];
	//[gcViewController release];
}

@end
