//
//  UserInfoVC.m
//  7lalak
//
//  Created by Faris IOS on 6/29/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "UserInfoVC.h"
#import "LocalizeHelper.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"

#define IS_HEIGHT_4S [[UIScreen mainScreen ] bounds].size.height < 568.0f

@interface UserInfoVC ()
@property (strong,nonatomic)  NSString *userId;
@property (strong,nonatomic)  NSString *apiKey;
@property bool deactiveFlag;
@end

@implementation UserInfoVC
@synthesize  deactiveFlag;
//


-(void)set4SFrame{
    
    _btnDeactive.frame = CGRectMake(80, 340, 156, 38);
    
}

-(void)viewDidLayoutSubviews{
    
    _fUserName.layer.cornerRadius = 5;
    _fPhone.layer.cornerRadius =5;
    BOOL IS_4S = IS_HEIGHT_4S;
    if (IS_4S) {
        [self set4SFrame];
    }
    [super viewDidLayoutSubviews];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = LocalizedString(@"TITLE_MORE_ACCOUNT_INFO");

    deactiveFlag = FALSE;
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"UserInfoData.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"UserInfoData" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    NSDictionary *userData =[NSDictionary dictionaryWithContentsOfFile:path];
    if (userData != nil) {
        _fUserName.text = [userData objectForKey:@"USERNAME"];
        _fPhone.text = [userData objectForKey:@"PHONE"];
        _userId = [userData objectForKey:@"ID"];
        _apiKey = [userData objectForKey:@"API_KEY"];
        [self getAdsScore];
    }else{
        //NSLog(@"No Registerd User ");
    }
}

-(void)getAdsScore{
    
    NSString *urlWithParam = [[NSString alloc]initWithFormat:@"http://185.56.85.28/~c7lalek4/api/api.php?tag=getUserInfo&user_id=%@",_userId];
    
    NSURL* url = [NSURL URLWithString:urlWithParam];
    
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
                 
                 id  jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (jsonObject) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [activityIndicator stopAnimating];
                         
                         if (jsonObject!=nil) {
                             
                             int AdsImageScore = [[[jsonObject objectForKey:@"userInfo"]valueForKey:@"imagesScore"]intValue];
                             _fAdsImagesCount.text = [[NSString alloc]initWithFormat:@"%i",AdsImageScore];
                             
                             int AdsVideoScore = [[[jsonObject objectForKey:@"userInfo"]valueForKey:@"videosScore"]intValue];
                             _fAdsVideoCount.text = [[NSString alloc]initWithFormat:@"%i",AdsVideoScore];
                             [activityIndicator stopAnimating];
                             
                             
                         }
                     });
                 } else {
                     [activityIndicator stopAnimating];
                 }
             }
             
             else if(httpResponse.statusCode == 408){
                 [self showErrorInterentMessage:LocalizedString(@"NETWORK_ERROR")
                                        message:LocalizedString(@"error_internet_timeout")];
                 [activityIndicator stopAnimating];

             }else{
                 [activityIndicator stopAnimating];
             }
         }
         else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self showErrorInterentMessage:LocalizedString(@"NETWORK_ERROR") message : LocalizedString(@"error_internet_offiline")];
                 [activityIndicator stopAnimating];
             });
         }
     }];
    
}

- (IBAction)btnDeactiveAccount:(id)sender {
    
    UIAlertView *deactive = [[UIAlertView alloc]
                             initWithTitle: nil message:LocalizedString(@"DEACTIVE_MESSAGE") delegate: self cancelButtonTitle: LocalizedString(@"CANCEL") otherButtonTitles: LocalizedString(@"SURE"), nil];
    
    [deactive show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
        [self deactiveProcess];
    }
    if ( buttonIndex==0 && deactiveFlag) {
        
        [self.navigationController popViewControllerAnimated:YES];
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

-(void)deactiveProcess{
    
    
    NSString *strURL = @"http://185.56.85.28/~c7lalek4/api/deactive_account.php";
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height / 2.0)-25);
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    
    NSDictionary *dictParameter =@{
                                   @"tag":@"dactiveAccount",
                                   @"user_id":_userId,
                                   @"UDID":_apiKey
                                   };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    AFHTTPRequestOperation *op = [manager POST:strURL parameters:dictParameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         
                                           if (responseObject !=nil) {
                                           
                                           if ([[responseObject valueForKey:@"error"]intValue]==0) {
                                               [self deactiveAccount];
                                              }
                                           }
                                           [activityIndicator stopAnimating];
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           [self showErrorInterentMessage:LocalizedString(@"NETWORK_ERROR")
                                                                  message:LocalizedString(@"error_internet_offiline")];
                                           [activityIndicator stopAnimating];
                                       }];
    
    [op start];
    
}

-(void)deactiveAccount{
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"UserInfoData.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"UserInfoData" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    
    NSDictionary *user =@{
                          @"ID": @"null",
                          @"USERNAME":@"null",
                          @"EMAIL":@"null",
                          @"PHONE":@"null",
                          @"ACTIVE":@"false",
                          @"VCODE":@"null",
                          @"API_KEY":@"null",
                          @"IMAGE_SCORE":@"null",
                          @"VIDEO_SCORE":@"null"
                          };
    
    [user writeToFile:path atomically:YES];
    
    UIAlertView *deactive = [[UIAlertView alloc]
                             initWithTitle: nil message:LocalizedString(@"DEACTIVE_SUCCESS") delegate: self cancelButtonTitle: LocalizedString(@"OK") otherButtonTitles: nil];
    [deactive show];
    deactiveFlag =TRUE;

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
