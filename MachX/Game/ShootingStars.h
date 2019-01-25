//
//  ShootingStars.h
//  MachX
//
//  Created by Mark Wong on 17/02/13.
//  Copyright 2013 Whizbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ShootingStars : CCLayer {
    CCSprite *_shootingStar;
    int _angle;
    float _timer;
    float _time;
}

- (void) fireShootingStars:(ccTime)dt;

@end
