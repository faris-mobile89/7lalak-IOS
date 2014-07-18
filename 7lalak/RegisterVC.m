//
//  RegisterVC.m
//  7lalak
//
//  Created by Faris IOS on 6/29/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "RegisterVC.h"
#import "RegisterConfirmVC.h"
#import "LocalizeHelper.h"

@interface RegisterVC ()

@end

@implementation RegisterVC


- (void)viewDidLoad
{
    _fUserName.delegate=self;
    _fPhone.delegate=self;
    _fEmail.delegate=self;
    self.title = LocalizedString(@"TITLE_MORE_REGISTER");
    [super viewDidLoad];
}


int phoneLength =10;


- (IBAction)fbtnRegister:(id)sender {
    
    if ([_fPhone.text length] > 1 && [_fUserName.text length]>1 && [_fEmail.text length] > 1) {
        
        if ([_fPhone.text length]!= phoneLength ){
            [self showErrorMessage:@"Phone number not valid"];
        }else
              if (![self NSStringIsValidEmail:_fEmail.text]) {
                
                [self showErrorMessage:@"Email not valid"];
                
            }else{
                // create init user data
                [self createUserData];
            }
        }
}

-(void)showErrorMessage:(NSString *)msg{
    
    UIAlertView *error = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [error show];
    
}

-(void)createUserData{
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"UserInfoData.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"userInfo" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    NSDictionary *user =@{
                          @"id": @"null",
                          @"username":_fUserName.text,
                          @"email":_fEmail.text,
                          @"phone":_fPhone.text,
                          @"active":@"false",
                          @"VCODE":@"Null",
                          @"images_score":@"null",
                          @"video_score":@"null"
                          };
    
    [user writeToFile:path atomically:YES];
    [self performSegueWithIdentifier:@"confirm_register" sender:self];
    
    //NSLog(@"id  %@",[user valueForKey:@"id"]);
  //    NSLog(@"content:%@",[NSDictionary dictionaryWithContentsOfFile:path]);
}
-(void)sendUserData{
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://example.com"];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height / 2.0)-50);
    [self.view addSubview: activityIndicator];
    
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
                 
                 id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (jsonObject) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         // self.model = jsonObject;
                         [activityIndicator stopAnimating];
                         
                         //  NSLog(@"jsonObject: %@", [jsonObject objectForKey:@"items"]);
                         
                         
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
             });
         }
     }];
    

}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_fPhone resignFirstResponder];
    [_fUserName resignFirstResponder];
    [_fEmail resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _fPhone) {
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > phoneLength) ? NO : YES;
    }
    else return YES;
}



 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if ([segue.identifier isEqualToString:@"confirm_register"]) {
        // RegisterConfirmVC *confirm = segue.destinationViewController ;
         
     }
 }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
