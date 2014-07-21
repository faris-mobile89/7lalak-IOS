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
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"

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
                          @"ID": @"null",
                          @"USERNAME":_fUserName.text,
                          @"EMAIL":_fEmail.text,
                          @"PHONE":_fPhone.text,
                          @"ACTIVE":@"false",
                          @"VCODE":@"null",
                          @"API_KEY":@"null",
                          @"IMAGE_SCORE":@"null",
                          @"VIDEO_SCORE":@"null"
                          };
    
    [user writeToFile:path atomically:YES];
    
    [self sendRegisterationRequest];
    
    //[self performSegueWithIdentifier:@"confirm_register" sender:self];
    
    //NSLog(@"id  %@",[user valueForKey:@"id"]);
    //    NSLog(@"content:%@",[NSDictionary dictionaryWithContentsOfFile:path]);
}

-(void)sendRegisterationRequest{
    
    NSString *strURL = @"http://185.56.85.28/~c7lalek4/api/SMS_authentication/process.php";
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height / 2.0)+10);
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    
    NSDictionary *dictParameter =@{
                                   @"username": _fUserName.text,
                                   @"phone_number":_fPhone.text,
                                   @"email":_fEmail.text,
                                   @"action":@"token"
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
                                                   [self performSegueWithIdentifier:@"confirm_register" sender:self];
                                               }else
                                                   if ([[responseObject valueForKey:@"error"]intValue] == 1) {
                                                       
                                                       if ( [[responseObject valueForKey:@"verified"]intValue]== 0 ) {
                                                           
                                                           [self performSegueWithIdentifier:@"confirm_register" sender:self];
                                                       }else{
                                                       UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"" message:@"The number already registered" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
                                                       [error show];
                                                       }
                                                   }
                                           }
                                           
                                           
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                                           [activityIndicator stopAnimating];
                                       }];
    
    [op start];
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
        RegisterConfirmVC *confirm = segue.destinationViewController ;
        confirm.phoneNumber = _fPhone.text;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
