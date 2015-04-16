//
//  CheckoutViewController.m
//  FoodTruck
//
//  Created by Hilal Habashi on 11/10/14.
//  Copyright (c) 2014 Fuzzy. All rights reserved.
//

#import "CheckoutViewController.h"
#import "CheckoutItemCellView.h"
#import "OrderPersistanceManager.h"
#import "AFNetworking.h"
#import "NSMutableDictionary+KAKeyRenaming.h"
#import "AppCache.h"

@interface CheckoutViewController () <UITableViewDataSource, UITableViewDelegate>

- (IBAction)didPayPressWithCash:(id)sender;

@property (strong, nonatomic) NSArray *items;

@property (nonatomic, assign) float total;

@end

@implementation CheckoutViewController

- (id)initWithItems:(NSArray *)items {
    self = [self init];
    if(self) {
        _items = items;
        _total = 0;
        for (NSDictionary* item in _items) {
            _total += ([item[@"quantity"] integerValue] * [item[@"price"] integerValue]);
        }
    }
    return self;
}

- (id)init
{
    self = [super initWithNibName:@"CheckoutViewController" bundle:nil];
    if (self != nil)
    {
        // Further initialization if needed
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ItemsTableView.delegate = self;
    self.ItemsTableView.dataSource = self;
    [self.ItemsTableView reloadData];
    self.totalPrice.text= [NSString stringWithFormat:@"Total: %f",self.total];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckoutItemCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"CheckoutItemCellView" bundle:nil] forCellReuseIdentifier:@"itemCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
    }
    cell.itemNameLabel.text = [self.items[indexPath.row] objectForKey:@"name"];
    cell.itemQuantityLabel.text = [NSString stringWithFormat:@"x%d",
                                   [[self.items[indexPath.row] objectForKey:@"quantity"] integerValue]];
    return cell;
}

- (void)createItemsForOrder:(NSMutableDictionary *)order
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableArray *orderItems = [NSMutableArray array];

    for (int i = 0; i < self.items.count; i++) {
        NSMutableDictionary *item = self.items[i];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:order[@"id"] forKey:@"order_id"];
        [params setValue:item[@"quantity"] forKey:@"quantity"];
        [params setValue:item[@"name"] forKey:@"name"];
        [params setValue:item[@"price"] forKey:@"price"];
        [params nestAllKeysWithString:@"order_item"];
        
        [manager POST:@"https://afternoon-inlet-3482.herokuapp.com/order_items.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSMutableDictionary *order_item = [responseObject mutableCopy];
            [orderItems addObject:order_item];
            
            if(i == self.items.count-1) {
                [order setValue:orderItems forKey:@"items"];
                [[OrderPersistanceManager sharedManager] appendOrder:order];
                [[self presentingViewController] dismissViewControllerAnimated:YES
                                                                    completion:^{
                                                                        [self.presentingViewController
                                                                         performSelector:@selector(showOrdersController)
                                                                         withObject:nil];
                                                                    }];

            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}

- (IBAction)didPayPressWithCash:(id)sender {
    
    //order[@"Total"] = @(self.total);
    //order[@"Items"] = self.items;
    
    
    
    NSMutableDictionary *userInfo = [AppCache sharedCache].userDict;
    NSMutableDictionary *foodTruckInfo = [AppCache sharedCache].foodTruckDict;

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:userInfo[@"email"] forKey:@"customerUserEmail"];
    [params setValue:userInfo[@"id"] forKey:@"user_id"];
    [params nestAllKeysWithString:@"order"];

    [manager POST:@"https://afternoon-inlet-3482.herokuapp.com/orders.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSMutableDictionary *order = [responseObject mutableCopy];
        [self createItemsForOrder:order];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    
    
    
}


@end
