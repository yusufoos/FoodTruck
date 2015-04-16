//
//  OrderPersistanceManager.m
//  FoodTruck
//
//  Created by Yusuf Sobh on 11/14/14.
//  Copyright (c) 2014 Fuzzy. All rights reserved.
//

#import "OrderPersistanceManager.h"
#import "NSMutableDictionary+KAKeyRenaming.h"
#import "AFNetworking.h"

@interface OrderPersistanceManager ()

@property (nonatomic, strong) NSMutableArray *orders;

@end

@implementation OrderPersistanceManager

+ (id)sharedManager {
    static OrderPersistanceManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.orders = [NSMutableArray array];
        [self loadOrders];
    }
    return self;
}

- (void)appendOrder:(NSDictionary *)order{
    [self.orders addObject:order];
    [self saveOrders];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderCreated"
                                                        object:self.orders
                                                      userInfo:nil];
    
}

- (void)saveOrders {
    [self.orders writeToFile:[self ordersPlistFilePath] atomically:YES];
}

- (NSMutableArray *)loadOrders {
    // Load the file content and read the data into arrays
    NSMutableArray *ordersFromPlist = [[NSMutableArray alloc] initWithContentsOfFile:[self ordersPlistFilePath]];
    
    
    if(ordersFromPlist) {
        self.orders = ordersFromPlist;
    }

    return self.orders;
}

- (NSString *)ordersPlistFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileDirectory = [documentsDirectory stringByAppendingPathComponent:@"orders.plist"];
    return fileDirectory;
}

@end
