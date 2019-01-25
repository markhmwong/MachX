//
//  GameHelper.m
//  MachX
//
//  Created by Mark Wong on 21/02/13.
//  Copyright 2013 Whizbang. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager {
    
}
//static GameManager* _sharedGameManager = nil;

@synthesize isLevelingUp;
@synthesize isMusicOff;
@synthesize isSoundEffectsOff;

@synthesize hasPlayerDied;

@synthesize coinsCollected;
@synthesize monstersKilled;
@synthesize distanceTraveled;

@synthesize highCoinsCollected;
@synthesize highDistanceTraveled;
@synthesize highMonstersKilled;
@synthesize highScore;

@synthesize currentHealth;
@synthesize startHealth;
@synthesize attackPower;
@synthesize attackSpeed;
@synthesize flightDuration;
@synthesize flightMaxSpeed;

@synthesize totalCoins;
@synthesize totalMonstersKilled;
@synthesize totalDistanceTraveled;

@synthesize currentLevel;
@synthesize score;

@synthesize xpCollected;
@synthesize totalXPCollected;

//Time
@synthesize totalTimePlayed;
@synthesize timePlayedThisGame;
@synthesize timeInReverse;
@synthesize iCloudTimestamp;

//CREDITS
@synthesize totalCreditsCollected;
@synthesize totalCredits;
@synthesize creditsCollectedThisGame;

//Score
@synthesize roundDistance;
@synthesize totalDistance;
@synthesize hiScore;

//Other Stats
@synthesize obstaclesPassed;
@synthesize totalObstaclesPassed;
@synthesize powerupsCollected;
@synthesize totalPowerupsCollected;
@synthesize playCount;
@synthesize firstTimePlayed;

//Items
@synthesize spaceBridge1Stock;
@synthesize spaceBridge2Stock;
@synthesize spaceBridge3Stock;
@synthesize magnetStock;
@synthesize extraLifeStock;
@synthesize doubleCreditsStock;

//Item slots
@synthesize slot1;
@synthesize slot2;

+(GameManager*)sharedGameManager {
    static dispatch_once_t pred;
    static GameManager* gameManager = nil;
    dispatch_once(&pred, ^{gameManager = [[GameManager alloc] init]; });
    return gameManager;
}

-(id)init {
    self = [super init];
    if (self!=nil) {
        //Game manager initialized
        CCLOG(@"Game Manager Singleton, init");
        
        hasPlayerDied = NO;
        
        [self loadGameData];
        [self initializePlayerStats];
    }
    return self;
}



