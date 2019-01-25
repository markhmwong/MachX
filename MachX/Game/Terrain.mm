//
//  Terrain.m
//  CrazyCars
//
//  Created by Mark Wong on 12/05/12.
//  Copyright 2012 Whizbang. All rights reserved.
//

#import "Terrain.h"


@implementation Terrain
@synthesize offsetY = _offsetY;

+ (id) terrainWithWorld:(b2World*)w {
	return [[self alloc] initWithWorld:w];
}

- (id) initWithWorld:(b2World*)w {
	
	if ((self = [super init])) {
        self.offsetY = 0;
		world = w;
        //self.scale = 1.5;
        
		CGSize size = [[CCDirector sharedDirector] winSize];
		screenW = size.width;
		screenH = size.height;
	}
	return self;
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
//	world->DrawDebugData();
	
	kmGLPopMatrix();
}

- (void) setOffsetY:(float)offsetY {
    _offsetY = offsetY;
    //self.position = ccp(0, screenW/3-_offsetY*self.scale);
    self.position = ccp(0, screenW / 3 - _offsetY);
}

@end
