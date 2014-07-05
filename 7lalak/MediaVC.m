//
//  MediaVC.m
//  7lalak
//
//  Created by Faris IOS on 7/3/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "MediaVC.h"
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f

@interface MediaVC ()

@end

@implementation MediaVC


- (void)viewDidLoad
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_header.png"] forBarMetrics:UIBarMetricsDefault];
    _holder.layer.cornerRadius = 18;

    if (IS_HEIGHT_GTE_568) {
        [_ios5View setHidden:FALSE];
        [_ios4View setHidden:TRUE];
    }else{
        [_ios5View setHidden:TRUE];
        [_ios4View setHidden:FALSE];
    }
    
    [super viewDidLoad];
}
-(BOOL)prefersStatusBarHidden{
    return TRUE;
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
