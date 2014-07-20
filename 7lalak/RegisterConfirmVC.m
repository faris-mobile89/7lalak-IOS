//
//  RegisterConfirmVC.m
//  7lalak
//
//  Created by Faris IOS on 7/16/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "RegisterConfirmVC.h"
#import "LocalizeHelper.h"

@interface RegisterConfirmVC ()
@property (nonatomic,strong) NSString *VCODE;
@end

@implementation RegisterConfirmVC
@synthesize VCODE;
bool flagRegisterSuccess=FALSE;
- (void)viewDidLoad
{
    //self.title = LocalizedString(@"TITLE_MORE_REGISTER");
    self.textVerificationCode.delegate=self;
    [super viewDidLoad];
    
}

- (IBAction)btnLoginClick:(id)sender {
    
    
    VCODE = _textVerificationCode.text;
    if (VCODE !=nil && [VCODE length] > 4) {
        
        [self checkVCODE:VCODE];
    }else{
        [ self showMessage:LocalizedString(@"VCODE_TITLE") message:LocalizedString(@"ERROR_INVALID_VOCODE")];
    }
}

-(void)checkVCODE:(NSString *)code{
    
    [_btnLogin setHidden:TRUE];
    NSURL* url = [NSURL URLWithString:@"http://185.56.85.28/~c7lalek4/api/authuntication.php"];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height / 2.0)-25);
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
                 
                 id  jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (jsonObject) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [activityIndicator stopAnimating];
                         
                         
                         if (jsonObject!=nil) {
                             //NSLog(@"jsonObject: %@", [jsonObject objectForKey:@"MainCat"]);
                             
                             NSString *serverVCODE = [jsonObject objectForKey:@"VCODE"];
                             if ([serverVCODE isEqualToString:VCODE]) {
                                 
                                 [self presenceUserData:serverVCODE];
                             }else{
                                 
                                 [self showMessage:LocalizedString(@"VCODE_TITLE") message:LocalizedString(@"ERROR_INVALID_VOCODE")];
                                 [_btnLogin setHidden:FALSE];
                             }
                         }else{
                             [_btnLogin setHidden:FALSE];
                         }
                         
                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                     });
                 }
             }
             
             else if(httpResponse.statusCode == 408){
                 [self showErrorInterentMessage:LocalizedString(@"NETWORK_ERROR")
                                        message:LocalizedString(@"error_internet_timeout")];
                 [_btnLogin setHidden:FALSE];
                 
             }else{
                 [activityIndicator stopAnimating];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [activityIndicator stopAnimating];
                     [_btnLogin setHidden:FALSE];
                     
                 });
             }
         }
         else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self showErrorInterentMessage:LocalizedString(@"NETWORK_ERROR") message : LocalizedString(@"error_internet_offiline")];
                 [_btnLogin setHidden:FALSE];
                 [activityIndicator stopAnimating];
             });
         }
     }];
    
}

-(void)presenceUserData:(NSString *)vCode{
    
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
    
    //enable user account
    NSDictionary *user =[NSDictionary dictionaryWithContentsOfFile:path];
    if (user !=nil) {
        //  [user valueForKey:@"VCODE"];
        [user setValue:vCode forKey:@"VCODE"];
        [user setValue:@"true" forKey:@"active"];
        [user setValue:@"7" forKey:@"images_score"];// variable not used in app // remotly using
        [user setValue:@"3" forKey:@"video_score"];// variable not used in app //
        [user writeToFile:path atomically:YES];
        
        NSLog(@"Complete Registeration");
        NSLog(@"FULL USER DATA : %@",[NSDictionary dictionaryWithContentsOfFile:path]);
        
        [self showMessage:LocalizedString(@"MESSAGE_REGISTER_SUCCESS_TITLE")message:LocalizedString(@"MESSAGE_REGISTER_SUCCESS_MSG")];
        [_btnLogin setHidden:TRUE];
        flagRegisterSuccess = TRUE;
    }else{
        [self showMessage:LocalizedString(@"MESSAGE_FAILD_REGISTER") message:LocalizedString(@"MESSAGE_FAILD_REGISTER_MSG")];
    }
    
}

-(void)showErrorInterentMessage:(NSString *)title message:(NSString*)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: title message:msg delegate: self cancelButtonTitle: LocalizedString(@"Ok") otherButtonTitles: nil];
    
    [internetError show];
    
}

-(void)showMessage:(NSString *)title message:(NSString*)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: title message:msg delegate: self cancelButtonTitle: LocalizedString(@"DONE") otherButtonTitles: nil];
    
    [internetError show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    
    if (buttonIndex == 0 && flagRegisterSuccess== TRUE) {
        [self performSegueWithIdentifier:@"return_to_more_segue" sender:self];
    }
    
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_textVerificationCode resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
