//
//  FoodTruckMenuController.m
//  FoodTruck
//
//  Created by Yusuf Sobh on 11/2/14.
//  Copyright (c) 2014 Fuzzy. All rights reserved.
//

#import "FoodTruckMenuController.h"
#import "ItemTableViewCell.h"
#import "OrdersViewController.h"

@interface FoodTruckMenuController ()

@property (strong, nonatomic) NSArray *menu;

@end

@implementation FoodTruckMenuController

- (id)initWithMenu:(NSArray *)menu {
    self = [super init];
    if(self) {
        self.menu = menu;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)orderedItems {
    NSMutableArray *orderedItems = [[NSMutableArray alloc] init];
    for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
        {
            ItemTableViewCell *cell = (ItemTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            if([[cell.item objectForKey:@"quantity"] integerValue] > 0) {
                [orderedItems addObject:cell.item];
            }
        }
    }
    return orderedItems;
}

- (IBAction)chooseItemsForCheckout:(id)sender {
    NSArray *orderedItems = [self orderedItems];
    //Init checkout controller with ordered items array
    #warning doesnt exist yet add array init method
    OrdersViewController *checkoutController = [[OrdersViewController alloc] init];
    // push it
    [self.navigationController pushViewController:checkoutController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.menu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.itemTitleLabel.text = [self.menu[indexPath.row] objectForKey:@"name"];
    cell.descriptionLabel.text = [self.menu[indexPath.row] objectForKey:@"decription"];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@", [self.menu[indexPath.row] objectForKey:@"price"]];
    cell.quantityLabel.text = @"x0";
    
    [cell.item addEntriesFromDictionary:self.menu[indexPath.row]];
    [cell.item setObject:[NSNumber numberWithInt:0] forKey:@"quantity"];
    
    return cell;
}

@end