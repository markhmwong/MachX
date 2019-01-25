//
//  Game.m
//  CrazyPlanes_cc2
//
//  Created by Mark Wong on 30/09/12.
//  Copyright 2012 Mark Wong. All rights reserved.
//

#import "Game.h"
#define PTM_RATIO 32
#define font "Walkway Bold"

@implementation Game

typedef enum itemNumbers {
    kBlankItem,
    kSpaceBridge1Num,
    kSpaceBridge2Num,
    kSpaceBridge3Num,
    kCreditMagnetNum,
    kDoubleCreditsNum,
    kExtraLifeNum
}itemNumbers;

@synthesize player = _player;
@synthesize world = _world;
@synthesize terrain = _terrain;
@synthesize HUD = _HUD;
@synthesize parallax = _parallax;
@synthesize leftWall = _leftWall;
@synthesize rightWall = _rightWall;
@synthesize middleWall = _middleWall;
@synthesize xpDetector = _xpDetector;
@synthesize speedPowerup = _speedPowerup;
@synthesize sideWallRight = _sideWallRight;
@synthesize sideWallLeft = _sideWallLeft;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Game *layer = [Game node];

	// add layer as a child to scene
	[scene addChild: layer];
	
    //add GameHUD to the scene
    GameHUD *HUDLayer = [GameHUD node];
    [scene addChild: HUDLayer z:1];
    
    //EndGame *EndGameScene = [EndGame node];
    //[scene addChild:EndGameScene z:2];
    
    //pointer to the HUD in this layer
    layer.HUD = HUDLayer;

	// return the scene
	return scene;
}

-(id) init {
    if ((self=[super init])) {

        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"hardnoise.mp3" loop:TRUE];
//        switch (arc4random() % 2 + 1) {
//            case 1:
//                [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Driven.mp3" loop:TRUE];
//                break;
//            case 2:
//                [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"hardnoise.mp3" loop:TRUE];
//                break;
//            default:
//                break;
//        }

        self.scale = 1;

        _enemyHelper = [EnemyHelper sharedXPManager];
        _xpManager = [XPManager sharedXPManager];
        _playerStats = [PlayerStats sharedXPManager];

        _intervalLevel = 59;
        _wallTimerdt = 1;
        _randomSpawnTimer = 0;
        _machLevel = 1;
        _countDown = 6;
        
        //Game Initial states
        _wallLight = TRUE;
        _newEvent = FALSE;
        _newGameDelay = FALSE;
        _eventFinishedState = FALSE;
        _enableMachWaveAfterDelay = TRUE;
        _newSpawnPosition = 0;
        _prevSpawnPosition = 0;
        _offscreenSpawnPosY = 400;
        _terrainMovement = 0;
        _eventType = 1;
        
        //ITEMS INITIAL STATES
        magnetState = FALSE;
        doubleCreditsState = FALSE;
        extraLifeState = FALSE;
        
        _numOfBeams = 0;
        _checkIfShieldIsCritical = TRUE;
        _checkIfShieldIsNominal = FALSE;
        [_playerStats setCredits:0];
        [[GameManager sharedGameManager] setCoinsCollected:0];

        //Timer initial state
        _globalEventTimer = 0;
        _globalEventTime = 20;
        _reticleTime = 1;
        
        //Powerup initial states
        _reverseControls = 1;
        _slowDebuff = FALSE;
        _fullShieldPowerup = FALSE;
        
        //Powerup timers
        _coinTimer = 0;
        _powerupTimer = 0;
        _levelTimer = 0;
        _reverseTimer = 0;
        _missileTimer = 0;
        _slowDownDelay = 1;
        _nextPowerupTime = 7;
        
        self.isAccelerometerEnabled = YES;
        self.isTouchEnabled = YES;
        
        //setup world
        [self initGameWorld];
        
        //add Terrain
        self.terrain = [Terrain terrainWithWorld:_world];
        [self addChild:_terrain];
        
        //parallax background
        self.parallax = [Background background];
        [self addChild:_parallax z:-1];

        //colour BACKGROUND
        _background = [CCLayerColor layerWithColor:ccc4(9, 54, 105, 255)];
        [self addChild:_background z:-10];
        
        _background2 = [CCLayerColor layerWithColor:ccc4(80, 100, 200, 255)];
        [self addChild:_background2 z:-9];
        
        _flash = [CCSequence actions:[CCSpawn actions:[CCFadeIn actionWithDuration:0.09], [CCTintTo actionWithDuration:0.09 red:185 green:185 blue:215], nil], [CCSpawn actions:[CCFadeOut actionWithDuration:0.09], [CCTintTo actionWithDuration:0.09 red:0 green:0 blue:0], nil], nil];
        
        //SHOOTING STARS
        _shootingStarsLayer = [[ShootingStars alloc] init];
        [self addChild:_shootingStarsLayer z:-3];
        
        //HUD
        [_HUD AnimateReadyGoLabel];
        
        //add Joystick Sprites
//        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
//        [frameCache addSpriteFramesWithFile:@"tutorial2_files.plist"];
        
        //add Joystick
        //[self addJoystick];
        
        //add Player
        self.player = [Player InitWithGame:self];
        [_terrain addChild:_player];
        _player.position = ccp(_winSize.width * 0.5, 240);
        
        //Reset stats
        [_player resetShield];
        
        self.xpDetector = [XPDetector InitWithGame:self];
        [self addChild:_xpDetector];
        
        self.sideWallLeft = [SideWall InitWithGame:self Position:ccp(-4, [_player getPlayerPosition].y)];
        [self addChild:_sideWallLeft];
        
        self.sideWallRight = [SideWall InitWithGame:self Position:ccp(324, [_player getPlayerPosition].y)];
        [self addChild:_sideWallRight];
        
        _xpWallArray = [[NSMutableArray alloc] init];
        _xpWallCountArray = [[NSMutableArray alloc] init];
        _laserBeamArray = [[NSMutableArray alloc] init];
        _missileArray = [[NSMutableArray alloc] init];
        _missileWarningArray = [[NSMutableArray alloc] init];
        _explosionArray = [[NSMutableArray alloc] init];
        
        _machWave = [MachWave InitWithGame:self Position:ccp(_winSize.width / 2, 20)];
        [_terrain addChild:_machWave];
        
//      WallLight *wallLight = [[WallLight alloc] initLight];
//      wallLight.position = ccp(70, 300);
//      [self addChild:wallLight];
        
        CCMenuItemSprite *Powerup_Button = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"PowerupTimer-hd.png"]selectedSprite:[CCSprite spriteWithFile:@"PowerupTimer-hd.png"] target:self selector:@selector(powerup:)];
        Powerup_Button.tag = 4;
        Powerup_Button.opacity = 100;
        Powerup_Button.position = ccp(0,-190);
        //[Powerup_Button runAction:[CCSequence actions:[CCDelayTime actionWithDuration:3], [CCFadeTo actionWithDuration:2.0f opacity:50], nil]];
        
        _shieldButton = [CCHoldableMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Boost_Button.png"] holdBlock:^(id sender){_shieldEnabled = TRUE;} releaseBlock:^(id sender) {_shieldEnabled = FALSE;}];
        _shieldButton.position = ccp(80,-190);
        
        _boostButton = [CCHoldableMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Boost_Button.png"] holdBlock:^(id sender){_boostEnabled = TRUE;} releaseBlock:^(id sender){_boostEnabled = TRUE;}];
        
        //INITIALISE LASER BEAMS
        [self initialiseLaserBeamsOffscreen];
        
        _winSize = [CCDirector sharedDirector].winSize;
        
        CCMenuItemSprite *Pause_Button = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Pause-hd.png"]selectedSprite:[CCSprite spriteWithFile:@"Pause-hd.png"] target:self selector:@selector(pause:)];
        Pause_Button.scale = 0.3f;
        Pause_Button.position = ccp(20, _winSize.height * 0.95);
        Pause_Button.tag = 1;
        //[Pause_Button runAction:[CCSequence actions:[CCDelayTime actionWithDuration:3], [CCFadeTo actionWithDuration:2.0f opacity:1], nil]];
        
        _ingameMenu = [CCMenu menuWithItems:Pause_Button, Powerup_Button, nil];
        _ingameMenu.position = ccp(0,0);
        [self addChild:_ingameMenu];
        
        _pauseBorder = [CCSprite spriteWithFile:@"ButtonBorder-hd.png"];
        _pauseBorder.position = ccp(20, _winSize.height * 0.95);
        _pauseBorder.scale = 0.3f;
        _pauseBorder.tag = 2;
        [_pauseBorder runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:8.0f angle:360]]];
        [self addChild:_pauseBorder];
        
        [self showPowerupButtons];
        
        if ([GameManager sharedGameManager].firstTimePlayed == FALSE) {
            [self showTiltTutorial];
        }
        
        _recordLine = [CCSprite spriteWithFile:@"RecordLine-hd.png"];
        _recordLine.opacity = 0;
        _recordLine.position = ccp(_winSize.width * 0.5, _hiScorePosY);
        [_terrain addChild:_recordLine z:-2];
        
        if ([GameManager sharedGameManager].hiScore >= 50) {
            _showHiScore = TRUE;
            _hiScorePosY = [GameManager sharedGameManager].hiScore / 0.1;
            _recordLine.opacity = 200;
            _recordLine.position = ccp(_winSize.width * 0.5, _hiScorePosY);
        }
        
        //Contact Listener
        _contactListener = new MyContactListener();
		_world->SetContactListener(_contactListener);
        
        //[self machSpeedLabel];

        [self schedule:@selector(update:)];
    }
    return self;
}

- (void) showTiltTutorial {
    _tiltLeft = [CCSprite spriteWithFile:@"TiltLeft-hd.png"];
    _tiltLeft.position = ccp(_winSize.width * 0.25, _winSize.height * 0.55);
    [self addChild:_tiltLeft];
    [_tiltLeft runAction:[CCSequence actions:[CCRepeat actionWithAction:[CCSequence actions:[CCFadeIn actionWithDuration:0.5], [CCFadeOut actionWithDuration:0.5], nil] times:4], [CCFadeOut actionWithDuration:2.0f], nil]];

    _tiltRight = [CCSprite spriteWithFile:@"TiltLeft-hd.png"];
    _tiltRight.position = ccp(_winSize.width * 0.75, _winSize.height * 0.55);
    _tiltRight.flipX = TRUE;
    [self addChild:_tiltRight];
    [_tiltRight runAction:[CCSequence actions:[CCRepeat actionWithAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.5], [CCFadeIn actionWithDuration:0.5], nil] times:4], [CCFadeOut actionWithDuration:2.0f], nil]];
    _tiltText = [CCLabelTTF labelWithString:@"TILT\nAND\nTOUCH" fontName:@font fontSize:20 dimensions:CGSizeMake(110, 90) hAlignment:kCCTextAlignmentCenter];
    _tiltText.position = ccp(_winSize.width * 0.5, _winSize.height * 0.53);
    [self addChild:_tiltText];
    [_tiltText runAction:[CCSequence actions:[CCDelayTime actionWithDuration:3], [CCFadeOut actionWithDuration:2.0f], nil]];
    
    [[GameManager sharedGameManager] setFirstTimePlayed:TRUE];
    [[GameManager sharedGameManager] saveGameData];
}

- (void) showPowerupButtons {
    _powerupButton1 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"ButtonBorder-hd.png"]selectedSprite:[CCSprite spriteWithFile:@"ButtonBorder-hd.png"] target:self selector:@selector(powerup1:)];
    _powerupButton1.position = ccp(100, 140);
    _powerupButton1.scale = 0.8;

    _powerupButton2 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"ButtonBorder-hd.png"]selectedSprite:[CCSprite spriteWithFile:@"ButtonBorder-hd.png"] target:self selector:@selector(powerup2:)];
    _powerupButton2.position = ccp(220, 140);
    _powerupButton2.scale = 0.8;

    _powerupMenu = [CCMenu menuWithItems:_powerupButton1, _powerupButton2, nil];
    _powerupMenu.position = ccp(0,0);
    [self addChild:_powerupMenu z:10];
    
    [_powerupButton1 runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:8.0f angle:360]]];
    [_powerupButton2 runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:8.0f angle:360]]];

    //show powerups
    switch ([GameManager sharedGameManager].slot1) {
        case kBlankItem:
            _powerupSlot1 = [CCSprite spriteWithFile:@"SelectItem-hd.png"];
            break;
        case kSpaceBridge1Num:
            _powerupSlot1 = [CCSprite spriteWithFile:@"SpaceBridge1-hd.png"];
            break;
        case kSpaceBridge2Num:
            _powerupSlot1 = [CCSprite spriteWithFile:@"SpaceBridge2-hd.png"];
            break;
        case kSpaceBridge3Num:
            _powerupSlot1 = [CCSprite spriteWithFile:@"SpaceBridge3-hd.png"];
            break;
        case kCreditMagnetNum:
            //magnet bool
            _powerupSlot1 = [CCSprite spriteWithFile:@"CreditMagnet-hd.png"];
            break;
        case kDoubleCreditsNum:
            //double credits bool
            _powerupSlot1 = [CCSprite spriteWithFile:@"DoubleCredits-hd.png"];
            break;
        case kExtraLifeNum:
            _powerupSlot1 = [CCSprite spriteWithFile:@"ExtraLife-hd.png"];
            break;
        default:
            _powerupSlot1 = [CCSprite spriteWithFile:@""];
            break;
    }
    _powerupSlot1.position = ccp(100, 140);
    [self addChild:_powerupSlot1];
    
    switch ([GameManager sharedGameManager].slot2) {
        case kBlankItem:
            _powerupSlot2 = [CCSprite spriteWithFile:@"SelectItem-hd.png"];
            break;
        case kSpaceBridge1Num:
            _powerupSlot2 = [CCSprite spriteWithFile:@"SpaceBridge1-hd.png"];
            break;
        case kSpaceBridge2Num:
            _powerupSlot2 = [CCSprite spriteWithFile:@"SpaceBridge2-hd.png"];
            break;
        case kSpaceBridge3Num:
            _powerupSlot2 = [CCSprite spriteWithFile:@"SpaceBridge3-hd.png"];
            break;
        case kCreditMagnetNum:
            //magnet bool
            _powerupSlot2 = [CCSprite spriteWithFile:@"CreditMagnet-hd.png"];
            break;
        case kDoubleCreditsNum:
            //double credits bool
            _powerupSlot2 = [CCSprite spriteWithFile:@"DoubleCredits-hd.png"];
            break;
        case kExtraLifeNum:
            _powerupSlot2 = [CCSprite spriteWithFile:@"ExtraLife-hd.png"];
            break;
        default:
            _powerupSlot2 = [CCSprite spriteWithFile:@""];
            break;
    }
    _powerupSlot2.position = ccp(220, 140);
    [self addChild:_powerupSlot2];
    
    [_powerupMenu runAction:[CCSequence actions:[CCFadeIn actionWithDuration:0.3f], [CCDelayTime actionWithDuration:3.0f], [CCFadeOut actionWithDuration:0.4f], [CCCallFuncN actionWithTarget:self selector:@selector(disablePowerup)], nil]];
    [_powerupSlot1 runAction:[CCSequence actions:[CCFadeIn actionWithDuration:0.3f], [CCDelayTime actionWithDuration:3.0f], [CCFadeOut actionWithDuration:0.4f], nil]];
    [_powerupSlot2 runAction:[CCSequence actions:[CCFadeIn actionWithDuration:0.3f], [CCDelayTime actionWithDuration:3.0f], [CCFadeOut actionWithDuration:0.4f], nil]];

}

