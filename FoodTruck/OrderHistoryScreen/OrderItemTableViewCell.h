//
//  OrderItemTableViewCell.h
//  FoodTruck
//
//  Created by Yusuf Sobh on 11/14/14.
//  Copyright (c) 2014 Fuzzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderItemTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@end
