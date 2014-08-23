//
//  AboutUsVC.m
//  7lalak
//
//  Created by Faris IOS on 8/13/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "AboutUsVC.h"
#import "HUD.h"
#import "LocalizeHelper.h"

@interface AboutUsVC ()

@end

@implementation AboutUsVC


- (void)viewDidLoad
{
    [HUD showUIBlockingIndicatorWithText:LocalizedString(@"LOADING") withTimeout:2];
    NSBundle *bundle=[NSBundle mainBundle];
    NSString *filePath = [bundle pathForResource:@"about_us" ofType: @"html"];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileUrl];
    
    [_webView loadRequest:request];
    [super viewDidLoad];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
