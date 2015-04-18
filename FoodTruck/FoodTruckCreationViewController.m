
#import "XLForm.h"
#import "FoodTruckCreationViewController.h"
#import "AFNetworking.h"
#import "MapViewController.h"
#import "NSMutableDictionary+KAKeyRenaming.h"
#import "AppCache.h"

static NSString *const kName = @"name";
static NSString *const kType = @"foodType";
static NSString *const kLongitude = @"longitude";
static NSString *const kLatitude = @"latitude";

@implementation FoodTruckCreationViewController

//FoodTruck(*foodTruckID, merchantUserEmail, name, type, longitude, latitude)

-(id)init
{
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Text Fields"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    formDescriptor.assignFirstResponderOnShow = YES;
    // Basic Information - Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Create or Update food truck"];
    //section.footerTitle = @"This is a long text that will appear on section footer";
    [formDescriptor addFormSection:section];

    
    NSMutableDictionary *userInfo = [AppCache sharedCache].userDict;
    NSMutableDictionary *foodTruckInfo = [AppCache sharedCache].foodTruckDict;
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kName rowType:XLFormRowDescriptorTypeText title:@"Name"];
    row.required = YES;
    if(foodTruckInfo) {
        row.value = foodTruckInfo[kName];
    }

    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kType rowType:XLFormRowDescriptorTypeText title:@"Type"];
    row.required = YES;
    if(foodTruckInfo) {
        row.value = foodTruckInfo[kType];
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kLongitude rowType:XLFormRowDescriptorTypeNumber title:@"Longitude"];
    row.required = YES;
    if(foodTruckInfo) {
        row.value = foodTruckInfo[kLongitude];
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kLatitude rowType:XLFormRowDescriptorTypeNumber title:@"Latitude"];
    //row.valueTransformer = [xCLLocationValueTrasformer class];
    //row.value = [[CLLocation alloc] initWithLatitude:-33 longitude:-56];
    row.required = YES;
    if(foodTruckInfo) {
        row.value = foodTruckInfo[kLatitude];
    }
    [section addFormRow:row];
    
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"button1" rowType:XLFormRowDescriptorTypeButton title:@"Create/Update"];
    row.action.formBlock = ^(XLFormRowDescriptor * sender) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *params = [[self httpParameters] mutableCopy];
        //[loginParams removeObjectForKey:kIsMerchant];
        [params removeObjectForKey:@"button1"];
        [params setValue:userInfo[@"email"] forKey:@"merchantUserEmail"];
        [params setValue:userInfo[@"id"] forKey:@"user_id"];
        [params nestAllKeysWithString:@"food_truck"];

        // Update
        if(foodTruckInfo) {
            NSString *url = [NSString stringWithFormat:@"https://afternoon-inlet-3482.herokuapp.com/food_trucks/%@.json",foodTruckInfo[@"id"]];
            [manager PUT:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                [AppCache sharedCache].foodTruckDict = [responseObject mutableCopy];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
        } else { // Create
            [manager POST:@"https://afternoon-inlet-3482.herokuapp.com/food_trucks.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                [AppCache sharedCache].foodTruckDict = [responseObject mutableCopy];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
        }
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    };
    
    [section addFormRow:row];
    
    
    return [super initWithForm:formDescriptor];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];

}

@end