- (void) disablePowerup {
    _powerupMenu.isTouchEnabled = FALSE;
}

- (void) spaceBridge1Powerup {
    //TEST FUNCTION
    //set type
    _spaceBridgeType = 1;
    //player boost sprite
    
    //boost player to 1000
    [_player spaceBridge1];
    //make invulnerable for duration of boost
}

- (void) checkSpaceBridgePowerupDistance {
    switch (_spaceBridgeType) {
        case 1:
            if ([_player getPositionY] * 0.1 >= 1000 && [_player getPositionY] * 0.1 <= 1010) {
                //stop the boost
                [_player stopSpaceBridgePowerup];
                _delayMachWave = TRUE;
                _delayMachWaveTimer = 0;
            }
            break;
        case 2:
            if ([_player getPositionY] * 0.1 >= 5000 && [_player getPositionY] * 0.1 <= 5010) {
                //stop the boost
                [_player stopSpaceBridgePowerup];
                _delayMachWave = TRUE;
                _delayMachWaveTimer = 0;
            }
            break;
        case 3:
            if ([_player getPositionY] * 0.1 >= 10000 && [_player getPositionY] * 0.1 <= 10010) {
                //stop the boost
                [_player stopSpaceBridgePowerup];
                _delayMachWave = TRUE;
                _delayMachWaveTimer = 0;
            }
            break;
        default:
            break;
    }
}

- (void) powerup1:(id) sender {
    //get item from manager
    //run item action
    switch ([GameManager sharedGameManager].slot1) {
        case kSpaceBridge1Num:
            if ([GameManager sharedGameManager].spaceBridge1Stock > 0) {
                _spaceBridgeType = 1;
                [_player spaceBridge1];
                [GameManager sharedGameManager].spaceBridge1Stock--;
                [[SimpleAudioEngine sharedEngine] playEffect:@"SpaceBridge.m4a"];
            }

            break;
        case kSpaceBridge2Num:
            if ([GameManager sharedGameManager].spaceBridge2Stock > 0) {
                _spaceBridgeType = 2;
                [_player spaceBridge2];
                [GameManager sharedGameManager].spaceBridge2Stock--;
                [[SimpleAudioEngine sharedEngine] playEffect:@"SpaceBridge.m4a"];
            }
            break;
        case kSpaceBridge3Num:
            if ([GameManager sharedGameManager].spaceBridge3Stock > 0) {
                _spaceBridgeType = 3;
                [_player spaceBridge3];
                [GameManager sharedGameManager].spaceBridge3Stock--;
                [[SimpleAudioEngine sharedEngine] playEffect:@"SpaceBridge.m4a"];
            }

            break;
        case kCreditMagnetNum:
            //magnet bool
            if ([GameManager sharedGameManager].magnetStock > 0) {
                magnetState = TRUE;
                [GameManager sharedGameManager].magnetStock--;
                [_HUD enableMagnetIcon];
            }
            break;
        case kDoubleCreditsNum:
            if ([GameManager sharedGameManager].doubleCreditsStock > 0) {
                doubleCreditsState = TRUE;
                [GameManager sharedGameManager].doubleCreditsStock--;
                [_HUD enableDoubleCreditsIcon];
            }
            //double credits bool
            break;
        case kExtraLifeNum:
            if ([GameManager sharedGameManager].extraLifeStock > 0) {
                extraLifeState = TRUE;
                [GameManager sharedGameManager].extraLifeStock--;
                [_HUD enableExtraLifeIcon];
            }
            break;
        default:
            break;
    }
    _powerupButton1.isEnabled = FALSE;
    [[GameManager sharedGameManager] saveGameData];
}

- (void) powerup2:(id) sender {
    switch ([GameManager sharedGameManager].slot2) {
        case kSpaceBridge1Num:
            if ([GameManager sharedGameManager].spaceBridge1Stock > 0) {
                _spaceBridgeType = 1;
                [_player spaceBridge1];
                [GameManager sharedGameManager].spaceBridge1Stock--;
                [[SimpleAudioEngine sharedEngine] playEffect:@"SpaceBridge.m4a"];
            }
            
            break;
        case kSpaceBridge2Num:
            if ([GameManager sharedGameManager].spaceBridge2Stock > 0) {
                _spaceBridgeType = 2;
                [_player spaceBridge2];
                [GameManager sharedGameManager].spaceBridge2Stock--;
                [[SimpleAudioEngine sharedEngine] playEffect:@"SpaceBridge.m4a"];
            }
            break;
        case kSpaceBridge3Num:
            if ([GameManager sharedGameManager].spaceBridge3Stock > 0) {
                _spaceBridgeType = 3;
                [_player spaceBridge3];
                [GameManager sharedGameManager].spaceBridge3Stock--;
                [[SimpleAudioEngine sharedEngine] playEffect:@"SpaceBridge.m4a"];
            }
            break;
        case kCreditMagnetNum:
            //magnet bool
            if ([GameManager sharedGameManager].magnetStock > 0) {
                magnetState = TRUE;
                [GameManager sharedGameManager].magnetStock--;
                [_HUD enableMagnetIcon];
            }
            break;
        case kDoubleCreditsNum:
            if ([GameManager sharedGameManager].doubleCreditsStock > 0) {
                doubleCreditsState = TRUE;
                [GameManager sharedGameManager].doubleCreditsStock--;
                [_HUD enableDoubleCreditsIcon];
            }
            break;
        case kExtraLifeNum:
            if ([GameManager sharedGameManager].extraLifeStock > 0) {
                extraLifeState = TRUE;
                [GameManager sharedGameManager].extraLifeStock--;
                [_HUD enableExtraLifeIcon];
            }
            break;
        default:
            break;
    }
    _powerupButton2.isEnabled = FALSE;
    [[GameManager sharedGameManager] saveGameData];
}

- (void) initialiseLaserBeamsOffscreen {
    _laserBeam1 = [LaserBeam InitWithGame:self Position:ccp(10, [_player getPositionY]) tag:-14];
    [_terrain addChild:_laserBeam1];
    [_laserBeamArray addObject:_laserBeam1];
    
    _laserBeam2 = [LaserBeam InitWithGame:self Position:ccp(160, [_player getPositionY]) tag:-15];
    [_terrain addChild:_laserBeam2];
    [_laserBeamArray addObject:_laserBeam2];
    
    _laserBeam3 = [LaserBeam InitWithGame:self Position:ccp(310, [_player getPositionY]) tag:-16];
    [_terrain addChild:_laserBeam3];
    [_laserBeamArray addObject:_laserBeam3];
    _laserBeamTimer = 0;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //UITouch * touch = [touches anyObject];
    [_player setBoost:TRUE];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_player setBoost:FALSE];
}

- (void) pause:(id) sender {
    [self pauseSchedulerAndActions];
    [_laserBeam1.spriteBody pauseSchedulerAndActions];
    [_laserBeam2.spriteBody pauseSchedulerAndActions];
    [_laserBeam3.spriteBody pauseSchedulerAndActions];
    [_laserBeam4.spriteBody pauseSchedulerAndActions];
    for (Explosion *explosionTemp in _explosionArray) {
        [explosionTemp.spriteBody pauseSchedulerAndActions];
    }
    
    [[[CCDirector sharedDirector] scheduler] setTimeScale:1];
    CCMenuItemSprite *pause = (CCMenuItemSprite*)[_ingameMenu getChildByTag:1];
    pause.isEnabled = FALSE;
    
    [pause stopAllActions];
    pause.opacity = 0;
    _pauseBorder.opacity = 0;
    
    CCMenuItemSprite *Resume_Button = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Resume-hd.png"]selectedSprite:[CCSprite spriteWithFile:@"Resume-hd.png"] target:self selector:@selector(resume:)];
    Resume_Button.tag = 2;
    Resume_Button.position = ccp(100, 240);
    [Resume_Button runAction:[CCFadeIn actionWithDuration:0.2f]];
    [_ingameMenu addChild:Resume_Button];
    
    CCSprite *ResumeBorder = [CCSprite spriteWithFile:@"ButtonBorder-hd.png"];
    ResumeBorder.position = ccp(93, 240);
    ResumeBorder.tag = 200;
    [ResumeBorder runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:8.0f angle:360]]];
    [ResumeBorder runAction:[CCFadeIn actionWithDuration:0.20f]];
    [self addChild:ResumeBorder];
    
    CCMenuItemSprite *Restart_Button = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Retry-hd.png"]selectedSprite:[CCSprite spriteWithFile:@"Retry-hd.png"] target:self selector:@selector(restart:)];
    Restart_Button.tag = 3;

    Restart_Button.position = ccp(228, 240);
    [Restart_Button runAction:[CCFadeIn actionWithDuration:0.2f]];
    [_ingameMenu addChild:Restart_Button];
    
    CCSprite *RestartBorder = [CCSprite spriteWithFile:@"ButtonBorder-hd.png"];
    RestartBorder.position = ccp(228, 240);
    RestartBorder.tag = 201;
    [RestartBorder runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:8.0f angle:360]]];
    [RestartBorder runAction:[CCFadeIn actionWithDuration:0.20f]];

    [self addChild:RestartBorder];
    
    _SFXButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"SFXOn-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"SFXOn-hd.png"] target:self selector:@selector(SFX:)];
    _SFXButton.position = ccp(220, 350);
    _SFXButton.tag = 4;
    [_SFXButton runAction:[CCFadeIn actionWithDuration:0.2f]];
    [_ingameMenu addChild:_SFXButton];
    
    CCSprite *SFXBorder = [CCSprite spriteWithFile:@"ButtonBorder-hd.png"];
    SFXBorder.position = ccp(220, 350);
    SFXBorder.tag = 202;
    SFXBorder.scale = 0.75;
    SFXBorder.rotation = 210;
    [self addChild:SFXBorder];
    [SFXBorder runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:5 angle:360]]];
    [SFXBorder runAction:[CCFadeIn actionWithDuration:0.20f]];
    
    _BGMButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"BGMOn-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"BGMOn-hd.png"] target:self selector:@selector(BGM:)];
    _BGMButton.tag = 5;
    _BGMButton.position = ccp(100, 350);
    [_BGMButton runAction:[CCFadeIn actionWithDuration:0.2f]];
    [_ingameMenu addChild:_BGMButton];
    
    CCSprite *BGMBorder = [CCSprite spriteWithFile:@"ButtonBorder-hd.png"];
    BGMBorder.position = ccp(100, 350);
    BGMBorder.scale = 0.75;
    BGMBorder.tag = 203;
    BGMBorder.rotation = 110;
    [self addChild:BGMBorder];
    [BGMBorder runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:5 angle:360]]];
    [BGMBorder runAction:[CCFadeIn actionWithDuration:0.20f]];
    
    [self SFXCheck];
    [self BGMCheck];
}

- (void) SFX:(id) sender {
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
}

- (void) BGM:(id) sender {
    [GameManager sharedGameManager].isMusicOff = ![GameManager sharedGameManager].isMusicOff;
    if ([GameManager sharedGameManager].isMusicOff) {
        //Music is off
        [_BGMButton setNormalImage:[CCSprite spriteWithFile:@"BGMOff-hd.png"]];
        //Turn music off
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0;
    }
    else {
        //Turn music on
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 1;
        [_BGMButton setNormalImage:[CCSprite spriteWithFile:@"BGMOn-hd.png"]];
    }
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
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 1;
        [_BGMButton setNormalImage:[CCSprite spriteWithFile:@"BGMOn-hd.png"]];
    }
}