-(void)saveGameData {
    // get allowed save paths
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //string for the default path
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // full path plus filename for saved game
    NSString *gameStatePath = [documentsDirectory stringByAppendingPathComponent:@"gameState.dat"];
    // storage for game state data
    NSMutableData *gameData = [NSMutableData data];
    //keyed archiver
    NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:gameData];
    
    //encode all variables you want to track
    [encoder encodeInt:xpCollected forKey:@"XPCollected"];
    CCLOG(@"Saving XPCollected: %d", xpCollected);
    totalXPCollected += xpCollected;
    [encoder encodeInt:totalXPCollected forKey:@"TotalXPCollected"];
    CCLOG(@"Saving totalXPCollected: %d", totalXPCollected);
    
    [encoder encodeBool:isMusicOff forKey:@"BGMTurnedOff"];
    CCLOG(@"Saving isMusicOff: %d", isMusicOff);
    [encoder encodeBool:isSoundEffectsOff forKey:@"SFXTurnedOff"];
    CCLOG(@"Saving isSoundsEffectsOff: %d", isSoundEffectsOff);
    
    [encoder encodeInt:highCoinsCollected forKey:@"HighCoinsCollected"];
    CCLOG(@"Saving highCoinsCollected: %d", highCoinsCollected);
    [encoder encodeInt:highMonstersKilled forKey:@"HighMonstersKilled"];
    [encoder encodeFloat:highDistanceTraveled forKey:@"HighDistanceTraveled"];
    [encoder encodeInt:highScore forKey:@"HighScore"];
    
    [encoder encodeInt:coinsCollected forKey:@"CoinsCollectedThisGame"];
    CCLOG(@"Saving CoinsCollectedThisGame: %i", coinsCollected);
    totalCoins += coinsCollected;
    [encoder encodeInt:totalCoins forKey:@"TotalCoinsCollected"];
    CCLOG(@"Saving TotalCoinsCollected: %i", totalCoins);
    
    [encoder encodeInt:monstersKilled forKey:@"MonstersKilledThisGame"];
    CCLOG(@"Saving MonstersKilledThisGame: %i", monstersKilled);
    totalMonstersKilled += monstersKilled;
    [encoder encodeInt:totalMonstersKilled forKey:@"TotalMonstersKilled"];
    CCLOG(@"Saving TotalMonstersKilled: %i", totalMonstersKilled);
    
    [encoder encodeInt:distanceTraveled forKey:@"DistanceTraveledThisGame"];
    CCLOG(@"Saving DistanceTraveledThisGame: %f", distanceTraveled);
    totalDistanceTraveled += distanceTraveled;
    [encoder encodeInt:totalDistanceTraveled forKey:@"TotalDistanceTraveled"];
    CCLOG(@"Saving TotalDistanceTraveled: %f", totalDistanceTraveled);
    
    [encoder encodeInt:startHealth forKey:@"PlayerStartHealth"];
    CCLOG(@"Saving PlayerStartHealth: %i", startHealth);
    [encoder encodeFloat:attackPower forKey:@"PlayerAttackPower"];
    CCLOG(@"Saving PlayerAttackPower: %f", attackPower);
    [encoder encodeFloat:attackSpeed forKey:@"PlayerAttackSpeed"];
    CCLOG(@"Saving PlayerAttackSpeed: %f", attackSpeed);
    [encoder encodeFloat:flightDuration forKey:@"PlayerFlightDuration"];
    CCLOG(@"Saving PlayerFlightDuration: %f", flightDuration);
    [encoder encodeFloat:flightMaxSpeed forKey:@"PlayerFlightMaxSpeed"];
    CCLOG(@"Saving PlayerMaxFlightSpeed: %f", flightMaxSpeed);
    
    //Time
    [encoder encodeInt:totalTimePlayed forKey:@"TotalTimePlayer"];
    [encoder encodeInt:timePlayedThisGame forKey:@"TimePlayedThisGame"];
    [encoder encodeInt:timeInReverse forKey:@"TimeInReverse"];
    [encoder encodeObject:iCloudTimestamp forKey:@"IcloudTimestamp"];
    
    //CREDITS
    [encoder encodeInt:totalCreditsCollected forKey:@"TotalCreditsCollected"];
    [encoder encodeInt:totalCredits forKey:@"TotalCredits"];
    [encoder encodeInt:creditsCollectedThisGame forKey:@"CreditsCollectedThisGame"];
    
    //Score
    [encoder encodeInt:totalDistance forKey:@"TotalDistance"];
    [encoder encodeInt:roundDistance forKey:@"RoundDistance"];
    [encoder encodeInt:hiScore forKey:@"HiScore"];

    //Other Stats
    [encoder encodeInt:obstaclesPassed forKey:@"ObstaclesPassed"];
    [encoder encodeInt:totalObstaclesPassed forKey:@"TotalObstaclesPassed"];
    [encoder encodeInt:powerupsCollected forKey:@"PowerupsCollected"];
    [encoder encodeInt:totalPowerupsCollected forKey:@"TotalPowerupsCollected"];
    [encoder encodeInt:playCount forKey:@"PlayCount"];
    [encoder encodeBool:firstTimePlayed forKey:@"FirstTimePlayed"];
    
    //Items
    [encoder encodeInt:spaceBridge1Stock forKey:@"SpaceBridge1Stock"];
    [encoder encodeInt:spaceBridge2Stock forKey:@"SpaceBridge2Stock"];
    [encoder encodeInt:spaceBridge3Stock forKey:@"SpaceBridge3Stock"];
    [encoder encodeInt:extraLifeStock forKey:@"ExtraLifeStock"];
    [encoder encodeInt:magnetStock forKey:@"MagnetStock"];
    [encoder encodeInt:doubleCreditsStock forKey:@"DoubleCreditsStock"];

    //Item Slots
    [encoder encodeInt:slot1 forKey:@"Slot1"];
    [encoder encodeInt:slot2 forKey:@"Slot2"];
    
    //finish, write the encoder
    [encoder finishEncoding];
    [gameData writeToFile:gameStatePath atomically:YES];
}

- (void) setFirstTimePlayed {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //string for the default path
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // full path plus filename for saved game
    NSString *gameStatePath = [documentsDirectory stringByAppendingPathComponent:@"gameState.dat"];
    // storage for game state data
    NSMutableData *gameData = [NSMutableData data];
    //keyed archiver
    NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:gameData];
    
    [encoder encodeBool:TRUE forKey:@"FirstTimePlayed"];
    [encoder finishEncoding];
    [gameData writeToFile:gameStatePath atomically:YES];
}

