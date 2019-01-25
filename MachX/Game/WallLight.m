//
//  WallLight.m
//  CrazyPlanes_cc2
//
//  Created by Mark Wong on 3/12/12.
//  Copyright 2012 Mark Wong. All rights reserved.
//

#import "WallLight.h"


@implementation WallLight

- (id) initLight {
    if ((self = [super init])) {
        CCSprite *w = [CCSprite spriteWithFile:@"Wall_Light.png"];
        [self addChild:w];
    }
    return self;
}
@end
