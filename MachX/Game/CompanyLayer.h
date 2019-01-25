//
//  CompanyLayer.h
//  CrazyPlanes_cc2
//
//  Created by Mark Wong on 14/12/12.
//  Copyright 2012 Mark Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MainScreen.h"

@interface CompanyLayer : CCLayerColor {
    CCSprite *_companyLogo;
    CCSprite *_shading;
    CCSprite *_flare;
    CCSprite *_particlesTop;
    CCSprite *_particlesBot;
}
+(CCScene *) scene;

@end
