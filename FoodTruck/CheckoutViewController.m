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
            _total += ([item[@"Quantity"] integerValue] * [item[@"Price"] integerValue]);
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
    cell.itemNameLabel.text = [self.items[indexPath.row] objectForKey:@"Name"];
    cell.itemQuantityLabel.text = [NSString stringWithFormat:@"x%d",
                                   [[self.items[indexPath.row] objectForKey:@"Quantity"] integerValue]];
    return cell;
}

- (IBAction)didPayPressWithCash:(id)sender {
    
    NSMutableDictionary *order = [NSMutableDictionary dictionary];
    order[@"Total"] = @(self.total);
    order[@"Items"] = self.items;
    [[OrderPersistanceManager sharedManager] appendOrder:order];
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:^{
                                                            [self.presentingViewController
                                                             performSelector:@selector(showOrdersController)
                                                             withObject:nil];
                                                        }];
}


@end
