//
//  CCParallaxScrollOffset.m v1.2
//
//  Created by Aram Kocharyan on 1/12/11
//  http://ak.net84.net/
//

#import "CCParallaxScrollOffset.h"

@implementation CCParallaxScrollOffset
@synthesize scrollOffset, position, ratio, child, origPosition, currPosition, relVelocity, buffer;
-(id) init {
	if ( (self=[super init]) ) {
		relVelocity = scrollOffset = position = ratio = ccp(0,0);
	}
	return self;
}
+(id) scrollWithNode:(CCNode *)node Ratio:(CGPoint)r Pos:(CGPoint)p ScrollOffset:(CGPoint)s {
	return [[self alloc] initWithNode:node Ratio:(CGPoint)r Pos:(CGPoint)p ScrollOffset:(CGPoint)s];
}

+(id) scrollWithNode:(CCNode *)node Ratio:(CGPoint)r Pos:(CGPoint)p ScrollOffset:(CGPoint)s RelVelocity:(CGPoint)v {
	return [[self alloc] initWithNode:node Ratio:(CGPoint)r Pos:(CGPoint)p ScrollOffset:(CGPoint)s RelVelocity:v];
}

-(id) initWithNode:(CCNode *)node Ratio:(CGPoint)r Pos:(CGPoint)p ScrollOffset:(CGPoint)s RelVelocity:(CGPoint)v {
	if( (self=[super init])) {
		child = node;
		ratio = r;
        scrollOffset = s;
		relVelocity = v;
		child.position = p;
		origPosition = p;
		//currPosition = p;
		child.anchorPoint = ccp(0, 0);
	}
	return self;
}

-(id) initWithNode:(CCNode *)node Ratio:(CGPoint)r Pos:(CGPoint)p ScrollOffset:(CGPoint)s {
	return [self initWithNode:node Ratio:r Pos:p ScrollOffset:p RelVelocity:ccp(0,0)];
}

-(id) changeRatio:(CGPoint)ratio1 forNode:(CCNode*)Node {
    NSLog(@"Offset Node.tag %d", Node.tag);
    
    child = Node;
    NSLog(@"Offset ratio: %f %f", self.ratio.x, ratio.y);

    return self;
}

+(void) initChangeRatio:(CGPoint)ratio1 forNode:(CCNode*)Node {
    [[self alloc] changeRatio:ratio1 forNode:Node];
}

@end