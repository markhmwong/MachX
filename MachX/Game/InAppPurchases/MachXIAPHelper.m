//
//  MachXIAPHelper.m
//  MachX
//
//  Created by Mark Wong on 23/02/13.
//  Copyright (c) 2013 Whizbang. All rights reserved.
//

#import "MachXIAPHelper.h"

@implementation MachXIAPHelper

+ (MachXIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static MachXIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.whizbang.MachX.Credit2000", //Credit1000 already in use :(.
                                      @"com.whizbang.MachX.Credit5000",
                                      @"com.whizbang.MachX.Credit20000",
                                      @"com.whizbang.MachX.Credit50000",
                                      @"com.whizbang.MachX.Credit100000",
                                      @"com.whizbang.MachX.Credit200000",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
