//
//  GameHelper.h
//  MachX
//
//  Created by Mark Wong on 21/02/13.
//  Copyright 2013 Whizbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameManager : NSObject {

}

@property (readwrite) BOOL isLevelingUp;

@property (readwrite) BOOL isMusicOff;
@property (readwrite) BOOL isSoundEffectsOff;
@property (readwrite) BOOL hasPlayerDied;
@property (readwrite) int currentLevel;

@property (readwrite) int coinsCollected;
@property (readwrite) int monstersKilled;
@property (readwrite) int distanceTraveled;

@property (readwrite) int highCoinsCollected;
@property (readwrite) int highMonstersKilled;
@property (readwrite) int highDistanceTraveled;

@property (readwrite) int score;
@property (readwrite) int highScore;

@property (readwrite) int currentHealth;
@property (readwrite) int startHealth;
@property (readwrite) float attackPower;
@property (readwrite) float attackSpeed;
@property (readwrite) float flightDuration;
@property (readwrite) float flightMaxSpeed;

@property (readwrite) int totalCoins;
@property (readwrite) int totalMonstersKilled;
@property (readwrite) int totalDistanceTraveled;

@property (readwrite) int xpCollected;
@property (readwrite) int totalXPCollected;

//Time
@property (readwrite) int totalTimePlayed;
@property (readwrite) int timePlayedThisGame;
@property (readwrite) int timeInReverse;
@property (readwrite) NSDate *iCloudTimestamp;

//CREDITS
@property (readwrite) int totalCreditsCollected;
@property (readwrite) int totalCredits;
@property (readwrite) int creditsCollectedThisGame;

//Score
@property (readwrite) int roundDistance;
@property (readwrite) int totalDistance;
@property (readwrite) int hiScore;

//Other Stats
@property (readwrite) int obstaclesPassed;
@property (readwrite) int totalObstaclesPassed;
@property (readwrite) int powerupsCollected;
@property (readwrite) int totalPowerupsCollected;
@property (readwrite) int playCount;
@property (readwrite) BOOL firstTimePlayed;

//Items
@property (readwrite) int spaceBridge1Stock;
@property (readwrite) int spaceBridge2Stock;
@property (readwrite) int spaceBridge3Stock;
@property (readwrite) int extraLifeStock;
@property (readwrite) int doubleCreditsStock;
@property (readwrite) int magnetStock;

//Slot item
@property (readwrite) int slot1;
@property (readwrite) int slot2;

+(GameManager*)sharedGameManager;
-(void)saveGameData;
//- (void) saveItemData;
//- (void) saveInventoryData;
-(void)loadGameData;
//-(void)resetAllData;
-(void)initializePlayerStats;
- (void) setFirstTimePlayed;
@end