//- (void) saveItemData {
//    // get allowed save paths
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    //string for the default path
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    // full path plus filename for saved game
//    NSString *gameStatePath = [documentsDirectory stringByAppendingPathComponent:@"gameState.dat"];
//    // storage for game state data
//    NSMutableData *gameData = [NSMutableData data];
//    //keyed archiver
//    NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:gameData];
//    
//    [encoder encodeInt:spaceBridge1Stock forKey:@"SpaceBridge1Stock"];
//    [encoder encodeInt:spaceBridge2Stock forKey:@"SpaceBridge2Stock"];
//    [encoder encodeInt:spaceBridge3Stock forKey:@"SpaceBridge3Stock"];
//    [encoder encodeInt:extraLifeStock forKey:@"ExtralifeStock"];
//    [encoder encodeInt:magnetStock forKey:@"MagnetStock"];
//    [encoder encodeInt:doubleCreditsStock forKey:@"DoubleCreditsStock"];
//    
//    [encoder finishEncoding];
//    [gameData writeToFile:gameStatePath atomically:YES];
//}
//
//- (void) saveInventoryData {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    //string for the default path
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    // full path plus filename for saved game
//    NSString *gameStatePath = [documentsDirectory stringByAppendingPathComponent:@"gameState.dat"];
//    // storage for game state data
//    NSMutableData *gameData = [NSMutableData data];
//    //keyed archiver
//    NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:gameData];
//    
//    [encoder encodeInt:slot1 forKey:@"Slot1"];
//    [encoder encodeInt:slot2 forKey:@"Slot2"];
//    [encoder finishEncoding];
//    [gameData writeToFile:gameStatePath atomically:YES];
//}

-(void)loadGameData {
    // get allowed save paths
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //string for the default path
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // full path plus filename for saved game
    NSString *gameStatePath = [documentsDirectory stringByAppendingPathComponent:@"gameState.dat"];
    // storage for game state data
    NSMutableData *gameData = [NSMutableData dataWithContentsOfFile:gameStatePath];
    // start the decoder
    NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:gameData];
    
    xpCollected = [decoder decodeIntForKey:@"XPCollected"];
    CCLOG(@"Loading xpCollected: %d", xpCollected);
    totalXPCollected = [decoder decodeIntForKey:@"TotalXPCollected"];
    CCLOG(@"Loading totalXPCollected: %d", totalXPCollected);
    
    highCoinsCollected = [decoder decodeIntForKey:@"HighCoinsCollected"];
    CCLOG(@"Loading highCoinsCollected: %d", highCoinsCollected);
    highMonstersKilled = [decoder decodeIntForKey:@"HighMonstersKilled"];
    highDistanceTraveled = [decoder decodeFloatForKey:@"HighDistanceTraveled"];
    highScore = [decoder decodeIntForKey:@"HighScore"];
    
    isSoundEffectsOff = [decoder decodeBoolForKey:@"SFXTurnedOff"];
    CCLOG(@"Retrieved isSoundEffectsOff: %d", isSoundEffectsOff);
    isMusicOff = [decoder decodeBoolForKey:@"BGMTurnedOff"];
    CCLOG(@"Retrieved isMusicOff: %d", isMusicOff);
    
    coinsCollected = [decoder decodeIntForKey:@"CoinsCollectedThisGame"];
    CCLOG(@"Retrieved CoinsCollectedThisGame: %i", coinsCollected);
    totalCoins = [decoder decodeIntForKey:@"TotalCoinsCollected"];
    CCLOG(@"Retrieved TotalCoinsCollected: %i", totalCoins);
    
    monstersKilled = [decoder decodeIntForKey:@"MonstersKilledThisGame"];
    CCLOG(@"Retrieved MonstersKilledThisGame: %i", monstersKilled);
    totalMonstersKilled = [decoder decodeIntForKey:@"TotalMonstersKilled"];
    CCLOG(@"Retrieved TotalMonstersKilled: %i", totalMonstersKilled);
    
    distanceTraveled = [decoder decodeIntForKey:@"DistanceTraveledThisGame"];
    CCLOG(@"Retrieved DistanceTraveledThisGame: %f",distanceTraveled);
    totalDistanceTraveled = [decoder decodeIntForKey:@"TotalDistanceTraveled"];
    CCLOG(@"Retrieved TotalDistanceTravled: %f", totalDistanceTraveled);
    
    startHealth = [decoder decodeIntForKey:@"PlayerStartHealth"];
    CCLOG(@"Retrieved PlayerStartHealth: %i", startHealth);
    attackPower = [decoder decodeFloatForKey:@"PlayerAttackPower"];
    CCLOG(@"Retrieved PlayerAttackPower %f", attackPower);
    attackSpeed = [decoder decodeFloatForKey:@"PlayerAttackSpeed"];
    CCLOG(@"Retrieved PlayerAttackSpeed: %f", attackSpeed);
    flightDuration = [decoder decodeFloatForKey:@"PlayerFlightDuration"];
    CCLOG(@"Retrieved PlayerFlightDuration: %f", flightDuration);
    flightMaxSpeed = [decoder decodeFloatForKey:@"PlayerFlightMaxSpeed"];
    CCLOG(@"Retrieved PlayerFlightMaxFlightSpeed: %f", flightMaxSpeed);
    
    //Time
    totalTimePlayed = [decoder decodeIntegerForKey:@"TotalTimePlayed"];
    timePlayedThisGame = [decoder decodeIntegerForKey:@"TimePlayedThisGame"];
    timeInReverse = [decoder decodeIntegerForKey:@"TimeInReverse"];
    iCloudTimestamp = [decoder decodeObjectForKey:@"IcloudTimestamp"];
    
    //CREDITS
    totalCredits = [decoder decodeIntegerForKey:@"TotalCredits"];
    totalCreditsCollected = [decoder decodeIntegerForKey:@"TotalCreditsCollected"];
    creditsCollectedThisGame = [decoder decodeIntegerForKey:@"CreditsCollectedThisGame"];
    //only sync when the player wants to don't do it when the game ends.
    
    //Score
    hiScore = [decoder decodeIntegerForKey:@"HiScore"];
    roundDistance = [decoder decodeIntegerForKey:@"RoundDistance"];
    totalDistance = [decoder decodeIntegerForKey:@"TotalDistance"];
    
    //Other stats
    obstaclesPassed = [decoder decodeIntegerForKey:@"ObstaclesPassed"];
    totalObstaclesPassed = [decoder decodeIntegerForKey:@"TotalObstaclesPassed"];
    powerupsCollected = [decoder decodeIntegerForKey:@"PowerupsCollected"];
    totalPowerupsCollected = [decoder decodeIntegerForKey:@"TotalPowerupsCollected"];
    playCount = [decoder decodeIntegerForKey:@"PlayCount"];
    firstTimePlayed = [decoder decodeBoolForKey:@"FirstTimePlayed"];
    
    //Items
    spaceBridge1Stock = [decoder decodeIntegerForKey:@"SpaceBridge1Stock"];
    spaceBridge2Stock = [decoder decodeIntegerForKey:@"SpaceBridge2Stock"];
    spaceBridge3Stock = [decoder decodeIntegerForKey:@"SpaceBridge3Stock"];
    extraLifeStock = [decoder decodeIntegerForKey:@"ExtraLifeStock"];
    magnetStock = [decoder decodeIntegerForKey:@"MagnetStock"];
    doubleCreditsStock = [decoder decodeIntegerForKey:@"DoubleCreditsStock"];    
    
    //Item Slots
    slot1 = [decoder decodeIntegerForKey:@"Slot1"];
    slot2 = [decoder decodeIntegerForKey:@"Slot2"];

    //testInteger = [decoder decodeIntForKey:@"TestInteger"];
    //CCLOG(@"Retrieved TestInteger %i", testInteger);
}

