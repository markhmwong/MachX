//
//  IntroLayer.m
//  CrazyPlanes_cc2
//
//  Created by Mark Wong on 23/09/12.
//  Copyright Mark Wong 2012. All rights reserved.
//


// Import the interfaces
#import "Tutorial.h"
#define PTM_RATIO 32

#define font "Walkway Bold"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation Tutorial
@synthesize player = _player;
@synthesize world = _world;
@synthesize terrain = _terrain;
@synthesize HUD = _HUD;
@synthesize parallax = _parallax;
@synthesize leftWall = _leftWall;
@synthesize rightWall = _rightWall;
@synthesize middleWall = _middleWall;
@synthesize sideWallRight = _sideWallRight;
@synthesize sideWallLeft = _sideWallLeft;

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

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Tutorial *layer = [[Tutorial alloc] init];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

//
-(id) init
{
	if ((self=[super init])) {
        self.isAccelerometerEnabled = YES;
        self.isTouchEnabled = YES;

        _textNum = 0;
        [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
        [[GameManager sharedGameManager] loadGameData];
        
        _winSize = [CCDirector sharedDirector].winSize;
        
        self.isTouchEnabled = TRUE;
        
        _background = [CCLayerColor layerWithColor:ccc4(80, 100, 200, 255)];
        [self addChild:_background z:-10];
        _background2 = [CCLayerColor layerWithColor:ccc4(80, 100, 200, 255)];
        [self addChild:_background2 z:-9];
        
        _flash = [CCSequence actions:[CCSpawn actions:[CCFadeIn actionWithDuration:0.09], [CCTintTo actionWithDuration:0.09 red:185 green:185 blue:215], nil], [CCSpawn actions:[CCFadeOut actionWithDuration:0.09], [CCTintTo actionWithDuration:0.09 red:0 green:0 blue:0], nil], nil];
        
        [_background runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCDelayTime actionWithDuration:15], [CCTintTo actionWithDuration:20 red:40 green:60 blue:135], [CCDelayTime actionWithDuration:15], [CCTintTo actionWithDuration:15 red:30 green:40 blue:80], nil]]];       
        
        _shootingStarsLayer = [[ShootingStars alloc] init];
        [self addChild:_shootingStarsLayer z:-3];
        
        _tutorialText = [CCLabelTTF labelWithString:@"" fontName:@font fontSize:16 dimensions:CGSizeMake(240, 150) hAlignment:kCCTextAlignmentCenter];
        _tutorialText.position = ccp(_winSize.width / 2, _winSize.height / 2);
        [self addChild:_tutorialText];
        
        //setup world
        [self initGameWorld];
        
        //add Terrain
        self.terrain = [Terrain terrainWithWorld:_world];
        [self addChild:_terrain];
        
        self.player = [Player InitWithTut:self];
        [_terrain addChild:_player];
        _player.position = ccp(_winSize.width * 0.5, 240);
        
        [self tutorialSceneStart];
        [self parallaxBG];
        [self schedule:@selector(update:)];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"mainMenuAmbience.m4a" loop:TRUE];
	}
	return self;
}

- (void) tutorialSceneStart {
    _speed = -12;
    
    
    
    //text in email
    //skip button
    //next button
    //need to add powerup button
    
//    Welcome to Mach X pilot (??)
//    
//    The Machinima have trapped us in digital space
//    
//    They intend to block our path but its nothing you can't handle.. I'm sure
//    
//    We must survive and warn our homeworld what is coming for us..
//        
//        But first I know it's been a while since you were called into service so let's begin with the basics..
//
//    Whoa! Watch out incoming obstacle ahead! Tilt the device left!
//    Another obstacle incoming to the right! Tilt the device right!
//        Phew that was close! Good work!
//
//    
//    *Rumble* Whoa! The explosion of our planet was so intense the nova is still chasing us!
//    Touch and hold on the screen to enable boost.
//        Don't worry this is the fastest ship in the fleet, we can escape anything.
//
//    
//        Now lets look at the interface. The top 3 icons show which of the powerups are in use
//        
//        This gives double te coins.
//        This enables the magnet in ur ship to attract coins easier
//        This gives a second chance
//        
//        The green bar shows how much shield is left
//        
//        This is the distance u have travelled
//        
//        And finally the button to enable items u purchased
//
    
    CCMenuItemSprite *nextButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Resume-hd.png"] selectedSprite:[CCSprite spriteWithFile:@"Resume-hd.png"] target:self selector:@selector(next)];
    nextButton.position = ccp(30, 30);
    CCMenu *tutorialMenu = [CCMenu menuWithItems:nextButton, nil];
    tutorialMenu.position = ccp(0,0);
    [self addChild:tutorialMenu];
}

