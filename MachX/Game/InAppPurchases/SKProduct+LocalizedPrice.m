//
//  SKProduct+LocalizedPrice.m
//  MachX
//
//  Created by Mark Wong on 27/02/13.
//  Copyright 2013 Whizbang. All rights reserved.
//

#import "SKProduct+LocalizedPrice.h"

@implementation SKProduct (LocalizedPrice)
//I don't think this is being used.
- (NSString *)localizedPrice
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:self.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:self.price];
    //[numberFormatter release];
    return formattedString;
}

@end