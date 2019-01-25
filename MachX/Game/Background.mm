//
//  Background.m
//  CrazyPlanes_cc2
//
//  Created by Mark Wong on 16/10/12.
//  Copyright 2012 Mark Wong. All rights reserved.
//

#import "Background.h"


@implementation Background

@synthesize darkenBG = _darkenBG;
/*
+ (id) backgrounWithGame:(Game*)game {
	return [[[self alloc] initWithBackground:game] autorelease];
}*/

+ (id) background {
    return [[self alloc] initWithBackground];
}

-(id) initWithBackground {
    if (self = [super init]) {

        _newEvent = TRUE;
        _dtEvent = 0.0;
        //self.game = game;
        _darkenBG = FALSE;
        
        _winSize = [CCDirector sharedDirector].winSize;

        _parallax = [[CCParallaxScrollNode alloc] init];
        _parallax_Border = [[CCParallaxScrollNode alloc] init];
        _parallax_Pillar = [[CCParallaxScrollNode alloc] init];
        _parallax_Lights = [[CCParallaxScrollNode alloc] init];
        _parallax_LightBorder = [[CCParallaxScrollNode alloc] init];
        [self clouds];

        
        //Full Screen Backgrounds
        //STARS
        _parallaxBG = [CCSprite spriteWithFile:@"ParallaxBackgroundBlur2.png"];
        [_parallaxBG.texture setAliasTexParameters];
        CCSprite *smallStars2 = [CCSprite spriteWithFile:@"ParallaxBackgroundBlur2.png"];
        [smallStars2.texture setAliasTexParameters];
		//smallStars.anchorPoint = ccp(0,0);
        [_parallax addInfiniteScrollYWithZ:1 Ratio:ccp(0,0.01) Pos:ccp(0,0) Objects:_parallaxBG, smallStars2, nil];
        
        //FASTER STARS
        CCSprite *parallaxBackground2_1 = [CCSprite spriteWithFile:@"ParallaxBackground2.png"];
        parallaxBackground2_1.tag = 2;
        CCSprite *parallaxBackground2_2 = [CCSprite spriteWithFile:@"ParallaxBackground2.png"];
        [_parallax addInfiniteScrollYWithZ:2 Ratio:ccp(0,0.03) Pos:ccp(0,0) Objects:parallaxBackground2_1, parallaxBackground2_2, nil];
        [self addChild:_parallax z:-4];
        
        //Left Border
        _Border_Left_1 = [CCSprite spriteWithFile:@"Border_Long.png"];
        //[Border_Left_1.texture setAliasTexParameters];
        _Border_Left_1.color = ccc3(200, 200, 200);
        _Border_Left_1.tag = 1;
        _Border_Left_2 = [CCSprite spriteWithFile:@"Border_Long.png"];
        //[Border_Left_2.texture setAliasTexParameters];
        _Border_Left_2.color = ccc3(200, 200, 200);
        _Border_Left_2.tag = 2;
        [_parallax_Border addInfiniteScrollYWithZ:2 Ratio:ccp(0,0.04) Pos:ccp(0,0) Objects:_Border_Left_1, _Border_Left_2, nil];

        //Right Border
        _Border_Right_1 = [CCSprite spriteWithFile:@"Border_Long.png"];
        _Border_Right_1.color = ccc3(200, 200, 200);
        _Border_Right_1.flipX = TRUE;
        _Border_Right_1.tag = 3;
        _Border_Right_2 = [CCSprite spriteWithFile:@"Border_Long.png"];
        _Border_Right_2.color = ccc3(200, 200, 200);
        _Border_Right_2.flipX = TRUE;
        _Border_Right_2.tag = 4;
        [_parallax_Border addInfiniteScrollYWithZ:2 Ratio:ccp(0,0.04) Pos:ccp(280,0) Objects:_Border_Right_1, _Border_Right_2, nil];
        //[self addChild:_parallax_Border z:-1];
        
        //Left Border Glow
        _Border_Left_1_Glow = [CCSprite spriteWithFile:@"Border_Glow_Long.png"];
        _Border_Left_1_Glow.color = ccc3(220, 220, 220);
        _Border_Left_1_Glow.tag = 1;
        _Border_Left_2_Glow = [CCSprite spriteWithFile:@"Border_Glow_Long.png"];
        _Border_Left_2_Glow.color = ccc3(220, 220, 220);
        _Border_Left_2_Glow.tag = 2;
        [_parallax_Border addInfiniteScrollYWithZ:2 Ratio:ccp(0,0.04) Pos:ccp(0,0) Objects:_Border_Left_1_Glow, _Border_Left_2_Glow, nil];
        
        //Right Border Glow
        _Border_Right_1_Glow = [CCSprite spriteWithFile:@"Border_Glow_Long.png"];
        _Border_Right_1_Glow.flipX = TRUE;
        _Border_Right_1_Glow.color = ccc3(220, 220, 220);
        _Border_Right_1_Glow.tag = 3;
        _Border_Right_2_Glow = [CCSprite spriteWithFile:@"Border_Glow_Long.png"];
        _Border_Right_2_Glow.flipX = TRUE;
        _Border_Right_2_Glow.color = ccc3(220, 220, 220);
        _Border_Right_2_Glow.tag = 4;
        [_parallax_Border addInfiniteScrollYWithZ:2 Ratio:ccp(0,0.04) Pos:ccp(270,0) Objects:_Border_Right_1_Glow, _Border_Right_2_Glow, nil];
        [self addChild:_parallax_Border z:-1];
        
        //Lights
        _lights = [CCSprite spriteWithFile:@"Wall_Light.png"];
        _lights.opacity = 200;
        _lights.tag = 1;
        _lights2 = [CCSprite spriteWithFile:@"Wall_Light.png"];
        _lights2.opacity = 200;
        _lights.tag = 2;
        [_parallax_Lights addInfiniteScrollYWithZ:2 Ratio:ccp(0,0.04) Pos:ccp(1, 0) Objects:_lights, _lights2, nil];
        
        _lights_Right = [CCSprite spriteWithFile:@"Wall_Light.png"];
        _lights_Right.flipX = TRUE;
        _lights2_Right = [CCSprite spriteWithFile:@"Wall_Light.png"];
        _lights2_Right.flipX = TRUE;
        [_parallax_Lights addInfiniteScrollYWithZ:2 Ratio:ccp(0,0.04) Pos:ccp(308, 0) Objects:_lights_Right, _lights2_Right, nil];
        [self addChild:_parallax_Lights z:0];
        
        CCSprite *_thinBorder = [CCSprite spriteWithFile:@"ThinBorder.png"];
        CCSprite *_thinBorder2 = [CCSprite spriteWithFile:@"ThinBorder.png"];
        [_parallax_LightBorder addInfiniteScrollYWithZ:2 Ratio:ccp(0,0.04) Pos:ccp(-1,0) Objects:_thinBorder, _thinBorder2, nil];
        
        CCSprite *_thinBorder_Right = [CCSprite spriteWithFile:@"ThinBorder.png"];
        CCSprite *_thinBorder2_Right = [CCSprite spriteWithFile:@"ThinBorder.png"];
        _thinBorder_Right.flipX = TRUE;
        _thinBorder2_Right.flipX = TRUE;
        [_parallax_LightBorder addInfiniteScrollYWithZ:2 Ratio:ccp(0,0.04) Pos:ccp(317,0) Objects:_thinBorder_Right, _thinBorder2_Right, nil];
        [self addChild:_parallax_LightBorder z:0];        
        
        //Pillar
        _pillar = [CCSprite spriteWithFile:@"Pillar_Long.png"];
        //_pillar.position = ccp(160, 500);
        //[self addChild:_pillar];
        _pillar2 = [CCSprite spriteWithFile:@"Pillar_Long.png"];
        [_parallax_Pillar addInfiniteScrollYWithZ:1 Ratio:ccp(0,0.04) Pos:ccp(40, 0) Objects:_pillar, _pillar2, nil];
        [self addChild:_parallax_Pillar z:-3];
        
        _opticalLense = [CCSprite spriteWithFile:@"opticalLense-hd.png"];
        _opticalLense.position = ccp(80, _winSize.height * 1.1);
        _opticalLense.opacity = 255;
        _opticalLense.scale = 0.7;
        [self addChild:_opticalLense z:-4];
        _lenseSpawn = TRUE;

    }
    return self;
}