- (void) next {
    CCCallBlockN * nextTutorial = [CCCallBlockN actionWithBlock:^(CCNode *node)  { _textNum++; }];

    [_tutorialText runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.4], nextTutorial, [CCFadeIn actionWithDuration:0.4], nil]];
}


- (void) parallaxBG {
    self.parallax = [Background background];
    [self addChild:_parallax z:-1];
    [_parallax darkenWallsMainMenu];
}

- (void) update:(ccTime)dt {
    [_parallax updateVelocity:ccp(0, _speed) delta:dt];
    [_shootingStarsLayer fireShootingStars:dt];

    //timer for text
    
    
    
    //tutorial text
    switch (_textNum) {
        case 0:
            [_tutorialText setString:@"Welcome Hero..."];
            break;
        case 1:
            [_tutorialText setString:@"The Machinima have surrounded us..."];
            break;
        case 2:
            [_tutorialText setString:@"They intend to stop our escape but its nothing you can't handle, I'm sure..."];
            break;
        case 3:
            [_tutorialText setString:@"We must survive, we must warn our homeworld..."];
            break;
        case 4:
            [_tutorialText setString:@"But first I know it's been a while since you were called into service so let's begin with the basics.."];
            break;
        case 5:
            [_tutorialText setString:@"Tilt the device left, to turn the ship left"];
            //timer disable
            //tilt left say good work!
            if ([_player getPositionX] < _winSize.width / 3) {
                //test
                //fade out text then increment _textNum
                _textNum++;
            }
            break;
        case 6:
            [_tutorialText setString:@"Good Work!"];
            //timer re-enable
            break;
        case 7:
            [_tutorialText setString:@"Tilt the device right, to turn the ship right!"];
            
            //time disable
            if ([_player getPositionX] > (_winSize.width * 2) / 3) {
                //fade out text then increment _textNum
            }
            break;
        case 8:
            //timer re-enable
            [_tutorialText setString:@"Looking good!"];
            
            break;
        case 9:
            [_tutorialText setString:@"Incoming obstacles ahead!"];
            //spawn left wall, middle wall and right wall
            break;
        case 10:
            [_tutorialText setString:@"I'm rebooting the ship's system, bringing shields online... keep your shields up always!"];
            break;
        case 11:
            [_tutorialText setString:@"Hitting obstacles damages the shield"];
            break;
        case 12:
            [_tutorialText setString:@"However collecting certain green powerups such as these can help charge your shield"];
            //show shield powerups
            break;
        case 13:
            [_tutorialText setString:@"But avoid collecting red powerups!"];
            break;
        case 14:
            //spawn mach nova
            [_tutorialText setString:@"Whoa! Our planet's explosion was so intense it's still chasing us!"];
            break;
        case 15:
            //enable boost
            [_tutorialText setString:@"Touch the screen to boost!"];
            break;
        case 16:
            [_tutorialText setString:@"Too easy!"];
            break;
        case 17:
            [_tutorialText setString:@"Now that we know the basics, let's begin..."];
            break;
        default:
            break;
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

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    if (acceleration.x < 0.001 && acceleration.x > -0.65) {
        //LEFT
        _player.body->ApplyLinearImpulse(b2Vec2((acceleration.x * 20) * [_player getTurnSpeedStat], 0), [_player getBodyPosition]);
    }
    else if (acceleration.x > 0.001 && acceleration.x < 0.65) {
        //RIGHT
        _player.body->ApplyLinearImpulse(b2Vec2((acceleration.x * 20) * [_player getTurnSpeedStat], 0), [_player getBodyPosition]);
    }
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

@end
