//
//  FoodTruckAnnotation.m
//  FoodTruck
//
//  Created by Yusuf Sobh on 11/2/14.
//  Copyright (c) 2014 Fuzzy. All rights reserved.
//

#import "FoodTruckAnnotation.h"

@implementation FoodTruckAnnotation

- (id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location {
    
    self = [super init];
    
    if (self) {
        _title = newTitle;
        _coordinate = location;
    }
    
    return self;
}

- (MKAnnotationView *)annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"FoodTruckAnnotation"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"truckPin.png"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    /*
     UIButton *arrowButton = [[UIButton alloc] init];
     [arrowButton setImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
     
     annotationView.rightCalloutAccessoryView = arrowButton;
     */
    
    return annotationView;
}

@end