- (void) updateVelocity:(CGPoint)position delta:(ccTime)dt {
    [_parallax updateWithVelocity:position AndDelta:dt];
    [_parallax_Border updateWithVelocity:position AndDelta:dt];
    [_parallax_Pillar updateWithVelocity:position AndDelta:dt];
    [_parallax_LightBorder updateWithVelocity:position AndDelta:dt];
    [_parallax_Lights updateWithVelocity:ccp(position.x, position.y-5) AndDelta:dt];
    
    //timeEvent
    if (_newEvent && _dtEvent > _nextEvent) {
        _dtEvent = 0.0;
        _nextEvent = arc4random() % (30 - 25) + 25;
        //NSLog(@"New Event");
    }
    
    //speed (slow)
    //side
    
    if (arc4random() % 300 <= 10 && _lenseSpawn) {
        _lenseFlag = TRUE;
        _lenseSpawn = FALSE;
        _lenseFinish = FALSE;
        switch (arc4random() % 2 + 1) {
            case 1:
                opticalLenseX = _winSize.width * 0.3;
                break;
            case 2:
                _opticalLense.flipX = TRUE;
                opticalLenseX = _winSize.width * 0.85;
                break;
            default:
                break;
        }
        opticalLenseY = _winSize.height * 1.1;
    }
    
    //run optical lense
    if (_lenseFlag) {
        opticalLenseY = opticalLenseY - 0.2;
        _opticalLense.position = ccp(opticalLenseX, opticalLenseY);
        if (opticalLenseY < -50) {
            _lenseFinish = TRUE;
        }
    }
    
    if (_time > 3) {
        //CCSprite *test = (CCSprite*)[_parallax getChildByTag:1];
        //NSLog(@"%f", test.position.y);
        //next mach level
        //need a boolean to enable this
        //if (test.position.y < 0) {
            //change bg
            //[smallStars setTexture:_tex];
        //}
    }
    
    _time += dt;
    _dtEvent += dt;
}

