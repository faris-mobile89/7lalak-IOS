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

@interface HomePageVC ()

@end

BOOL appEnabled=TRUE;

@implementation HomePageVC
/*
-(id)init{
    
    NSString *tempValue =@"ar";
    
    NSString *currentLanguage = @"en";
    
    if ([tempValue rangeOfString:NSLocalizedString(@"English", nil)].location != NSNotFound) {
        currentLanguage = @"en";
    } else if ([tempValue rangeOfString:NSLocalizedString(@"Arabic", nil)].location != NSNotFound) {
        currentLanguage = @"ar";
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"ar", nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    return nil;
}
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
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"004557"]];

    _fImageTopAds.layer.cornerRadius=4;
    _fImageTopAds.layer.borderWidth=1.0;
    _fImageTopAds.layer.masksToBounds = YES;
    _fImageTopAds.clipsToBounds = YES;
    _fImageTopAds.layer.borderColor=[[UIColor colorWithHexString:@"ffffff"] CGColor];
    
    
    
    [super viewDidLoad];
   // [_btnEN setEnabled:FALSE];
    [_buttonAR setEnabled:FALSE];
   
    [self loadAppData];
}

-(void)loadAppData{
    
    NSString * urlString =[[NSString alloc]initWithFormat:@"http://7lalek.com/api/appConfig.php?device=IOS"];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
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
                            
                            [_fImageTopAds setImageWithURL:[NSURL URLWithString:homeImgURl] usingProgressView:nil];
                             }
                         
                         }
                         
                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         // NSLog(@"ERROR: %@", error);
                     });
                 }
             }
             
             else if(httpResponse.statusCode == 408){
                 [_errorHolder setHidden:FALSE];
                 //[self showErrorInterentMessage:LocalizedString(@"error_internet_timeout")];
                 [activityIndicator stopAnimating];
                 
             }else{
                 [activityIndicator stopAnimating];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSLog(@"ERROR: %@", error);
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
