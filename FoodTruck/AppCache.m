//
//  AppCache.m
//  FoodTruck
//
//  Created by Yusuf Sobh on 4/1/15.
//  Copyright (c) 2015 Fuzzy. All rights reserved.
//

#import "AppCache.h"

@implementation AppCache

NSString *const kFoodTruck = @"food_truck";

+ (AppCache *)sharedCache
{
    static AppCache *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

@end
