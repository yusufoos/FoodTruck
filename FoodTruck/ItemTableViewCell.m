//
//  ItemTableViewCell.m
//  FoodTruck
//
//  Created by Shane Carey on 11/5/14.
//  Copyright (c) 2014 Fuzzy. All rights reserved.
//

#import "ItemTableViewCell.h"

@implementation ItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)addButton:(id)sender {
    NSInteger curQuant = [[self.item objectForKey:@"quantity"] integerValue];
    NSInteger newQuant = curQuant--;
    [self.item setValue:[NSNumber numberWithInt:(int)newQuant] forKey:@"quantity"];
    self.quantityLabel.text = [NSString stringWithFormat:@"x%ld", newQuant];
}

- (IBAction)deleteButton:(id)sender {
    NSInteger curQuant = [[self.item objectForKey:@"quantity"] integerValue];
    NSInteger newQuant = curQuant--;
    [self.item setValue:[NSNumber numberWithInt:(int)newQuant] forKey:@"quantity"];
    self.quantityLabel.text = [NSString stringWithFormat:@"x%ld", newQuant];
}

@end
