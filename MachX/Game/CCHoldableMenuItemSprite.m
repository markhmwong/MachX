/*
 *  CCHoldableMenuItemSprite.m
 *
 *  Created by Peter Easdown on 29/10/12.
 *  Copyright (c) 2012 PKCLsoft. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "CCHoldableMenuItemSprite.h"

@implementation CCHoldableMenuItemSprite

+(id) itemWithNormalSprite:(CCNode<CCRGBAProtocol>*)normalSprite holdBlock:(void(^)(id sender))holdBlock releaseBlock:(void(^)(id sender))releaseBlock {
    return [self itemWithNormalSprite:normalSprite selectedSprite:nil holdBlock:holdBlock releaseBlock:releaseBlock];
}

+(id) itemWithNormalSprite:(CCNode<CCRGBAProtocol>*)normalSprite selectedSprite:(CCNode<CCRGBAProtocol>*)selectedSprite holdBlock:(void(^)(id sender))holdBlock releaseBlock:(void(^)(id sender))releaseBlock
{
	return [self itemWithNormalSprite:normalSprite selectedSprite:selectedSprite disabledSprite:nil holdBlock:holdBlock releaseBlock:releaseBlock];
}

+(id) itemWithNormalSprite:(CCNode<CCRGBAProtocol>*)normalSprite selectedSprite:(CCNode<CCRGBAProtocol>*)selectedSprite disabledSprite:(CCNode<CCRGBAProtocol>*)disabledSprite holdBlock:(void(^)(id sender))holdBlock releaseBlock:(void(^)(id sender))releaseBlock
{
	return [[self alloc] initWithNormalSprite:normalSprite selectedSprite:selectedSprite disabledSprite:disabledSprite holdBlock:holdBlock releaseBlock:releaseBlock];
}

-(id) initWithNormalSprite:(CCNode<CCRGBAProtocol>*)normalSprite selectedSprite:(CCNode<CCRGBAProtocol>*)selectedSprite disabledSprite:(CCNode<CCRGBAProtocol>*)disabledSprite holdBlock:(void(^)(id sender))holdBlock releaseBlock:(void(^)(id sender))releaseBlock
{
	if ( (self = [super initWithBlock:holdBlock] ) ) {

        if ( releaseBlock ) {
			releaseBlock_ = [releaseBlock copy];
        }
        
		self.normalImage = normalSprite;
		self.selectedImage = selectedSprite;
		self.disabledImage = disabledSprite;
        
        [self setContentSize: [_normalImage contentSize]];
	}
	return self;
}


-(void) cleanup
{
	//[releaseBlock_ release];
	releaseBlock_ = nil;
    
	[super cleanup];
}

// Tell the app that the user has tapped/held the button.
-(void) selected
{
    [super selected];
        
    if(_isEnabled&& _block )
		_block(self);
    
}

// Tell the app that the user has released the button.
-(void) unselected
{
    BOOL wasSelected = _isSelected;
    
    [super unselected];
    
    if((_isEnabled && releaseBlock_) || (wasSelected && releaseBlock_))
		releaseBlock_(self);
}

// We don't want to call the block on activate for this menu item subclass.
-(void) activate
{
}


@end
