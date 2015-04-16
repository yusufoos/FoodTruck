//
//  InputsFormViewController.m
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "XLForm.h"
#import "InputsFormViewController.h"
#import "AFNetworking.h"
#import "MapViewController.h"
#import "NSMutableDictionary+KAKeyRenaming.h"
#import "AppCache.h"

static NSString *const kName = @"name";
static NSString *const kEmail = @"email";
static NSString *const kTwitter = @"twitter";
static NSString *const kNumber = @"number";
static NSString *const kInteger = @"integer";
static NSString *const kDecimal = @"decimal";
static NSString *const kPassword = @"password";

static NSString *const kIsMerchant = @"isMerchant";



@implementation InputsFormViewController

-(id)init
{
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Text Fields"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    formDescriptor.assignFirstResponderOnShow = YES;
    
    // Basic Information - Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Login Or Signup"];
    //section.footerTitle = @"This is a long text that will appear on section footer";
    [formDescriptor addFormSection:section];
    
    // Email
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kEmail rowType:XLFormRowDescriptorTypeEmail title:@"Email"];
    // validate the email
    row.required = YES;
    [row addValidator:[XLFormValidator emailValidator]];
    [section addFormRow:row];
    
    // Password
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPassword rowType:XLFormRowDescriptorTypePassword title:@"Password"];
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kIsMerchant rowType:XLFormRowDescriptorTypeBooleanCheck title:@"isMerchant"];
    row.required = YES;
    row.value = @0;
    [section addFormRow:row];
    
    
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"login" rowType:XLFormRowDescriptorTypeButton title:@"login"];
    row.action.formBlock = ^(XLFormRowDescriptor * sender) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *loginParams = [[self httpParameters] mutableCopy];
        
        [loginParams removeObjectForKey:kIsMerchant];
        [loginParams removeObjectForKey:@"signup"];
        [loginParams removeObjectForKey:@"login"];

        [loginParams nestAllKeysWithString:@"user"];
        
        [manager POST:@"https://afternoon-inlet-3482.herokuapp.com/users/" parameters:loginParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            [AppCache sharedCache].userDict = [responseObject mutableCopy];
            [self presentControllerWithIsMerchant:[[responseObject objectForKey:kIsMerchant] boolValue]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    };
    [section addFormRow:row];
    
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"signup" rowType:XLFormRowDescriptorTypeButton title:@"signup"];
    row.action.formBlock = ^(XLFormRowDescriptor * sender) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        NSMutableDictionary *signupParams = [[self httpParameters] mutableCopy];
        //[loginParams removeObjectForKey:kIsMerchant];
        [signupParams removeObjectForKey:@"signup"];
        [signupParams removeObjectForKey:@"login"];
        [signupParams setValue:@YES forKey:@"isSignup"];
        [signupParams nestAllKeysWithString:@"user"];


        [manager POST:@"http://afternoon-inlet-3482.herokuapp.com/users.json" parameters:signupParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            [AppCache sharedCache].userDict = [responseObject mutableCopy];
            [self presentControllerWithIsMerchant:[[responseObject objectForKey:kIsMerchant] boolValue]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    };
    [section addFormRow:row];
    
    return [super initWithForm:formDescriptor];
    
}

-(void)presentControllerWithIsMerchant:(BOOL)isMerchant
{
    if(isMerchant) {
        [self presentViewController:self.merchantController animated:YES completion:nil];
    } else {
        [self presentViewController:self.userController animated:YES completion:nil];
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
}


-(void)savePressed:(UIBarButtonItem * __unused)button
{
    
    
    
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    [self.tableView endEditing:YES];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Valid Form", nil) message:@"No errors found" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alertView show];
}

@end
