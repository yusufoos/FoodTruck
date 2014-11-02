//
//  FirstViewController.m
//  FoodTruck
//
//  Created by Yusuf Sobh on 10/30/14.
//  Copyright (c) 2014 Fuzzy. All rights reserved.
//

#import "MapViewController.h"
#import "FoodTruckAnnotation.h"
#import "OrdersViewController.h"

@interface MapViewController ()

- (void)zoomToCurrentLocation;

- (void)addFoodTruckAnnotations;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end

@implementation MapViewController

- (id)init
{
    self = [super initWithNibName:@"MapViewController" bundle:nil];
    if (self != nil)
    {
        // Further initialization if needed
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    NSAssert(NO, @"Initialize with -init");
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;

    [self addFoodTruckAnnotations];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)viewDidAppear:(BOOL)animated{
    [self zoomToCurrentLocation];
}

- (void)addFoodTruckAnnotations {
    CLLocationCoordinate2D foodTruckCoords = CLLocationCoordinate2DMake(37.332968, -122.029041);
    FoodTruckAnnotation *annotation = [[FoodTruckAnnotation alloc] initWithTitle:@"Cracked Egg" Location:foodTruckCoords];
    [self.mapView addAnnotation:annotation];
}

- (void)zoomToCurrentLocation {
    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = self.mapView.userLocation.coordinate.latitude;
    region.center.longitude = self.mapView.userLocation.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region animated:YES];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self.mapView setCenterCoordinate:userLocation.coordinate animated:NO];
}

// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
}

#pragma mark - Map View Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[FoodTruckAnnotation class]]) {
        FoodTruckAnnotation *myLocation = (FoodTruckAnnotation *)annotation;
        
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"FoodTruckAnnotation"];
        
        if(annotationView == nil) {
            annotationView = myLocation.annotationView;
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    } else {
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    MKAnnotationView *annView = view.annotation;
    
    /*
    self performSegueWithIdentifier:<#(NSString *)#> sender:<#(id)#>
    detailedViewOfList *detailView = [[detailedViewOfList alloc]init];
    detailView.address = annView.address;
    detailView.phoneNumber = annView.phonenumber;
    */
    
    OrdersViewController *ordersController = [[OrdersViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ordersController];
    [self presentViewController:navController animated:YES completion:nil];
}


@end
