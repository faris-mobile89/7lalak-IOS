//
//  MyAdDetails.m
//  7lalak
//
//  Created by Faris IOS on 7/22/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "MyAdDetails.h"
#import "UIColor_hex.h"
#import "LocalizeHelper.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"

#define IS_HEIGHT_4S [[UIScreen mainScreen ] bounds].size.height < 568.0f

@interface MyAdDetails ()
@property NSDictionary *jsonObject;
@property NSDictionary *subCat;
@property NSString *catId;
@property (strong) NSString *selectedMaincatId;
@property (strong) NSString *selectedSubcatId;

@end

@implementation MyAdDetails
@synthesize jsonObject,subCat,catId,selectedMaincatId,selectedSubcatId;
UIActivityIndicatorView *activityIndicator;
bool flagEditCat= false;

-(void)viewDidLayoutSubviews{
    
    selectedMaincatId = [[NSString alloc]init];
    selectedSubcatId = [[NSString alloc]init];
    
    _description.layer.cornerRadius= 10;
    _description.layer.borderWidth=0.5;
    _description.clipsToBounds = YES;
    _description.layer.borderColor=[[UIColor darkGrayColor] CGColor];

    //_labelStatus.layer.cornerRadius =7;
    //_labelCat.layer.cornerRadius =7;
    _category_picker.transform = CGAffineTransformMakeScale(0.8, 0.6);
    selectedSubcatId =00; selectedMaincatId=00;
    BOOL IS_4S = IS_HEIGHT_4S;
    if (!IS_4S) {
        
    }
    
    [super viewDidLayoutSubviews];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _price.delegate = self;
    _description.delegate=self;
    
    [_category_picker setHidden:TRUE];
    _description.text= _paramDescription;
    _price.text = _paramPrice;
    
    if ([_paramStatus isEqualToString:@"2"]) {
        
        [_availability setSelectedSegmentIndex:0];
        
    }else{
        [_availability setSelectedSegmentIndex:1];
    }
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height / 2.0)+50);
    [self.view addSubview: activityIndicator];
    [self loadMainCat];
}


- (IBAction)deleteBtn:(id)sender {
    
    UIAlertView *deleteConfirm = [[UIAlertView alloc]initWithTitle:nil message:LocalizedString(@"DELETE_CONFIRM") delegate:self cancelButtonTitle:LocalizedString(@"CANCEL") otherButtonTitles:LocalizedString(@"DELETE"), nil];
    [deleteConfirm show];
    
}

- (IBAction)saveBtn:(id)sender {
    
    NSString*paramSelectedMaincatId,*paramSelectedSubcatId;

    
    if (flagEditCat) {
    
        
    if (selectedSubcatId != _paramSid) {
        //send new cat
        NSLog(@"selected= %@,%@",selectedMaincatId,selectedSubcatId);
        paramSelectedMaincatId = selectedMaincatId;
        paramSelectedSubcatId = selectedSubcatId;
        if (selectedMaincatId == nil || selectedSubcatId == nil) {
            NSLog(@"please select category");
            return;
        }
     }
    
    }else{
        paramSelectedSubcatId = @"00"; paramSelectedMaincatId=@"00";
        NSLog(@"nil selected");
        
    }
    
    
    NSString *newSatus;
    if (_availability.selectedSegmentIndex == 0 ) {
       newSatus  = @"2"; //sold
    }else if (_availability.selectedSegmentIndex == 1 ){
        newSatus = @"1"; //available
    }
    
    NSString *strURL = @"http://185.56.85.28/~c7lalek4/api/api.php";
    
    [activityIndicator startAnimating];
    
    NSDictionary *dictParameter =@{
                                   @"tag":@"editAd",
                                   @"Ad_id":_paramAdId,
                                   @"text":_description.text,
                                   @"price":_price.text,
                                   @"status":newSatus,
                                   @"mid":paramSelectedMaincatId,
                                   @"sid":paramSelectedSubcatId,
                                   @"user_id":_userID,
                                   @"UDID":_apiKey
                                   };
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    AFHTTPRequestOperation *op = [manager POST:strURL parameters:dictParameter
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           [activityIndicator stopAnimating];
                                           if (responseObject != nil) {
                                               
                                               if ([[responseObject valueForKey:@"error"]intValue]==0) {
                                                   [self.navigationController popViewControllerAnimated:YES];
                                               }
                                           }
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                                           [activityIndicator stopAnimating];
                                       }];
    
    [op start];

    
}

