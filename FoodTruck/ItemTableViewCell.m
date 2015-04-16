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
    [self setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)addButton:(id)sender {
    NSInteger curQuant = [(NSNumber *)[self.item objectForKey:@"quantity"] integerValue];
    NSInteger newQuant = curQuant+1;
    [self.item setObject:[NSNumber numberWithInt:(int)newQuant] forKey:@"quantity"];
    [self.quantityLabel setText:[NSString stringWithFormat:@"x%ld", (long)newQuant]];
}

- (IBAction)deleteButton:(id)sender {
    NSInteger curQuant = [[self.item objectForKey:@"quantity"] integerValue];
    if(curQuant == 0) {
        return;
    }
    NSInteger newQuant = curQuant-1;
    [self.item setObject:[NSNumber numberWithInt:(int)newQuant] forKey:@"quantity"];
    [self.quantityLabel setText:[NSString stringWithFormat:@"x%ld", (long)newQuant]];
}

@end
