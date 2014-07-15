//
//  OffersVC.m
//  7lalak
//
//  Created by Faris IOS on 6/25/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "OffersVC.h"
#import "InternetConnection.h"

@interface OffersVC ()

@end

@implementation OffersVC


- (void)viewDidLoad
{
    
   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_header.png"] forBarMetrics:UIBarMetricsDefault];
    _fWebView.delegate = self;

    
    _fWebView.scrollView.scrollEnabled = NO;
    
    [self loadWebPage];
  
    
    [super viewDidLoad];
}
UIActivityIndicatorView *activityIndicator;

-(void)loadWebPage{
    
    NSString *urlAddress = @"http://serv01.vm1692.sgvps.net/~karasi/sale/widgets/offers/index.html";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_header.png"] forBarMetrics:UIBarMetricsDefault];

    if ([self connectedToInternet]) {
        
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
        [self.view addSubview: activityIndicator];
        
        [activityIndicator startAnimating];
        //Create a URL object.
        NSURL *url = [NSURL URLWithString:urlAddress];
        
        //URL Requst Object
        [self.fWebView loadHTMLString:@"" baseURL:nil];
        NSURLRequest* requestObj = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
        [self performSelector:@selector(hideHUD) withObject:nil afterDelay:9];
        //Load the request in the UIWebView.
        [self.fWebView loadRequest:requestObj];
	}
	else {
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Network Error" message: @"Error connecting to the internet" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		[someError show];
	}

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
