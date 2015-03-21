//
//  OrderPersistanceManager.h
//  FoodTruck
//
//  Created by Yusuf Sobh on 11/14/14.
//  Copyright (c) 2014 Fuzzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderPersistanceManager : NSObject

+ (id)sharedManager;

- (NSMutableArray *)loadOrders;

- (void)appendOrder:(NSDictionary *)order;


@end
