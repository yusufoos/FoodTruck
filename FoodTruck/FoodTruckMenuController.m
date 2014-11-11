//
//  FoodTruckMenuController.m
//  FoodTruck
//
//  Created by Yusuf Sobh on 11/2/14.
//  Copyright (c) 2014 Fuzzy. All rights reserved.
//

#import "FoodTruckMenuController.h"
#import "ItemTableViewCell.h"
#import "CheckoutViewController.h"
@interface FoodTruckMenuController ()

@property (strong, nonatomic) NSMutableArray *menu;

@end

@implementation FoodTruckMenuController

- (id)initWithMenu:(NSMutableArray *)menu {
    self = [super init];
    if(self) {
        _menu = [[NSMutableArray alloc] init];
        for (NSDictionary *item in menu) {
            NSMutableDictionary *itemDict = [[NSMutableDictionary alloc] initWithDictionary:item];
            [itemDict setValue:[NSNumber numberWithInt:0] forKey:@"Quantity"];
            [_menu addObject:itemDict];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *checkoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Checkout" style:UIBarButtonItemStylePlain target:self action:@selector(checkout)];
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = checkoutButton;
    checkoutButton.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)orderedItems {
    NSMutableArray *orderedItems = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *orderedItem in self.menu) {
        if([[orderedItem objectForKey:@"Quantity"] integerValue] > 0) {
            [orderedItems addObject:orderedItem];
        }
    }
    return orderedItems;
}

- (void)checkout {
    NSArray *orderedItems = [self orderedItems];
    CheckoutViewController *checkoutController = [[CheckoutViewController alloc] initWithItems:orderedItems];
    [self.navigationController pushViewController:checkoutController animated:YES];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.menu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"ItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"itemCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
    }
    
    cell.item = self.menu[indexPath.row];
    
    // Configure the cell...
    cell.itemTitleLabel.text = [self.menu[indexPath.row] objectForKey:@"Name"];
    cell.descriptionLabel.text = [self.menu[indexPath.row] objectForKey:@"Description"];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@", [self.menu[indexPath.row] objectForKey:@"Price"]];
    cell.quantityLabel.text = [NSString stringWithFormat:@"x%@", [self.menu[indexPath.row] valueForKey:@"Quantity"]];
    
    return cell;
}

@end