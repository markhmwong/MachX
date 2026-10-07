//
//  AppDelegate.h
//  MachX
//
//  Created by Mark Wong on 14/12/12.
//  Copyright Whizbang 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "CompanyLayer.h"

// Process-level events only. Since iOS 13 the window and UI life cycle live in
// SceneDelegate, and apps built with the iOS 27 SDK won't launch without it.
@interface AppController : NSObject <UIApplicationDelegate>
@end

// Hosts the director's GL view. The game was laid out for a 320pt wide screen,
// so the view keeps a 320pt wide design size and is scaled up to fit the
// safe area of whatever device it runs on.
@interface MachXRootViewController : UIViewController
- (instancetype)initWithDirector:(CCDirectorIOS *)director;
@end

// Owns the window, the root view controller and the cocos2d director.
// Referenced by name from UIApplicationSceneManifest in Info.plist.
@interface SceneDelegate : UIResponder <UIWindowSceneDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	MachXRootViewController *rootViewController_;

	CCDirectorIOS	*__weak director_;							// weak ref
}

@property (nonatomic, strong) UIWindow *window;
@property (readonly) MachXRootViewController *rootViewController;
@property (weak, readonly) CCDirectorIOS *director;

@end
