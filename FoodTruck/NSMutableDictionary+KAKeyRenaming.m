//
//  NSMutableDictionary+KAKeyRenaming.m
//  FoodTruck
//
//  Created by Yusuf Sobh on 4/1/15.
//  Copyright (c) 2015 Fuzzy. All rights reserved.
//

#import "NSMutableDictionary+KAKeyRenaming.h"

@implementation NSMutableDictionary (KAKeyRenaming)
- (void)ka_replaceKey:(id)oldKey withKey:(id)newKey
{
    id value = [self objectForKey:oldKey];
    if (value) {
        [self setObject:value forKey:newKey];
        [self removeObjectForKey:oldKey];
    }
}

- (void)nestAllKeysWithString:(NSString *)nestedString
{
    for(NSString *key in self.allKeys) {
        NSString *newKey = [NSString stringWithFormat:@"%@[%@]",nestedString,key];
        [self ka_replaceKey:key withKey:newKey];
    }
}
@end

