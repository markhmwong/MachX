//
//  AppDelegate.mm
//  MachX
//
//  Created by Mark Wong on 14/12/12.
//  Copyright Whizbang 2012. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"

@implementation AppController

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// The window and director are created in SceneDelegate once the scene connects.
    [SDCloudUserDefaults registerForNotifications];

	return YES;
}

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options
{
	UISceneConfiguration *config = [UISceneConfiguration configurationWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
	config.delegateClass = [SceneDelegate class];
	return config;
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{

	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

@end

static const CGFloat kDesignWidth = 320.0f;

@implementation MachXRootViewController
{
	CCDirectorIOS *director_;
}

- (instancetype)initWithDirector:(CCDirectorIOS *)director
{
	if ((self = [super initWithNibName:nil bundle:nil])) {
		director_ = director;
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor blackColor];

	[self addChildViewController:director_];
	[self.view addSubview:director_.view];
	[director_ didMoveToParentViewController:self];
}

// Runs before the GL view lays itself out, so cocos2d only ever sees the design size.
- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];

	CGRect safe = UIEdgeInsetsInsetRect(self.view.bounds, self.view.safeAreaInsets);
	if (CGRectIsEmpty(safe))
		return;

	CGFloat scale = safe.size.width / kDesignWidth;
	CGRect designBounds = CGRectMake(0, 0, kDesignWidth, floor(safe.size.height / scale));

	UIView *glView = director_.view;
	if (!CGRectEqualToRect(glView.bounds, designBounds)) {
		glView.transform = CGAffineTransformIdentity;
		glView.bounds = designBounds;
	}
	glView.center = CGPointMake(CGRectGetMidX(safe), CGRectGetMidY(safe));
	glView.transform = CGAffineTransformMakeScale(scale, scale);
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

- (BOOL)prefersHomeIndicatorAutoHidden
{
	return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

@end

@implementation SceneDelegate

@synthesize window=window_, rootViewController=rootViewController_, director=director_;

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions
{
	if (![scene isKindOfClass:[UIWindowScene class]])
		return;

	// Create the main window
	window_ = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
	window_.backgroundColor = [UIColor blackColor];


	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];

	// Enable multiple touches
	[glView setMultipleTouchEnabled:YES];

	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];

	// Display FSP and SPF
	[director_ setDisplayStats:NO];

	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];

	// attach the openglView to the director
	[director_ setView:glView];

	// for rotation and other messages
	[director_ setDelegate:self];

	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
	//	[director setProjection:kCCDirectorProjection3D];

	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");

	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"

	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

	// Host the Director in a root view controller that scales it to the screen
	rootViewController_ = [[MachXRootViewController alloc] initWithDirector:director_];

	// set it as the root view controller
	[window_ setRootViewController:rootViewController_];

	// make main window visible
	[window_ makeKeyAndVisible];
}

// This is needed for iOS4 and iOS5 in order to ensure
// that the 1st scene has the correct dimensions
// This is not needed on iOS6 and could be added to the application:didFinish...
-(void) directorDidReshapeProjection:(CCDirector*)director
{
	if(director.runningScene == nil) {
		// Add the first scene to the stack. The director will draw it immediately into the framebuffer. (Animation is started automatically when the view is displayed.)
		// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
		[director runWithScene: [CompanyLayer scene]];
	}
}

// getting a call, pause the game
- (void)sceneWillResignActive:(UIScene *)scene
{
	if( director_.presentedViewController == nil )
		[director_ pause];
}

// call got rejected
- (void)sceneDidBecomeActive:(UIScene *)scene
{
	if( director_.presentedViewController == nil )
		[director_ resume];
}

- (void)sceneDidEnterBackground:(UIScene *)scene
{
	if( director_.presentedViewController == nil )
		[director_ stopAnimation];
}

- (void)sceneWillEnterForeground:(UIScene *)scene
{
	if( director_.presentedViewController == nil )
		[director_ startAnimation];
}

@end
