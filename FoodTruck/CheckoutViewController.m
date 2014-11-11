//
//  CheckoutViewController.m
//  FoodTruck
//
//  Created by Hilal Habashi on 11/10/14.
//  Copyright (c) 2014 Fuzzy. All rights reserved.
//

#import "CheckoutViewController.h"

@interface CheckoutViewController () <UITableViewDataSource>

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
    CheckoutViewController *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"CheckoutItemCellView" bundle:nil] forCellReuseIdentifier:@"itemCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
    }
    cell.itemNameLabel.text = [self.menu[indexPath.row] objectForKey:@"Name"];
    cell.itemQuantityLabel.text = [self.menu[indexPath.row] objectForKey:@"quantity"];
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