-(void)initializePlayerStats {
    [self saveGameData];
}

//-(void)resetAllData {
//    CCLOG(@"RESETTING ALL DATA!!");
//    coinsCollected = 0;
//    totalCoins = 0;
//    monstersKilled = 0;
//    totalMonstersKilled = 0;
//    startHealth = 0;
//    attackPower = 0;
//    attackSpeed = 0;
//    flightDuration = 0;
//    distanceTraveled = 0;
//    totalDistanceTraveled = 0;
//    xpCollected = 0;
//    totalXPCollected = 0;
//    highScore = 0;
//    highDistanceTraveled = 0;
//    highCoinsCollected = 0;
//    highMonstersKilled = 0;
//    
//    //Time
//    totalTimePlayed = 0;
//    timePlayedThisGame = 0;
//    timeInReverse = 0;
//    
//    //CREDITS
//    totalCredits = 0;
//    totalCreditsCollected = 0;
//    creditsCollectedThisGame = 0;
//    
//    //Score
//    totalDistance = 0;
//    roundDistance = 0;
//    hiScore = 0;
//
//    //Other Stats
//    obstaclesPassed = 0;
//    totalObstaclesPassed = 0;
//    powerupsCollected = 0;
//    totalPowerupsCollected = 0;
//    playCount = 0;
//    firstTimePlayed = FALSE;
//    
//    //slot
//    slot1 = -1;
//    slot2 = -1;
//    
//    //SOUND/MUSIC
//    isSoundEffectsOff = 0;
//    isMusicOff = 0;
//    
//    [self saveGameData];
//    [self initializePlayerStats];
//}

@end
