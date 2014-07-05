//
//  HomePageVC.m
//  7lalak
//
//  Created by Faris IOS on 7/2/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "HomePageVC.h"
#import "LocalizeHelper.h"

@interface HomePageVC ()

@end

@implementation HomePageVC


- (void)viewDidLoad
{
    
    
    [_fImageTopAds setImage:
     [UIImage imageWithData:[NSData dataWithContentsOfURL:
                             [NSURL URLWithString:@"http://"]]]];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