- (void) darkenWalls {
    
    [_Border_Left_1 runAction:[CCSequence actions:[CCTintTo actionWithDuration:0.9f red:255 green:255 blue:255], [CCDelayTime actionWithDuration:1.2], [CCTintTo actionWithDuration:0.25f red:150 green:150 blue:150], nil]];
    [_Border_Left_2 runAction:[CCSequence actions:[CCTintTo actionWithDuration:0.9f red:255 green:255 blue:255], [CCDelayTime actionWithDuration:1.2], [CCTintTo actionWithDuration:0.25f red:150 green:150 blue:150], nil]];
    [_Border_Right_1 runAction:[CCSequence actions:[CCTintTo actionWithDuration:0.9f red:255 green:255 blue:255], [CCDelayTime actionWithDuration:1.2], [CCTintTo actionWithDuration:0.25f red:150 green:150 blue:150], nil]];
    [_Border_Right_2 runAction:[CCSequence actions:[CCTintTo actionWithDuration:0.9f red:255 green:255 blue:255], [CCDelayTime actionWithDuration:1.2], [CCTintTo actionWithDuration:0.25f red:150 green:150 blue:150], nil]];
    
    [_Border_Left_1_Glow runAction:[CCSequence actions:[CCTintTo actionWithDuration:0.7f red:255 green:255 blue:255], [CCDelayTime actionWithDuration:1.2], [CCTintTo actionWithDuration:0.25f red:180 green:180 blue:180], nil]];
    [_Border_Left_2_Glow runAction:[CCSequence actions:[CCTintTo actionWithDuration:0.7f red:255 green:255 blue:255], [CCDelayTime actionWithDuration:1.2], [CCTintTo actionWithDuration:0.25f red:180 green:180 blue:180], nil]];
    [_Border_Right_1_Glow runAction:[CCSequence actions:[CCTintTo actionWithDuration:0.7f red:255 green:255 blue:255], [CCDelayTime actionWithDuration:1.2], [CCTintTo actionWithDuration:0.25f red:180 green:180 blue:180], nil]];
    [_Border_Right_2_Glow runAction:[CCSequence actions:[CCTintTo actionWithDuration:0.7f red:255 green:255 blue:255], [CCDelayTime actionWithDuration:1.2], [CCTintTo actionWithDuration:0.25f red:180 green:180 blue:180], nil]];

    [_pillar runAction:[CCTintTo actionWithDuration:2.0f red:150 green:150 blue:150]];
    [_pillar2 runAction:[CCTintTo actionWithDuration:2.0f red:150 green:150 blue:150]];

}

- (void) redFlashingWalls {
    [_Border_Left_1_Glow runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCTintTo actionWithDuration:0.4 red:190 green:0 blue:0], [CCTintTo actionWithDuration:0.5 red:255 green:255 blue:255], nil]]];
    [_Border_Left_2_Glow runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCTintTo actionWithDuration:0.4 red:190 green:0 blue:0], [CCTintTo actionWithDuration:0.5 red:255 green:255 blue:255], nil]]];
    [_Border_Right_2_Glow runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCTintTo actionWithDuration:0.4 red:190 green:0 blue:0], [CCTintTo actionWithDuration:0.5 red:255 green:255 blue:255], nil]]];
    [_Border_Right_1_Glow runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCTintTo actionWithDuration:0.4 red:190 green:0 blue:0], [CCTintTo actionWithDuration:0.5 red:255 green:255 blue:255], nil]]];
}

