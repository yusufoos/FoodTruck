//
//  FoodTruckMenuController.m
//  FoodTruck
//
//  Created by Yusuf Sobh on 11/2/14.
//  Copyright (c) 2014 Fuzzy. All rights reserved.
//

#import "FoodTruckMenuController.h"
#import "ItemTableViewCell.h"

@interface FoodTruckMenuController ()

@end

@implementation FoodTruckMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)orderedItems {
    return nil;
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
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end