- (void) resume:(id) sender {
    [self resumeSchedulerAndActions];
    [_laserBeam1.spriteBody resumeSchedulerAndActions];
    [_laserBeam2.spriteBody resumeSchedulerAndActions];
    [_laserBeam3.spriteBody resumeSchedulerAndActions];
    [_laserBeam4.spriteBody resumeSchedulerAndActions];
    
    for (Explosion *explosionTemp in _explosionArray) {
        [explosionTemp.spriteBody resumeSchedulerAndActions];
    }
    
    [[[CCDirector sharedDirector] scheduler] setTimeScale:_slowDownDelay];

    [_ingameMenu removeChildByTag:2 cleanup:YES];
    [_ingameMenu removeChildByTag:3 cleanup:YES];
    [_ingameMenu removeChildByTag:4 cleanup:YES];
    [_ingameMenu removeChildByTag:5 cleanup:YES];
    [self removeChildByTag:200 cleanup:YES];
    [self removeChildByTag:201 cleanup:YES];
    [self removeChildByTag:202 cleanup:YES];
    [self removeChildByTag:203 cleanup:YES];
    
    CCMenuItemSprite *pause = (CCMenuItemSprite*)[_ingameMenu getChildByTag:1];
    pause.isEnabled = TRUE;
    pause.opacity = 255;
    CCSprite *pauseBorder = (CCSprite*)[self getChildByTag:2];
    pauseBorder.opacity = 255;
}

- (void) restart:(id) sender {
    [self resumeSchedulerAndActions];
    
    [_ingameMenu removeChildByTag:2 cleanup:YES];
    [_ingameMenu removeChildByTag:3 cleanup:YES];
    [_ingameMenu removeChildByTag:4 cleanup:YES];
    [_ingameMenu removeChildByTag:5 cleanup:YES];
    [self removeChildByTag:200 cleanup:YES];
    [self removeChildByTag:201 cleanup:YES];
    [self removeChildByTag:202 cleanup:YES];
    [self removeChildByTag:203 cleanup:YES];
    
    CCMenuItemSprite *pause = (CCMenuItemSprite*)[_ingameMenu getChildByTag:1];
    pause.isEnabled = TRUE;
    CCSprite *pauseBorder = (CCSprite*)[self getChildByTag:2];
    pauseBorder.opacity = 255;
    [[[CCDirector sharedDirector] scheduler] setTimeScale:1];
    [[CCDirector sharedDirector] replaceScene:[Game scene]];
    _powerupButton1.isEnabled = TRUE;
    _powerupButton2.isEnabled = TRUE;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    if (acceleration.x < 0.001 && acceleration.x > -0.65) {
        //LEFT
        _player.body->ApplyLinearImpulse(b2Vec2((acceleration.x * 20) * [_player getTurnSpeedStat] * _reverseControls, 0), [_player getBodyPosition]);

    }
    else if (acceleration.x > 0.001 && acceleration.x < 0.65) {
        //RIGHT
        _player.body->ApplyLinearImpulse(b2Vec2((acceleration.x * 20) * [_player getTurnSpeedStat] * _reverseControls, 0), [_player getBodyPosition]);
    }
}

