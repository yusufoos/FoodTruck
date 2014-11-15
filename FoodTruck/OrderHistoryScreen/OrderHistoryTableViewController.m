//
//  OrderHistoryTableViewController.m
//  FoodTruck
//
//  Created by Yusuf Sobh on 11/14/14.
//  Copyright (c) 2014 Fuzzy. All rights reserved.
//

#import "OrderHistoryTableViewController.h"
#import "OrderItemTableViewCell.h"
#import "OrderPersistanceManager.h"

@interface OrderHistoryTableViewController ()

@property (strong, nonatomic) NSMutableArray *orders;

@end

@implementation OrderHistoryTableViewController

- (id)init {
    self = [super init];
    if(self) {
        _orders = [[OrderPersistanceManager sharedManager] loadOrders];
        self.title = @"Orders";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"OrderCreated" object:nil];
        
        /*for (NSDictionary *item in orders) {
            NSMutableDictionary *itemDict = [[NSMutableDictionary alloc] initWithDictionary:item];
            [itemDict setValue:[NSNumber numberWithInt:0] forKey:@"Quantity"];
            [_orders addObject:itemDict];
        }*/
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData {
    [self.tableView reloadData];
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
    return self.orders.count;
}

- (OrderItemTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderItemCell"];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"OrderItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderItemCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"orderItemCell" forIndexPath:indexPath];
    }
    
    // Configure the cell...
    cell.titleLabel.text = [self.orders[indexPath.row][@"Items"][0] objectForKey:@"Name"];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@", [self.orders[indexPath.row][@"Items"][0] objectForKey:@"Price"]];
    cell.quantityLabel.text = [NSString stringWithFormat:@"x%@", [self.orders[indexPath.row][@"Items"][0] valueForKey:@"Quantity"]];
    
    return cell;
}

@end
