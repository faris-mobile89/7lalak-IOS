//
//  HomePageVC.m
//  7lalak
//
//  Created by Faris IOS on 7/2/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "HomePageVC.h"
#import "LocalizeHelper.h"
#import "FirstViewController.h"
#import "UIImageView+ProgressView.h"
#import "UIColor_hex.h"
#import "Localization.h"

@interface HomePageVC ()

@end

BOOL appEnabled=TRUE;

@implementation HomePageVC

/*
 To get the bundle for the current language:
 
 NSString *path = [[NSBundle mainBundle] pathForResource:currentLanguage ofType:@"lproj"];
 if (path) {
 NSBundle *localeBundle = [NSBundle bundleWithPath:path];
 }
 
 //localized images
 UIImage *img = [UIImage imageNamed:NSLocalizedString(@"TestImage",@"")];
 */

-(BOOL)prefersStatusBarHidden{
    
    return YES;
}
-(void)viewWillAppear:(BOOL)animated{
 [_errorHolder setHidden:TRUE];
}
- (void)viewDidLoad
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:LocalizedString(@"BACK") style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];

    _fImageTopAds.layer.cornerRadius=4;
    _fImageTopAds.layer.borderWidth=1.0;
    _fImageTopAds.layer.masksToBounds = YES;
    _fImageTopAds.clipsToBounds = YES;
    _fImageTopAds.layer.borderColor=[[UIColor colorWithHexString:@"ffffff"] CGColor];
    
    _errorHolder.layer.cornerRadius=4;
    _errorHolder.layer.borderWidth=1.0;
    _errorHolder.layer.masksToBounds = YES;
    _errorHolder.clipsToBounds = YES;
    _errorHolder.layer.borderColor=[[UIColor colorWithHexString:@"CCCCCC"] CGColor];
    
    [super viewDidLoad];
   // [_btnEN setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    //[_buttonAR setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];

    [_btnEN setEnabled:FALSE];
    [_buttonAR setEnabled:FALSE];
   
    [self loadAppData];
}

-(void)loadAppData{
    
    NSString * urlString =[[NSString alloc]initWithFormat:@"http://7lalek.com/api/appConfig.php?device=IOS"];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
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
                         [activityIndicator stopAnimating];
                         
                    if (jsonObject !=nil) {
                        
                        if ([[jsonObject valueForKey:@"error"]intValue]==0) {
                             [activityIndicator stopAnimating];
                            
                            if ([[jsonObject valueForKey:@"newUpdate"]intValue]==1) {
                                // new update found
                                [self showMessage:LocalizedString(@"FOUND_UPDATE")];
                                [_btnEN setEnabled:TRUE];
                                [_buttonAR setEnabled:TRUE];
                             }
                              if ([[jsonObject valueForKey:@"enable"]intValue]==0) {
                                  //app disabled by admin // show messages
                                  appEnabled = FALSE;
                                  [self showOffilneMessage:[jsonObject valueForKey:@"message"]];
                              }else{
                                  
                                  [_btnEN setEnabled:TRUE];
                                  [_buttonAR setEnabled:TRUE];
                              }
                            
                             NSString *homeImgURl =[jsonObject valueForKey:@"home_img"];
                             //NSLog(@"Hoe%@",homeImgURl);
                            
                            [_fImageTopAds setImageWithURL:[NSURL URLWithString:homeImgURl] usingProgressView:nil];
                             }
                         
                         }
                         
                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         // NSLog(@"ERROR: %@", error);
                          [activityIndicator stopAnimating];
                     });
                 }
             }
             
             else if(httpResponse.statusCode == 408){
                 [_errorHolder setHidden:FALSE];
                 [self showErrorInterentMessage:LocalizedString(@"error_internet_timeout")];
                 [activityIndicator stopAnimating];
                 
             }else{
                 [activityIndicator stopAnimating];
                 dispatch_async(dispatch_get_main_queue(), ^{
                    // NSLog(@"ERROR: %@", error);
                     [_errorHolder setHidden:FALSE];
                     [activityIndicator stopAnimating];
                 });
             }
         }
         else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 // NSLog(@"ERROR: %@", error);
                 [_errorHolder setHidden:FALSE];
                // [self showErrorInterentMessage:LocalizedString(@"error_internet_offiline")];
                 [activityIndicator stopAnimating];
             });
         }
     }];
    

}


- (IBAction)arClick:(id)sender {
    
   // NSLog(@"ar");
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"ar", nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    LocalizationSetLanguage(@"ar");
    [[Localization sharedInstance] setPreferred:@"ar" fallback:@"en"];

    
}

- (IBAction)enClick:(id)sender {
    
   // NSLog(@"en");

    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en", nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    LocalizationSetLanguage(@"en");
    [[Localization sharedInstance] setPreferred:@"en" fallback:@"ar"];

    
}

- (IBAction)btnRefresh:(id)sender {
    [_errorHolder setHidden:TRUE];
    [self loadAppData];
}

-(void)showErrorInterentMessage: (NSString*)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: nil message:msg delegate: self cancelButtonTitle: LocalizedString(@"Ok") otherButtonTitles: nil];
    
    [internetError show];
    
}

-(void)showMessage: (NSString*)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: nil message:msg delegate: self cancelButtonTitle: LocalizedString(@"Ok") otherButtonTitles: nil];
    [internetError show];
}

-(void)showOffilneMessage: (NSString*)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: nil message:msg delegate: self cancelButtonTitle: nil otherButtonTitles: nil];
    
    [internetError show];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