- (void) update:(ccTime)dt {
    int32 velocityIterations = 8;
	int32 positionIterations = 8;
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	_world->Step(dt, velocityIterations, positionIterations);
	_world->ClearForces();
    
    //Next Mach Level
    if (_levelTimer > _intervalLevel) {
        //NSLog(@"next Level");
        //_levelTimer = -5;
        //_machLevel = _machLevel + 1;
        [_player setCruiseSpeed];
        //[_player setMaxSpeed];
        
        //show mach level label
        //[self machSpeedLabel];
    }
    
    //position the line
    if ([_player getPositionY] > _hiScorePosY && _showHiScore) {
        [_HUD showNewHiScore];
        [[SimpleAudioEngine sharedEngine] playEffect:@"hiScore.m4a"];
        _showHiScore = FALSE;
    }

    [_player updateNode];
    [_player updatePhysics];
    
    if (![_player getIsInvulnerable]) {
        //normal run
    }
    else {
        //runs during item boost
        _enableMachWaveAfterDelay = FALSE;
        [_machWave updatePosition:[_player getPlayerPosition]];

    }
    
    if (_powerupBoost) {
        [_machWave updatePosition:[_player getPlayerPosition]];
    }
    
    if (_delayMachWave) {
        //start timer
        if (_delayMachWaveTimer > 2.0) {
            _delayMachWave = FALSE;
            _enableMachWaveAfterDelay = TRUE;
        }
        _delayMachWaveTimer += dt;
    }
    
    if (_enableMachWaveAfterDelay) {
        [_machWave updateVelocity:[_player getMachLevelVelocity:_machLevel]];
    }
    
    [_xpDetector updatePosition:[_player getPlayerPosition]];
    [_sideWallLeft updatePosition:[_player getPlayerPosition]];
    [_sideWallRight updatePosition:[_player getPlayerPosition]];
    [_speedPowerup updateNode];
    [_coinPowerup updateNode];
    [_reverse updateNode];
    [_slowmo updateNode];
    [_rechargeShield updateNode];
    [_slowCharge updateNode];
    [_slow updateNode];
    [_fullShield updateNode];
    [_missile updateNode];
    [_explosion updateNode];
    [_shootingStarsLayer fireShootingStars:dt];
//    [_machWave printVelocityY];
//    [_player printVelocityY];
    [self checkSpaceBridgePowerupDistance];
    
    
//    if (arc4random() % 750 + 1 == 5) {
//        if (arc4random() % 2 + 1) {
//            [_background2 runAction:[CCSequence actions:_flash, _flash,  nil]];
//        }
//        else {
//            [_background2 runAction:[CCSequence actions:_flash, nil]];
//        }
//    }
    
    if ([_laserBeamArray count] != 0) {
        if (_numOfBeams == 1) {
            if (![_laserBeam1 getEndLaserBeamEvent]) {
                [_laserBeam1 updatePosition:[_player getPlayerPosition]];
                [_laserBeam1 updateNode];
            }
        }
        else if (_numOfBeams == 2) {
            if (![_laserBeam1 getEndLaserBeamEvent]) {
                [_laserBeam1 updatePosition:[_player getPlayerPosition]];
                [_laserBeam1 updateNode];
            }
            if (![_laserBeam2 getEndLaserBeamEvent]) {
                [_laserBeam2 updatePosition:[_player getPlayerPosition]];
                [_laserBeam2 updateNode];
            }
        }
        else if (_numOfBeams == 3) {
            if (![_laserBeam1 getEndLaserBeamEvent]) {
                [_laserBeam1 updatePosition:[_player getPlayerPosition]];
                [_laserBeam1 updateNode];
            }
            if (![_laserBeam2 getEndLaserBeamEvent] && ![_laserBeam2 getRemoveBody]) {
                [_laserBeam2 updatePosition:[_player getPlayerPosition]];
                [_laserBeam2 updateNode];
            }
            if (![_laserBeam3 getEndLaserBeamEvent] && ![_laserBeam3 getRemoveBody]) {
                [_laserBeam3 updatePosition:[_player getPlayerPosition]];
                [_laserBeam3 updateNode];
            }
        }
    }


    //SHIELD TIMER
    if (_startRecharge) {
        //_rechargeDelay += dt;
    }
    
    if (_rechargeDelay > 3.0 && _startRecharge) {
        _rechargeDelay = 0;
        _startRecharge = FALSE;
        _recharge = TRUE;
    }
    
    if (_recharge) {
        if (_shieldPowerup && ![_player checkIfShieldIsFull]) {
            [self shieldChargePowerup];
        }
        else {
            [_player rechargeShield];
        }
        
        //stop charging after shield is full
        if ([_player checkIfShieldIsFull]) {
            _recharge = FALSE;
        }
    }
    
    if ([_player boost]) {
        //Recharge shield after player uses boost
        _startRecharge = TRUE;
        _recharge = FALSE;
        _rechargeDelay = 0;
    }
    
    _player.body->SetLinearDamping(4);//makes the spaceship slide around less
    
    if ([_player getBoost]) {
        [_parallax updateVelocity:ccp(0, -[_player getLinearVelocity].y * 30 * 1.3) delta:dt];
        //[_HUD updateDistance:[_player getPositionY] * 0.1];
    }
    else {
        [_parallax updateVelocity:ccp(0, -[_player getLinearVelocity].y * 30) delta:dt];
        //[_HUD updateDistance:[_player getPositionY] * 0.1];
    }
    [_HUD updateDistance:[_player getPositionY] * 0.1];

    //keeps player locked at a certain position on the screen.
    [_terrain setOffsetY:_player.position.y];
    [_player setHitWall:FALSE];
    [_player setHitExplosion:FALSE];
    /****COLLISION*****/
    std::vector<b2Body *>toDestroy;
    std::vector<MyContact2>::iterator pos;
    for(pos = _contactListener->_contacts.begin(); pos != _contactListener->_contacts.end(); ++pos) {
        MyContact2 contact = *pos;

        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        
        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
            CCSprite *spriteA = (__bridge CCSprite *) bodyA->GetUserData();
            CCSprite *spriteB = (__bridge CCSprite *) bodyB->GetUserData();
            
            //COLLISION FOR WALLS
            if ((spriteA.tag == 1 && spriteB.tag == -1) || (spriteA.tag == -1 && spriteB.tag == 1)) {
                //Player SlowDown method in player class
                [_player setHitWall:TRUE];
                //[_xpManager resetMultiplier];
                [_player takeWallDamage:_machLevel];
                
                //RECHARGE STUFF
                _startRecharge = TRUE;
                _recharge = FALSE;
                _rechargeDelay = 0;
                
                _powerupBoost = FALSE;
            }
            
            //COLLISION FOR EXPLOSIONS
            if ((spriteA.tag == 1 && spriteB.tag == -5) || (spriteA.tag == -5 && spriteB.tag == 1)) {
                [_player setHitExplosion:TRUE];
                [_player takeExplosionDamage:_machLevel];
                _powerupBoost = FALSE;

            }
            
            //COIN
            if ((spriteA.tag == 1 && spriteB.tag == 15)) {
                //ADD COIN TO PLAYER
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end()) {
                    toDestroy.push_back(bodyB);
                    if (doubleCreditsState) {
                        [_player addCredits:2];
                    }
                    else {
                        [_player addCredits:1];
                    }
                    [[SimpleAudioEngine sharedEngine] playEffect:@"pickupCoin.m4a"];
                }
                //update hud
                //[_HUD setCoinLabel:[_player getCredits]];
                //update player stats
                [_xpManager setTotalGold:[_player getCredits]];
                //animate icon
                //[_HUD animateCoinIcon];
                
                //_coinPowerup = FALSE;
            }
            
            //COLLISION FOR MACH WAVE
            if ((spriteA.tag == 1 && spriteB.tag == -3)) {
                [_player takeMachNovaDamage:_machLevel];
            }

            //ADD XP
            if (((spriteA.tag == -1 && spriteB.tag == -2) || (spriteA.tag == -2 && spriteB.tag == -1)) && ![_player getHitWall]) {
                //if ([_xpWallArray count] != 0) {
                    //Wall *wallXP = [_xpWallArray objectAtIndex:0];
                    //[wallXP tagXp];
                //}
                //Wall *wallXP = [_xpWallArray objectAtIndex:0];
                //[wallXP tagXp];
            }

            //BOOST
            if (((spriteA.tag == 1 && spriteB.tag == 10)) && _powerup) {
                _powerup = FALSE;
                _powerupIndicator = TRUE;
                _powerupBoost = TRUE;
                [_player activateSpeedPowerup];//mach combo?
                [_player boostAnimation];
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end()) {
                    toDestroy.push_back(bodyB);
                    [_player addPowerup:1];
                }
                [[SimpleAudioEngine sharedEngine] playEffect:@"CollectPowerup.m4a"];
            }
            
            //SHIELD
            if (((spriteA.tag == 1 && spriteB.tag == 11))) {
                _shieldPowerup = TRUE;
                _recharge = TRUE;
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end()) {
                    toDestroy.push_back(bodyB);
                    [_player addPowerup:1];
                }
                [[SimpleAudioEngine sharedEngine] playEffect:@"CollectPowerup.m4a"];

            }
            
            //SLOWMO
            if (((spriteA.tag == 1 && spriteB.tag == 12))) {
                _slowmoPowerup = TRUE;
                _powerupIndicator = TRUE;
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end()) {
                    toDestroy.push_back(bodyB);
                    [_player addPowerup:1];
                }
                [[SimpleAudioEngine sharedEngine] playEffect:@"CollectPowerup.m4a"];

            }
            
            //FULL SHIELD
            if (((spriteA.tag == 1 && spriteB.tag == 13))) {
                //_fullShieldPowerup = FALSE;
                //[self fullShield];
                _fullShieldPowerup = TRUE;
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end()) {
                    toDestroy.push_back(bodyB);
                    [_player addPowerup:1];

                }
                [[SimpleAudioEngine sharedEngine] playEffect:@"CollectPowerup.m4a"];

            }
            
            //REVERSE
            if (((spriteA.tag == 1 && spriteB.tag == -10))) {
                _reverseDebuff = TRUE;
                _powerupIndicator = TRUE;
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end()) {
                    toDestroy.push_back(bodyB);
                    [_player addPowerup:1];

                }
                [[SimpleAudioEngine sharedEngine] playEffect:@"CollectPowerupReverse.m4a"];

            }
            
            //SLOW
            if (((spriteA.tag == 1 && spriteB.tag == -11))) {
                _slowDebuff = TRUE;
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end()) {
                    toDestroy.push_back(bodyB);
                    [_player addPowerup:1];
                }
            }
            
            //SLOW CHARGE
            if (((spriteA.tag == 1 && spriteB.tag == -12))) {
                _slowChargeDebuff = TRUE;
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end()) {
                    toDestroy.push_back(bodyB);
                    [_player addPowerup:1];

                }
            }
            
            //LASER BEAM
            if ((spriteA.tag == 1 && spriteB.tag == -14)) {
                if ([_laserBeam1 getDamageActive]) {
                    //deal damage
                    [_player takeLaserDamage:_machLevel];
                    _startRecharge = TRUE;
                    _recharge = FALSE;
                    _rechargeDelay = 0;
                    _powerupBoost = FALSE;

                }
            }
            
            if ((spriteA.tag == 1 && spriteB.tag == -15)) {
                if ([_laserBeam2 getDamageActive]) {
                    //deal damage
                    [_player takeLaserDamage:_machLevel];
                    _startRecharge = TRUE;
                    _recharge = FALSE;
                    _rechargeDelay = 0;
                    _powerupBoost = FALSE;

                }
            }
            
            if ((spriteA.tag == 1 && spriteB.tag == -16)) {
                if ([_laserBeam3 getDamageActive]) {
                    //deal damage
                    [_player takeLaserDamage:_machLevel];
                    _startRecharge = TRUE;
                    _recharge = FALSE;
                    _rechargeDelay = 0;
                    _powerupBoost = FALSE;

                }
            }
        }
    }

    [_player checkXPLevel];
    
    //Remove bodies when player collides
    std::vector<b2Body *>::iterator pos2;
    for(pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2) {
        b2Body *body = *pos2;

        if (body->GetUserData() != NULL) {
            CCSprite *sprite = (__bridge CCSprite *) body->GetUserData();

            [sprite removeFromParentAndCleanup:YES];
            [self removeChild:sprite cleanup:YES];
        }
        _world->DestroyBody(body);
    }

    if ([_player getHitWall]) {
        //3 second buffer period where the player can't gain more "Close Calls", "Multipliers"
        _closeCallBuffer = TRUE;
        _closeCallTimer = 0;
    }
    
    if (_closeCallBuffer) {
        _closeCallTimer = _closeCallTimer + dt;
    }

    if (_closeCallTimer > 3) {
        _closeCallBuffer = FALSE;
        _closeCallTimer = 0;
    }

    //Destroy Bodies Loop
    for(b2Body *b = _world->GetBodyList(); b; b = b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCNode *objectData = (__bridge CCNode *)b->GetUserData();
            
            //Walls
            if(objectData.tag == -1) {
                objectData.position = ccp(b->GetPosition().x * [Box2DHelper pointsPerMeter], b->GetPosition().y * [Box2DHelper pointsPerMeter]);
                
                //caclulate the distance from the player to all walls
                float distanceFromPlayerToWall = b2Distance(b2Vec2(b->GetPosition().x, b->GetPosition().y), b2Vec2(_player.body->GetPosition().x, _player.body->GetPosition().y)) * [Box2DHelper pointsPerMeter];

                //Light up walls for shutdown event
                if (distanceFromPlayerToWall > 190.00 && distanceFromPlayerToWall < 210.00 && _shutdownEvent) {
                    [objectData runAction:[CCFadeTo actionWithDuration:0.2f opacity:255]];
                }
                
                //"Close Calls"
//                if (distanceFromPlayerToWall > 60.00 && distanceFromPlayerToWall < 80.00 && ![_player getHitWall] && !_closeCallBuffer) {
//                    
//                }
                
                //if objectData position is behind the player car then remove it
                if (objectData.position.y < _player.body->GetPosition().y * [Box2DHelper pointsPerMeter] - 120) {
                    [_xpWallArray removeObjectAtIndex:0];
                    [objectData removeFromParentAndCleanup:YES];
                    objectData = nil;
                    _world->DestroyBody(b);
                    [_xpWallCountArray removeObjectAtIndex:0];
                    [_player addObstacle:1];
                }
                
            }
            
            //MISSILE
            if (objectData.tag == -4) {
                objectData.position = ccp(b->GetPosition().x * [Box2DHelper pointsPerMeter], b->GetPosition().y * [Box2DHelper pointsPerMeter]);
//                objectData.position = ccp(b->GetPosition().x , b->GetPosition().y );

                float distanceFromPlayerToMissile = b2Distance(b2Vec2(b->GetPosition().x, b->GetPosition().y), b2Vec2(_player.body->GetPosition().x, _player.body->GetPosition().y)) * [Box2DHelper pointsPerMeter];
                
                //CHANGE DISTANCE?
                int rndDistance = arc4random() % 50 + 120;
                if (distanceFromPlayerToMissile < rndDistance + 10) {
                    //explode missile

                    _explosion = [Explosion InitWithGame:self Position:objectData.position];
                    [_terrain addChild:_explosion];
                    [_explosion explosionAnimation];
                    [_explosionArray addObject:_explosion];
                    [[SimpleAudioEngine sharedEngine] playEffect:@"missileExplosion.m4a"];
                    
                    //remove missile sprite
                    [objectData removeFromParentAndCleanup:YES];
                    objectData = nil;
                    _world->DestroyBody(b);
                    [_missileArray removeObjectAtIndex:0];
                }
                else if (objectData.position.y < _player.body->GetPosition().y * [Box2DHelper pointsPerMeter] - 130) {
                    [objectData removeFromParentAndCleanup:YES];
                    objectData = nil;
                    _world->DestroyBody(b);
                }
            }
            
            //EXPLOSION
            if (objectData.tag == -5) {
                objectData.position = ccp(b->GetPosition().x * [Box2DHelper pointsPerMeter], b->GetPosition().y * [Box2DHelper pointsPerMeter]);

                if (objectData.position.y < _player.body->GetPosition().y * [Box2DHelper pointsPerMeter] - 130) {
                    [_explosionArray removeObjectAtIndex:0];
                    [objectData removeFromParentAndCleanup:YES];
                    objectData = nil;
                    _world->DestroyBody(b);
                    [_player addObstacle:1];
                }
            }
            
            //Mach Nova
            if (objectData.tag == -3) {
                objectData.position = ccp(b->GetPosition().x * [Box2DHelper pointsPerMeter], b->GetPosition().y * [Box2DHelper pointsPerMeter]);
                
                //SHAKING
                //Get distance from player
                //Closer the mach wave is the more intense the shake

                float distanceFromPlayerToWave = b2Distance(b2Vec2(b->GetPosition().x, b->GetPosition().y), b2Vec2(_player.body->GetPosition().x, _player.body->GetPosition().y)) * [Box2DHelper pointsPerMeter];
                if (distanceFromPlayerToWave < 100) {
                    [self runAction:[CCShake actionWithDuration:0.1f amplitude:ccp(1.5,3) shakes:50]];
                }
                else if (distanceFromPlayerToWave >= 100 && distanceFromPlayerToWave <= 150) {
                    [self runAction:[CCShake actionWithDuration:0.1f amplitude:ccp(1,2) shakes:50]];
                }
                else if (distanceFromPlayerToWave >= 151 && distanceFromPlayerToWave <= 200) {
                    [self runAction:[CCShake actionWithDuration:0.1f amplitude:ccp(.5,1) shakes:50]];
                }
                
                if (distanceFromPlayerToWave > 200 || [_player getIsInvulnerable]) {
                    [_machWave updatePosition:[_player getPlayerPosition]];
                }
            }
            
            //Powerup (speed boost) off screen removal
            if (objectData.tag == 10) {
                objectData.position = ccp(b->GetPosition().x * [Box2DHelper pointsPerMeter], b->GetPosition().y * [Box2DHelper pointsPerMeter]);
                //If speed powerup is offscreen remove that bitch!
                if (objectData.position.y < _player.body->GetPosition().y * [Box2DHelper pointsPerMeter] - 150) {
                    [objectData removeFromParentAndCleanup:YES];
                    objectData = nil;
                    _world->DestroyBody(b);
                }
            }
            
            //SHIELD
            if (objectData.tag == 11) {
                objectData.position = ccp(b->GetPosition().x * [Box2DHelper pointsPerMeter], b->GetPosition().y * [Box2DHelper pointsPerMeter]);
                //If speed powerup is offscreen remove that bitch!
                if (objectData.position.y < _player.body->GetPosition().y * [Box2DHelper pointsPerMeter] - 150) {
                    [objectData removeFromParentAndCleanup:YES];
                    objectData = nil;
                    _world->DestroyBody(b);
                }
            }
            
            //SLOW MO
            if (objectData.tag == 12) {
                objectData.position = ccp(b->GetPosition().x * [Box2DHelper pointsPerMeter], b->GetPosition().y * [Box2DHelper pointsPerMeter]);
                //If speed powerup is offscreen remove that bitch!
                if (objectData.position.y < _player.body->GetPosition().y * [Box2DHelper pointsPerMeter] - 150) {
                    [objectData removeFromParentAndCleanup:YES];
                    objectData = nil;
                    _world->DestroyBody(b);
                }
            }
            
            //FULL SHIELD
            if (objectData.tag == 13) {
                objectData.position = ccp(b->GetPosition().x * [Box2DHelper pointsPerMeter], b->GetPosition().y * [Box2DHelper pointsPerMeter]);
                //If speed powerup is offscreen remove that bitch!
                if (objectData.position.y < _player.body->GetPosition().y * [Box2DHelper pointsPerMeter] - 150) {
                    [objectData removeFromParentAndCleanup:YES];
                    objectData = nil;
                    _world->DestroyBody(b);
                }
            }
            
            //REVERSE
            if (objectData.tag == -10) {
                objectData.position = ccp(b->GetPosition().x * [Box2DHelper pointsPerMeter], b->GetPosition().y * [Box2DHelper pointsPerMeter]);
                //If speed powerup is offscreen remove that bitch!
                if (objectData.position.y < _player.body->GetPosition().y * [Box2DHelper pointsPerMeter] - 150) {
                    [objectData removeFromParentAndCleanup:YES];
                    objectData = nil;
                    _world->DestroyBody(b);
                }
            }
            
            //Laser Beam
            if (objectData.tag == -14) {
                //laserbeam1
                if ([_laserBeam1 getActiveBeam]) {
                    [_laserBeam1 fireBeam:dt];
                }
            }
            if (objectData.tag == -15) {
                
                if ([_laserBeam2 getActiveBeam]) {
                    [_laserBeam2 fireBeam:dt];
                }
            }
            if (objectData.tag == -16) {
                
                if ([_laserBeam3 getActiveBeam]) {
                    [_laserBeam3 fireBeam:dt];
                }
            }
            
            //Coin off screen removal
            if (objectData.tag == 15) {
                objectData.position = ccp(b->GetPosition().x * [Box2DHelper pointsPerMeter], b->GetPosition().y * [Box2DHelper pointsPerMeter]);
                
//                Magnet
                //BOOL magnet = FALSE;
                float maxDistance = 1;
                float maxForce = 1;
                CGFloat distance;
                CGFloat strength;
                float force;
                b2Vec2 b2BodyPosition = b2Vec2(b->GetPosition().x, b->GetPosition().y);
                CGFloat angle;
                if (magnetState) {
                    distance = b2Distance(b2BodyPosition, [_player getBodyPosition]);
                    if(distance > maxDistance) distance = maxDistance - 0.01;
                    // Get the strength
                    //strength = distance / maxDistance; // Uncomment and reverse these two. and ones further away will get more force instead of less
                    strength = (maxDistance - distance) / maxDistance; // This makes it so that the closer something is - the stronger, instead of further
                    force  = strength * maxForce;
                    
                    // Get the angle
                    angle = atan2f([_player getBodyPosition].y - b2BodyPosition.y, [_player getBodyPosition].x - b2BodyPosition.x);
                    // Apply an impulse to the body, using the angle
                    b->ApplyLinearImpulse(b2Vec2(cosf(angle) * force * 2, sinf(angle) * force), b->GetPosition());
                }
                
                //If speed powerup is offscreen remove that bitch!
                if (objectData.position.y < _player.body->GetPosition().y * [Box2DHelper pointsPerMeter] - 150) {
                    [objectData removeFromParentAndCleanup:YES];
                    objectData = nil;
                    _world->DestroyBody(b);
                }
            }
        }
    }
    
    if (!_newGameDelay) {
        //countdown
        if (_countDown <= 1) {
            _newGameDelay = TRUE;
        }
        //finished countdown, spawn walls
        _countDown = _countDown - dt;
    }
        
    //Event MANAGER
    if (_globalEventTimer <= _globalEventTime && _newGameDelay && !_break) {
        //turn lights back on
        if (_eventFinishedState) {
            [_parallax lightenWalls];
            _eventFinishedState = FALSE;
        }
        
        if (arc4random() % 10 + 1 <= 2) {
            //Mach Wave Event
            [_machWave machWaveEvent];
        }
        
        switch (_eventType) {// _eventType
            case 1:
                //easy
                [self spawnEasyWall:FALSE randomMoving:FALSE];
                break;
            case 2:
                //easy, rocket
                [self spawnEasyWall:FALSE randomMoving:FALSE];
                [self spawnMissile:dt];
                break;
            case 3:
                [self spawnEasyWall:FALSE randomMoving:FALSE];
                [self spawnLaserBeamEvent:dt];
                break;
            case 4:
                //easy, rocket, laser
                [self spawnEasyWall:FALSE randomMoving:FALSE];
                [self spawnMissile:dt];
                [self spawnLaserBeamEvent:dt];
                break;
            case 5:
                //easy, rocket, laser, shutdown
                [self spawnEasyWall:FALSE randomMoving:FALSE];
                [self spawnMissile:dt];
                [self spawnLaserBeamEvent:dt];
                
                _shutdownEvent = TRUE;
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax redFlashingWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                break;
            case 6:
                //easy, missile, shutdown
                [self spawnEasyWall:FALSE randomMoving:FALSE];
                [self spawnMissile:dt];
                
                _shutdownEvent = TRUE;
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                
                break;
            case 7:
                //easy, laser, shutdown
                [self spawnEasyWall:FALSE randomMoving:FALSE];
                [self spawnLaserBeamEvent:dt];
                
                _shutdownEvent = TRUE;
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                
                break;
            case 8:
                //easy, shutdown
                [self spawnEasyWall:FALSE randomMoving:FALSE];
                
                _shutdownEvent = TRUE;
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                
                break;
            case 9:
                //easy moving
                [self spawnEasyWall:TRUE randomMoving:FALSE];
                break;
            case 10:
                //easy moving, rocket
                [self spawnEasyWall:TRUE randomMoving:FALSE];
                [self spawnMissile:dt];
                break;
            case 11:
                [self spawnEasyWall:TRUE randomMoving:FALSE];
                [self spawnLaserBeamEvent:dt];
                break;
            case 12:
                //easy moving, rocket, laser
                [self spawnEasyWall:TRUE randomMoving:FALSE];
                [self spawnMissile:dt];
                [self spawnLaserBeamEvent:dt];
                break;
            case 13:
                //easy moving, rocket, laser, shutdown
                [self spawnEasyWall:TRUE randomMoving:FALSE];
                [self spawnMissile:dt];
                [self spawnLaserBeamEvent:dt];
                
                _shutdownEvent = TRUE;
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                break;
            case 14:
                //easy moving, missile, shutdown
                [self spawnEasyWall:TRUE randomMoving:FALSE];
                [self spawnMissile:dt];
                
                _shutdownEvent = TRUE;
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                break;
            case 15:
                //easy moving, laser, shutdown
                [self spawnEasyWall:TRUE randomMoving:FALSE];
                [self spawnLaserBeamEvent:dt];
                
                _shutdownEvent = TRUE;
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                break;
            case 16:
                //easy moving, shutdown
                [self spawnEasyWall:TRUE randomMoving:FALSE];
                
                _shutdownEvent = TRUE;
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                break;
            case 17:
                //easy random
                [self spawnEasyWall:FALSE randomMoving:TRUE];
                break;
            case 18:
                //easy random, rocket
                [self spawnEasyWall:FALSE randomMoving:TRUE];
                [self spawnMissile:dt];
                break;
            case 19:
                //easy random, rocket, laser
                [self spawnEasyWall:FALSE randomMoving:TRUE];
                [self spawnMissile:dt];
                [self spawnLaserBeamEvent:dt];
                break;
            case 20:
                //easy random, rocket, laser, shutdown
                [self spawnEasyWall:FALSE randomMoving:TRUE];
                [self spawnMissile:dt];
                [self spawnLaserBeamEvent:dt];
                
                _shutdownEvent = TRUE;
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                break;
            case 21:
                //easy random, missile, shutdown
                [self spawnEasyWall:FALSE randomMoving:TRUE];
                [self spawnMissile:dt];
                
                _shutdownEvent = TRUE;
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                break;
            case 22:
                //easy random, laser, shutdown
                [self spawnEasyWall:FALSE randomMoving:TRUE];
                [self spawnLaserBeamEvent:dt];
                
                _shutdownEvent = TRUE;
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                
                break;
            case 23:
                //easy, shutdown
                [self spawnEasyWall:FALSE randomMoving:TRUE];
                
                _shutdownEvent = TRUE;
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                
                break;
            case 24:
                //medium
                [self spawnMediumWall:FALSE randomMoving:FALSE];
                break;
            case 25:
                //medium, rocket
                [self spawnMediumWall:FALSE randomMoving:FALSE];
                [self spawnMissile:dt];
                break;
            case 26:
                //medium, rocket, laser
                [self spawnMediumWall:FALSE randomMoving:FALSE];
                [self spawnMissile:dt];
                [self spawnLaserBeamEvent:dt];
                break;
            case 27:
                //medium rocket, laser, shutdown
                [self spawnMediumWall:FALSE randomMoving:FALSE];
                [self spawnMissile:dt];
                [self spawnLaserBeamEvent:dt];
                
                _shutdownEvent = TRUE;
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                
                break;
            case 28:
                //medium laser shutdown
                [self spawnMediumWall:FALSE randomMoving:FALSE];
                [self spawnLaserBeamEvent:dt];
                
                _shutdownEvent = TRUE;
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                
                break;
            case 29:
                //medium, shutdown
                [self spawnMediumWall:FALSE randomMoving:FALSE];
                
                _shutdownEvent = TRUE;
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                break;
            case 30:
                //medium moving
                [self spawnMediumWall:TRUE randomMoving:FALSE];
                break;
            case 31:
                //medium moving, rocket
                [self spawnMediumWall:TRUE randomMoving:FALSE];
                [self spawnMissile:dt];
                break;
            case 32:
                //medium moving, laser
                [self spawnMediumWall:TRUE randomMoving:FALSE];
                [self spawnLaserBeamEvent:dt];
                
                break;
            case 33:
                //medium moving, rocket, laser
                [self spawnMediumWall:TRUE randomMoving:FALSE];
                [self spawnMissile:dt];
                [self spawnLaserBeamEvent:dt];
                break;
            case 34:
                //medium moving, rocket, shutdown
                [self spawnMediumWall:TRUE randomMoving:FALSE];
                [self spawnMissile:dt];
                
                _shutdownEvent = TRUE;
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                
                break;
            case 35:
                //medium moving, laser, shutdown
                [self spawnMediumWall:TRUE randomMoving:FALSE];
                [self spawnLaserBeamEvent:dt];
                
                _shutdownEvent = TRUE;
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                break;
            case 36:
                //medium moving, shutdown
                [self spawnMediumWall:TRUE randomMoving:FALSE];
                
                _shutdownEvent = TRUE;
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                
                break;
            case 37:
                //medium random
                [self spawnMediumWall:FALSE randomMoving:TRUE];
                break;
            case 38:
                //medium random, rocket
                [self spawnMediumWall:FALSE randomMoving:TRUE];
                [self spawnMissile:dt];
                break;
            case 39:
                //medium random, laser
                [self spawnMediumWall:FALSE randomMoving:TRUE];
                [self spawnLaserBeamEvent:dt];
                break;
            case 40:
                //medium random, rocket, laser
                [self spawnMediumWall:FALSE randomMoving:TRUE];
                [self spawnMissile:dt];
                [self spawnLaserBeamEvent:dt];
                break;
            case 41:
                //medium random, rocket, shutdown
                [self spawnMediumWall:FALSE randomMoving:TRUE];
                [self spawnMissile:dt];
                
                _shutdownEvent = TRUE;
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                break;
            case 42:
                //medium random, laser, shutdown
                [self spawnMediumWall:FALSE randomMoving:TRUE];
                [self spawnLaserBeamEvent:dt];
                
                _shutdownEvent = TRUE;
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                break;
            case 43:
                //medium random, shutdown
                [self spawnMediumWall:FALSE randomMoving:TRUE];
                
                _shutdownEvent = TRUE;
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                break;
            case 44:
                //hard
                [self spawnHardWall:FALSE randomMoving:FALSE];
                break;
            case 45:
                //easy random, laser
                [self spawnEasyWall:FALSE randomMoving:TRUE];
                [self spawnLaserBeamEvent:dt];
                break;
            case 46:
                [self spawnMissile:dt];
                break;
            case 47:
                //hard, missile
                [self spawnHardWall:FALSE randomMoving:FALSE];
                [self spawnMissile:dt];
                break;
            case 48:
                //hard, shutdown
                [self spawnHardWall:FALSE randomMoving:FALSE];
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                break;
            case 49:
                //hard missile shutdown
                [self spawnHardWall:FALSE randomMoving:FALSE];
                [self spawnMissile:dt];
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                break;
            case 50:
                //hard shutdown laserbeam
                [self spawnHardWall:FALSE randomMoving:FALSE];
                [self spawnLaserBeamEvent:dt];
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                break;
            case 51:
                //hard moving,
                [self spawnHardWall:TRUE randomMoving:FALSE];
                break;
            case 52:
                //hard moving, missile
                [self spawnHardWall:TRUE randomMoving:FALSE];
                [self spawnMissile:dt];
                break;
            case 53:
                //hard moving, shutdown
                [self spawnHardWall:TRUE randomMoving:FALSE];
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                break;
            case 54:
                //hard moving, laserbeam
                [self spawnHardWall:TRUE randomMoving:FALSE];
                [self spawnLaserBeamEvent:dt];
                break;
            case 55:
                //hard moving, missile, shutdown
                [self spawnHardWall:TRUE randomMoving:FALSE];
                [self spawnMissile:dt];
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                break;
            case 56:
                //hard moving, shutdown, laserbeam
                [self spawnHardWall:TRUE randomMoving:FALSE];
                [self spawnLaserBeamEvent:dt];
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                break;
            case 57:
                //random
                [self spawnHardWall:FALSE randomMoving:TRUE];
                break;
            case 58:
                //random missile
                [self spawnHardWall:FALSE randomMoving:TRUE];
                [self spawnMissile:dt];
                break;
            case 59:
                //random shutdown
                [self spawnHardWall:FALSE randomMoving:TRUE];
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                break;
            case 60:
                //random laserbeam
                [self spawnHardWall:FALSE randomMoving:TRUE];
                [self spawnLaserBeamEvent:dt];
                break;
            case 61:
                //random missile shutdown
                [self spawnHardWall:FALSE randomMoving:TRUE];
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                break;
            case 62:
                //random shutdown laserbeam
                [self spawnHardWall:FALSE randomMoving:TRUE];
                [self spawnLaserBeamEvent:dt];
                if (_shutdownEvent && _wallLight) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Shutdown.m4a"];
                    [_parallax darkenWalls];
                    [_parallax turnOffWallLight];
                    _wallLight = FALSE;
                    _eventFinishedState = TRUE;
                }
                break;
            case 63:
                break;
                //random missile laserbeam
                [self spawnHardWall:FALSE randomMoving:TRUE];
                [self spawnMissile:dt];
                [self spawnLaserBeamEvent:dt];
                break;
            case 64:
                //moving missile laserbeam
                [self spawnHardWall:TRUE randomMoving:FALSE];
                [self spawnMissile:dt];
                [self spawnLaserBeamEvent:dt];
                break;
            case 65:
                //hard, missile laserbeam
                [self spawnHardWall:FALSE randomMoving:FALSE];
                [self spawnMissile:dt];
                [self spawnLaserBeamEvent:dt];
                break;
            default:
                [self spawnHardWall:FALSE randomMoving:FALSE];
                [self spawnMissile:dt];
                [self spawnLaserBeamEvent:dt];
                break;
        }
        
        
        _globalEventTimer += dt;
        
        if (_globalEventTimer >= _globalEventTime - 0.5) {
            _globalEventTimer = 0;
            _newEvent = TRUE;
            _break = TRUE;
            
            //Pick new Event
            int prevEventType = _eventType;
            do {
                _eventType = arc4random() % 65 + 1;
            } while (_eventType == prevEventType);
            
            //Initialise Break
            if (_break) {
                _breakTime = arc4random() % 1 + 6;
            }
        }
    }
    
    if (_break) {
        if (_breakTimer < _breakTime) {
            _breakTimer += dt;
            //[self spawnCoin:dt];
        }
        else {
            [_HUD showBonus:_machLevel doubleCredits:doubleCreditsState];
            if (doubleCreditsState) {
                [_player addCredits:_machLevel * 20 * 2];
            }
            else {
                [_player addCredits:_machLevel * 20];
            }
            //NEW LEVEL
            //NSLog(@"new level");
            _machLevel = _machLevel + 1;
            _breakTimer = 0;
            _break = FALSE;
            _globalEventTime = arc4random() % 2 + 20;
        }
    }

    //POWERUPS
    [self spawnPowerup:dt];
    //COINS
    [self spawnCoin:dt];

    if (_reverseDebuff) {
        [self reversePowerup:dt];
        //reset bool after timer is complete
        //_reversePowerup = FALSE;
    }
    
    if (_slowmoPowerup) {
        [self SlowMo:dt];
    }
    
    if (_slowCharge) {
        [self slowChargeShield];
    }
    
    if (_slowDebuff) {
        [self slowDown];
        _slowDebuff = FALSE;
    }
    
    if (_fullShieldPowerup) {
        [self fullShield];
        _fullShieldPowerup = FALSE;
    }
    
    //check if shield is below 0
    if ([_player checkShieldDeath]) {
        //GAME OVER        
        //Stats distance
        
        if (extraLifeState) {
            extraLifeState = FALSE;
            magnetState = FALSE;
            doubleCreditsState = FALSE;
            [_HUD disableExtraLifeIcon];
            [_HUD disableDoubleCreditsIcon];
            [_HUD disableMagnetIcon];
            [_player setShieldToMax];
        }
        else {
            [GameManager sharedGameManager].totalDistanceTraveled = [GameManager sharedGameManager].distanceTraveled + [_playerStats getDistance];
            [GameManager sharedGameManager].distanceTraveled = [_playerStats getDistance];
            [GameManager sharedGameManager].timePlayedThisGame = time;
            [GameManager sharedGameManager].totalTimePlayed = [GameManager sharedGameManager].totalTimePlayed + time;
            [GameManager sharedGameManager].creditsCollectedThisGame = [_playerStats getCredits];
            [[GameManager sharedGameManager] setTotalCreditsCollected:[GameManager sharedGameManager].totalCreditsCollected + [GameManager sharedGameManager].creditsCollectedThisGame ];
            [GameManager sharedGameManager].totalPowerupsCollected = [GameManager sharedGameManager].totalPowerupsCollected + [GameManager sharedGameManager].powerupsCollected;
            [[GameManager sharedGameManager] saveGameData];
            [self endGame];
        }
    }
    
    if ([_player checkIfShieldIsCritical] && _checkIfShieldIsCritical) {
        [_HUD flashEnergyBar];
        _checkIfShieldIsCritical = FALSE;
        _checkIfShieldIsNominal = TRUE;
    }
    
    if ([_player checkIfShieldIsNominal] && _checkIfShieldIsNominal) {
        [_HUD stopFlashingEnergyBar];
        _checkIfShieldIsCritical = TRUE;
        _checkIfShieldIsNominal = FALSE;
    }
    
    //_breakTimer += dt;
    //_globalEventTimer += dt;
    //_levelTimer += dt;
    _wallSpawnTimer += _wallTimerdt;
    time += dt;
}

