//
//  MerchantViewController.m
//  FoodTruck
//
//  Created by Yusuf Sobh on 4/2/15.
//  Copyright (c) 2015 Fuzzy. All rights reserved.
//

#import "MerchantViewController.h"
#import "FoodTruckCreationViewController.h"
#import "NSMutableDictionary+KAKeyRenaming.h"
#import "AFNetworking.h"
#import "AppCache.h"
#import "OrderItemTableViewCell.h"

@interface MerchantViewController ()
@property (weak, nonatomic) IBOutlet UIButton *deleteFoodTruckBtn;
@property (weak, nonatomic) IBOutlet UIButton *CreateUpdateFoodTruckBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *orders;
@property (strong, nonatomic) NSMutableArray *finishedCellRows;

@end

@implementation MerchantViewController

- (instancetype)init {
    self = [super init];
    if(self) {
        //[self loadOrders];
        _orders = [NSArray arrayWithObject:@{@"customerUserEmail":@"afsas"}];
        _finishedCellRows = [NSMutableArray array];
    }
    return self;
}

- (void)loadOrders {
    NSDictionary *foodTruckInfo = [AppCache sharedCache].foodTruckDict;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"https://afternoon-inlet-3482.herokuapp.com/food_trucks/%@/orders.json",foodTruckInfo[@"id"]];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        _orders = [NSArray arrayWithArray:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.multipleTouchEnabled = NO;
    [self.tableView reloadData];
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)didPressDelete:(id)sender {
    NSMutableDictionary *userInfo = [AppCache sharedCache].userDict;
    NSDictionary *foodTruckInfo = [AppCache sharedCache].foodTruckDict;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"https://afternoon-inlet-3482.herokuapp.com/food_trucks/%@.json",foodTruckInfo[@"id"]];

    [manager DELETE:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [AppCache sharedCache].foodTruckDict = nil;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (IBAction)didPressCreate:(id)sender {
    
    FoodTruckCreationViewController *truckCreationController = [[FoodTruckCreationViewController alloc] init];
    [self presentViewController:truckCreationController animated:YES completion:nil];
}

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
//    
//    NSNumber *quantity = [self.orders[indexPath.row][@"items"][0] objectForKey:@"quantity"];
//    NSNumber *price = [self.orders[indexPath.row][@"items"][0] objectForKey:@"price"];
//
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.backgroundColor = [UIColor redColor];

    // Configure the cell...
    for (NSNumber *num in self.finishedCellRows) {
        if(num.intValue == indexPath.row) {
            cell.backgroundColor = [UIColor greenColor];
        }
    }

    NSString *name = self.orders[indexPath.row][@"customerUserEmail"];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@'s order",name];
//    cell.priceLabel.text = [NSString stringWithFormat:@"%@", @(quantity.integerValue * price.integerValue)];
//    cell.quantityLabel.text = [NSString stringWithFormat:@"x%@", [self.orders[indexPath.row][@"items"][0] valueForKey:@"quantity"]];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderItemTableViewCell *cell = (OrderItemTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Finish %@?",cell.titleLabel.text] message:nil delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        NSLog(@"FINISHED");
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        [self.finishedCellRows addObject:@(selectedIndexPath.row)];
        [self.tableView reloadData];
    }
}

@end
