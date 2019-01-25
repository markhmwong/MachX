//
//  ShootingStars.m
//  MachX
//
//  Created by Mark Wong on 17/02/13.
//  Copyright 2013 Whizbang. All rights reserved.
//

#import "ShootingStars.h"


@implementation ShootingStars

- (id) init {
    if((self=[super init])) {
        _shootingStar = [CCSprite spriteWithFile:@"ShootingStar-hd.png"];
        _shootingStar.position = ccp(30, 1060);
        [self addChild:_shootingStar];
        
        _timer = 0;
        _time = 3;
        
    }
    return self;
}

- (void) fireShootingStars:(ccTime)dt {
    
    while (_timer >= _time) {
        
        
        //Work out speed
        //Work out starting location x
        int startingPosX = arc4random() % 280 + 40;
        int startingPosY = 1000;
        
        //reset position
        _shootingStar.position = ccp(startingPosX, startingPosY);
        
        //int max = 500;
        int min = -100;
        int range = max - min;
        
        int endPosY = -100;
        int endPosX = (arc4random() % range + 1) + min;
        if (startingPosX >= 160) {
            endPosX = (arc4random() % (160 + 150) + 1) + min;
        }
        else {
            endPosX = (arc4random() % (450 - 161) + 1) + 161;
        }
        
        
        int deltaY = endPosY - startingPosY;
        int deltaX = endPosX - startingPosX;
        
        int angleInDegrees = atan2(deltaX, deltaY) * 180 / M_PI;
        
        _shootingStar.rotation = angleInDegrees;
        [_shootingStar runAction:[CCMoveTo actionWithDuration:10 position:ccp(endPosX, endPosY)]];
        [_shootingStar runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCFadeTo actionWithDuration:.2f opacity:200], [CCFadeTo actionWithDuration:0.2f opacity:255], nil]]];
        
        _time = arc4random() % 5 + 15;
        _timer = 0;
    }
    
    
    _timer += dt;
}

@end