#pragma WallSpawner

- (void) spawnRandomWall {
    if (_wallSpawnTimer > _randomSpawnTimer && _newGameDelay) {
        
        //calculate next spawn position
        
        
        _newSpawnPosition = _player.body->GetPosition().y * [Box2DHelper pointsPerMeter] + _offscreenSpawnPosY;
        
        //int spaceBetweenWalls = 500;//this will need to be decreased as the player lasts longer
        if (_newSpawnPosition > _prevSpawnPosition + [_enemyHelper getSpaceBetweenWalls:_machLevel]) {
            _randomSpawnTimer = (arc4random() % 6 + 1);

            //spawn wall formation
            _prevSpawnPosition = _newSpawnPosition;
            _prevWallPosY = _nextWallPosY;
            _nextWallPosY = _newSpawnPosition;
            _offscreenSpawnPosY = arc4random() % 100 + 400;

            if ([self moveWallDecision]) {
                if (_machLevel >= 0) {
                    //                switch (arc4random() % 12 + 1) {
                    switch (arc4random() % 14 + 1) {
                        case 1:
                            [self spawnLeftWallEasy:TRUE];
                            break;
                        case 2:
                            [self spawnRightWallEasy:TRUE];
                            break;
                        case 3:
                            [self spawnMiddleWallEasy:TRUE direction:1];
                            break;
                        case 4:
                            [self spawnTwoWallsEasy:TRUE];
                            break;
                        case 5:
                            [self spawnMiddleWallMedium:TRUE direction:1];
                            break;
                        case 6:
                            [self spawnLeftWallMedium:TRUE];
                            break;
                        case 7:
                            [self spawnLeftWallMedium:TRUE];
                            break;
                        case 8:
                            [self spawnRightWallMedium:TRUE];
                            break;
                        case 9:
                            [self spawnRightWallMedium:TRUE];
                            break;
                        case 10:
                            [self spawnMiddleWallMedium:TRUE direction:1];
                            break;
                        case 11:
                            [self spawnLeftWallMedium:TRUE];
                            break;
                        case 12:
                            [self spawnLeftWallMedium:TRUE];
                            break;
                        case 13:
                            [self spawnRightWallMedium:TRUE];
                            break;
                        case 14:
                            [self spawnRightWallMedium:TRUE];
                            break;
                        case 15:
                            //[self spawn]
                        default:
                            [self spawnMiddleWallEasy:FALSE direction:1];
                            break;
                    }
                }
            }
            if (_machLevel >= 0) {
                
            }
            
            
        }
        _wallSpawnTimer = 0;
    }
}

