//
//  FirstViewController.h
//  FoodTruck
//
//  Created by Yusuf Sobh on 10/30/14.
//  Copyright (c) 2014 Fuzzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

- (id)initWithTruckData:(NSDictionary *)data;

- (void)showOrdersController;

@property (nonatomic, assign) BOOL loggedIn;

@end