- (void) darkenWallsMainMenu {
    _Border_Left_1.color = ccc3(150, 150, 150);
    _Border_Left_2.color = ccc3(150, 150, 150);
    _Border_Left_1_Glow.color = ccc3(200, 200, 200);
    _Border_Left_2_Glow.color = ccc3(200, 200, 200);
    _Border_Right_1.color = ccc3(150, 150, 150);
    _Border_Right_2.color = ccc3(150, 150, 150);
    _Border_Right_1_Glow.color = ccc3(200, 200, 200);
    _Border_Right_2_Glow.color = ccc3(200, 200, 200);
}

- (void) lightenWalls {
    [_Border_Left_1 runAction:[CCSequence actions:[CCTintTo actionWithDuration:2.0f red:210 green:210 blue:210], nil]];
    [_Border_Left_2 runAction:[CCSequence actions:[CCTintTo actionWithDuration:2.0f red:210 green:210 blue:210], nil]];
    [_Border_Right_1 runAction:[CCSequence actions:[CCTintTo actionWithDuration:2.0f red:210 green:210 blue:210], nil]];
    [_Border_Right_2 runAction:[CCSequence actions:[CCTintTo actionWithDuration:2.0f red:210 green:210 blue:210], nil]];
    
    [_Border_Left_1_Glow runAction:[CCSequence actions:[CCTintTo actionWithDuration:0.7f red:255 green:255 blue:255], nil]];
    [_Border_Left_2_Glow runAction:[CCSequence actions:[CCTintTo actionWithDuration:0.7f red:255 green:255 blue:255], nil]];
    [_Border_Right_1_Glow runAction:[CCSequence actions:[CCTintTo actionWithDuration:0.7f red:255 green:255 blue:255], nil]];
    [_Border_Right_2_Glow runAction:[CCSequence actions:[CCTintTo actionWithDuration:0.7f red:255 green:255 blue:255], nil]];

    [_pillar runAction:[CCTintTo actionWithDuration:2.0f red:255 green:255 blue:255]];
    [_pillar2 runAction:[CCTintTo actionWithDuration:2.0f red:255 green:255 blue:255]];
    
    [_lights stopAllActions];
    [_lights2 stopAllActions];
    [_lights_Right stopAllActions];
    [_lights2_Right stopAllActions];
    [_lights runAction:[CCFadeIn actionWithDuration:0]];
    [_lights2 runAction:[CCFadeIn actionWithDuration:0]];
    [_lights_Right runAction:[CCFadeIn actionWithDuration:0]];
    [_lights2_Right runAction:[CCFadeIn actionWithDuration:0]];
}

- (void) turnOffWallLight {
    //CCSprite *lightTag1 = (CCSprite*)[_parallax_Lights getChildByTag:1];
    //CCSprite *lightTag2 = (CCSprite*)[_parallax_Lights getChildByTag:2];
    id flicker = [CCSequence actions:[CCFadeTo actionWithDuration:0.4f opacity:100], [CCDelayTime actionWithDuration:0.4f], [CCFadeTo actionWithDuration:0.1f opacity:200], [CCFadeTo actionWithDuration:0.4f opacity:100], [CCDelayTime actionWithDuration:0.1f], [CCFadeTo actionWithDuration:0.5f opacity:255], nil];
    [_lights runAction:[CCRepeatForever actionWithAction:flicker]];
    [_lights2 runAction:[CCRepeatForever actionWithAction:flicker]];
    [_lights_Right runAction:[CCRepeatForever actionWithAction:flicker]];
    [_lights2_Right runAction:[CCRepeatForever actionWithAction:flicker]];
}

- (void) clouds {
    _env_clouds = [[CCParallaxScrollNode alloc] init];
    CCSprite *clouds = [CCSprite spriteWithFile:@"Noise.png"];
    //[[clouds texture] setAliasTexParameters];
    clouds.opacity = 180;
    //clouds.position = ccp(512/2, 512/2);
    [clouds setBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ZERO}];
    
    CCSprite *clouds2 = [CCSprite spriteWithFile:@"Noise.png"];
    //[[clouds2 texture] setAliasTexParameters];
    clouds2.opacity = 180;
    [clouds2 setBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ZERO}];
    //[clouds2 visit];
    
    //black line is hidden by offsetting the clouds to -90
    [_env_clouds addInfiniteScrollYWithZ:1 Ratio:ccp(0,0.06) Pos:ccp(0, 0) Objects:clouds, nil];
    [self addChild:_env_clouds z:-4];
}


@end
