//
//  ItemTableViewCell.h
//  FoodTruck
//
//  Created by Shane Carey on 11/5/14.
//  Copyright (c) 2014 Fuzzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;

@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) NSMutableDictionary *item;

@end
