//
//  FoodTruckAnnotation.h
//  FoodTruck
//
//  Created by Yusuf Sobh on 11/2/14.
//  Copyright (c) 2014 Fuzzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FoodTruckAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSNumber *foodtruckId;


- (id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location ID:(NSNumber *)truckID;
- (MKAnnotationView *)annotationView;

@end
