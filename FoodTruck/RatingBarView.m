//
//  RatingBarView.m
//  FoodTruck
//
//  Created by Yusuf Sobh on 11/4/14.
//  Copyright (c) 2014 Fuzzy. All rights reserved.
//

#import "RatingBarView.h"

@interface RatingBarView ()

@property (strong, nonatomic) IBOutlet UIView *view;

@end

@implementation RatingBarView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if(self) {
        //Initialization code
        
        // 1. Load .xib
        [[NSBundle mainBundle] loadNibNamed:@"RatingBarView" owner:self options:nil];
        
        // 2. Adjust bounds
        self.bounds = self.view.bounds;
        
        // 3. Add as subview
        [self addSubview:self.view];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    // Load interface file from .xib
    if(self) {
        [[NSBundle mainBundle] loadNibNamed:@"RatingBarView" owner:self options:nil];
    }
    
    // Add it as a subview
    [self addSubview:self.view];
    
    return self;
}

- (void)setRating:(NSNumber *)rating {
    _rating = rating;
    
    int count = 0;
  
    for (UIImageView *starView in self.view.subviews) {
        if (count != [rating integerValue]) {
            starView.highlighted = YES;
            count++;
        } else {
            starView.highlighted = NO;
        }
    }
}

@end
