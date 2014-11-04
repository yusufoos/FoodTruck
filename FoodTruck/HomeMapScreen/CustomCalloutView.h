//
//  CustomCalloutView.h
//  FoodTruck
//
//  Created by Yusuf Sobh on 11/3/14.
//  Copyright (c) 2014 Fuzzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingBarView.h"

@interface CustomCalloutView : UIView

@property (strong, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet RatingBarView *ratingBar;

@end
