//
//  AppCache.h
//  FoodTruck
//
//  Created by Yusuf Sobh on 4/1/15.
//  Copyright (c) 2015 Fuzzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppCache : NSObject

@property (nonatomic, copy) NSMutableDictionary *userDict;
@property (nonatomic, copy) NSMutableDictionary *foodTruckDict;
@property (nonatomic, copy) NSMutableDictionary *foodTrucksDict;

+ (AppCache *)sharedCache;

extern NSString *const kFoodTruck;


@end