- (IBAction)btnEditCatClick:(id)sender {
   
    [_category_picker setHidden:FALSE];
    [_labelCatName setHidden:TRUE];
    [_btnEditCat setHidden:TRUE];
    flagEditCat = true;
    [self loadMainCat];
  
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex ==1) {
        
        [self deleteAction];
    }
}

-(void)deleteAction{
    
    NSString *strURL = @"http://185.56.85.28/~c7lalek4/api/api.php";
    
    [activityIndicator startAnimating];
    
    NSDictionary *dictParameter =@{
                                   @"tag":@"deleteAd",
                                   @"Ad_id":_paramAdId,
                                   @"user_id":_userID,
                                   @"UDID":_apiKey
                                   };
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    AFHTTPRequestOperation *op = [manager POST:strURL parameters:dictParameter
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           [activityIndicator stopAnimating];
                                           if (responseObject != nil) {
                                               
                                               if ([[responseObject valueForKey:@"error"]intValue]==0) {
                                                   [self.navigationController popViewControllerAnimated:YES];
                                               }
                                           }
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                                           [activityIndicator stopAnimating];
                                       }];
    
    [op start];

}
#pragma mark picker

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component ==0) {
        return [[jsonObject objectForKey:@"MainCat"]count];
    }else if (component==1){
        return [[subCat objectForKey:@"SubCat"]count];
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* label = (UILabel*)view;
    if (!label){
        label = [[UILabel alloc] init];
       // [label setFont:[UIFont  boldSystemFontOfSize:10]];
        
    
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
        label.numberOfLines=3;
        //[label setBackgroundColor:[UIColor colorWithHexString:@"339999"]];
        
        if (component == 0) {
            if ([[jsonObject objectForKey:@"MainCat"]count]>0) {
                NSString *lableText= [[NSString alloc]initWithFormat:@"sakhdklfhsdfgjsdgfjkg %@ > ",[[[jsonObject objectForKey:@"MainCat"]objectAtIndex:row]valueForKey:@"name"]];
                label.text= lableText;
            }
        }
        
        else if (component==1){
            if ([[subCat objectForKey:@"SubCat"]count]>0) {
                
                label.text=  [[[subCat objectForKey:@"SubCat"]objectAtIndex:row]objectForKey:@"name"];
            }
        }
        
    }
    return label;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component==0){
        
        catId = [[[jsonObject objectForKey:@"MainCat"]objectAtIndex:row]valueForKey:@"id"];
        [self loadSubCat];
        selectedMaincatId = catId;
    }else if (component == 1){
        selectedSubcatId = [[[subCat objectForKey:@"SubCat"]objectAtIndex:row]objectForKey:@"id"];
    }
}


