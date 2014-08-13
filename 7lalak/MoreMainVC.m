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
#import "MyAdsVC.h"
#import "UIColor_hex.h"
#import "AboutUsVC.h"

#define IS_HEIGHT_4S [[UIScreen mainScreen ] bounds].size.height < 568.0f

@interface MoreMainVC ()

@end
Boolean isRegistered=FALSE;
NSString *userID;
NSString *apiKey;
BOOL frameSet=FALSE;

@implementation MoreMainVC


-(void)viewWillAppear:(BOOL)animated{
    
    [self getUserData];

}

-(void)viewDidLayoutSubviews{
    
    [_btn1 setTitle:LocalizedString(@"BTN_FAV") forState:UIControlStateNormal];
    [_btn2 setTitle:LocalizedString(@"BTN_Add") forState:UIControlStateNormal];
    [_btn3 setTitle:LocalizedString(@"BTN_INFO") forState:UIControlStateNormal];
    [_btn4 setTitle:LocalizedString(@"BTN_BUY") forState:UIControlStateNormal];
    [_btn5 setTitle:LocalizedString(@"BTN_CONTACT") forState:UIControlStateNormal];
    [_btn6 setTitle:LocalizedString(@"BTN_ABOUT") forState:UIControlStateNormal];
    [_btn7 setTitle:LocalizedString(@"BTN_MY_Ad") forState:UIControlStateNormal];

    
    NSLog(@"prefered language: %@",[[Localization sharedInstance]getPreferredLanguage]);
    
    [self getUserData];
    BOOL IS_4S = IS_HEIGHT_4S;
    if (!IS_4S) {
        [_holderBtns setFrame:CGRectMake(_holderBtns.frame.origin.x, _holderBtns.frame.origin.y+40, _holderBtns.frame.size.width, _holderBtns.frame.size.height)];
    }
}

- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"FFFFFF"]];
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
    isRegistered =FALSE;
    if (userData !=nil) {
        
        if ([[userData valueForKey:@"ACTIVE"]isEqualToString:@"true"]) {
            isRegistered = TRUE;
            userID = [userData valueForKey:@"ID"];
            apiKey = [userData valueForKey:@"API_KEY"];
           // [_btn7 setHidden:FALSE];
           // NSLog(@"A    %@",userData);
          
        }else{
            
             //  NSLog(@"fr%f",_holderBtns.frame.origin.y+40);
            
            if (_holderBtns.frame.origin.y < 33.0) {
                
                 [_holderBtns setFrame:CGRectMake(_holderBtns.frame.origin.x, _holderBtns.frame.origin.y+40, _holderBtns.frame.size.width, _holderBtns.frame.size.height)];
            }
            
            
            [_btn7 setHidden:TRUE];

            //NSLog(@"B:  %@",userData);
        }
    }
}


-(void)registerView{
    
        RegisterVC *userRegister = [self.storyboard instantiateViewControllerWithIdentifier:@"registerVC"];
        [self.navigationController pushViewController: userRegister animated:YES];

}

- (IBAction)btnMyAds:(id)sender {
    
    MyAdsVC *myAds = [self.storyboard instantiateViewControllerWithIdentifier:@"MyAdsVC"];
    myAds.userID=userID;
    myAds.apiKey=apiKey;
    [self.navigationController pushViewController:myAds animated:YES];
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
        
        BuyTableVC *buy = [self.storyboard instantiateViewControllerWithIdentifier:@"buyAdsView"];
        [self.navigationController pushViewController:buy animated:YES];
        
    }else{
        [self registerView];
    }
}

- (IBAction)btnContact:(id)sender {
    
    ContactUsVC *contactUs = [self.storyboard instantiateViewControllerWithIdentifier:@"contactUsVC"];
    if (userID != nil) {
        
        contactUs.userID = userID;
    }else{
        contactUs.userID =@"0000";
    }
    
    [self.navigationController pushViewController:contactUs animated:YES];
}

- (IBAction)btnAboutUS:(id)sender {
    
    AboutUsVC *about = [self.storyboard instantiateViewControllerWithIdentifier:@"about_us"];
    
    [self.navigationController pushViewController:about animated:YES];
}

-(void)checkUserAdsScore :(NSString *)choosenType{
    
   NSString *urlWithParam = [[NSString alloc]initWithFormat:@"http://7lalek.com/api/api.php?tag=getUserInfo&user_id=%@",userID];
    NSLog(@"URl:%@",urlWithParam);
    
    NSURL* url = [NSURL URLWithString:urlWithParam];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height / 2.0)-50);
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    [_btnAdd setEnabled:FALSE];
    
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
                 [_btnAdd setEnabled:TRUE];

                 id  jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (jsonObject) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [activityIndicator stopAnimating];

                         if (jsonObject!=nil) {
                             //NSLog(@"response%@",jsonObject);
                             
                             if ([choosenType isEqualToString:@"image"]) {
                                 int AdsImageScore = [[[jsonObject objectForKey:@"userInfo"]valueForKey:@"imagesScore"]intValue];
                                 
                                 if ( AdsImageScore < 1 ) {
                                      [self showMessage:@"" message:LocalizedString(@"ERROR_NO_ADs_SCORE")];
                                 }else{
                                     AddImageVC *imageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addImages"];
                                     imageVC.userID = userID;
                                     imageVC.apiKey = apiKey;
                                     [self.navigationController pushViewController:imageVC animated:YES];
                                 }
                                 
                             }else if ([choosenType isEqualToString:@"video"]){
                                 int AdsVideoScore = [[[jsonObject objectForKey:@"userInfo"]valueForKey:@"videosScore"]intValue];
                                
                                 if (AdsVideoScore < 1) {
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
                     [activityIndicator stopAnimating];
                     [_btnAdd setEnabled:TRUE];
                 }
             }
             
             else if(httpResponse.statusCode == 408){
                 [self showErrorInterentMessage:LocalizedString(@"NETWORK_ERROR")
                                        message:LocalizedString(@"error_internet_timeout")];
                 [_btnAdd setEnabled:TRUE];
                 
             }else{
                 [activityIndicator stopAnimating];
                 [_btnAdd setEnabled:TRUE];
             }
         }
         else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self showErrorInterentMessage:LocalizedString(@"NETWORK_ERROR") message : LocalizedString(@"error_internet_offiline")];
                 [_btnAdd setEnabled:TRUE];
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
