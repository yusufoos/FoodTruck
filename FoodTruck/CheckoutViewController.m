//
//  CheckoutViewController.m
//  FoodTruck
//
//  Created by Hilal Habashi on 11/10/14.
//  Copyright (c) 2014 Fuzzy. All rights reserved.
//

#import "CheckoutViewController.h"
#import "CheckoutItemCellView.h"

@interface CheckoutViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *items;

@end

@implementation CheckoutViewController

- (id)initWithItems:(NSArray *)items {
    self = [self init];
    if(self) {
        self.items = items;
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
    
    float total;
    for (NSDictionary* item in self.items) {
        total += ([item[@"Quantity"] integerValue] * [item[@"Price"] integerValue]);
    
    }
    self.totalPrice.text= [NSString stringWithFormat:@"Total: %f",total];
    
    
    // Do any additional setup after loading the view.
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
    cell.itemQuantityLabel.text = [self.items[indexPath.row] objectForKey:@"Quantity"];
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
