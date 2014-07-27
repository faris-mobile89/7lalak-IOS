//
//  FirstViewController.m
//  7lalak
//
//  Created by Faris IOS on 6/21/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "FirstViewController.h"
#import "UIColor_hex.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"004557"]];

    
}

-(BOOL)prefersStatusBarHidden{

    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
