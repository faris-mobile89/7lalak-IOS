//
//  MoreMainVC.m
//  7lalak
//
//  Created by Faris IOS on 6/25/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "MoreMainVC.h"
#import "AddVideoVC.h"
#import "AddImageVC.h"
#import "FavoriteVC.h"
#import "UserInfoVC.h"
#import "RegisterVC.h"
#import "ContactUsVC.h"
#import "BuyTableVC.h"
#import "LocalizeHelper.h"

@interface MoreMainVC ()

@end
Boolean isRegistered=FALSE;
NSString *userID;
@implementation MoreMainVC

- (void)viewDidLoad
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_header.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    
    [super viewDidLoad];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
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

    if ([userData count]>0 && userData !=nil) {
        
        if ([[userData valueForKey:@"ACTIVE"]isEqualToString:@"true"]) {
            isRegistered = TRUE;
            userID = [userData valueForKey:@"ID"];
        }
    }
}


-(void)registerView{
    
        RegisterVC *userRegister = [self.storyboard instantiateViewControllerWithIdentifier:@"registerVC"];
        [self.navigationController pushViewController: userRegister animated:YES];

}

- (IBAction)btnAdd:(id)sender {
    
    [self getUserData];
    
    if (isRegistered) {
        
        UIAlertView *chooser = [[UIAlertView alloc]initWithTitle:nil message:LocalizedString(@"MESSAGE_CHOOSE_ADS") delegate:self cancelButtonTitle:LocalizedString(@"CANCEL")
                                               otherButtonTitles:LocalizedString(@"IMAGE"),
                                LocalizedString(@"VIDEO"), nil];
        [chooser show];
        
    }else{
        [self registerView];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [self checkUserAdsScore:@"image"];
    }else if (buttonIndex == 2){
        [self checkUserAdsScore:@"video"];
    }
}

- (IBAction)btnFav:(id)sender {
    
    FavoriteVC *fav = [self.storyboard instantiateViewControllerWithIdentifier:@"FavVC"];
    [self.navigationController pushViewController:fav animated:YES];
}

- (IBAction)btnAccountInfo:(id)sender {
    
    [self getUserData];
    
    if (isRegistered) {
        UserInfoVC *info = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoVC"];
        [self.navigationController pushViewController:info animated:YES];
    }else{
        [self registerView];
    }
}

- (IBAction)btnBuy:(id)sender {
    
    [self getUserData];
    if (isRegistered) {
        
        BuyTableVC *buy = [self.storyboard instantiateViewControllerWithIdentifier:@"buyAdsVC"];
        [self.navigationController pushViewController:buy animated:YES];
    }else{
        [self registerView];
    }
}

- (IBAction)btnContact:(id)sender {
    
    ContactUsVC *contactUs = [self.storyboard instantiateViewControllerWithIdentifier:@"contactUsVC"];
    [self.navigationController pushViewController:contactUs animated:YES];
}

- (IBAction)btnAboutUS:(id)sender {
}

-(void)checkUserAdsScore :(NSString *)choosenType{
    
    NSURL* url = [NSURL URLWithString:@"http://185.56.85.28/~c7lalek4/api/authuntication.php"];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
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
                             
                             if ([choosenType isEqualToString:@"image"]) {
                                 NSString *AdsImageScore = [[jsonObject objectForKey:@"userInfo"]valueForKey:@"imagesScore"];
                                 int count = [AdsImageScore intValue];
                                 NSLog(@"Image choosen");
                                 if ( count < 1 ) {
                                     NSLog(@"score is 0");
                                      [self showMessage:@"" message:LocalizedString(@"ERROR_NO_ADs_SCORE")];
                                 }else{
                                     NSLog(@"video choosen");
                                     AddImageVC *imageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addImages"];
                                     imageVC.userID = userID;
                                     [self.navigationController pushViewController:imageVC animated:YES];
                                 }
                                 
                             }else if ([choosenType isEqualToString:@"video"]){
                                 NSString *AdsVideoScore = [[jsonObject objectForKey:@"userInfo"]valueForKey:@"VideosScore"];
                                 int count = [AdsVideoScore intValue];
                                 if (count < 1) {
                                     NSLog(@"video score is 0");
                                     [self showMessage:@"" message:LocalizedString(@"ERROR_NO_ADs_SCORE")];
                                 }else{
                                     AddVideoVC *videoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addVideoView"];
                                     videoVC.userID = userID;
                                     [self.navigationController pushViewController:videoVC animated:YES];
                                 }
                             }
                         }
                     });
                 } else {
                     [activityIndicator stopAnimating];
                 }
             }
             
             else if(httpResponse.statusCode == 408){
                 [self showErrorInterentMessage:LocalizedString(@"NETWORK_ERROR")
                                        message:LocalizedString(@"error_internet_timeout")];
                 
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
