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

NSString *phone;
NSString *email;


-(void)viewDidLayoutSubviews{

    [_lable1 setText:LocalizedString(@"app_work_kwait")];
    [_fEmail setPlaceholder:LocalizedString(@"Input_email")];
    [_fPhone setPlaceholder:LocalizedString(@"Input_phone")];
    [_fUserName setPlaceholder:LocalizedString(@"input_name")];
    [_register_btn setTitle:LocalizedString(@"Btn_Register") forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    _lable1.layer.cornerRadius= 4;
    _fUserName.delegate=self;
    _fPhone.delegate=self;
    _fEmail.delegate=self;
    self.title = LocalizedString(@"TITLE_MORE_REGISTER");
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           
                           [[UIBarButtonItem alloc]initWithTitle:LocalizedString(@"DONE") style:UIBarButtonItemStyleBordered target:self action:@selector(doneButton:)],
                           
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           nil];
    _fPhone.inputAccessoryView = numberToolbar;
    
    [super viewDidLoad];
    
}

int phoneLength =8;

- (IBAction)fbtnRegister:(id)sender {
    
    // Register Debug number
    if ([_fPhone.text isEqualToString:@"172170"]) {
        // Register Debug number
        UIAlertView *confirm = [[UIAlertView alloc]initWithTitle:@"" message:LocalizedString(@"CONFIRM_REGISTERATION") delegate:self cancelButtonTitle:LocalizedString(@"CANCEL") otherButtonTitles:LocalizedString(@"OK"), nil];
        [confirm show];
        
    }//end Register Debug number
    
    
    if ([_fUserName.text length]>1 &&[_fPhone.text length] > 1 ) {
        
        if ([_fPhone.text length] != phoneLength){
            [self showErrorMessage:LocalizedString(@"Num_Not_Valid")];
            return;
        }
        
        if (![self validatePhone:_fPhone.text]) {
            [self showErrorMessage:LocalizedString(@"Num_Not_Valid")];
            return;
        }
        
       if ([_fEmail.text length] > 0) {
                
                if (![self NSStringIsValidEmail:_fEmail.text]) {
                    
                    [self showErrorMessage:LocalizedString(@"Email_not_Valid")];
                    return;
            }
       }
        
        UIAlertView *confirm = [[UIAlertView alloc]initWithTitle:@"" message:LocalizedString(@"CONFIRM_REGISTERATION") delegate:self cancelButtonTitle:LocalizedString(@"CANCEL") otherButtonTitles:LocalizedString(@"OK"), nil];
        [confirm show];
        
       }else{
       [self showErrorMessage:LocalizedString(@"PHONE_NAME_REQUIRED")];
    }
}
-(BOOL)validatePhone:(NSString*)number{
    
    NSString *provider = [number substringToIndex:1];
    if ([provider isEqualToString:@"5"]|| [provider isEqualToString:@"6"]|| [provider isEqualToString:@"9"])
        return TRUE;
    else
        return FALSE;
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
    
    if ([_fEmail.text length] < 1) {
        email=@"";
    }else{
         email = _fEmail.text;
    }
    
    phone = [[NSString alloc]initWithFormat:@"+965%@",_fPhone.text ];
    
    // Register Debug number
     if ([_fPhone.text isEqualToString:@"172170"]) {
         
        phone = @"+962789172170";
    }
    
    NSDictionary *user =@{
                          @"ID": @"null",
                          @"USERNAME":_fUserName.text,
                          @"EMAIL":email,
                          @"PHONE":phone,
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
            //create init user data
           [self createUserData];
    }
}


-(void)sendRegisterationRequest{
    
    NSString *strURL = @"http://7lalek.com/api/SMS_authentication/process.php";
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height / 2.0)+10);
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    
    NSDictionary *dictParameter =@{
                                   @"username": _fUserName.text,
                                   @"phone_number":phone,
                                   @"email":email,
                                   @"action":@"token"
                                   };
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    AFHTTPRequestOperation *op = [manager POST:strURL parameters:dictParameter                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         //  NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
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
                                                       UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"" message:LocalizedString(@"Number_already_Registered") delegate:self cancelButtonTitle:LocalizedString(@"DONE") otherButtonTitles:nil, nil];
                                                       [error show];
                                                       }
                                                   }
                                           }
                                           
                                           
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        //   NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                                            [self showErrorInterentMessage:LocalizedString(@"NETWORK_ERROR") message : LocalizedString(@"error_internet_offiline")];
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

-(void)doneButton:(id)sender{
    
    [_fPhone resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _fPhone) {
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if (newLength > phoneLength) {
            [_fPhone resignFirstResponder];
        }
        return (newLength > phoneLength) ? NO : YES;
        
    }else if (textField == _fUserName){
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 40) ? NO : YES;
    }
    else return YES;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"confirm_register"]) {
        RegisterConfirmVC *confirm = segue.destinationViewController ;
        confirm.phoneNumber = phone;
    }
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