- (void) spawnEasyWall:(BOOL) isMoving randomMoving:(BOOL)isRandom {
    if (_wallSpawnTimer > _randomSpawnTimer && _newGameDelay) {
        
        //calculate next spawn position
        
        
        _newSpawnPosition = _player.body->GetPosition().y * [Box2DHelper pointsPerMeter] + _offscreenSpawnPosY;
        
        //int spaceBetweenWalls = 500;//this will need to be decreased as the player lasts longer
        if (_newSpawnPosition > _prevSpawnPosition + [_enemyHelper getSpaceBetweenWalls:_machLevel]) {
            _randomSpawnTimer = (arc4random() % 6 + 1);
            
            //spawn wall formation
            _prevSpawnPosition = _newSpawnPosition;
            _prevWallPosY = _nextWallPosY;
            _nextWallPosY = _newSpawnPosition;
            _offscreenSpawnPosY = arc4random() % 100 + 600;
            
            if (isMoving) {
                if (_machLevel >= 0) {
                    switch (arc4random() % 4 + 1) {
                        case 1:
                            [self spawnLeftWallEasy:TRUE];
                            break;
                        case 2:
                            [self spawnRightWallEasy:TRUE];
                            break;
                        case 3:
                            switch (arc4random() % 2 + 1) {
                                case 1:
                                    [self spawnMiddleWallEasy:TRUE direction:1];
                                    
                                    break;
                                case 2:
                                    [self spawnMiddleWallEasy:TRUE direction:-1];
                                    break;
                                default:
                                    break;
                            }
                            break;
                        case 4:
                            [self spawnTwoWallsEasy:TRUE];
                            break;
                        default:
                            [self spawnMiddleWallEasy:TRUE direction:1];
                            break;
                    }
                }
            }
            else if (isRandom) {
                switch (arc4random() % 2 + 1) {
                    case 1:
                        _movingWall = TRUE;
                        break;
                    case 2:
                        _movingWall = FALSE;
                    default:
                        break;
                }
                
                if (_machLevel >= 0) {
                    switch (arc4random() % 4 + 1) {
                        case 1:
                            [self spawnLeftWallEasy:_movingWall];
                            break;
                        case 2:
                            [self spawnRightWallEasy:_movingWall];
                            break;
                        case 3:
                            switch (arc4random() % 2 + 1) {
                                case 1:
                                    [self spawnMiddleWallEasy:_movingWall direction:1];
                                    
                                    break;
                                case 2:
                                    [self spawnMiddleWallEasy:_movingWall direction:-1];
                                    break;
                                default:
                                    break;
                            }
                            break;
                        case 4:
                            [self spawnTwoWallsEasy:_movingWall];
                            break;
                        default:
                            [self spawnMiddleWallEasy:_movingWall direction:1];
                            break;
                    }
                }
            }
            else {
                if (_machLevel >= 0) {
                    switch (arc4random() % 4 + 1) {
                        case 1:
                            [self spawnLeftWallEasy:FALSE];
                            break;
                        case 2:
                            [self spawnRightWallEasy:FALSE];
                            break;
                        case 3:
                            switch (arc4random() % 2 + 1) {
                                case 1:
                                    [self spawnMiddleWallEasy:FALSE direction:1];
                                    
                                    break;
                                case 2:
                                    [self spawnMiddleWallEasy:FALSE direction:-1];
                                    break;
                                default:
                                    break;
                            }
                            break;
                        case 4:
                            [self spawnTwoWallsEasy:FALSE];
                            break;
                        default:
                            [self spawnMiddleWallEasy:FALSE direction:1];
                            break;
                    }
                }
            }
        }
        _wallSpawnTimer = 0;
    }
}

- (void) spawnMediumWall:(BOOL) isMoving randomMoving:(BOOL)isRandom {
    if (_wallSpawnTimer > _randomSpawnTimer && _newGameDelay) {
        
        //calculate next spawn position
        
        
        _newSpawnPosition = _player.body->GetPosition().y * [Box2DHelper pointsPerMeter] + _offscreenSpawnPosY;
        
        //int spaceBetweenWalls = 500;//this will need to be decreased as the player lasts longer
        if (_newSpawnPosition > _prevSpawnPosition + [_enemyHelper getSpaceBetweenWalls:_machLevel]) {
            _randomSpawnTimer = (arc4random() % 6 + 1);
            
            //spawn wall formation
            _prevSpawnPosition = _newSpawnPosition;
            _prevWallPosY = _nextWallPosY;
            _nextWallPosY = _newSpawnPosition;
            _offscreenSpawnPosY = arc4random() % 100 + 600;
            
            if (isMoving) {
                if (_machLevel >= 0) {
                    switch (arc4random() % 4 + 1) {
                        case 1:
                            [self spawnLeftWallMedium:TRUE];
                            break;
                        case 2:
                            [self spawnRightWallMedium:TRUE];
                            break;
                        case 3:
                            switch (arc4random() % 2 + 1) {
                                case 1:
                                    [self spawnMiddleWallMedium:TRUE direction:1];
                                    break;
                                case 2:
                                    [self spawnMiddleWallMedium:TRUE direction:-1];
                                    break;
                            }
                            break;
                        case 4:
                            [self spawnTwoWallsMedium:TRUE];
                            break;
                        default:
                            [self spawnMiddleWallMedium:FALSE direction:1];
                            break;
                    }
                }
            }
            else if (isRandom) {
                switch (arc4random() % 2 + 1) {
                    case 1:
                        _movingWall = TRUE;
                        break;
                    case 2:
                        _movingWall = FALSE;
                        break;
                    default:
                        break;
                }
                
                if (_machLevel >= 0) {
                    switch (arc4random() % 4 + 1) {
                        case 1:
                            [self spawnLeftWallMedium:_movingWall];
                            break;
                        case 2:
                            [self spawnRightWallMedium:_movingWall];
                            break;
                        case 3:
                            switch (arc4random() % 2 + 1) {
                                case 1:
                                    [self spawnMiddleWallMedium:_movingWall direction:1];
                                    break;
                                case 2:
                                    [self spawnMiddleWallMedium:_movingWall direction:-1];
                                    break;
                            }
                            break;
                        case 4:
                            [self spawnTwoWallsMedium:_movingWall];
                            break;
                        default:
                            [self spawnMiddleWallMedium:_movingWall direction:1];
                            break;
                    }
                }
            }
            else {
                if (_machLevel >= 0) {
                    switch (arc4random() % 4 + 1) {
                        case 1:
                            [self spawnLeftWallMedium:FALSE];
                            break;
                        case 2:
                            [self spawnRightWallMedium:FALSE];
                            break;
                        case 3:
                            switch (arc4random() % 2 + 1) {
                                case 1:
                                    [self spawnMiddleWallMedium:FALSE direction:1];
                                    break;
                                case 2:
                                    [self spawnMiddleWallMedium:FALSE direction:-1];
                                    break;
                            }
                            break;
                        case 4:
                            [self spawnTwoWallsMedium:FALSE];
                            break;
                        default:
                            [self spawnMiddleWallMedium:FALSE direction:1];
                            break;
                    }
                }
            }
        }
        _wallSpawnTimer = 0;
    }
}

- (void) spawnHardWall:(BOOL)isMoving randomMoving:(BOOL)isRandom {
    if (_wallSpawnTimer > _randomSpawnTimer && _newGameDelay) {
        //calculate next spawn position

        _newSpawnPosition = _player.body->GetPosition().y * [Box2DHelper pointsPerMeter] + _offscreenSpawnPosY;
        
        //int spaceBetweenWalls = 500;//this will need to be decreased as the player lasts longer
        if (_newSpawnPosition > _prevSpawnPosition + [_enemyHelper getSpaceBetweenWalls:_machLevel]) {
            _randomSpawnTimer = (arc4random() % 6 + 1);
            
            //spawn wall formation
            _prevSpawnPosition = _newSpawnPosition;
            _prevWallPosY = _nextWallPosY;
            _nextWallPosY = _newSpawnPosition;
            _offscreenSpawnPosY = arc4random() % 100 + 600;
            
            if (isMoving) {
                if (_machLevel >= 0) {
                    switch (arc4random() % 4 + 1) {
//                        case 1:
//                            [self spawnLeftWallHard:TRUE];
//                            break;
//                        case 2:
//                            [self spawnRightWallHard:TRUE];
//                            break;
//                        case 3:
//                            switch (arc4random() % 4 + 1) {
//                                case 1:
//                                    [self spawnMiddleLeftWallHard:TRUE direction:1];
//                                    break;
//                                case 2:
//                                    [self spawnMiddleLeftWallHard:TRUE direction:-1];
//                                    break;
//                                case 3:
//                                    [self spawnMiddleRightWallHard:TRUE direction:1];
//                                    break;
//                                case 4:
//                                    [self spawnMiddleRightWallHard:TRUE direction:-1];
//                                    break;
//                                default:
//                                    [self spawnMiddleRightWallHard:TRUE direction:-1];
//                                    break;
//                            }
//                            break;
                        case 1:
                            [self spawnTwoWallsHard:TRUE];
                            break;
                        case 2:
                            [self spawnThreeWallsHard:TRUE];
                            break;
                        case 3:
                            [self spawnTwoWallsHard:TRUE];
                            break;
                        case 4:
                            [self spawnThreeWallsHard:TRUE];
                            break;
                        default:
                            [self spawnMiddleWallMedium:FALSE direction:1];
                            break;
                    }
                }
            }
            else if (isRandom) {
                switch (arc4random() % 2 + 1) {
                    case 1:
                        _movingWall = TRUE;
                        break;
                    case 2:
                        _movingWall = FALSE;
                        break;
                    default:
                        break;
                }
                
                if (_machLevel >= 0) {
                    switch (arc4random() % 4 + 1) {
//                        case 1:
//                            [self spawnLeftWallHard:_movingWall];
//                            break;
//                        case 2:
//                            [self spawnRightWallHard:_movingWall];
//                            break;
//                        case 3:
//                            switch (arc4random() % 4 + 1) {
//                                case 1:
//                                    [self spawnMiddleLeftWallHard:_movingWall direction:1];
//                                    break;
//                                case 2:
//                                    [self spawnMiddleLeftWallHard:_movingWall direction:-1];
//                                    break;
//                                case 3:
//                                    [self spawnMiddleRightWallHard:_movingWall direction:1];
//                                    break;
//                                case 4:
//                                    [self spawnMiddleRightWallHard:_movingWall direction:-1];
//                                    break;
//                                default:
//                                    [self spawnMiddleRightWallHard:_movingWall direction:-1];
//                                    break;
//                            }
//                            break;
                        case 1:
                            [self spawnTwoWallsHard:_movingWall];
                            break;
                        case 2:
                            [self spawnThreeWallsHard:_movingWall];
                            break;
                        case 3:
                            [self spawnTwoWallsHard:_movingWall];
                            break;
                        case 4:
                            [self spawnThreeWallsHard:_movingWall];
                            break;
                        default:
                            [self spawnTwoWallsHard:_movingWall];
                            break;
                    }
                }
            }
            else {
                if (_machLevel >= 0) {
                    switch (arc4random() % 4 + 1) {
//                        case 1:
//                            [self spawnLeftWallHard:FALSE];
//                            break;
//                        case 2:
//                            [self spawnRightWallHard:FALSE];
//                            break;
//                        case 3:
//                            switch (arc4random() % 4 + 1) {
//                                case 1:
//                                    [self spawnMiddleLeftWallHard:FALSE direction:1];
//                                    break;
//                                case 2:
//                                    [self spawnMiddleLeftWallHard:FALSE direction:-1];
//                                    break;
//                                case 3:
//                                    [self spawnMiddleRightWallHard:FALSE direction:1];
//                                    break;
//                                case 4:
//                                    [self spawnMiddleRightWallHard:FALSE direction:-1];
//                                    break;
//                                default:
//                                    [self spawnMiddleRightWallHard:FALSE direction:-1];
//                                    break;
//                            }
//                            break;
                        case 1:
                            [self spawnTwoWallsHard:FALSE];
                            break;
                        case 2:
                            [self spawnThreeWallsHard:FALSE];
                            break;
                        case 3:
                            [self spawnTwoWallsHard:FALSE];
                            break;
                        case 4:
                            [self spawnThreeWallsHard:FALSE];
                            break;
                        default:
                            [self spawnTwoWallsHard:FALSE];
                            break;
                    }
                }
            }
        } 
        _wallSpawnTimer = 0;
    }
}

