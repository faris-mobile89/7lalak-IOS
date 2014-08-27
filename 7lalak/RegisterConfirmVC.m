//
//  RegisterConfirmVC.m
//  7lalak
//
//  Created by Faris IOS on 7/16/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "RegisterConfirmVC.h"
#import "LocalizeHelper.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"

@interface RegisterConfirmVC ()
@property (nonatomic,strong) NSString *VCODE;
@end

@implementation RegisterConfirmVC
@synthesize VCODE;
bool flagRegisterSuccess=FALSE;

-(void)viewDidLayoutSubviews{
    
    [_label1 setText:LocalizedString(@"we_sent_vcode")];
    [_textVerificationCode setPlaceholder:LocalizedString(@"input_vcode")];
    [_btnLogin setTitle:LocalizedString(@"Btn_verify") forState:UIControlStateNormal];
}
- (void)viewDidLoad
{
    _label1.layer.cornerRadius= 4;
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
    
    NSString *strURL = @"http://7lalek.com/api/SMS_authentication/process.php";
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height / 2.0)-25);
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    
    NSDictionary *dictParameter =@{
                                   @"phone_number":_phoneNumber,
                                   @"key":code,
                                   @"action":@"login"
                                   };
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    AFHTTPRequestOperation *op = [manager POST:strURL parameters:dictParameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                                           [activityIndicator stopAnimating];
                                           if (responseObject != nil) {
                                               if ([[responseObject valueForKey:@"error"]intValue] == 0) {
                                                   //seccess ;
                                                   [self presenceUserData:code
                                                                   APIKey:[responseObject valueForKey:@"api_key"]
                                                                   UserId:[responseObject valueForKey:@"user_id"]];
                                                   [activityIndicator stopAnimating];
                                                   
                                               }else
                                                   if ([[responseObject valueForKey:@"error"]intValue] == 1) {
                                                       
                                                       [self showMessage:LocalizedString(@"VCODE_TITLE") message:LocalizedString(@"ERROR_INVALID_VOCODE")];
                                                       [_btnLogin setHidden:FALSE];
                                                       [activityIndicator stopAnimating];

                                                   }
                                           }
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          // NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                                           [self showErrorInterentMessage:LocalizedString(@"NETWORK_ERROR")
                                                                  message:LocalizedString(@"error_internet_timeout")];
                                           [_btnLogin setHidden:FALSE];
                                           [activityIndicator stopAnimating];
                                       }];
    
    [op start];
    
    
    
}

-(void)presenceUserData :(NSString *)vCode APIKey:(NSString *)apiKey UserId:(NSString *)userId{
    
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
        [user setValue:userId forKey:@"ID"];
        [user setValue:vCode forKey:@"VCODE"];
        [user setValue: apiKey forKey:@"API_KEY"];
        [user setValue:@"true" forKey:@"ACTIVE"];
        [user setValue:@"7" forKey:@"IMAGE_SCORE"];// variable not used in app // remotly using
        [user setValue:@"3" forKey:@"VIDEO_SCORE"];// variable not used in app //
        [user writeToFile:path atomically:YES];
        
       // NSLog(@"Complete Registeration");
        //NSLog(@"FULL USER DATA : %@",[NSDictionary dictionaryWithContentsOfFile:path]);
        
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
