//
//  NSMutableDictionary+KAKeyRenaming.h
//  FoodTruck
//
//  Created by Yusuf Sobh on 4/1/15.
//  Copyright (c) 2015 Fuzzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (KAKeyRenaming)
- (void)ka_replaceKey:(id)oldKey withKey:(id)newKey;
- (void)nestAllKeysWithString:(NSString *)nestedString;
@end