- (void) spawnLaserBeamEvent:(ccTime)dt {
    _laserBeamEvent = TRUE;

    if (_laserBeamTimer > _laserBeamTime) {
        if (_machLevel >= 1 && _machLevel <= 6) {
            _laserBeamTime = 12;
            _numOfBeams = 1;
            int newPosX = arc4random() % 301 + 10;
            [_laserBeam1 runLaserBeamEmitters:7 spawnPositionX:newPosX];
            _laserBeamTimer = 0;
        }
        else if (_machLevel >= 7 && _machLevel <= 20) {
            //Single Beam
            if (arc4random() % 13 >= 12) {
                _laserBeamTime = 14;
                _numOfBeams = 1;
                int newPosX = arc4random() % 301 + 10;
                [_laserBeam1 runLaserBeamEmitters:8 spawnPositionX:newPosX];
                _laserBeamTimer = 0;
            }
            else {
                //Double Beam
                _laserBeamTime = 14;
                _numOfBeams = 2;
                int newPosX = arc4random() % 161 + 10;
                [_laserBeam1 runLaserBeamEmitters:8 spawnPositionX:newPosX];
                newPosX = arc4random() % 151 + 160;
                [_laserBeam2 runLaserBeamEmitters:8 spawnPositionX:newPosX];
                _laserBeamTimer = 0;
            }
        }
        else if (_machLevel >= 21) {
            int beamNum = arc4random() % 13;

            if (beamNum >= 11) {
                //Single Beam
                _laserBeamTime = 14;
                _numOfBeams = 1;

                int newPosX = arc4random() % 301 + 10;
                [_laserBeam1 runLaserBeamEmitters:8 spawnPositionX:newPosX];
                _laserBeamTimer = 0;
            }
            else if (beamNum >= 8 && beamNum <= 10){
                //Double Beam
                _laserBeamTime = 14;
                _numOfBeams = 2;
                int newPosX = arc4random() % 161 + 10;
                [_laserBeam1 runLaserBeamEmitters:8 spawnPositionX:newPosX];
                newPosX = arc4random() % 151 + 160;
                [_laserBeam2 runLaserBeamEmitters:8 spawnPositionX:newPosX];
                _laserBeamTimer = 0;
            }
            else if (beamNum >= 0 && beamNum <= 6) {
                //TRiple beam
                _laserBeamTime = 14;
                _numOfBeams = 3;
                int newPosX = arc4random() % 161 + 10;
                [_laserBeam1 runLaserBeamEmitters:8 spawnPositionX:newPosX];
                int range = 180 - 140;
                newPosX = (arc4random() % (range + 1)) + 140;
                [_laserBeam2 runLaserBeamEmitters:8 spawnPositionX:newPosX];
                newPosX = arc4random() % 151 + 160;
                [_laserBeam3 runLaserBeamEmitters:8 spawnPositionX:newPosX];
                _laserBeamTimer = 0;
            }
        }
    }

    _laserBeamTimer += dt;
}

- (BOOL) moveWallDecision {
    
    BOOL moveWall;
    
    switch (arc4random() % 2 + 1) {
        case 1:
            moveWall = TRUE;
            break;
        case 2:
            moveWall = FALSE;
            break;
        default:
            break;
    }
    
    return moveWall;
}

- (void) spawnLeftWallEasy:(BOOL)moveWall {
    [_xpWallCountArray addObject:[NSNumber numberWithInt:1]];
    
    if (moveWall) {
        _leftWall = [Wall InitWallEasyWithDirection:self Position:ccp(55, _newSpawnPosition) machLevel:_machLevel moveWall:moveWall direction:1 sprite:@"WallsEasyLeft-hd"];
    }
    else {
        _leftWall = [Wall InitWallEasy:self Position:ccp(55, _newSpawnPosition) machLevel:_machLevel sprite:@"WallsEasyLeft-hd"];
    }
    
    if (_shutdownEvent) {
        _leftWall.wallSprite.opacity = 60;
    }
    
    [_terrain addChild:_leftWall];
    [_xpWallArray addObject:_leftWall];
    
//    _coinSpawnMiddle = TRUE;
}

- (void) spawnMiddleWallEasy:(BOOL)moveWall direction:(int)direction {
    [_xpWallCountArray addObject:[NSNumber numberWithInt:1]];
    
    if (moveWall) {
        _middleWall = [Wall InitWallEasyWithDirection:self Position:ccp(160, _newSpawnPosition) machLevel:_machLevel moveWall:moveWall direction:direction * 1 sprite:@"WallsEasyMiddle-hd"];
    }
    else {
        _middleWall = [Wall InitWallEasy:self Position:ccp(160, _newSpawnPosition) machLevel:_machLevel sprite:@"WallsEasyMiddle-hd"];
    }
    
    if (_shutdownEvent) {
        _middleWall.wallSprite.opacity = 60;
    }
    
    [_terrain addChild:_middleWall];
    [_xpWallArray addObject:_middleWall];
//    int spawnSide = arc4random() % 2 + 1;
//    if (spawnSide == 1) {
//        _coinSpawnLeft = TRUE;
//    }
//    else {
//        _coinSpawnRight = TRUE;
//    }
}

- (void) spawnRightWallEasy:(BOOL)moveWall {
    [_xpWallCountArray addObject:[NSNumber numberWithInt:1]];
    
    if (moveWall) {
        _rightWall = [Wall InitWallEasyWithDirection:self Position:ccp(265, _newSpawnPosition) machLevel:_machLevel moveWall:moveWall direction:-1 sprite:@"WallsEasyRight-hd"];
    }
    else {
        _rightWall = [Wall InitWallEasy:self Position:ccp(265, _newSpawnPosition) machLevel:_machLevel sprite:@"WallsEasyRight-hd"];
    }
    
    if (_shutdownEvent) {
        _rightWall.wallSprite.opacity = 60;
    }
    
    [_terrain addChild:_rightWall];
    [_xpWallArray addObject:_rightWall];
//    _coinSpawnMiddle = TRUE;
}

- (void) spawnTwoWallsEasy:(BOOL)moveWall {
    switch (arc4random() % 2 + 1) {
        case 1:
            //need newY for each
            [self spawnLeftWallEasy:moveWall];
            [self spawnMiddleWallEasy:moveWall direction:1];
            break;
        case 2:
            [self spawnRightWallEasy:moveWall];
            [self spawnMiddleWallEasy:moveWall direction:-1];
            break;
        default:
            break;
    }
}

- (void) spawnTwoWallsMedium:(BOOL)moveWall {
    switch (arc4random() % 2 + 1) {
        case 1:
            //need newY for each
            [self spawnLeftWallMedium:moveWall];
            [self spawnMiddleWallMedium:moveWall direction:1];
            break;
        case 2:
            [self spawnRightWallMedium:moveWall];
            [self spawnMiddleWallMedium:moveWall direction:-1];
            break;
        default:
            break;
    }
}

- (void) spawnTwoWallsHard:(BOOL) moveWall {
    switch (arc4random() % 10 + 1) {
        case 1:
            [self spawnLeftWallHard:moveWall];
            [self spawnRightWallHard:moveWall];
            break;
        case 2:
            [self spawnMiddleLeftWallHard:moveWall direction:1];
            [self spawnLeftWallHard:moveWall];
            break;
        case 3:
            [self spawnMiddleLeftWallHard:moveWall direction:1];
            [self spawnMiddleRightWallHard:moveWall direction:-1];
            break;
        case 4:
            [self spawnMiddleLeftWallHard:moveWall direction:-1];
            [self spawnMiddleRightWallHard:moveWall direction:1];
            break;
        case 5:
            [self spawnMiddleRightWallHard:moveWall direction:-1];
            [self spawnRightWallHard:moveWall];
            break;
        case 6:
            [self spawnLeftWallHard:moveWall];
            [self spawnMiddleRightWallHard:moveWall direction:-1];
            break;
        case 7:
            [self spawnLeftWallHard:moveWall];
            [self spawnMiddleRightWallHard:moveWall direction:1];
            break;
        case 8:
            [self spawnRightWallHard:moveWall];
            [self spawnMiddleLeftWallHard:moveWall direction:1];
            break;
        case 9:
            [self spawnRightWallHard:moveWall];
            [self spawnMiddleLeftWallHard:moveWall direction:-1];
            break;
        case 10:
            [self spawnRightWallHard:moveWall];
            [self spawnMiddleRightWallHard:moveWall direction:-1];
            break;
        default:
            break;
    }
}

- (void) spawnThreeWallsHard:(BOOL) moveWall {
    switch (arc4random() % 4 + 1) {
        case 1:
            [self spawnLeftWallHard:moveWall];
            [self spawnMiddleLeftWallHard:moveWall direction:1];
            [self spawnMiddleRightWallHard:moveWall direction:1];
            break;
        case 2:
            [self spawnLeftWallHard:moveWall];
            [self spawnMiddleLeftWallHard:moveWall direction:1];
            [self spawnRightWallHard:moveWall];
            break;
        case 3:
            [self spawnLeftWallHard:moveWall];
            [self spawnMiddleRightWallHard:moveWall direction:-1];
            [self spawnRightWallHard:moveWall];
            break;
        case 4:
            [self spawnMiddleLeftWallHard:moveWall direction:-1];
            [self spawnMiddleRightWallHard:moveWall direction:-1];
            [self spawnRightWallHard:moveWall];
            break;
        default:
            break;
    }
}

- (void) spawnLeftWallMedium:(BOOL)moveWall {
    [_xpWallCountArray addObject:[NSNumber numberWithInt:1]];
    
    if (moveWall) {
        _leftWall = [Wall InitWallMediumWithDirection:self Position:ccp(55, _newSpawnPosition) machLevel:_machLevel moveWall:TRUE direction:1 sprite:@"WallsMedLeft-hd"];
    }
    else {
        _leftWall = [Wall InitWallMedium:self Position:ccp(55, _newSpawnPosition) machLevel:_machLevel sprite:@"WallsMedLeft-hd"];
    }
    
    if (_shutdownEvent) {
        _leftWall.wallSprite.opacity = 60;
    }
    
    [_terrain addChild:_leftWall];
    [_xpWallArray addObject:_leftWall];
}

- (void) spawnMiddleWallMedium:(BOOL)moveWall {
    [_xpWallCountArray addObject:[NSNumber numberWithInt:1]];
    
    
    if (moveWall) {
        _middleWall = [Wall InitWallMediumWithDirection:self Position:ccp(190, _newSpawnPosition) machLevel:_machLevel moveWall:TRUE direction:1 sprite:@"WallsMedMiddle-hd"];
    }
    else {
        _middleWall = [Wall InitWallMedium:self Position:ccp(190, _newSpawnPosition) machLevel:_machLevel sprite:@"WallsMedMiddle-hd"];
    }
    
    if (_shutdownEvent) {
        _middleWall.wallSprite.opacity = 60;
    }
    
    [_terrain addChild:_middleWall];
    [_xpWallArray addObject:_middleWall];
}

- (void) spawnRightWallMedium:(BOOL)moveWall {
    [_xpWallCountArray addObject:[NSNumber numberWithInt:1]];
    
    if (moveWall) {
        _rightWall = [Wall InitWallMediumWithDirection:self Position:ccp(265, _newSpawnPosition) machLevel:_machLevel moveWall:TRUE direction:-1 sprite:@"WallsMedRight-hd"];
    }
    else {
        _rightWall = [Wall InitWallMedium:self Position:ccp(265, _newSpawnPosition) machLevel:_machLevel sprite:@"WallsMedRight-hd"];
    }
    
    if (_shutdownEvent) {
        _rightWall.wallSprite.opacity = 60;
    }
    
    [_terrain addChild:_rightWall];
    [_xpWallArray addObject:_rightWall];
}

- (void) spawnMiddleWallMedium:(BOOL)moveWall direction:(int)direction {
    [_xpWallCountArray addObject:[NSNumber numberWithInt:1]];
    
    if (moveWall) {
        _middleWall = [Wall InitWallMediumWithDirection:self Position:ccp(160, _newSpawnPosition) machLevel:_machLevel moveWall:moveWall direction:direction * 1 sprite:@"WallsMedMiddle-hd"];
    }
    else {
        _middleWall = [Wall InitWallMedium:self Position:ccp(160, _newSpawnPosition) machLevel:_machLevel sprite:@"WallsMedMiddle-hd"];
    }
    
    if (_shutdownEvent) {
        _middleWall.wallSprite.opacity = 60;
    }
    
    [_terrain addChild:_middleWall];
    [_xpWallArray addObject:_middleWall];
}

