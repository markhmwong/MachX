//
//  IntroLayer.m
//  CrazyPlanes_cc2
//
//  Created by Mark Wong on 23/09/12.
//  Copyright Mark Wong 2012. All rights reserved.
//


// Import the interfaces
#import "CompanyLayer.h"
#import "SimpleAudioEngine.h"

#pragma mark - CompanyLayer

// HelloWorldLayer implementation
@implementation CompanyLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CompanyLayer *layer = [[CompanyLayer alloc] init];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

//
-(id) init
{
	if ((self=[super initWithColor:ccc4(0, 0, 0, 255)])) {
		
		// ask director for the window size
		//CGSize size = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = TRUE;
        //[self companyScene];
//        [self companySceneNew];
        [self companySceneSimple];
        //[self cosTest];
	}
	return self;
}

- (void) companySceneSimple {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    _companyLogo = [CCSprite spriteWithFile:@"CompanyLogo_simple-hd.png"];
    _companyLogo.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:_companyLogo];
    
    [_companyLogo runAction:[CCSequence actions:[CCDelayTime actionWithDuration:2.0f], [CCFadeOut actionWithDuration:2.0f], [CCCallFuncN actionWithTarget:self selector:@selector(nextScene)], nil]];
}

- (void) companySceneNew {
    CGSize winSize = [CCDirector sharedDirector].winSize;

    _companyLogo = [CCSprite spriteWithFile:@"CompanyTitle-hd.png"];
    _companyLogo.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:_companyLogo];
    
    _particlesTop = [CCSprite spriteWithFile:@"Particles-hd.png"];
    _particlesTop.position = ccp(winSize.width/2, winSize.height * 0.62);
    [self addChild:_particlesTop];
    
    _particlesBot = [CCSprite spriteWithFile:@"Particles-hd.png"];
    _particlesBot.position = ccp(winSize.width/2, winSize.height * 0.42);
    _particlesBot.flipY = TRUE;
    [self addChild:_particlesBot];
    
    [_particlesTop runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2],  [CCScaleTo actionWithDuration:5 scale:1.1], [CCFadeOut actionWithDuration:2.0], nil]];
    [_particlesBot runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2], [CCScaleTo actionWithDuration:5 scale:1.1], [CCFadeOut actionWithDuration:2.0], [CCCallFuncN actionWithTarget:self selector:@selector(nextScene)], nil]];
    [_companyLogo runAction:[CCSequence actions:[CCDelayTime actionWithDuration:5.2f], [CCFadeOut actionWithDuration:2.0], nil]];
}

- (void) companyScene {
    [[SimpleAudioEngine sharedEngine] playEffect:@"Title.m4a"];
    
    _companyLogo = [CCSprite spriteWithFile:@"CompanyLogo_MachX2_title.png"];
    _companyLogo.position = ccp(160, 320);
    _companyLogo.opacity = 50;
    [self addChild:_companyLogo];
    
    [_companyLogo runAction:[CCSequence actions:[CCDelayTime actionWithDuration:3.0f], [CCFadeTo actionWithDuration:0.1f opacity:255], [CCDelayTime actionWithDuration:1.0f], [CCFadeOut actionWithDuration:1.5f], [CCCallFuncN actionWithTarget:self selector:@selector(nextScene)], nil]];
    
    _shading = [CCSprite spriteWithFile:@"CompanyLogo_MachX2_shading.png"];
    _shading.position = ccp(160, 320);
    [self addChild:_shading];
    
    [_shading runAction:[CCSequence actions:[CCFadeTo actionWithDuration:3.0f opacity:255], [CCFadeOut actionWithDuration:0.1f], nil]];
    _flare = [CCSprite spriteWithFile:@"CompanyLogo_MachX2_flare.png"];
    _flare.position = ccp(25, 340);
    _flare.opacity = 0;
    [self addChild:_flare];

    id fadeIn = [CCFadeTo actionWithDuration:3.0f opacity:90];
    id flash = [CCFadeTo actionWithDuration:0.1f opacity:255];
    id move = [CCMoveTo actionWithDuration:1.4f position:ccp(65, 340)];
    [_flare runAction:[CCSequence actions:fadeIn, flash, [CCSpawn actions:move, nil], [CCFadeOut actionWithDuration:1.0f], nil]];
}

- (void) nextScene {
    CCScene *mainScreenLayerScene = [MainScreen scene];
    [[CCDirector sharedDirector] replaceScene:mainScreenLayerScene];
}

- (void) update:(ccTime)dt {

}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //make stars fly by faster before going to the game
    CCScene *mainScreenLayerScene = [MainScreen scene];
    [[CCDirector sharedDirector] replaceScene:mainScreenLayerScene];
    self.isTouchEnabled = FALSE;

}


@end
