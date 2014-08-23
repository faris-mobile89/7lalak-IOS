//
//  OffersVC.m
//  7lalak
//
//  Created by Faris IOS on 6/25/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "OffersVC.h"
#import "InternetConnection.h"
#import "LocalizeHelper.h"
#import "Localization.h"

#define IS_HEIGHT_4S [[UIScreen mainScreen ] bounds].size.height < 568.0f

@interface OffersVC ()

@end

@implementation OffersVC

-(void)viewDidAppear:(BOOL)animated{
    
    
    NSString *string = [_fWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].innerHTML"];
    BOOL isEmpty = [string length] < 50;
    
    if (isEmpty) {
         [self loadWebPage];
    }
    
    int BadgeValue = [UIApplication sharedApplication].applicationIconBadgeNumber;
    
    if (BadgeValue < 1) {
        
        //[_tabOffers setBadgeValue:LocalizedString(@"NEW")];
        
    }else{
        
        [_tabOffers setBadgeValue:[[NSString alloc]initWithFormat:@"%i",BadgeValue ]];
    }
}

- (void)viewDidLoad
{
    
    _fWebView.delegate = self;
    _fWebView.scrollView.scrollEnabled = NO;
    
    [super viewDidLoad];
}

UIActivityIndicatorView *activityIndicator;

-(void)loadWebPage{
    
    NSString * lang = [[NSString alloc]init];
    lang = [[Localization sharedInstance]getPreferredLanguage];
    
    NSString *urlAddress;
    BOOL IS_4S = IS_HEIGHT_4S;
   
    
    if (IS_4S) {
        urlAddress = [[NSString alloc]initWithFormat:
                      @"http://7lalek.com/api/offers/iphone-4/home.php?lang=%@",lang];
    }
    else{
         urlAddress = [[NSString alloc]initWithFormat:
                  @"http://7lalek.com/api/offers/iphone-5/home.php?lang=%@",lang];
    }
    
    
    //NSLog(@"%@",urlAddress);
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_header.png"] forBarMetrics:UIBarMetricsDefault];

    if ([self connectedToInternet]) {
        
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
        [self.view addSubview: activityIndicator];
        
        [activityIndicator startAnimating];
        //Create a URL object.
        NSURL *url = [NSURL URLWithString:urlAddress];
        
        // disable cache
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        //URL Requst Object
        [self.fWebView loadHTMLString:@"" baseURL:nil];
        NSURLRequest* requestObj = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
        [self performSelector:@selector(hideHUD) withObject:nil afterDelay:9];
        //Load the request in the UIWebView.
        [self.fWebView loadRequest:requestObj];
	}
	else {
        [self showErrorInterentMessage:LocalizedString(@"error_internet_offiline")];
	}
}

-(void)showErrorInterentMessage:(NSString *)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: LocalizedString(@"NETWORK_ERROR") message:msg delegate: self cancelButtonTitle: LocalizedString(@"Ok") otherButtonTitles: nil];
    
    [internetError show];
}

- (BOOL)connectedToInternet
{
    InternetConnection *networkReachability = [InternetConnection reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    return networkStatus == NotReachable ?FALSE:TRUE;
}


-(void)hideHUD
{
     [activityIndicator stopAnimating];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //this method will call after getting any error while loading the web view.
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