- (void) spawnLeftWallHard:(BOOL)moveWall {
    [_xpWallCountArray addObject:[NSNumber numberWithInt:1]];

    if (moveWall) {
        _leftWall = [Wall InitWallHardWithDirection:self Position:ccp(35, _newSpawnPosition) machLevel:_machLevel moveWall:moveWall direction:1 sprite:@"WallsHardLeft-hd"];
    }
    else {
        _leftWall = [Wall InitWallHard:self Position:ccp(35, _newSpawnPosition) machLevel:_machLevel sprite:@"WallsHardLeft-hd"];
    }
    
    if (_shutdownEvent) {
        _middleWall.wallSprite.opacity = 60;
    }
    
    [_terrain addChild:_leftWall];
    [_xpWallArray addObject:_leftWall];

}

- (void) spawnRightWallHard:(BOOL)moveWall {
    [_xpWallCountArray addObject:[NSNumber numberWithInt:1]];

    if (moveWall) {
        _rightWall = [Wall InitWallHardWithDirection:self Position:ccp(285, _newSpawnPosition) machLevel:_machLevel moveWall:moveWall direction:-1 sprite:@"WallsHardRight-hd"];
    }
    else {
        _rightWall = [Wall InitWallHard:self Position:ccp(285, _newSpawnPosition) machLevel:_machLevel sprite:@"WallsHardRight-hd"];
    }
    
    if (_shutdownEvent) {
        _middleWall.wallSprite.opacity = 60;
    }
    
    [_terrain addChild:_rightWall];
    [_xpWallArray addObject:_rightWall];
}

- (void) spawnMiddleLeftWallHard:(BOOL)moveWall direction:(int) direction {
    [_xpWallCountArray addObject:[NSNumber numberWithInt:1]];
    
    if (moveWall) {
        _middleLeftWall = [Wall InitWallHardWithDirection:self Position:ccp(125, _newSpawnPosition) machLevel:_machLevel moveWall:moveWall direction:1 sprite:@"WallsHardMiddle-hd"];
    }
    else {
        _middleLeftWall = [Wall InitWallHard:self Position:ccp(125, _newSpawnPosition) machLevel:_machLevel sprite:@"WallsHardMiddle-hd"];
    }
    
    if (_shutdownEvent) {
        _middleWall.wallSprite.opacity = 60;
    }
    
    [_terrain addChild:_middleLeftWall];
    [_xpWallArray addObject:_middleLeftWall];
}

- (void) spawnMiddleRightWallHard:(BOOL)moveWall direction:(int) direction {
    [_xpWallCountArray addObject:[NSNumber numberWithInt:1]];
    
    if (moveWall) {
        _middleRightWall = [Wall InitWallHardWithDirection:self Position:ccp(190, _newSpawnPosition) machLevel:_machLevel moveWall:moveWall direction:1 sprite:@"WallsHardMiddle-hd"];
    }
    else {
        _middleRightWall = [Wall InitWallHard:self Position:ccp(190, _newSpawnPosition) machLevel:_machLevel sprite:@"WallsHardMiddle-hd"];
    }
    
    if (_shutdownEvent) {
        _middleWall.wallSprite.opacity = 60;
    }
    
    [_terrain addChild:_middleRightWall];
    [_xpWallArray addObject:_middleRightWall];
}

- (void) spawnPowerup:(ccTime)dt {
    //interval
    if (_powerupTimer > _nextPowerupTime) {
        _powerupSpawnReset = TRUE;
        //chance 1/7
        int offscreenSpawnPosY = arc4random() % 100 + _winSize.height * 1.1;
        int powerupSpawnPosition = [_player getBodyPosition].y * [Box2DHelper pointsPerMeter] + offscreenSpawnPosY;
        
        switch (arc4random() % 15 + 1) {
            case 1:
                _speedPowerup = [PowerupSpeedBoost InitSpeedBoost:self Position:ccp(arc4random() % 260 + 40, powerupSpawnPosition)];
                [_terrain addChild:_speedPowerup];
                _powerup = TRUE;
                //Reset Powerup timer
                _powerupTimer = 0;
                break;
            case 2:
                _reverse = [DebuffReverse InitDebuffReverse:self Position:ccp(arc4random() % 260 + 40, powerupSpawnPosition)];
                [_terrain addChild:_reverse];
                _powerupTimer = 0;
                break;
            case 3:
                _slowmo = [PowerupSlowmo InitSlowmo:self Position:ccp(arc4random() % 260 + 40, powerupSpawnPosition)];
                [_terrain addChild:_slowmo];
                _powerupTimer = 0;
                break;
            case 4:
                _rechargeShield = [PowerupShield InitShield:self Position:ccp(arc4random() % 260 + 40, powerupSpawnPosition)];
                [_terrain addChild:_rechargeShield];
                _powerupTimer = 0;
                //_powerupSpawnReset = FALSE;
                break;
            case 5:
                _fullShield = [PowerupFullShield InitFullShield:self Position:ccp(arc4random() % 260 + 40, powerupSpawnPosition)];
                [_terrain addChild:_fullShield];
                _powerupTimer = 0;
                //_powerupSpawnReset = FALSE;
                break;
            default:
                break;
        }
        
        _nextPowerupTime = arc4random() % 5 + 25;
    }
    _powerupTimer = _powerupTimer + dt;
}

- (void) spawnCoin:(ccTime)dt {
    if (_coinTimer > _coinTime) {
            
        int coinsPosX = 0;
        int coinsPosX2 = 0;

        switch (arc4random() % 3 + 1) {
            case 1:
                _coinSpawnLeft = TRUE;
                break;
            case 2:
                _coinSpawnMiddle = TRUE;
                break;
            case 3:
                _coinSpawnRight = TRUE;
                break;
            default:
                break;
        }
        
        if (_coinSpawnLeft) {
            coinsPosX = _winSize.width * 0.15;
            coinsPosX2 = _winSize.width * 0.3;
        }
        else if (_coinSpawnMiddle) {
            coinsPosX = _winSize.width * 0.4;
            coinsPosX2 = _winSize.width * 0.6;
        }
        else if (_coinSpawnRight) {
            coinsPosX = _winSize.width * 0.7;
            coinsPosX2 = _winSize.width * 0.85;
        }
        
        int y = 0;
        int offscreenPosition = _winSize.height * 1.1;

        int coinsPosXTemp = coinsPosX;
        int row, c, n = arc4random() % 2 + 5;
        
        //DIAMOND COIN SHAPE
        for ( row = 1 ; row <= n ; row++ )
        {
            for ( c = 1 ; c <= row - 1 ; c++ ) {
                coinsPosXTemp = coinsPosXTemp + 20;
                _coinPowerup = [PowerupCoin InitCoinSingle:self Position:ccp(coinsPosXTemp, [_player getPositionY] + offscreenPosition + y)];
                [_terrain addChild:_coinPowerup];
            }
            y = y + 15;
            coinsPosX = coinsPosX - 10;//Starting position for the next row
            coinsPosXTemp = coinsPosX;
        }
        coinsPosXTemp = coinsPosXTemp + 20;
        coinsPosX = coinsPosXTemp;
        for ( row = 1 ; row <= n - 1 ; row++ )
        {
            for ( c = 1 ; c <= n - row - 1 ; c++ ) {
                coinsPosXTemp = coinsPosXTemp + 20;
                _coinPowerup = [PowerupCoin InitCoinSingle:self Position:ccp(coinsPosXTemp, [_player getPositionY] + offscreenPosition + y)];
                [_terrain addChild:_coinPowerup];
            }
            y = y + 15;
            coinsPosX = coinsPosX + 10;//Starting position for the next row
            coinsPosXTemp = coinsPosX;
        }
        
        
        _powerupCoin = TRUE;
        //Reset Powerup timer
        _coinTimer = 0;
        _coinSpawnMiddle = FALSE;
        _coinSpawnLeft = FALSE;
        _coinSpawnRight = FALSE;
        _coinTime = arc4random() % 18 + 5;
    }
    _coinTimer = _coinTimer + dt;
}

- (void) spawnMegaCoin:(ccTime) dt {
    
}

//POWERUP METHODS
- (void) reversePowerup:(ccTime)dt {
    int reverseTime = 4;
    if (_reverseTimer < reverseTime) {
        _reverseDebuff = TRUE;
        if (_powerupIndicator) {
            [_HUD powerupSprite:@"Reverse-hd"];
            _powerupIndicator = FALSE;
        }
        [_HUD powerupTimer:_reverseTimer time:reverseTime];
        _reverseControls = -1;
        _reverseTimer += dt;
    }
    else {
        [_HUD removePowerupSprite];
        _reverseTimer = 0;
        _reverseControls = 1;
        _reverseDebuff = FALSE;
    }
}

- (void) SlowMo:(ccTime)dt {
    int slowmoTime = 5;
    if (_slowmoTimer < slowmoTime) {
        _slowmoPowerup = TRUE;
        if (_powerupIndicator) {
            [_HUD powerupSprite:@"SlowMo-hd"];
            _powerupIndicator = FALSE;
        }
        [_HUD powerupTimer:_slowmoTimer time:slowmoTime];
        if (_slowDownDelay > 0.3f) {
            _slowDownDelay = _slowDownDelay - dt;
            [[[CCDirector sharedDirector] scheduler] setTimeScale:_slowDownDelay];
        }
        _slowmoTimer += dt;
    }
    else {
        if (_slowDownDelay < 1.0f) {
            _slowDownDelay = _slowDownDelay + dt*2;
            [[[CCDirector sharedDirector] scheduler] setTimeScale:_slowDownDelay];
        }
        else {
            [_HUD removePowerupSprite];
            _slowmoTimer = 0;
            _slowmoPowerup = FALSE;
        }
    }
    //CCProgressTimer* progressBar;
    //progressBar.type = kCCProgressTimerTypeRadial;
}

- (void) shieldChargePowerup {
    //if shield is full stop charge at buffed rate
    [_player rechargeShieldPowerup];
}

- (void) slowChargeShield {
    if (_slowCharge && [_player checkIfShieldIsFull]) {
        [_player slowChargeDebuff];
    }
}

- (void) slowDown {
    //NSLog(@"slow");
    [_player slowDebuff];
}

- (void) fullShield {
    if (![_player checkIfShieldIsFull]) {
        //NSLog(@"max shield");
        [_player setShieldToMax];
    }
}

- (void) eventLabel:(NSString*) label {
    CCLabelTTF *eventLabel = [CCLabelTTF labelWithString:label fontName:@font fontSize:15 dimensions:CGSizeMake(150, 150) hAlignment:kCCTextAlignmentCenter];
    eventLabel.position = ccp(-100, 200);
    eventLabel.color = ccc3(255, 255, 255);
    [self addChild:eventLabel];
    
    [eventLabel runAction:[CCSequence actions:[CCMoveTo actionWithDuration:.11f position:ccp(155, 200)], [CCMoveTo actionWithDuration:2.7f position:ccp(165, 200)], [CCMoveTo actionWithDuration:.11f position:ccp(370, 200)], nil]];
}

- (void) machSpeedLabel {    
    [_HUD machSpeedLabel:_machLevel];
}

- (void) endGame {
    //explosion on player position
    [_player death];

    [self unschedule:@selector(update:)];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.0], [CCCallFunc actionWithTarget:self selector:@selector(endTransition)], nil]];

}

- (void) endTransition {
    [[[CCDirector sharedDirector] scheduler] setTimeScale:1];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.0f scene:[EndGame scene] withColor:ccc3(0, 0, 0)]];
}

- (void) initGameWorld
{
	CGSize s = [[CCDirector sharedDirector] winSize];

	b2Vec2 gravity;
	gravity.Set(0.0f, 0.0f);
	_world = new b2World(gravity);
	
	// Do we want to let bodies sleep?
	_world->SetAllowSleeping(true);
	_world->SetContinuousPhysics(true);
	
	m_debugDraw = new GLESDebugDraw( [Box2DHelper pointsPerMeter] );
	_world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = _world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;
	
	// bottom
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	//groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
	//groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
}

- (void) spawnMissile:(ccTime) dt {
    //reticle find targets for a few seconds then fires then next reticle finds target then fires missile
    if (_reticleTimer > _reticleTime) {
        do {
            _reticleX = arc4random() % 300 + 20;
        } while ((_reticleX < _prevReticleX - 50) && (_reticleX > _prevReticleX + 50));
        
        do {
            _reticleY = arc4random() % 200 + 200;
        } while ((_reticleY < _prevReticleY - 50) && (_reticleY > _prevReticleY + 50));
        
        //add reticle
        [self addReticle:_reticleX y:400];

        //pause then fire missile
        [self performSelector:@selector(missile) withObject:nil afterDelay:(double)(arc4random() % 1 + [_enemyHelper getTimeForExplosions:_machLevel]) / 10];//reduce delay slowly
        
        _prevReticleX = _reticleX;
        _prevReticleY = _reticleY;
        
        _reticleTimer = 0;
        _reticleTime = (double)(arc4random() % 1 + [_enemyHelper getTimeForExplosions:_machLevel] - 1) / 10;//make sure this numer is higher than the delay in the performselector!
    }
    
    _reticleTimer += dt;
    _missileTimer += dt;
}

- (void) missile {
    _missile = [Missile InitWithGame:self Position:ccp(_reticleX, [_player getPositionY] + 500)];
    [_terrain addChild:_missile];
    [_missileArray addObject:_missile];
    
    [_HUD removeChild:_missileWarning cleanup:YES];
}

- (void) addReticle:(int)x y:(int)y {
    CCCallBlockN * removeMissileWarning = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    
    CCSprite *missileWarning = [CCSprite spriteWithFile:@"MissileWarning-hd.png"];
    missileWarning.position = ccp(x, y);
    missileWarning.tag = 100;
    [_HUD addChild:missileWarning];
    [missileWarning runAction:[CCSequence actions:[CCFadeOut actionWithDuration:1.0f], removeMissileWarning, nil]];
    [_missileWarningArray addObject:missileWarning];
}

- (void) dealloc {
    delete _world;
	_world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
}

@end
