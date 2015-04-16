//
//  FirstViewController.m
//  FoodTruck
//
//  Created by Yusuf Sobh on 10/30/14.
//  Copyright (c) 2014 Fuzzy. All rights reserved.
//

#import "MapViewController.h"
#import "FoodTruckAnnotation.h"
#import "FoodTruckMenuController.h"
#import "CustomCalloutView.h"
#import "InputsFormViewController.h"
#import "CustomAnnotationView.h"
#import "AFNetworking.h"
#import "AppCache.h"


@interface MapViewController ()

- (void)zoomToCurrentLocation;

- (void)addFoodTruckAnnotations;

-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) CustomCalloutView *calloutView;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, assign) BOOL initialPositionSet;



@end

@implementation MapViewController

- (id)initWithTruckData:(NSDictionary *)data {
    
    self = [self init];
    if (self != nil)
    {
        //_data = data;
    }
    
    return self;
}

- (id)init
{
    self = [super initWithNibName:@"MapViewController" bundle:nil];
    if (self != nil)
    {
        self.title = @"map";
        
        // Further initialization if needed
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    NSAssert(NO, @"Initialize with -init");
    return nil;
}

-(void)downloadFoodTruckData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __block id response = nil;
    [manager GET:@"https://afternoon-inlet-3482.herokuapp.com/food_trucks.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.data = responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

-(void)setData:(NSArray *)data
{
    _data = data;
    
    if(_data) {
        [self addFoodTruckAnnotations];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    [self zoomToCurrentLocation];
    
    _calloutView = [[CustomCalloutView alloc] init];
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [_calloutView addGestureRecognizer:singleTapGestureRecognizer];
    
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;
    
    [self downloadFoodTruckData];
}

- (void)viewDidAppear:(BOOL)animated{
    
}


- (void)zoomToCurrentLocation {
    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = self.mapView.userLocation.coordinate.latitude;
    region.center.longitude = self.mapView.userLocation.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region animated:NO];
}

- (void)addFoodTruckAnnotations {
    
    for (NSDictionary *foodTruck in self.data) {
            float longitude = ((NSNumber *)foodTruck[@"longitude"]).floatValue;
            float latitude = ((NSNumber *)foodTruck[@"latitude"]).floatValue;
            NSString *name = foodTruck[@"name"];
            NSNumber *truckID =foodTruck[@"id"];
            CLLocationCoordinate2D foodTruckCoords = CLLocationCoordinate2DMake(longitude, latitude);
            FoodTruckAnnotation *annotation = [[FoodTruckAnnotation alloc] initWithTitle:name Location:foodTruckCoords ID:truckID];
            annotation.type = @"";
            annotation.rating = @3;
            [self.mapView addAnnotation:annotation];
    }
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if(!self.initialPositionSet) {
        [self.mapView setCenterCoordinate:userLocation.coordinate animated:NO];
        self.initialPositionSet = YES;
    }
}

// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
   // NSLog(@"%@", [locations lastObject]);
}

#pragma mark - Map View Delegate

- (CustomAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[FoodTruckAnnotation class]]) {
        FoodTruckAnnotation *myLocation = (FoodTruckAnnotation *)annotation;
        
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"FoodTruckAnnotation"];
        
        if(annotationView == nil) {
            annotationView = (CustomAnnotationView *) myLocation.annotationView;
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    } else {
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    [view addSubview:self.calloutView];
    self.calloutView.center = CGPointMake(view.bounds.size.width*0.5f, -self.calloutView.bounds.size.height*0.5f - 5);
    
    FoodTruckAnnotation *annotation =((FoodTruckAnnotation *)view.annotation);
    self.calloutView.titleLabel.text = annotation.title;
    self.calloutView.ratingBar.rating = annotation.rating;
    self.calloutView.typeLabel.text = annotation.type;
    self.calloutView.foodtruckId = annotation.foodtruckId;
    self.calloutView.hidden = NO;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    self.calloutView.hidden = YES;
}

- (void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    NSNumber *foodTruckId = ((CustomCalloutView * )tapGestureRecognizer.view).foodtruckId;
    [AppCache sharedCache].foodTruckDict = [self foodTruckForID:foodTruckId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"https://afternoon-inlet-3482.herokuapp.com/food_trucks/%@/menu_items.json",foodTruckId];

    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSMutableArray *menu = responseObject;
        FoodTruckMenuController *menuController = [[FoodTruckMenuController alloc] initWithMenu:menu];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:menuController];
        [self presentViewController:navController animated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)showOrdersController {
    [self.tabBarController setSelectedIndex:1];
}

-(NSDictionary *)foodTruckForID:(NSNumber *)truckID
{
    for (NSDictionary * dict in self.data) {
        if([dict[@"id"] isEqual:truckID]) {
            return dict;
        }
    }
    
    return nil;
}


@end
