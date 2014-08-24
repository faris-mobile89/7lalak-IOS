//
//  AddAdMainVC.m
//  7lalak
//
//  Created by Faris IOS on 8/23/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "AddAdMainVC.h"
#import "RegisterVC.h"
#import "AddVideoVC.h"
#import "AddImageVC.h"
#import "Localization.h"
#import "LocalizeHelper.h"
#import "HUD.h"

@interface AddAdMainVC (){
    
    Boolean isRegistered;
    NSString *userID;
    NSString *apiKey;
    BOOL frameSet;
}

@end

@implementation AddAdMainVC




- (void)viewDidLoad
{
    
    [_addImage setTitle:LocalizedString(@"Add_Image_Ad") forState:UIControlStateNormal];
    [_addVideo setTitle:LocalizedString(@"Add_Video_Ad") forState:UIControlStateNormal];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_header.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
}

- (IBAction)addimageClick:(id)sender {
    
    [self getUserData];
    if (isRegistered) {
        [self checkUserAdsScore:@"image"];
    }else{
        [self registerView];
    }
}

- (IBAction)addVideoClick:(id)sender {
    
    [self getUserData];
    if (isRegistered) {
        [self checkUserAdsScore:@"video"];
    }else{
        [self registerView];
    }
}

-(void)getUserData{
    
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
    isRegistered =FALSE;
    if (userData !=nil) {
        
        if ([[userData valueForKey:@"ACTIVE"]isEqualToString:@"true"]) {
            isRegistered = TRUE;
            userID = [userData valueForKey:@"ID"];
            apiKey = [userData valueForKey:@"API_KEY"];
            // [_btn7 setHidden:FALSE];
            // NSLog(@"A    %@",userData);
            
        }else{
            
            // [_btn7 setHidden:TRUE];
            
            //NSLog(@"B:  %@",userData);
        }
    }
}

-(void)checkUserAdsScore :(NSString *)choosenType{
    
    NSString *urlWithParam = [[NSString alloc]initWithFormat:@"http://7lalek.com/api/api.php?tag=getUserInfo&user_id=%@",userID];
    // NSLog(@"URl:%@",urlWithParam);
    
    NSURL* url = [NSURL URLWithString:urlWithParam];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40];
    
    [HUD showUIBlockingIndicatorWithText:LocalizedString(@"LOADING")];
    
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
                  [_addImage setEnabled:TRUE];
                 
                 id  jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (jsonObject) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         if (jsonObject!=nil) {
                             [HUD hideUIBlockingIndicator];

                             if ([choosenType isEqualToString:@"image"]) {
                                 
                                 int adsImageScore = [[[jsonObject objectForKey:@"userInfo"]valueForKey:@"imagesScore"]intValue];
                                 
                                 int adsPaidImageScore = [[[jsonObject objectForKey:@"userInfo"]valueForKey:@"paidImagesScore"]intValue];
                                 
                                 if ( adsImageScore < 1  && adsPaidImageScore < 1) {
                                     [self showMessage:@""message:LocalizedString(@"ERROR_NO_ADs_SCORE")];
                                 }else{
                                     AddImageVC *imageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addImages"];
                                     imageVC.userID = userID;
                                     imageVC.apiKey = apiKey;
                                     [self.navigationController pushViewController:imageVC animated:YES];
                                 }
                                 
                             }else if ([choosenType isEqualToString:@"video"]){
                                 
                                 int adsVideoScore = [[[jsonObject objectForKey:@"userInfo"]valueForKey:@"videosScore"]intValue];
                                 
                                 int adsPaidVideosScore = [[[jsonObject objectForKey:@"userInfo"]valueForKey:@"paidVideosScore"]intValue];
                                 
                                 if (adsVideoScore < 1 && adsPaidVideosScore < 1) {
                                     [self showMessage:@"" message:LocalizedString(@"ERROR_NO_ADs_SCORE")];
                                 }else{
                                     AddVideoVC *videoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addVideoView"];
                                     videoVC.userID = userID;
                                     videoVC.apiKey = apiKey;
                                     [self.navigationController pushViewController:videoVC animated:YES];
                                 }
                             }
                         }
                     });
                 } else {
                     [HUD hideUIBlockingIndicator];
                 }
             }
             
             else if(httpResponse.statusCode == 408){
                 [self showErrorInterentMessage:LocalizedString(@"NETWORK_ERROR")
                                        message:LocalizedString(@"error_internet_timeout")];
                 
             }else{
                 [HUD hideUIBlockingIndicator];
             }
         }
         else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self showErrorInterentMessage:LocalizedString(@"NETWORK_ERROR") message : LocalizedString(@"error_internet_offiline")];
                 [HUD hideUIBlockingIndicator];
             });
         }
     }];
    
}

-(void)registerView{
    
    RegisterVC *userRegister = [self.storyboard instantiateViewControllerWithIdentifier:@"registerVC"];
    [self.navigationController pushViewController: userRegister animated:YES];
    
}

-(void)showErrorInterentMessage:(NSString *)title message:(NSString*)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: title message:msg delegate: self cancelButtonTitle: LocalizedString(@"Ok") otherButtonTitles: nil];
    
    [internetError show];
    
}

-(void)showMessage:(NSString *)title message:(NSString*)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: title message:msg delegate: self cancelButtonTitle: LocalizedString(@"DONE") otherButtonTitles: nil];
    
    [internetError show];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
