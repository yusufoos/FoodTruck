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

@interface MerchantViewController ()
@property (weak, nonatomic) IBOutlet UIButton *deleteFoodTruckBtn;
@property (weak, nonatomic) IBOutlet UIButton *CreateUpdateFoodTruckBtn;

@end

@implementation MerchantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
