//
//  CustomCalloutView.m
//  FoodTruck
//
//  Created by Yusuf Sobh on 11/3/14.
//  Copyright (c) 2014 Fuzzy. All rights reserved.
//

#import "CustomCalloutView.h"

@implementation CustomCalloutView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if(self) {
        //Initialization code
        
        // 1. Load .xib
        [[NSBundle mainBundle] loadNibNamed:@"CustomCalloutView" owner:self options:nil];

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
        [[NSBundle mainBundle] loadNibNamed:@"CustomCalloutView" owner:self options:nil];
    }
    
    // Add it as a subview
    [self addSubview:self.view];
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