-(void)loadSubCat{
    
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://185.56.85.28/~c7lalek4/api/getSubCategories.php?tag=getSubCat&mainId=%@",catId];
    
    NSURL *url= [NSURL URLWithString:urlString];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40];
    
    [activityIndicator startAnimating];
    
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:queue
                           completionHandler:^(NSURLResponse* response,
                                               NSData* data,
                                               NSError* error)
     {
         
         if (data) {
             NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
             
             if (httpResponse.statusCode == 200 /* OK */) {
                 NSError* error;
                 
                 subCat = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (subCat) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [activityIndicator stopAnimating];
                         
                         if ([subCat count] < 1 )
                             return;
                         
                         selectedSubcatId = [[[subCat objectForKey:@"SubCat"]objectAtIndex:0]objectForKey:@"id"];
                         [_category_picker reloadComponent:1];
                         
                         ;
                          // search by cat name => return cat name from JSON
                         for (NSInteger i = 0 ; i < [[subCat objectForKey:@"SubCat"]count]; i++) {
                             
                             if ([_paramSid intValue] ==  [[[[subCat objectForKey:@"SubCat"]objectAtIndex:i]objectForKey:@"id"]intValue] ) {
                                 
                                 _labelCatName.text = [[[subCat objectForKey:@"SubCat"]objectAtIndex:i]objectForKey:@"name"];
                                 break;
                             }
                         }
                       
                         
                        // NSLog(@"subCat: %@", subCat);
                         
                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         //[self handleError:error];
                         NSLog(@"ERROR: %@", error);
                     });
                 }
             }
             
             else if(httpResponse.statusCode == 408){
                 UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Network Error" message: @"Connection Time Out" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                 [someError show];
                 [_btnEditCat setHidden:FALSE];
             }else{
                 [activityIndicator stopAnimating];
                 [_btnEditCat setHidden:FALSE];
                 // status code indicates error, or didn't receive type of data requested
                 NSString* desc = [[NSString alloc] initWithFormat:@"HTTP Request failed with status code: %d (%@)",
                                   
                                   (int)(httpResponse.statusCode),
                                   [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]];
                 NSError* error = [NSError errorWithDomain:@"HTTP Request"
                                                      code:-1000
                                                  userInfo:@{NSLocalizedDescriptionKey: desc}];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     //[self handleError:error];  // execute on main thread!
                     NSLog(@"ERROR: %@", error);
                     [activityIndicator stopAnimating];
                 });
             }
         }
         else {
             // request failed - error contains info about the failure
             dispatch_async(dispatch_get_main_queue(), ^{
                 //[self handleError:error]; // execute on main thread!
                 NSLog(@"ERROR: %@", error);
                 UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: @"Network Error" message:@"The Internet connection appears to be offline" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                 [_btnEditCat setHidden:FALSE];
                 [internetError show];
                 [activityIndicator stopAnimating];
             });
         }
     }];
    
}

-(void)loadMainCat{
    
    NSURL* url = [NSURL URLWithString:@"http://185.56.85.28/~c7lalek4/api/getMainCategories.php?tag=getMainCat"];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40];
    
    
    [activityIndicator startAnimating];
    
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:queue
                           completionHandler:^(NSURLResponse* response,
                                               NSData* data,
                                               NSError* error)
     {
         
         if (data) {
             NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
             
             if (httpResponse.statusCode == 200 /* OK */) {
                 NSError* error;
                 
                 jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (jsonObject) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [activityIndicator stopAnimating];
                         [_category_picker reloadComponent:0];
                         
                         catId = [[[jsonObject objectForKey:@"MainCat"]objectAtIndex:0]valueForKey:@"id"];
                         selectedMaincatId = catId;
                         [self loadSubCat];
                         
                         // NSLog(@"jsonObject: %@", [jsonObject objectForKey:@"MainCat"]);
                         
                         
                         
                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         NSLog(@"ERROR: %@", error);
                     });
                 }
             }
             
             else if(httpResponse.statusCode == 408){
                 UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Network Error" message: @"Connection Time Out" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                 [someError show];
             }else{
                 [activityIndicator stopAnimating];
                 
                 // status code indicates error, or didn't receive type of data requested
                 NSString* desc = [[NSString alloc] initWithFormat:@"HTTP Request failed with status code: %d (%@)",
                                   
                                   (int)(httpResponse.statusCode),
                                   [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]];
                 NSError* error = [NSError errorWithDomain:@"HTTP Request"
                                                      code:-1000
                                                  userInfo:@{NSLocalizedDescriptionKey: desc}];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     //[self handleError:error];  // execute on main thread!
                     NSLog(@"ERROR: %@", error);
                     [activityIndicator stopAnimating];
                 });
             }
         }
         else {
             // request failed - error contains info about the failure
             dispatch_async(dispatch_get_main_queue(), ^{
                 //[self handleError:error]; // execute on main thread!
                 NSLog(@"ERROR: %@", error);
                 UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: @"Network Error" message:@"The Internet connection appears to be offline" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                 
                 [internetError show];
                 [activityIndicator stopAnimating];
             });
         }
     }];
    
}


#pragma mark Keyboard

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _price) {
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 8) ? NO : YES;
    }
    else return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_price resignFirstResponder];
    return YES;
}

-(void)showErrorInterentMessage:(NSString *)title message:(NSString*)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: title message:msg delegate: self cancelButtonTitle: LocalizedString(@"Ok") otherButtonTitles: nil];
    
    [internetError show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
