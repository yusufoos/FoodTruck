//
//  CheckoutViewController.h
//  FoodTruck
//
//  Created by Hilal Habashi on 11/10/14.
//  Copyright (c) 2014 Fuzzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckoutViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *ItemsTableView;

- (id)initWithItems:(NSArray *)items;

@end
