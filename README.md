# Mach X (iOS)
## Release some time on the app store during 2011-2012

## Brief
Tested end of Dec 2018 on iOS 11 written in Obj-C. A working cocos2d game with box2d, this was my second game I made on the Cocos2D framework. I've made this repo to help anyone trying to breathe new life in their old cocos2d game pre-64bit. There's a lot of refactoring and I think cross referencing the cocos2d/box2d files will help you out a lot! I spent multiple days getting it to work, hopefully it'll cut out some much needed hours for you!

Good Luck!

## Running on iOS 27 (Xcode 27)
Updated October 2026 so the project builds against the iOS 27 SDK:

- **Scene life cycle.** Apps built with the iOS 27 SDK won't launch without a `UISceneDelegate`. The window and director now live in `SceneDelegate` (in `AppDelegate.mm`), declared in `Info.plist` under `UIApplicationSceneManifest`.
- **Full-screen on modern iPhones.** A `UILaunchScreen` entry stops iOS from running the game letterboxed. The game was laid out for a 320pt wide screen, so `MachXRootViewController` keeps a 320pt wide design size and scales the GL view up to fill the safe area.
- **Removed or broken APIs replaced:** Twitter/Social sharing → `UIActivityViewController`, `GKLeaderboardViewController` → `GKGameCenterViewController`, `GKScore` → `GKLeaderboard submitScore`, `openURL:` → `openURL:options:completionHandler:`, `keyWindow` lookups, and the C `AudioSession*` calls in CocosDenshion → `AVAudioSession`.
- **Project settings:** deployment target is now iOS 15.0 (the lowest Xcode 27 supports). The hard-coded provisioning profiles and signing identity are gone, so set your own Team under Signing & Capabilities.

The game still renders with OpenGL ES, which Apple has deprecated but still ships. Because the entitlements request iCloud key-value storage, you need a paid developer team to sign it, or you can remove that entitlement to run with a free account.

## Gameplay Video
https://youtu.be/Ey_bntaPvJA

## Screenshots
![Mach X Screenshot](https://github.com/markhmwong/MachX/blob/master/Media/SS1.jpg)
![Mach X Screenshot](https://github.com/markhmwong/MachX/blob/master/Media/SS2.jpg)
![Mach X Screenshot](https://github.com/markhmwong/MachX/blob/master/Media/SS3.jpg)
![Mach X Screenshot](https://github.com/markhmwong/MachX/blob/master/Media/SS4.jpg)